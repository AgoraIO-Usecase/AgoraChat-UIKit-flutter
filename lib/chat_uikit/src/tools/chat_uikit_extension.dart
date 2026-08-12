import 'dart:convert';
import 'dart:math';

import 'package:agora_chat_uikit/chat_sdk_context/src/context.dart';
import 'package:agora_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

const String convLoadFinishedKey =
    'EaseChatUIKit_conversation_load_more_finished';
const String contactLoadFinishedKey =
    'EaseChatUIKit_contact_load_more_finished';
const String muteMapKey = 'EaseChatUIKit_conversation_mute_map';
const String requestsKey = 'EaseChatUIKit_friend_requests';

extension Request on ChatSDKContext {
  List requestList() {
    return cachedMap[requestsKey] ?? [];
  }

  int newRequestCount() {
    int count = 0;
    cachedMap[requestsKey]?.forEach((element) {
      if (!element['isRead']) {
        count++;
      }
    });
    return count;
  }

  void markAllRequestsAsRead() {
    List requestList = cachedMap[requestsKey] ?? [];
    bool hasUnread = false;
    for (var element in requestList) {
      if (element['isRead'] == false) {
        hasUnread = true;
      }
      element['isRead'] = true;
    }
    cachedMap[requestsKey] = requestList;
    if (hasUnread) {
      ChatUIKit.instance.onFriendRequestCountChanged(newRequestCount());
    }

    save();
  }

  bool addRequest(String userId, String? reason, [bool isGroup = false]) {
    List requestList = cachedMap[requestsKey] ?? [];
    if (requestList.any((element) =>
        element['id'] == userId && element['isGroup'] == isGroup)) {
      return false;
    }
    requestList.add({
      'id': userId,
      'reason': reason,
      'isGroup': isGroup,
      'isRead': false,
    });
    cachedMap[requestsKey] = requestList;
    ChatUIKit.instance.onFriendRequestCountChanged(newRequestCount());
    save();
    return true;
  }

  void removeRequest(String userId, [bool isGroup = false]) {
    List requestList = cachedMap[requestsKey] ?? [];
    int index = requestList.indexWhere(
        (element) => element['id'] == userId && element['isGroup'] == isGroup);
    if (index != -1) {
      Map ret = requestList.removeAt(index);
      if (ret.containsKey('isRead') && !ret['isRead']) {
        ChatUIKit.instance.onFriendRequestCountChanged(newRequestCount());
      }
      cachedMap[requestsKey] = requestList;
      save();
    }
  }

  // 删除指定id的请求
  void removeRequests(List<String> userIds, [isGroup = false]) {
    List requestList = cachedMap[requestsKey] ?? [];
    bool needUpdate = false;
    for (var userId in userIds) {
      int index = requestList.indexWhere((element) =>
          element['id'] == userId && element['isGroup'] == isGroup);

      if (index != -1) {
        needUpdate = true;
        requestList.removeAt(index);
      }
    }
    if (needUpdate) {
      cachedMap[requestsKey] = requestList;
      save();
      ChatUIKit.instance.onFriendRequestCountChanged(newRequestCount());
    }
  }
}

extension ContactLoad on ChatSDKContext {
  bool isContactLoadFinished() {
    return cachedMap[contactLoadFinishedKey] ??= false;
  }

  void setContactLoadFinished() {
    cachedMap[contactLoadFinishedKey] = true;
    save();
  }
}

extension ConversationFirstLoad on ChatSDKContext {
  bool isConversationLoadFinished() {
    return cachedMap[convLoadFinishedKey] ??= false;
  }

  void setConversationLoadFinished() {
    cachedMap[convLoadFinishedKey] = true;
    save();
  }
}

extension ConversationMute on ChatSDKContext {
  void addConversationMute(Map<String, int> map) {
    dynamic tmpMap = cachedMap[muteMapKey] ?? {};
    tmpMap.addAll(map);
    cachedMap[muteMapKey] = tmpMap;
    save();
  }

  bool conversationIsMute(String conversationId) {
    dynamic tmpMap = cachedMap[muteMapKey] ?? {};
    return tmpMap?.containsKey(conversationId) ?? false;
  }

