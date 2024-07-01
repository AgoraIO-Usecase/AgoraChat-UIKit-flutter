import 'chat_uikit.dart';

import 'package:flutter/material.dart';

enum CornerRadius { extraSmall, small, medium, large }

class ChatUIKitSettings {
  // 头像圆角
  static CornerRadius avatarRadius = CornerRadius.medium;

  // 搜索框圆角
  static CornerRadius searchBarRadius = CornerRadius.small;

  // 头像默认占位图
  static ImageProvider? avatarPlaceholder;

  // Dialog 圆角
  static ChatUIKitDialogRectangleType dialogRectangleType =
      ChatUIKitDialogRectangleType.filletCorner;

  // 消息气泡默认显示样式
  static ChatUIKitMessageListViewBubbleStyle messageBubbleStyle =
      ChatUIKitMessageListViewBubbleStyle.arrow;

  // 会话列表是否显示头像
  static bool showConversationListAvatar = true;

  // 会话列表是否显示未读消息数
  static bool showConversationListUnreadCount = true;

  // 会话列表显示的静音图标
  static ImageProvider? conversationListMuteImage;

  // 消息输入状态
  static bool enableTypingIndicator = true;

  /// 消息长按菜单
  static List<ChatUIKitActionType> msgItemLongPressActions = [
    ChatUIKitActionType.reaction,
    ChatUIKitActionType.copy, // only text message
    ChatUIKitActionType.reply,
    ChatUIKitActionType.forward,
    ChatUIKitActionType.multiSelect,
    ChatUIKitActionType.translate, // only text message
    ChatUIKitActionType.thread, // only group message
    ChatUIKitActionType.edit, // only text message
    ChatUIKitActionType.report,
    ChatUIKitActionType.recall,
    ChatUIKitActionType.delete,
  ];

  /// 是否开启 thread 功能
  static bool enableMessageThread = false;

  /// 是否开启消息翻译功能
  static bool enableMessageTranslation = false;

  /// 消息翻译目标语言
  static String translateTargetLanguage = 'zh-Hans';

  /// 是否开启消息表情回复功能
  static bool enableMessageReaction = false;

  /// 消息表情回复 bottom sheet title 展示内容, 该内容需要包含在表情列表 [ChatUIKitEmojiData.emojiList] 中。
  static List<String> favoriteReaction = [
    '\u{1F44D}',
    '\u{2764}',
    '\u{1F609}',
    '\u{1F928}',
    '\u{1F62D}',
    '\u{1F389}',
  ];

  /// 默认 消息 url 正则
  static RegExp defaultUrlRegExp = RegExp(
    r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+',
    caseSensitive: false,
  );

  /// 是否开启消息置顶功能
  static bool enablePinMsg = true;

  /// 是否开启消息引用功能
  static bool enableMessageReply = true;

  /// 是否开启消息撤回功能
  static bool enableMessageRecall = true;

  /// 撤回消息的时间限制，单位秒
  static int recallExpandTime = 120;

  /// 是否开启消息编辑功能
  static bool enableMessageEdit = true;

  /// 是否开启消息举报功能
  static bool enableMessageReport = true;

  /// 消息举报tag, 可以用于自定义，举报的 reason 需要写在国际化文件中，国际化文件中的reason的key要和tag一致。如 [ChatUIKitLocal.reportTarget1]
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

  /// 是否开启消息多选转发功能
  static bool enableMessageMultiSelect = true;

  /// 是否开启消息转发功能
  static bool enableMessageForward = true;

  /// 联系人字母排序顺序, 如果有中文，可以用过 [ChatUIKitAlphabetSortHelper] 首字母重新定义, 如:
  /// ```dart
  /// ChatUIKitAlphabetSortHelper.instance.sortHandler = (showName) {
  ///   /// 获取中文首字母
  ///   return PinyinHelper.getPinyinE(showName, defPinyin: '#', format: PinyinFormat.WITHOUT_TONE).substring(0, 1);
  /// }
  /// ```
  static String sortAlphabetical = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ#';
}
