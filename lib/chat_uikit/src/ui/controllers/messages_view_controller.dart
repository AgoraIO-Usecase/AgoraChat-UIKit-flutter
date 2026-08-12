import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:agora_chat_uikit/chat_uikit.dart';
import 'package:agora_chat_uikit/chat_uikit/src/tools/safe_disposed.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';

enum MessageLastActionType {
  topPosition, // 主要用于搜索时直接跳转到顶部
  bottomPosition,
  originalPosition,
}

/// 消息列表控制器
class MessagesViewController extends ChangeNotifier
    with SafeAreaDisposed, ChatObserver, MessageObserver, ThreadObserver {
  /// 用户信息对象，用于设置对方信息, 详细参考 [ChatUIKitProfile]。如果你自己设置了 `MessageListViewController` 需要确保 `profile` 与 [MessagesView] 传入的 `profile` 一致。
  ChatUIKitProfile profile;

  final List<BottomCondition> bottomConditions = [];

  /// 一次获取的消息数量，默认为 30
  final int pageSize;

  final Future<Message>? Function(Message willSendMessage)? willSendHandler;

  /// 消息列表
  final List<MessageModel> msgModelList = [];

  /// 用户信息缓存，用于显示头像昵称, 不建议修改， 详细参考 [ChatUIKitProfile]
  final Map<String, ChatUIKitProfile> userMap = {};

  /// 会话类型, 不可修改，会根据 `profile` 自动设置。 详细参考 [ConversationType]
  late final ConversationType conversationType;

  /// 不可修改
  MessageLastActionType lastActionType = MessageLastActionType.originalPosition;

  /// 不可修改
  bool _isEmpty = false;

  /// 不可修改
  String? _lastMessageId;

  /// 不可修改
  bool hasNew = false;

  bool canMoveToBottomPosition = true;

  /// 不可修改
  bool _isFetching = false;

  /// 不可修改
  bool isDisposed = false;

  /// 不可修改
  bool _typing = false;

  List<Message> selectedMessages = [];

  List<MessageModel> cacheMessages = [];

  ValueNotifier<List<Message>> pinedMessages = ValueNotifier([]);

  bool isMultiSelectMode = false;

  Message? searchedMsg;

  bool hasSearched = false;

  void clearMessages() {
    msgModelList.clear();
    cacheMessages.clear();
    lastActionType = MessageLastActionType.bottomPosition;
    canMoveToBottomPosition = true;
    hasNew = false;
    _lastMessageId = null;
    refresh();
  }

  MessagesViewController({
    required this.profile,
    this.pageSize = 30,
    this.searchedMsg,
    this.willSendHandler,
  }) {
    ChatUIKit.instance.addObserver(this);
    conversationType = () {
      if (profile.type == ChatUIKitProfileType.group) {
        return ConversationType.GroupChat;
      } else {
        return ConversationType.Chat;
      }
    }();
    userMap[profile.id] = profile;
    if (ChatUIKit.instance.currentUserId != null) {
      final profile = ChatUIKitProvider.instance.getProfileById(
        ChatUIKit.instance.currentUserId!,
      );
      if (profile != null) {
        userMap[ChatUIKit.instance.currentUserId!] = profile;
      }
    }
  }

  void jumpToSearchedMessage(Message searchedMessage) {
    searchedMsg = searchedMessage;
    hasSearched = false;
    msgModelList.clear();
    lastActionType = MessageLastActionType.bottomPosition;
    canMoveToBottomPosition = true;
    hasNew = false;
    _lastMessageId = null;
    _isEmpty = false;
    fetchItemList();
  }

  @override
  void dispose() {
    isDisposed = true;
    bottomConditions.clear();
    ChatUIKit.instance.removeObserver(this);
    pinedMessages.dispose();
    super.dispose();
  }

  void fetchItemList() async {
    if (_isEmpty) {
      return;
    }
    if (_isFetching) return;
    _isFetching = true;
    List<Message> list;
    if (searchedMsg != null && hasSearched == false) {
      List<Message> searchList =
          await ChatUIKit.instance.loadLocalMessagesByTimestamp(
        conversationId: profile.id,
        type: conversationType,
        count: 100,
        startTime: searchedMsg!.serverTime - 100000,
        endTime: DateTime.now().millisecondsSinceEpoch,
      );

      List<Message> beforeSearchList =
          await ChatUIKit.instance.loadLocalMessages(
        conversationId: profile.id,
        type: conversationType,
        count: pageSize,
        startId: searchList.first.msgId,
      );
      list = beforeSearchList + searchList;
      _lastMessageId = list.first.msgId;
      hasSearched = true;
      lastActionType = MessageLastActionType.topPosition;
    } else {
      list = await ChatUIKit.instance.loadLocalMessages(
        conversationId: profile.id,
        type: conversationType,
        count: pageSize,
        startId: _lastMessageId,
      );
      lastActionType = MessageLastActionType.originalPosition;
    }
    if (list.length < pageSize) {
      _isEmpty = true;
    }
    if (list.isNotEmpty) {
      List<MessageModel> modelLists = [];
      _lastMessageId = list.first.msgId;

      for (var msg in list) {
        List<MessageReaction> reactions = await msg.reactionList();
        ChatThread? threadOverView = await msg.chatThread();
        MessagePinInfo? pinInfo = await msg.pinInfo();
        modelLists.add(
          MessageModel(
            message: msg,
            reactions: reactions,
            thread: threadOverView,
            pinInfo: pinInfo,
          ),
        );
        // 先从缓存的profile中取
        ChatUIKitProfile? profile =
            ChatUIKitProvider.instance.getProfileById(msg.from!);
        if (profile != null) {
          userMap[msg.from!] = profile;
        } else {
          ChatUIKitProfile? mapProfile = userMap[msg.from!];
          if ((mapProfile?.timestamp ?? 0) < msg.fromProfile.timestamp) {
            userMap[msg.from!] = msg.fromProfile;
          }
        }
      }
      msgModelList.addAll(modelLists.reversed);
      for (var model in msgModelList) {
        if (ChatUIKitURLHelper().isFetching(model.message.msgId)) {
          model.message.status = MessageStatus.PROGRESS;
        }
      }
      refresh();
    }

    _isFetching = false;
  }

  void addAllCacheToList() {
    if (cacheMessages.isNotEmpty) {
      msgModelList.insertAll(0, cacheMessages.reversed);
      lastActionType = MessageLastActionType.bottomPosition;
      cacheMessages.clear();
      refresh();
    }
  }

  @override
  void onMessageContentChanged(
    Message message,
    String operatorId,
    int operationTime,
  ) {
    final index = msgModelList
        .indexWhere((element) => element.message.msgId == message.msgId);
    if (index != -1) {
      msgModelList[index] = msgModelList[index].copyWith(message: message);
      refresh();
    }
  }

  @override
  void onMessagesReceived(List<Message> messages) {
    List<MessageModel> list = [];
    for (var element in messages) {
      debugPrint(element.toString());
      // 如果是当前用户发送的消息，并且不是Alert类型的自定义消息，也不是RTC调用消息，则跳过
      if (element.from == ChatUIKit.instance.currentUserId &&
          !element.isAlertCustomMessage &&
          !element.isRtcCallWithAgora) {
        continue;
      }
      // 检查是否属于当前会话
      if (element.conversationId == profile.id) {
        list.add(
          MessageModel(message: element),
        );
        ChatUIKitProfile? profile =
            ChatUIKitProvider.instance.getProfileById(element.from!);
        profile ??= element.fromProfile;
        userMap[element.from!] = profile;
      }
    }
    if (list.isNotEmpty) {
      _clearMention(list);
      bool canMoveBottom = true;
      for (var element in bottomConditions) {
        canMoveBottom = element.call();
        if (canMoveBottom == false) {
          break;
        }
      }
      if (canMoveToBottomPosition && canMoveBottom) {
        msgModelList.insertAll(0, list.reversed);
        lastActionType = MessageLastActionType.bottomPosition;
      } else {
        cacheMessages.addAll(list.reversed);
        lastActionType = MessageLastActionType.originalPosition;
      }

      refresh();
    }
  }

  @override
  void onMessageUpdate(Message newMessage, [Message? oldMessage]) {
    _replaceMessage(newMessage);
  }

  @override
  void onConversationRead(String from, String to) {
    if (from == profile.id) {
      for (var element in msgModelList) {
        element.message.hasReadAck = true;
      }

      refresh();
    }
  }

  @override
  void onMessagesDelivered(List<Message> messages) {
    List<MessageModel> list = msgModelList
        .where((element1) => messages
            .where((element2) => element1.message.msgId == element2.msgId)
            .isNotEmpty)
        .toList();
    if (list.isNotEmpty) {
      for (var element in list) {
        element.message.hasDeliverAck = true;
      }
      refresh();
    }
  }

  @override
  void onMessagesRead(List<Message> messages) {
    List<MessageModel> list = msgModelList
        .where((element1) => messages
            .where((element2) => element1.message.msgId == element2.msgId)
            .isNotEmpty)
        .toList();
    if (list.isNotEmpty) {
      for (var element in list) {
        element.message.hasReadAck = true;
      }
      refresh();
    }
  }

  @override
  void onMessagesRecalledInfo(
      List<RecallMessageInfo> infos, List<Message> replaces) {
    bool needReload = false;
    for (var i = 0; i < infos.length; i++) {
      int index = msgModelList.indexWhere(
          (element) => infos[i].recallMessageId == element.message.msgId);
      if (index != -1) {
        msgModelList[index] =
            msgModelList[index].copyWith(message: replaces[i]);
        needReload = true;
      }
    }
    if (needReload) {
      refresh();
    }
  }

  @override
  void onMessageReactionDidChange(List<MessageReactionEvent> events) async {
    bool needUpdate = false;
    for (var reactionEvent in events) {
      if (reactionEvent.conversationId == profile.id) {
        final index = msgModelList.indexWhere(
            (element) => element.message.msgId == reactionEvent.messageId);
        if (index != -1) {
          Message? msg = await ChatUIKit.instance
              .loadMessage(messageId: msgModelList[index].message.msgId);
          if (msg != null) {
            needUpdate = true;
            List<MessageReaction>? reactions = await msg.reactionList();
            msgModelList[index] = msgModelList[index].copyWith(
              message: msg,
              reactions: reactions,
            );
          }
        }
      }
    }
    if (needUpdate) {
      lastActionType = MessageLastActionType.originalPosition;
      refresh();
    }
  }

  @override
  void onChatThreadUpdate(ChatThreadEvent event) async {
    int index = msgModelList.indexWhere(
        (element) => element.message.msgId == event.chatThread?.messageId);
    if (index != -1) {
      if (event.type == ChatThreadOperation.Update_Msg) {
        msgModelList[index] =
            msgModelList[index].copyWith(thread: event.chatThread);
        lastActionType = MessageLastActionType.originalPosition;
      } else if (event.type == ChatThreadOperation.Update) {
        ChatThread oldThread = msgModelList[index].thread!;
        ChatThread newThread = event.chatThread!;
        newThread = newThread.copyWith(lastMessage: oldThread.lastMessage);
        msgModelList[index] = msgModelList[index].copyWith(thread: newThread);
        lastActionType = MessageLastActionType.originalPosition;
      }
      refresh();
    }
  }

  @override
  void onChatThreadDestroy(ChatThreadEvent event) async {
    int index = msgModelList.indexWhere(
        (element) => element.message.msgId == event.chatThread?.messageId);
    if (index != -1) {
      msgModelList[index] = msgModelList[index].clearThread();
      lastActionType = MessageLastActionType.originalPosition;
      refresh();
    }
  }

  @override
  void onMessageSendSuccess(String msgId, Message msg) {
    final index = msgModelList.indexWhere((element) =>
        element.message.msgId == msgId && msg.status != element.message.status);

    if (index != -1) {
      msgModelList[index] = msgModelList[index].copyWith(message: msg);
      refresh();
    }
  }

  @override
  void onMessageSendError(String msgId, Message msg, ChatError error) {
    final index = msgModelList.indexWhere((element) =>
        element.message.msgId == msgId && msg.status != element.message.status);
    if (index != -1) {
      msgModelList[index] = msgModelList[index].copyWith(message: msg);
      refresh();
    }
  }

  void _replaceMessage(Message message) {
    final index = msgModelList
        .indexWhere((element) => element.message.msgId == message.msgId);
    if (index != -1) {
      msgModelList[index] = msgModelList[index].copyWith(message: message);
      refresh();
    }
  }

  void playMessage(Message message) {
    if (message.bodyType == MessageType.VOICE) {
      if (!message.voiceHasPlay) {
        message.setVoiceHasPlay(true);
        _replaceMessage(message);
      }
    }
  }

  Future<void> translateMessage(Message message,
      {bool showTranslate = true}) async {
    try {
      Message msg = await ChatUIKit.instance.translateMessage(
        msg: message,
        languages: [ChatUIKitSettings.translateTargetLanguage],
      );
      Map<String, dynamic>? map = msg.attributes;
      map ??= {};
      if (showTranslate) {
        msg.setHasTranslate(true);
      } else {
        msg.setHasTranslate(false);
      }

      await ChatUIKit.instance.updateMessage(message: msg);
      _replaceMessage(msg);
    } catch (e) {
      debugPrint('translateMessage: $e');
    }
  }

  Future<void> _clearMention(List<MessageModel> msgs) async {
    // if (profile.type == ChatUIKitProfileType.group) {
    //   return;
    // }
    if (msgs.any((element) => element.message.hasMention != null)) {
      clearMentionIfNeed();
    }
  }

  void refresh() {
    if (isDisposed) return;
    if (msgModelList.isEmpty) {
      lastActionType = MessageLastActionType.bottomPosition;
      canMoveToBottomPosition = true;
    }
    notifyListeners();
  }

  ChatType get chatType {
    if (profile.type == ChatUIKitProfileType.group) {
      return ChatType.GroupChat;
    } else {
      return ChatType.Chat;
    }
  }

  Future<void> sendTextMessage(
    String text, {
    Message? replay,
    dynamic mention,
  }) async {
    Message message = Message.createTxtSendMessage(
      targetId: profile.id,
      chatType: chatType,
      content: text,
    );

    if (mention != null) {
      Map<String, dynamic> mentionExt = {};
      if (mention is bool && mention == true) {
        mentionExt[mentionKey] = mentionAllValue;
      } else if (mention is List<String>) {
        List<String> mentionList = [];
        for (var userId in mention) {
          {
            mentionList.add(userId);
          }
        }
        if (mentionList.isNotEmpty) {
          mentionExt[mentionKey] = mentionList;
        }
      }
      if (mentionExt.isNotEmpty) {
        message.attributes = mentionExt;
      }
    }

    if (replay != null) {
      message.addQuote(replay);
    }

    await sendMessage(message);
  }

  Future<void> editMessage(Message message, String content) async {
    TextMessageBody msgBody = TextMessageBody(content: content);
    try {
      Message msg = await ChatUIKit.instance.modifyMessage(
        messageId: message.msgId,
        msgBody: msgBody,
      );
      msg.setHasTranslate(false);
      String? url = ChatUIKitURLHelper().getUrlFromText(content);
      ChatUIKitPreviewObj? obj = message.getPreview();
      if (obj?.url != url) {
        msg.removePreview();
      }
      ChatUIKit.instance.updateMessage(message: msg);
      final index = msgModelList
          .indexWhere((element) => msg.msgId == element.message.msgId);
      if (index != -1) {
        msgModelList[index] = msgModelList[index].copyWith(message: msg);
        refresh();
      }

      if (url != null) {
        try {
          ChatUIKitPreviewObj? obj =
              await ChatUIKitURLHelper().fetchPreview(url);
          msg.addPreview(obj);
          ChatUIKit.instance.updateMessage(message: msg);
          final index = msgModelList
              .indexWhere((element) => msg.msgId == element.message.msgId);
          if (index != -1) {
            msgModelList[index] = msgModelList[index].copyWith(message: msg);
            refresh();
          }
        } catch (e) {
          debugPrint('fetchPreview: $e');
        }
      }

      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      await ChatUIKit.instance.deleteLocalMessageById(
        conversationId: profile.id,
        type: conversationType,
        messageId: messageId,
      );
      msgModelList.removeWhere((element) => messageId == element.message.msgId);
      if (cacheMessages.isNotEmpty) {
        msgModelList.insert(0, cacheMessages.first);
        cacheMessages.removeAt(0);
      }
      refresh();
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> recallMessage(Message message) async {
    int index = msgModelList
        .indexWhere((element) => message.msgId == element.message.msgId);
    if (index != -1) {
      try {
        await ChatUIKit.instance.recallMessage(message: message);
        refresh();
      } catch (e) {
        debugPrint('recallMessage err: $e');
      }
    }
  }

  Future<void> reportMessage({
    required Message message,
    required String tag,
    required String reason,
  }) async {
    try {
      ChatUIKit.instance.reportMessage(
        messageId: message.msgId,
        tag: tag,
        reason: reason,
      );
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> sendVoiceMessage(
      String path, int duration, String? displayName) async {
    final message = Message.createVoiceSendMessage(
      targetId: profile.id,
      chatType: chatType,
      filePath: path,
      duration: duration,
      displayName: displayName,
    );
    sendMessage(message);
  }

  Future<void> sendImageMessage(
    String path, {
    String? name,
    bool? isGif,
  }) async {
    if (path.isEmpty) {
      return;
    }

    File file = File(path);

    final ImageStream stream =
        Image.file(file).image.resolve(ImageConfiguration.empty);
    final Completer<Size> completer = Completer<Size>();
    final ImageStreamListener listener = ImageStreamListener(
      (ImageInfo imageInfo, bool synchronousCall) {
        final Size size = Size(
          imageInfo.image.width.toDouble(),
          imageInfo.image.height.toDouble(),
        );
        if (!completer.isCompleted) {
          completer.complete(size);
        }
      },
      onError: (dynamic exception, StackTrace? stackTrace) {
        if (!completer.isCompleted) {
          completer.completeError(exception, stackTrace);
        }
      },
    );

    stream.addListener(listener);
    Size? size;
    try {
      size = await completer.future;
    } catch (e) {
      debugPrint('获取图片尺寸失败: $e');
    } finally {
      stream.removeListener(listener);
    }

    Message message = Message.createImageSendMessage(
      targetId: profile.id,
      chatType: chatType,
      filePath: path,
      width: size?.width ?? 100,
      height: size?.height ?? 100,
      fileSize: file.lengthSync(),
      displayName: name,
      isGif: isGif ?? false,
    );

    sendMessage(message);
  }

  Future<void> sendVideoMessage(
    String path, {
    String? name,
    double? width,
    double? height,
    int? duration,
  }) async {
    if (path.isEmpty) {
      return;
    }
    final uint8list =
        await VideoCompress.getByteThumbnail(path, quality: 80, position: -1);

    final directory = await getApplicationCacheDirectory();
    String thumbnailPath =
        '${directory.path}/thumbnail_${Random().nextInt(999999999)}.jpeg';
    final file = File(thumbnailPath);
    file.writeAsBytesSync(uint8list!);

    final videoFile = File(path);

    Image.file(file)
        .image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((info, synchronousCall) {
      final msg = Message.createVideoSendMessage(
        targetId: profile.id,
        chatType: chatType,
        filePath: path,
        thumbnailLocalPath: file.path,
        width: info.image.width.toDouble(),
        height: info.image.height.toDouble(),
        fileSize: videoFile.lengthSync(),
        displayName: videoFile.path.split('/').last,
      );
      sendMessage(msg);
    }));
  }

  Future<void> sendFileMessage(
    String path, {
    String? name,
    int? fileSize,
  }) async {
    final msg = Message.createFileSendMessage(
      targetId: profile.id,
      chatType: chatType,
      filePath: path,
      fileSize: fileSize,
      displayName: name,
    );
    sendMessage(msg);
  }

  Future<void> sendCardMessage(ChatUIKitProfile cardProfile) async {
    Map<String, String> param = {cardUserIdKey: cardProfile.id};
    if (cardProfile.contactShowName.isNotEmpty) {
      param[cardNicknameKey] = cardProfile.contactShowName;
    }
    if (cardProfile.avatarUrl != null) {
      param[cardAvatarKey] = cardProfile.avatarUrl!;
    }

    final message = Message.createCustomSendMessage(
      targetId: profile.id,
      chatType: chatType,
      event: cardMessageKey,
      params: param,
    );
    sendMessage(message);
  }

  Future<void> sendMessage(Message message) async {
    Message? willSendMsg = message;
    if (willSendHandler != null) {
      willSendMsg = await willSendHandler!(willSendMsg);
      if (willSendMsg == null) {
        return Future(() => null);
      }
    }
    willSendMsg.addProfile();
    if (ChatUIKit.instance.currentUserId != null) {
      final profile = ChatUIKitProvider.instance.getProfileById(
        ChatUIKit.instance.currentUserId!,
      );
      if (profile != null) {
        userMap[ChatUIKit.instance.currentUserId!] = profile;
      }
    }
    // 插入缓存中的消息
    addAllCacheToList();

    String? url;
    if (willSendMsg.bodyType == MessageType.TXT) {
      url = ChatUIKitURLHelper().getUrlFromText(willSendMsg.textContent);
      if (url?.isNotEmpty == true) {
        willSendMsg.status = MessageStatus.FAIL;
        await ChatUIKit.instance.insertMessage(message: willSendMsg);
        willSendMsg.status = MessageStatus.PROGRESS;
        msgModelList.insert(0, MessageModel(message: willSendMsg));
        hasNew = true;
        lastActionType = MessageLastActionType.bottomPosition;
        refresh();
        ChatUIKitPreviewObj? obj = await ChatUIKitURLHelper()
            .fetchPreview(url!, messageId: willSendMsg.msgId);
        willSendMsg.addPreview(obj);
        ChatSDKService.instance.sendMessage(message: willSendMsg);
      }
    }

    if (url == null) {
      final msg =
          await ChatSDKService.instance.sendMessage(message: willSendMsg);
      msgModelList.insert(0, MessageModel(message: msg));
      hasNew = true;
      lastActionType = MessageLastActionType.bottomPosition;
      refresh();
    }
    debugPrint(willSendMsg.toString());
  }

  Future<void> resendMessage(Message message) async {
    msgModelList
        .removeWhere((element) => element.message.msgId == message.msgId);
    sendMessage(message);
  }

  void clearMentionIfNeed() {
    if (profile.type == ChatUIKitProfileType.group) {
      ChatUIKit.instance
          .getConversation(
        conversationId: profile.id,
        type: ConversationType.GroupChat,
      )
          .then((conv) {
        if (conv != null) {
          conv.removeMention();
        }
      });
    }
  }

// support single chat.
  Future<void> sendConversationsReadAck() async {
    await markAllMessageAsRead();
    if (conversationType == ConversationType.Chat) {
      try {
        final conv = await ChatUIKit.instance.getConversation(
          conversationId: profile.id,
          type: conversationType,
        );
        int unreadCount = await conv?.unreadCount() ?? 0;
        if (unreadCount > 0) {
          await ChatUIKit.instance
              .sendConversationReadAck(conversationId: profile.id);
          for (var element in msgModelList) {
            element.message.hasReadAck = true;
          }
        }

        // 因为已读状态是对方看的，所以这个时候不需要刷新ui
        // updateView();
        // ignore: empty_catches
      } catch (e) {
        debugPrint('sendConversationsReadAck: $e');
      }
    }
  }

  void sendMessageReadAck(Message message) {
    if (message.chatType == ChatType.Chat &&
        message.direction == MessageDirection.RECEIVE &&
        message.hasReadAck == false) {
      ChatSDKService.instance
          .sendMessageReadAck(message: message)
          .then((value) {
        message.hasReadAck = true;
      }).catchError((error) {});
    }
  }

  Future<void> markAllMessageAsRead() async {
    await ChatUIKit.instance.markConversationAsRead(conversationId: profile.id);
  }

  Future<void> downloadMessage(Message message) async {
    ChatUIKit.instance.downloadAttachment(message: message);
  }

  String getModelId(Message message) {
    return Random().nextInt(999999999).toString() +
        message.localTime.toString();
  }

  void attemptSendInputType() {
    if (profile.type == ChatUIKitProfileType.contact) {
      if (_typing || ChatUIKitSettings.enableTypingIndicator == false) {
        return;
      }
      ChatUIKit.instance.sendTyping(userId: profile.id);
      _typing = true;
      Future.delayed(const Duration(seconds: 4), () {
        _typing = false;
      });
    }
  }

  void enableMultiSelectMode() {
    isMultiSelectMode = true;
    selectedMessages.clear();
    lastActionType = MessageLastActionType.originalPosition;
    notifyListeners();
  }

  void disableMultiSelectMode() {
    isMultiSelectMode = false;
    selectedMessages.clear();
    notifyListeners();
  }

  void deleteSelectedMessages() async {
    await deleteMessages(
      messageIds: selectedMessages.map((e) => e.msgId).toList(),
    );
    disableMultiSelectMode();
  }

  Future<void> deleteMessages({required List<String> messageIds}) async {
    try {
      await ChatUIKit.instance.deleteLocalMessageByIds(
        conversationId: profile.id,
        type: conversationType,
        messageIds: messageIds,
      );
      msgModelList
          .removeWhere((element) => messageIds.contains(element.message.msgId));

      refresh();
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> updateReaction(
    String messageId,
    String reaction,
    bool isAdd,
  ) async {
    try {
      if (isAdd) {
        await ChatUIKit.instance.addReaction(
          messageId: messageId,
          reaction: reaction,
        );
      } else {
        await ChatUIKit.instance.deleteReaction(
          messageId: messageId,
          reaction: reaction,
        );
      }
    } catch (e) {
      debugPrint('updateReaction: $e');
    }
  }

  Future<void> pinMessage(Message message) async {
    try {
      await ChatUIKit.instance.pinMessage(
        messageId: message.msgId,
      );
      pinedMessages.value = pinedMessages.value + [message];
    } catch (e) {
      debugPrint('pinMessage: $e');
    }
  }

  Future<void> unpinMessage(Message message) async {
    try {
      await ChatUIKit.instance.unpinMessage(messageId: message.msgId);
      List<Message> pinedMessagesList = pinedMessages.value;
      int index = pinedMessagesList
          .indexWhere((element) => element.msgId == message.msgId);
      if (index != -1) {
        pinedMessagesList.removeAt(index);
        pinedMessages.value = pinedMessagesList;
      }
    } catch (e) {
      debugPrint('unpinMessage: $e');
    }
  }

  Future<void> fetchPinnedMessages() async {
    try {
      List<Message> ret = await ChatUIKit.instance
          .fetchPinnedMessages(conversationId: profile.id);
      pinedMessages.value = ret;
    } catch (e) {
      debugPrint('fetchPinMessage: $e');
    }
  }

  @override
  void onMessagePinChanged(
    String messageId,
    String conversationId,
    MessagePinOperation pinOperation,
    MessagePinInfo pinInfo,
  ) {}
}

typedef BottomCondition = bool Function();

extension MessageListViewControllerExtension on MessagesViewController {
  void addCanMoveBottomConditions(BottomCondition condition) {
    bottomConditions.add(condition);
  }

  void cleanBottomConditions(BottomCondition condition) {
    bottomConditions.remove(condition);
  }
}