  void deleteConversationMute(List<String> list) {
    dynamic tmpMap = cachedMap[muteMapKey] ?? {};
    for (var element in list) {
      tmpMap.remove(element);
    }
    cachedMap[muteMapKey] = tmpMap;
    save();
  }
}

const String userGenderKey = 'gender';
const String userIdentifyKey = 'identify';
const String userExtKey = 'ext';

extension ConversationHelp on Conversation {
  Future<void> addMention([String mentionType = hasMentionValue]) async {
    Map<String, String> conversationExt = ext ?? {};
    conversationExt[hasMentionKey] = mentionType;
    await setExt(conversationExt);
  }

  Future<void> removeMention() async {
    if (ext != null && ext?[hasMentionKey] != null) {
      ext?.remove(hasMentionKey);
      await setExt(ext);
    }
  }
}

extension StringLocal on String {
  String localString(BuildContext context) => getString(context);

  bool hasURL() {
    final urlRegex = ChatUIKitSettings.defaultUrlRegExp;
    return urlRegex.hasMatch(this);
  }
}

extension PutWithoutNull on Map<String, dynamic> {
  void putIfNotNull(String key, dynamic value) {
    if (value != null) {
      this[key] = value;
    }
  }
}

extension ChatRoomUserInfo on ChatUIKitProfile {
  static ChatUIKitProfile createUserProfile({
    required String userId,
    String? nickname,
    String? avatarUrl,
    int? gender,
    String? identify,
    Map<String, String>? ext,
  }) {
    final profile = ChatUIKitProfile(
      id: userId,
      type: ChatUIKitProfileType.contact,
      showName: nickname,
      avatarUrl: avatarUrl,
    );
    if (gender != null) {
      profile.extension[userGenderKey] = gender;
    }
    if (identify != null) {
      profile.extension[userIdentifyKey] = identify;
    }
    if (ext != null) {
      profile.extension[userExtKey] = ext;
    }
    return profile;
  }

  static ChatUIKitProfile userInfoFromJson(Map<String, dynamic> json) {
    final profile = ChatUIKitProfile(
      id: json['userId']!,
      type: ChatUIKitProfileType.contact,
      showName: json['nickname'],
      avatarUrl: json['avatarURL'],
    );
    if (json[userGenderKey] != null) {
      profile.extension[userGenderKey] = json[userGenderKey];
    }
    if (json[userIdentifyKey] != null) {
      profile.extension[userIdentifyKey] = json[userIdentifyKey];
    }
    if (json[userExtKey] != null) {
      profile.extension[userExtKey] = json[userExtKey];
    }
    return profile;
  }

  Map<String, Object> toJson() {
    Map<String, Object> map = {};
    map.putIfNotNull('userId', id);
    map.putIfNotNull('nickname', nickname);
    map.putIfNotNull('avatarURL', avatarUrl);
    map.putIfNotNull('gender', extension[userGenderKey]);
    map.putIfNotNull('identify', extension[userIdentifyKey]);
    map.putIfNotNull('ext', extension[userExtKey]);
    return map;
  }

  String? get identify {
    return extension[userIdentifyKey] as String?;
  }

  int? get gender {
    return extension[userGenderKey] as int?;
  }

  Map<String, String>? get ext {
    return extension[userExtKey] as Map<String, String>?;
  }
}

extension ChatUIKitMessage on Message {
  static Message createAlertMessage(String targetId, ChatType chatType,
      {Map<String, String>? params}) {
    return Message.createCustomSendMessage(
        targetId: targetId,
        event: alertCustomMessageKey,
        chatType: chatType,
        params: params);
  }

  Map<String, String>? get customBodyParams {
    if (bodyType == MessageType.CUSTOM) {
      return (body as CustomMessageBody).params;
    }
    return null;
  }
}

class ChatRoomUIKitKey {
  static String userInfo = 'chatroom_uikit_userInfo';
  static String userJoinEvent = 'CHATROOMUIKITUSERJOIN';
  static String customEvent = 'CHATROOMUIKITCUSTOM';
  static String giftEvent = 'CHATROOMUIKITGIFT';
  static String gift = 'chatroom_uikit_gift';
}

extension ChatRoomMessage on Message {
  bool get isChatRoomJoinNotify {
    bool ret = false;
    if (body.type == MessageType.CUSTOM) {
      String event = (body as CustomMessageBody).event;
      if (ChatRoomUIKitKey.userJoinEvent == event) {
        ret = true;
      }
    }
    return ret;
  }

