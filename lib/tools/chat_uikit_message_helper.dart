import '../chat_uikit.dart';

import 'package:flutter/material.dart';

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
    _addAvatarURL(ChatUIKitProvider.instance.currentUserProfile?.avatarUrl);
    _addNickname(ChatUIKitProvider.instance.currentUserProfile?.showName);
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

  void fetchPreviewing() {
    attributes ??= {};
    attributes!['fetching'] = true;
  }

  void removePreviewing() {
    attributes?.remove('fetching');
  }

  bool hasFetchingPreview() {
    attributes ??= {};
    return attributes!['fetching'] == true;
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
            ChatUIKitProvider.instance.profilesCache[from!]?.showName;
        showName ??= nickname;
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
          if (isRecallAlert) {
            Map<String, String>? map = (body as CustomMessageBody).params;

            String? from = map?[alertOperatorIdKey];
            String? showName;
            if (ChatUIKit.instance.currentUserId == from) {
              showName = ChatUIKitLocal.alertYou.localString(context);
            } else {
              ChatUIKitProfile profile = ChatUIKitProvider.instance.getProfile(
                ChatUIKitProfile.contact(id: from!),
              );
              showName = profile.showName;
            }
            return '$showName${ChatUIKitLocal.alertRecallInfo.localString(context)}';
          }
          if (isCreateGroupAlert) {
            Map<String, String>? map = (body as CustomMessageBody).params;
            String? operator = map![alertOperatorIdKey]!;
            String? showName;
            if (ChatUIKit.instance.currentUserId == operator) {
              showName = ChatUIKitLocal.alertYou.localString(context);
            } else {
              ChatUIKitProfile profile = ChatUIKitProvider.instance.getProfile(
                ChatUIKitProfile.contact(id: from!),
              );
              showName = profile.showName;
            }
            return '$showName ${ChatUIKitLocal.messagesViewAlertGroupInfoTitle.localString(context)}';
          }
          if (isCreateThreadAlert) {
            Map<String, String>? map = (body as CustomMessageBody).params;
            String? operator = map![alertOperatorIdKey]!;
            String? showName;
            if (ChatUIKit.instance.currentUserId == operator) {
              showName = ChatUIKitLocal.alertYou.localString(context);
            } else {
              ChatUIKitProfile profile = ChatUIKitProvider.instance.getProfile(
                ChatUIKitProfile.contact(id: operator),
              );
              showName = profile.showName;
            }
            return '$showName ${ChatUIKitLocal.messagesViewAlertThreadInfoTitle.localString(context)}';
          }
          if (isDestroyGroupAlert) {
            return ChatUIKitLocal.alertDestroy.localString(context);
          }

          if (isLeaveGroupAlert) {
            return ChatUIKitLocal.alertLeave.localString(context);
          }

          if (isKickedGroupAlert) {
            return ChatUIKitLocal.alertKickedInfo.localString(context);
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

  bool get hasMention {
    bool ret = false;
    if (attributes == null) {
      ret = false;
    }
    if (attributes?[mentionKey] == null) {
      ret = false;
    }
    if (attributes?[mentionKey] is List) {
      List mentionList = attributes?[mentionKey];
      if (mentionList.isNotEmpty) {
        ret = mentionList.contains(ChatUIKit.instance.currentUserId);
      }
    } else if (attributes?[mentionKey] is String) {
      if (attributes?[mentionKey] == mentionAllValue) {
        ret = true;
      }
    }

    return ret;
  }

  bool get isTimeMessageAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertTimeKey) {
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
