import 'dart:io';
import 'dart:math';
import '../../chat_uikit.dart';
import '../../tools/safe_disposed.dart';
import '../../universal/chat_uikit_tools.dart';
import '../../universal/inner_headers.dart';

import 'package:flutter/material.dart';

class ThreadMessagesViewController
    with
        ChangeNotifier,
        SafeAreaDisposed,
        ChatObserver,
        MessageObserver,
        ThreadObserver {
  MessageModel? model;
  ChatThread? thread;

  bool loadFinished = false;
  String? cursor;
  final int pageSize;
  final Message? Function(Message)? willSendHandler;
  bool fetching = false;
  bool hasPermission = false;
  final Map<String, ChatUIKitProfile> userMap = {};

  bool isMultiSelectMode = false;
  List<Message> selectedMessages = [];
  List<MessageModel> msgModelList = [];

  ThreadMessagesViewController({
    this.model,
    this.willSendHandler,
    this.pageSize = 10,
  }) {
    ChatUIKit.instance.addObserver(this);
    if (ChatUIKit.instance.currentUserId != null) {
      if (ChatUIKitProvider.instance.currentUserProfile != null) {
        userMap[ChatUIKit.instance.currentUserId!] =
            ChatUIKitProvider.instance.currentUserProfile!;
      }
    }
    thread ??= model?.thread;
    joinThreadIfCan();
    updatePermission();
  }

  String? title(String? title) {
    return thread?.threadName ?? title;
  }

  void updatePermission() async {
    if (thread == null) return;
    Group? group = await ChatUIKit.instance.getGroup(groupId: thread!.parentId);
    if (group?.permissionType == GroupPermissionType.Owner) {
      hasPermission = true;
    } else {
      hasPermission = false;
    }
  }

  void joinThreadIfCan() async {
    if (thread != null) {
      try {
        thread = await ChatUIKit.instance
            .fetchChatThread(chatThreadId: thread!.threadId);
        await ChatUIKit.instance.joinChatThread(chatThreadId: thread!.threadId);
        await fetchItemList();
      } catch (e) {
        chatPrint('join thread error: $e');
      }
      await insertCreateMessage();
    }
  }

  Future<void> insertCreateMessage() async {
    if (thread != null) {
      List<Message> messages = ChatUIKitTools.tmpCreateThreadMessages(
        thread: thread!,
      );
      msgModelList.insertAll(
          0, messages.map((e) => MessageModel(message: e)).toList());

      refresh();
    }
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> fetchItemList() async {
    if (thread == null || fetching || loadFinished) return;
    try {
      fetching = true;
      CursorResult<Message> result =
          await ChatUIKit.instance.fetchHistoryMessages(
        conversationId: thread!.threadId,
        type: ConversationType.GroupChat,
        pageSize: pageSize,
        startMsgId: cursor ?? '',
        direction: SearchDirection.Down,
      );
      cursor = result.cursor;
      if (result.data.length < pageSize) {
        loadFinished = true;
      }
      for (var msg in result.data) {
        List<MessageReaction>? list = await msg.reactionList();
        msgModelList.add(MessageModel(message: msg, reactions: list));

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

      refresh();
    } catch (e) {
      chatPrint('fetch history messages error: $e');
    } finally {
      fetching = false;
    }
  }

  void enableMultiSelectMode() {
    isMultiSelectMode = true;
    selectedMessages.clear();
    notifyListeners();
  }

  void disableMultiSelectMode() {
    isMultiSelectMode = false;
    selectedMessages.clear();
    notifyListeners();
  }

  Future<bool> createThreadIfNotExits({String? threadName}) async {
    if (thread != null) {
      return true;
    }
    String name = threadName ?? model?.message.showInfo() ?? '';
    if (name.length > 32) {
      name = '${name.substring(0, 29)}...';
    }
    try {
      ChatThread createdThread = await ChatUIKit.instance.createChatThread(
        threadName: name,
        messageId: model?.message.msgId ?? '',
        parentId: model?.message.conversationId ?? '',
      );
      model = model?.copyWith(thread: createdThread);
      thread = createdThread;
      loadFinished = true;
      hasPermission = true;
      insertCreateMessage();
      return true;
    } catch (e) {
      chatPrint('create thread error: $e');
    }
    return false;
  }

  Future<void> changeThreadName(String newName) async {
    try {
      await ChatUIKit.instance.updateChatThreadName(
        chatThreadId: thread!.threadId,
        newName: newName,
      );
    } catch (e) {
      chatPrint('change thread name error: $e');
    }
  }

  Future<void> destroyChatThread() async {
    try {
      await ChatUIKit.instance.destroyChatThread(
        chatThreadId: thread?.threadId ?? model?.thread?.threadId ?? '',
      );
    } catch (e) {
      chatPrint('destroy thread error: $e');
    }
  }

  Future<void> leaveChatThread() async {
    try {
      await ChatUIKit.instance.leaveChatThread(
        chatThreadId: thread?.threadId ?? model?.thread?.threadId ?? '',
      );
    } catch (e) {
      chatPrint('leave thread error: $e');
    }
  }

  Future<void> sendTextMessage(
    String text, {
    Message? replay,
  }) async {
    if (await createThreadIfNotExits() == false) return;
    Message message = Message.createTxtSendMessage(
      targetId: thread!.threadId,
      content: text,
    );

    if (replay != null) {
      message.addQuote(replay);
    }

    sendMessage(message);
  }

  Future<void> editMessage(Message message, String content) async {
    TextMessageBody msgBody = TextMessageBody(content: content);
    try {
      Message msg = await ChatUIKit.instance.modifyMessage(
        messageId: message.msgId,
        msgBody: msgBody,
      );

      msg.setHasTranslate(false);
      ChatUIKit.instance.updateMessage(message: msg);

      final index = msgModelList
          .indexWhere((element) => msg.msgId == element.message.msgId);
      if (index != -1) {
        msgModelList[index] = msgModelList[index].copyWith(message: msg);
        refresh();
      }
      // ignore: empty_catches
    } catch (e) {}
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
    if (await createThreadIfNotExits() == false) return;
    final message = Message.createVoiceSendMessage(
      targetId: thread!.threadId,
      filePath: path,
      duration: duration,
      displayName: displayName,
    );
    sendMessage(message);
  }

  Future<void> sendImageMessage(String path, {String? name}) async {
    if (await createThreadIfNotExits() == false) return;
    if (path.isEmpty) {
      return;
    }

    File file = File(path);
    Image.file(file)
        .image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((info, synchronousCall) {
      Message message = Message.createImageSendMessage(
        targetId: thread!.threadId,
        filePath: path,
        width: info.image.width.toDouble(),
        height: info.image.height.toDouble(),
        fileSize: file.lengthSync(),
        displayName: name,
      );
      sendMessage(message);
    }));
  }

  Future<void> sendVideoMessage(
    String path, {
    String? name,
    double? width,
    double? height,
    int? duration,
  }) async {
    if (await createThreadIfNotExits() == false) return;
    if (path.isEmpty) {
      return;
    }
    final imageData = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 200,
      quality: 80,
    );
    if (imageData != null) {
      final directory = await getApplicationCacheDirectory();
      String thumbnailPath =
          '${directory.path}/thumbnail_${Random().nextInt(999999999)}.jpeg';
      final file = File(thumbnailPath);
      file.writeAsBytesSync(imageData);

      final videoFile = File(path);

      Image.file(file)
          .image
          .resolve(const ImageConfiguration())
          .addListener(ImageStreamListener((info, synchronousCall) {
        final msg = Message.createVideoSendMessage(
          targetId: thread!.threadId,
          filePath: path,
          thumbnailLocalPath: file.path,
          width: info.image.width.toDouble(),
          height: info.image.height.toDouble(),
          fileSize: videoFile.lengthSync(),
        );
        sendMessage(msg);
      }));
    }
  }

  Future<void> sendFileMessage(
    String path, {
    String? name,
    int? fileSize,
  }) async {
    if (await createThreadIfNotExits() == false) return;
    final msg = Message.createFileSendMessage(
      targetId: thread!.threadId,
      filePath: path,
      fileSize: fileSize,
      displayName: name,
    );
    sendMessage(msg);
  }

  Future<void> sendCardMessage(ChatUIKitProfile cardProfile) async {
    if (await createThreadIfNotExits() == false) return;
    Map<String, String> param = {cardUserIdKey: cardProfile.id};
    if (cardProfile.contactShowName.isNotEmpty) {
      param[cardNicknameKey] = cardProfile.contactShowName;
    }
    if (cardProfile.avatarUrl != null) {
      param[cardAvatarKey] = cardProfile.avatarUrl!;
    }

    final message = Message.createCustomSendMessage(
      targetId: thread!.threadId,
      event: cardMessageKey,
      params: param,
    );
    sendMessage(message);
  }

  Future<void> sendMessage(Message message) async {
    Message? willSendMsg = message;
    if (willSendHandler != null) {
      willSendMsg = willSendHandler!(willSendMsg);
      if (willSendMsg == null) {
        return Future(() => null);
      }
    }
    willSendMsg.addProfile();
    willSendMsg.isChatThreadMessage = true;
    willSendMsg.chatType = ChatType.GroupChat;
    final msg = await ChatUIKit.instance.sendMessage(message: willSendMsg);
    if (ChatUIKitProvider.instance.currentUserProfile != null) {
      userMap[ChatUIKit.instance.currentUserId!] =
          ChatUIKitProvider.instance.currentUserProfile!;
    }

    if (loadFinished) {
      msgModelList.add(MessageModel(message: msg));
      refresh();
    }
  }

  Future<void> resendMessage(Message message) async {
    msgModelList
        .removeWhere((element) => element.message.msgId == message.msgId);
    final msg = await ChatUIKit.instance.sendMessage(message: message);
    msgModelList.insert(0, MessageModel(message: msg));

    refresh();
  }

  Future<void> downloadMessage(Message message) async {
    ChatUIKit.instance.downloadAttachment(message: message);
  }

  Future<void> translateMessage(Message message,
      {bool showTranslate = true}) async {
    Message msg = await ChatUIKit.instance.translateMessage(
      msg: message,
      languages: [ChatUIKitSettings.translateTargetLanguage],
    );

    if (showTranslate) {
      msg.setHasTranslate(true);
    } else {
      msg.setHasTranslate(false);
    }

    await ChatUIKit.instance.updateMessage(message: msg);
    _replaceMessage(msg);
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
      chatPrint('updateReaction: $e');
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

  void addCreateMessage(Message message) {
    msgModelList.add(MessageModel(message: message));
    refresh();
  }

  void refresh() {
    notifyListeners();
  }

  @override
  void onMessageContentChanged(
    Message message,
    String operatorId,
    int operationTime,
  ) {
    _replaceMessage(message);
  }

  @override
  void onMessagesReceived(List<Message> messages) async {
    bool needUpdate = false;
    if (loadFinished) {
      for (var msg in messages) {
        if (msg.isChatThreadMessage && msg.conversationId == thread!.threadId) {
          needUpdate = true;
          List<MessageReaction>? list = await msg.reactionList();
          msgModelList.add(MessageModel(message: msg, reactions: list));
          ChatUIKitProfile? profile =
              ChatUIKitProvider.instance.getProfileById(msg.from!);
          profile ??= msg.fromProfile;
          userMap[msg.from!] = profile;
        }
      }
    }
    if (needUpdate) {
      refresh();
    }
  }

  @override
  void onMessageSendSuccess(String msgId, Message msg) {
    final index = msgModelList.indexWhere((element) =>
        element.message.msgId == msgId && msg.status != element.message.status);
    if (index != -1) {
      msgModelList[index] = msgModelList[index].copyWith(
        message: msg,
      );
      refresh();
      try {
        ChatUIKit.instance.deleteLocalThreadMessageById(
          threadId: thread!.threadId,
          messageId: msg.msgId,
        );
      } catch (e) {
        chatPrint('delete local thread message error: $e');
      }
    }
  }

  @override
  void onMessageSendError(String msgId, Message msg, ChatError error) {
    chatPrint(' thread message error: $error');
    final index = msgModelList.indexWhere((element) =>
        element.message.msgId == msgId && msg.status != element.message.status);
    if (index != -1) {
      msgModelList[index] = msgModelList[index].copyWith(message: msg);
      refresh();
    }
  }

  @override
  void onChatThreadUpdate(ChatThreadEvent event) {
    if (thread != null && thread?.threadId == event.chatThread?.threadId) {
      model = model?.copyWith(thread: thread);
      thread = event.chatThread;
      updatePermission();
      refresh();
    }
  }

  @override
  void onMessageReactionDidChange(List<MessageReactionEvent> events) async {
    bool needUpdate = false;
    for (var reactionEvent in events) {
      if (reactionEvent.conversationId == thread?.threadId) {
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
      refresh();
    }
  }
}