  bool get isChatRoomGiftNotify {
    return isBroadcast;
  }

  bool get isChatRoomGift {
    bool ret = false;
    if (body.type == MessageType.CUSTOM) {
      String event = (body as CustomMessageBody).event;
      if (ChatRoomUIKitKey.giftEvent == event) {
        ret = true;
      }
    }
    return ret;
  }

  ChatRoomGift? getGift() {
    ChatRoomGift? gift;
    if (body.type == MessageType.CUSTOM) {
      String event = (body as CustomMessageBody).event;
      if (ChatRoomUIKitKey.giftEvent != event) {
        return null;
      }
      Map<String, String>? params = (body as CustomMessageBody).params;
      String? giftJs = params?[ChatRoomUIKitKey.gift];
      if (giftJs != null) {
        gift = ChatRoomGift.fromJson(json.decode(giftJs));
      }
    }
    return gift;
  }

  void addUserInfo([String? belongId]) {
    ChatUIKitProfile? profile =
        ChatUIKitProvider.instance.getProfileById(from, belongId);
    profile ??= ChatUIKitProfile.contact(
      id: ChatUIKit.instance.currentUserId!,
    );
    attributes ??= {};
    attributes![ChatRoomUIKitKey.userInfo] = profile.toJson();
  }

  ChatUIKitProfile? getUserInfo() {
    Map<String, dynamic>? map = attributes?[ChatRoomUIKitKey.userInfo];
    if (map == null) return null;
    return ChatRoomUserInfo.userInfoFromJson(map);
  }

  /// 创建礼物消息
  static Message giftMessage(String roomId, ChatRoomGift gift) {
    Message giftMsg = Message.createCustomSendMessage(
      targetId: roomId,
      event: ChatRoomUIKitKey.giftEvent,
      params: {ChatRoomUIKitKey.gift: json.encode(gift.toJson())},
      chatType: ChatType.ChatRoom,
    );

    giftMsg.addUserInfo(roomId);

    return giftMsg;
  }

  /// 创建聊天室消息
  static Message roomMessage(String roomId, String text) {
    Message msg = Message.createTxtSendMessage(
      targetId: roomId,
      content: text,
      chatType: ChatType.ChatRoom,
    );
    msg.addUserInfo(roomId);
    return msg;
  }

  static Message joinedMessage(String roomId) {
    Message msg = Message.createCustomSendMessage(
      targetId: roomId,
      event: ChatRoomUIKitKey.userJoinEvent,
      chatType: ChatType.ChatRoom,
    );
    msg.addUserInfo(roomId);
    return msg;
  }

  /// 创建自定义聊天室消息
  static Message customMessage(
    String roomId,
    String event, {
    Map<String, String>? params,
    ChatRoomMessagePriority priority = ChatRoomMessagePriority.Normal,
  }) {
    Message msg = Message.createCustomSendMessage(
      targetId: roomId,
      event: event,
      params: params,
      chatType: ChatType.ChatRoom,
    );

    msg.chatroomMessagePriority = priority;
    msg.addUserInfo(roomId);
    return msg;
  }
}

extension MessageHelper on Message {
  MessageType get bodyType => body.type;

  ChatUIKitProfile get fromProfile {
    return ChatUIKitProfile.contact(
      id: from!,
      avatarUrl: avatarUrl,
      nickname: nickname,
      timestamp: serverTime,
    );
  }

  void addProfile() {
    _addAvatarURL(
      ChatUIKitProvider.instance
          .getProfileById(ChatUIKit.instance.currentUserId)
          ?.avatarUrl,
    );
    _addNickname(
      ChatUIKitProvider.instance
          .getProfileById(ChatUIKit.instance.currentUserId)
          ?.contactShowName,
    );
  }

  void addPreview(ChatUIKitPreviewObj? previewObj) {
    if (previewObj == null) return;
    attributes ??= {};
    attributes![msgPreviewKey] = previewObj.toJson();
  }

  ChatUIKitPreviewObj? getPreview() {
    Map<String, dynamic>? previewMap = attributes?[msgPreviewKey];
    if (previewMap != null) {
      return ChatUIKitPreviewObj.fromJson(previewMap);
    }
    return null;
  }

