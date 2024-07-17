import 'chat_uikit.dart';

import 'package:flutter/material.dart';

enum CornerRadius { extraSmall, small, medium, large }

class ChatUIKitSettings {
  /// Specifies the corner radius for the avatars in the uikit.
  static CornerRadius avatarRadius = CornerRadius.medium;

  /// Specifies the corner radius of the search box.
  static CornerRadius searchBarRadius = CornerRadius.small;

  /// Specifies the corner radius of the input box.
  static CornerRadius inputBarRadius = CornerRadius.medium;

  /// Default avatar placeholder image
  static ImageProvider? avatarPlaceholder;

  /// The corner radius for the dialog.
  static ChatUIKitDialogRectangleType dialogRectangleType =
      ChatUIKitDialogRectangleType.filletCorner;

  /// Default display style of message bubbles
  static ChatUIKitMessageListViewBubbleStyle messageBubbleStyle =
      ChatUIKitMessageListViewBubbleStyle.arrow;

  /// Whether to show avatars in the conversation list
  static bool showConversationListAvatar = true;

  /// Whether to show unread message count in the conversation list
  static bool showConversationListUnreadCount = true;

  /// Mute icon displayed in the conversation list
  static ImageProvider? conversationListMuteImage;

  /// Contact item list height
  static double contactItemListItemHeight = 60;

  /// Contact item more list item height
  static double contactItemMoreListItemHeight = 56;

  /// Message long press menu
  static List<ChatUIKitActionType> msgItemLongPressActions = [
    ChatUIKitActionType.reaction,
    ChatUIKitActionType.copy, // only text message
    ChatUIKitActionType.forward,
    ChatUIKitActionType.thread, // only group message
    ChatUIKitActionType.reply,
    ChatUIKitActionType.recall,
    ChatUIKitActionType.edit, // only text message
    ChatUIKitActionType.multiSelect,
    ChatUIKitActionType.pinMessage,
    ChatUIKitActionType.translate, // only text message
    ChatUIKitActionType.report,
    ChatUIKitActionType.delete,
  ];

  /// Whether to enable the functionality of input status for one-on-one chat messages.
  static bool enableTypingIndicator = true;

  /// Whether to enable the thread feature
  static bool enableMessageThread = true;

  /// Whether to enable message translation feature
  static bool enableMessageTranslation = true;

  /// Message translation target language
  static String translateTargetLanguage = 'zh-Hans';

  /// Whether to enable message reaction feature
  static bool enableMessageReaction = true;

  /// Message emoji reply bottom sheet title display content, this content needs to be included in the emoji list [ChatUIKitEmojiData.emojiList].
  static List<String> favoriteReaction = [
    '\u{1F44D}',
    '\u{2764}',
    '\u{1F609}',
    '\u{1F928}',
    '\u{1F62D}',
    '\u{1F389}',
  ];

  /// Default message URL regular expression
  static RegExp defaultUrlRegExp = RegExp(
    r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+',
    caseSensitive: false,
  );

  /// Whether to enable the message pinning feature
  static bool enablePinMsg = true;

  /// Whether to enable message quoting feature
  static bool enableMessageReply = true;

  /// Whether to enable message recall feature
  static bool enableMessageRecall = true;

  /// Time limit for message recall, in seconds
  static int recallExpandTime = 120;

  /// Whether to enable message editing feature
  static bool enableMessageEdit = true;

  /// Whether to enable message reporting feature
  static bool enableMessageReport = true;

  /// Message report tags, can be customized. The reasons for reporting should be written in the localization file, and the key for the reason in the localization file should be consistent with the tag. For example, [ChatUIKitLocal.reportTarget1]
  static List<String> reportMessageTags = [
    'tag1',
    'tag2',
    'tag3',
    'tag4',
    'tag5',
    'tag6',
    'tag7',
    'tag8',
    'tag9',
  ];

  /// Whether to enable message multi-select forwarding feature
  static bool enableMessageMultiSelect = true;

  /// Whether to enable message forwarding feature
  static bool enableMessageForward = true;

  /// Contact alphabetical sorting order, if there are Chinese characters, you can redefine the initials using [ChatUIKitAlphabetSortHelper].
  static String sortAlphabetical = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ#';
}