  void removePreview() {
    attributes?.remove(msgPreviewKey);
  }

  String? get avatarUrl {
    Map? userInfo = attributes?[msgUserInfoKey];
    return userInfo?[userAvatarKey];
  }

  bool get voiceHasPlay {
    return attributes?[voiceHasReadKey] == true;
  }

  void setVoiceHasPlay(bool hasPlay) {
    attributes ??= {};
    attributes![voiceHasReadKey] = hasPlay;
    ChatUIKit.instance.updateMessage(message: this);
  }

  String? get nickname {
    Map? userInfo = attributes?[msgUserInfoKey];
    return userInfo?[userNicknameKey];
  }

  void _addNickname(String? nickname) {
    if (nickname?.isNotEmpty == true) {
      attributes ??= {};
      attributes![msgUserInfoKey] ??= {};
      attributes![msgUserInfoKey][userNicknameKey] = nickname;
    }
  }

  void _addAvatarURL(String? avatarUrl) {
    if (avatarUrl?.isNotEmpty == true) {
      attributes ??= {};
      attributes![msgUserInfoKey] ??= {};
      attributes![msgUserInfoKey][userAvatarKey] = avatarUrl;
    }
  }

  String get textContent {
    if (bodyType == MessageType.TXT) {
      return (body as TextMessageBody).content;
    }
    return '';
  }

  bool get isEdit {
    if (bodyType == MessageType.TXT) {
      if ((body as TextMessageBody).modifyCount == null) return false;
      return (body as TextMessageBody).modifyCount! > 0;
    }
    return false;
  }

  String? get displayName {
    if (bodyType == MessageType.IMAGE) {
      return (body as ImageMessageBody).displayName;
    } else if (bodyType == MessageType.VOICE) {
      return (body as VoiceMessageBody).displayName;
    } else if (bodyType == MessageType.VIDEO) {
      return (body as VideoMessageBody).displayName;
    } else if (bodyType == MessageType.FILE) {
      return (body as FileMessageBody).displayName;
    }
    return null;
  }

  int get duration {
    if (bodyType == MessageType.VOICE) {
      return (body as VoiceMessageBody).duration;
    } else if (bodyType == MessageType.VIDEO) {
      return (body as VideoMessageBody).duration ?? 0;
    }
    return 0;
  }

  int get fileSize {
    int? length;
    if (bodyType == MessageType.IMAGE) {
      length = (body as ImageMessageBody).fileSize;
    } else if (bodyType == MessageType.VOICE) {
      length = (body as VoiceMessageBody).fileSize;
    } else if (bodyType == MessageType.VIDEO) {
      length = (body as VideoMessageBody).fileSize;
    } else if (bodyType == MessageType.FILE) {
      length = (body as FileMessageBody).fileSize;
    } else {
      length = 0;
    }
    return length!;
  }

  String get fileSizeStr {
    int? length;
    if (bodyType == MessageType.IMAGE) {
      length = (body as ImageMessageBody).fileSize;
    } else if (bodyType == MessageType.VOICE) {
      length = (body as VoiceMessageBody).fileSize;
    } else if (bodyType == MessageType.VIDEO) {
      length = (body as VideoMessageBody).fileSize;
    } else if (bodyType == MessageType.FILE) {
      length = (body as FileMessageBody).fileSize;
    } else {
      length = 0;
    }
    return ChatUIKitFileSizeTool.fileSize(length!);
  }

  String? get thumbnailLocalPath {
    if (bodyType == MessageType.IMAGE) {
      return (body as ImageMessageBody).thumbnailLocalPath;
    } else if (bodyType == MessageType.VIDEO) {
      return (body as VideoMessageBody).thumbnailLocalPath;
    }
    return null;
  }

  bool get isGif {
    if (bodyType == MessageType.IMAGE) {
      return (body as ImageMessageBody).isGif;
    }
    return false;
  }

  String? get thumbnailRemotePath {
    if (bodyType == MessageType.IMAGE) {
      return (body as ImageMessageBody).thumbnailRemotePath;
    } else if (bodyType == MessageType.VIDEO) {
      return (body as VideoMessageBody).thumbnailRemotePath;
    }
    return null;
  }

  String? get localPath {
    if (bodyType == MessageType.IMAGE) {
      return (body as ImageMessageBody).localPath;
    } else if (bodyType == MessageType.VOICE) {
      return (body as VoiceMessageBody).localPath;
    } else if (bodyType == MessageType.VIDEO) {
      return (body as VideoMessageBody).localPath;
    } else if (bodyType == MessageType.FILE) {
      return (body as FileMessageBody).localPath;
    }
    return null;
  }

  String? get remotePath {
    if (bodyType == MessageType.IMAGE) {
      return (body as ImageMessageBody).remotePath;
    } else if (bodyType == MessageType.VOICE) {
      return (body as VoiceMessageBody).remotePath;
    } else if (bodyType == MessageType.VIDEO) {
      return (body as VideoMessageBody).remotePath;
    } else if (bodyType == MessageType.FILE) {
      return (body as FileMessageBody).remotePath;
    }
    return null;
  }

  double get width {
    double ret = 0.0;
    if (bodyType == MessageType.IMAGE) {
      ret = (body as ImageMessageBody).width ?? 0;
    } else if (bodyType == MessageType.VIDEO) {
      ret = (body as VideoMessageBody).width ?? 0;
    }
    return ret;
  }

  double get height {
    double ret = 0.0;
    if (bodyType == MessageType.IMAGE) {
      ret = (body as ImageMessageBody).height ?? 0;
    } else if (bodyType == MessageType.VIDEO) {
      ret = (body as VideoMessageBody).height ?? 0;
    }
    return ret;
  }

  bool get isCardMessage {
    if (bodyType == MessageType.CUSTOM) {
      final customBody = body as CustomMessageBody;
      if (customBody.event == cardMessageKey) {
        return true;
      }
    }
    return false;
  }

  String? get cardUserNickname {
    if (bodyType == MessageType.CUSTOM) {
      final customBody = body as CustomMessageBody;
      if (customBody.event == cardMessageKey) {
        return customBody.params?[cardNicknameKey];
      }
    }
    return null;
  }

  String? get cardUserAvatar {
    if (bodyType == MessageType.CUSTOM) {
      final customBody = body as CustomMessageBody;
      if (customBody.event == cardMessageKey) {
        return customBody.params?[cardAvatarKey];
      }
    }
    return null;
  }

  String? get cardUserId {
    if (bodyType == MessageType.CUSTOM) {
      final customBody = body as CustomMessageBody;
      if (customBody.event == cardMessageKey) {
        return customBody.params?[cardUserIdKey];
      }
    }
    return null;
  }

  String? get summary {
    if (bodyType == MessageType.COMBINE) {
      return (body as CombineMessageBody).summary;
    }
    return null;
  }

  String showInfo({String? customInfo}) {
    if (customInfo != null) {
      return customInfo;
    }
    String str = '';
    if (bodyType == MessageType.TXT) {
      str += textContent;
    }

    if (bodyType == MessageType.IMAGE) {
      str += '[Image]';
    }

    if (bodyType == MessageType.VOICE) {
      str += "[Voice] $duration'";
    }

    if (bodyType == MessageType.LOCATION) {
      str += '[Location]';
    }

    if (bodyType == MessageType.VIDEO) {
      str += '[Video]';
    }

    if (bodyType == MessageType.FILE) {
      str += '[File]';
    }

    if (bodyType == MessageType.COMBINE) {
      str += '[Combine]';
    }

    if (bodyType == MessageType.CUSTOM && isCardMessage) {
      str += '[Card] ${cardUserNickname ?? cardUserId}';
    }
    return str;
  }

  String showInfoTranslate(BuildContext context, {bool needShowName = false}) {
    String? title;
    if (needShowName) {
      if (chatType == ChatType.GroupChat) {
        String? showName =
            ChatUIKitProvider.instance.getProfileById(from!)?.contactShowName;
        if (nickname?.isNotEmpty == true) {
          showName ??= nickname;
        }
        title = "${showName ?? from ?? ""}: ";
      }
    }

    String? str;

    switch (body.type) {
      case MessageType.TXT:
        str = (body as TextMessageBody).content;
        break;
      case MessageType.IMAGE:
        str =
            '${[ChatUIKitLocal.messageCellCombineImage.localString(context)]}';
        break;
      case MessageType.VIDEO:
        str =
            '${[ChatUIKitLocal.messageCellCombineVideo.localString(context)]}';
        break;
      case MessageType.VOICE:
        str =
            '${[ChatUIKitLocal.messageCellCombineVoice.localString(context)]}';
        break;
      case MessageType.LOCATION:
        str = '${[
          ChatUIKitLocal.messageCellCombineLocation.localString(context)
        ]}';
        break;
      case MessageType.COMBINE:
        str = '${[
          ChatUIKitLocal.messageCellCombineCombine.localString(context)
        ]}';
        break;
      case MessageType.FILE:
        str = '${[ChatUIKitLocal.messageCellCombineFile.localString(context)]}';
        break;
      case MessageType.CUSTOM:
        if (isCardMessage) {
          str = '${[
            ChatUIKitLocal.messageCellCombineContact.localString(context)
          ]}';
        } else {
          Map<String, String>? map = (body as CustomMessageBody).params;
          String? operator = map?[alertOperatorIdKey];
          String? showName;
          if (ChatUIKit.instance.currentUserId == operator) {
            showName = ChatUIKitLocal.alertYou.localString(context);
          } else {
            if (operator?.isNotEmpty == true) {
              ChatUIKitProfile profile = ChatUIKitProvider.instance.getProfile(
                ChatUIKitProfile.contact(id: operator!),
              );
              showName = profile.contactShowName;
            }
            showName ??= '';
          }
          if (isRecallAlert) {
            return '$showName${ChatUIKitLocal.alertRecallInfo.localString(context)}';
          }
          if (isCreateGroupAlert) {
            return '$showName${ChatUIKitLocal.messagesViewAlertGroupInfoTitle.localString(context)}';
          }
          if (isCreateThreadAlert) {
            return '$showName${ChatUIKitLocal.messagesViewAlertThreadInfoTitle.localString(context)}';
          }
          if (isDestroyGroupAlert) {
            return ChatUIKitLocal.alertDestroy.localString(context);
          }

          if (isLeaveGroupAlert) {
            return '$showName${ChatUIKitLocal.alertLeave.localString(context)}';
          }

          if (isKickedGroupAlert) {
            return '$showName${ChatUIKitLocal.alertKickedInfo.localString(context)}';
          }
          if (isNewContactAlert) {
            return '${ChatUIKitLocal.alertYou.localString(context)}${ChatUIKitLocal.alertAlreadyAdd.localString(context)}$showName${ChatUIKitLocal.alertAsContact.localString(context)}';
          }

          if (isPinAlert) {
            return '$showName${ChatUIKitLocal.alertPinTitle.localString(context)}';
          }

          if (isUnPinAlert) {
            return '$showName${ChatUIKitLocal.alertUnpinTitle.localString(context)}';
          }

          str = '[Custom]';
        }

        break;
      default:
    }

    if (title?.isNotEmpty == true) {
      str = '$title$str';
    }

    return str ?? '';
  }

  String? get hasMention {
    if (attributes == null) {
      return null;
    }
    if (attributes?[mentionKey] == null) {
      return null;
    }
    if (attributes?[mentionKey] is List) {
      List mentionList = attributes?[mentionKey];
      if (mentionList.isNotEmpty) {
        if (mentionList.any((item) =>
            item.toString().toLowerCase() == mentionAllValue.toLowerCase())) {
          return hasMentionAllValue;
        } else if (mentionList.contains(ChatUIKit.instance.currentUserId)) {
          return hasMentionValue;
        }
      }
    } else if (attributes?[mentionKey] is String) {
      String mentionType = attributes?[mentionKey];
      if (mentionType.toLowerCase() == mentionAllValue.toLowerCase()) {
        return hasMentionAllValue;
      } else if (mentionType == ChatUIKit.instance.currentUserId) {
        return hasMentionValue;
      }
    }

    return null;
  }

  bool get isTimeMessageAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertTimeKey) {
        return true;
      }
    }
    return false;
  }

  bool get isAlertCustomMessage {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertCustomMessageKey) {
        return true;
      }
    }
    return false;
  }

  bool get isCreateGroupAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertGroupCreateKey) {
        return true;
      }
    }
    return false;
  }

  bool get isCreateThreadAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertCreateThreadKey) {
        return true;
      }
    }
    return false;
  }

  bool get isUpdateThreadAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertUpdateThreadKey) {
        return true;
      }
    }
    return false;
  }

  bool get isDeleteThreadAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertDeleteThreadKey) {
        return true;
      }
    }
    return false;
  }

  bool get isRecallAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertRecalledKey) {
        return true;
      }
    }
    return false;
  }

  bool get isDestroyGroupAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertGroupDestroyKey) {
        return true;
      }
    }
    return false;
  }

  bool get isLeaveGroupAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertGroupLeaveKey) {
        return true;
      }
    }
    return false;
  }

  bool get isNewContactAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertContactAddKey) {
        return true;
      }
    }
    return false;
  }

  bool get isPinAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertPinMessageKey) {
        return true;
      }
    }
    return false;
  }

  bool get isUnPinAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertUnPinMessageKey) {
        return true;
      }
    }
    return false;
  }

  bool get isRtcCallWithAgora {
    return attributes?.containsValue(rtcCallWithAgoraValue) ?? false;
  }

  bool get hasTranslate {
    return attributes?[hasTranslatedKey] == true;
  }

  void setHasTranslate(bool hasTranslate) {
    attributes ??= {};
    attributes![hasTranslatedKey] = hasTranslate;
  }

  String get translateText {
    if (hasTranslate) {
      Map<String, String>? map = (body as TextMessageBody).translations;
      if (map != null) {
        return map[ChatUIKitSettings.translateTargetLanguage] ??
            map[(body as TextMessageBody).targetLanguages?.first] ??
            '';
      }
    }
    return '';
  }

  bool get isKickedGroupAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertGroupKickedKey) {
        return true;
      }
    }
    return false;
  }

  void addQuote(Message message) {
    attributes ??= {};
    attributes![quoteKey] = message.toQuote().toJson();
  }

  QuoteModel toQuote() {
    if (bodyType == MessageType.TXT) {
      return QuoteModel.fromMessage(this, textContent);
    } else {
      return QuoteModel.fromMessage(this, '');
    }
  }

  QuoteModel? get getQuote {
    Map? quoteMap = attributes?[quoteKey];
    if (quoteMap != null) {
      return QuoteModel(
        quoteMap[quoteMsgIdKey],
        quoteMap[quoteMsgTypeKey],
        quoteMap[quoteMsgPreviewKey],
        quoteMap[quoteMsgSenderKey],
      );
    }
    return null;
  }
}

extension CornerRadiusHelper on CornerRadius {
  static double searchBarRadius(double height, {CornerRadius? cornerRadius}) {
    double circularRadius = 0;
    switch (cornerRadius ?? ChatUIKitSettings.searchBarRadius) {
      case CornerRadius.extraSmall:
        circularRadius = min(height / 16, 16);
        break;
      case CornerRadius.small:
        circularRadius = min(height / 8, 8);
        break;
      case CornerRadius.medium:
        circularRadius = min(height / 4, 4);
        break;
      case CornerRadius.large:
        circularRadius = height / 2;
        break;
    }
    return circularRadius;
  }

  static double avatarRadius(double height, {CornerRadius? cornerRadius}) {
    double circularRadius = 0;
    switch (cornerRadius ?? ChatUIKitSettings.avatarRadius) {
      case CornerRadius.extraSmall:
        circularRadius = min(height / 16, 16);
        break;
      case CornerRadius.small:
        circularRadius = min(height / 8, 8);
        break;
      case CornerRadius.medium:
        circularRadius = min(height / 4, 4);
        break;
      case CornerRadius.large:
        circularRadius = height / 2;
        break;
    }
    return circularRadius;
  }

  static double inputBarRadius(double height, {CornerRadius? cornerRadius}) {
    double circularRadius = 0;
    switch (cornerRadius ?? ChatUIKitSettings.inputBarRadius) {
      case CornerRadius.extraSmall:
        circularRadius = min(height / 16, 16);
        break;
      case CornerRadius.small:
        circularRadius = min(height / 8, 8);
        break;
      case CornerRadius.medium:
        circularRadius = min(height / 4, 4);
        break;
      case CornerRadius.large:
        circularRadius = height / 2;
        break;
    }
    return circularRadius;
  }
}
