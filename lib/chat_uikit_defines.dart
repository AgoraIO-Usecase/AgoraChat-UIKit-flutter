import 'chat_uikit.dart';
import 'package:flutter/widgets.dart';

// 消息列表 item 构建器，需要返回一个 widget，如果返回 null 将会使用默认的 item。 返回后会用于列表显示。
typedef MessageItemBuilder = Widget? Function(
    BuildContext context, MessageModel model);

/// 消息列表 item 点击事件，返回 true 表示消费事件，false 或 null 表示不消费事件，事件将会继续传递。
typedef MessageItemTapHandler = bool? Function(
    BuildContext context, MessageModel model);

typedef MessageReactionItemTapHandler = bool? Function(
    BuildContext context, MessageModel model, MessageReaction reaction);

/// 消息列表 item 元素是否展示，返回 true 表示展示，false 表示不展示。
typedef MessageItemShowHandler = bool Function(MessageModel model);

/// 消息列表 item 长按事件，会返回默认的列表，需要你调整后返回来，返回来的数据会用于 bottom sheet 显示。
typedef MessagesViewItemLongPressHandler = List<ChatUIKitBottomSheetAction>?
    Function(
  BuildContext context,
  MessageModel model,
  List<ChatUIKitBottomSheetAction> defaultActions,
);

/// 消息页 输入框 更多按钮点击事件，会返回默认的列表，需要你调整后返回来，返回来的数据会用于 bottom sheet 显示。
typedef MessagesViewMorePressHandler = List<ChatUIKitBottomSheetAction>?
    Function(
  BuildContext context,
  List<ChatUIKitBottomSheetAction> defaultActions,
);

/// 消息气泡构建器，需要返回一个 widget，如果返回 null 将会使用默认的气泡。 返回后会用于列表显示。其中 child 是气泡内部的内容。
typedef MessageItemBubbleBuilder = Widget? Function(
  BuildContext context,
  Widget child,
  MessageModel model,
);

/// 联系人列表 item 构建器，需要返回一个 widget，如果返回 null 将会使用默认的 item。 返回后会用于列表显示。
typedef ChatUIKitContactItemBuilder = Widget? Function(
    BuildContext context, ContactItemModel model);

/// 群列表 item 构建器，需要返回一个 widget，如果返回 null 将会使用默认的 item。 返回后会用于列表显示。
typedef ChatUIKitGroupItemBuilder = Widget Function(
    BuildContext context, GroupItemModel model);

/// 创建群组拦截器，当在创建群组页面点击创建后回调给你当前选择的用户，你需要返回一个 CreateGroupInfo 对象，如果返回 null 将会取消创建。
typedef CreateGroupHandler = Future<CreateGroupInfo?> Function(
  BuildContext context,
  List<ChatUIKitProfile> selectedProfiles,
);

/// 创建群组后的回调
typedef GroupCreateCallback = void Function(Group? group, ChatError? error);

// 会话列表 item 构建器，需要返回一个 widget，如果返回 null 将会使用默认的 item。 返回后会用于列表显示。
typedef ConversationItemBuilder = Widget? Function(
    BuildContext context, ConversationItemModel model);

/// 会话列表展示前回调，会将当前的会话列表传递过来，你需要调整后返回来，返回来的数据会用于列表显示。
typedef ConversationListViewShowHandler = List<ConversationItemModel> Function(
    List<ConversationItemModel> conversations);

/// 通讯录列表展示前回调，会将当前的通讯录列表传递过来，你需要调整后返回来，返回来的数据会用于列表显示。
typedef ContactListViewShowHandler = List<ContactItemModel> Function(
    List<ContactItemModel> contacts);

/// 用户会话列表长按事件，会返回默认的列表，需要你调整后返回来，返回来的数据会用于 bottom sheet 显示。
typedef ConversationsViewItemLongPressHandler
    = List<ChatUIKitBottomSheetAction>? Function(
  BuildContext context,
  ConversationItemModel model,
  List<ChatUIKitBottomSheetAction> defaultActions,
);

// 好友申请列表 item 构建器，需要返回一个 widget，如果返回 null 将会使用默认的 item。 返回后会用于列表显示。
typedef ChatUIKitNewRequestItemBuilder = Widget Function(
    BuildContext context, NewRequestItemModel model);

/// appBar 点击更多按钮时会弹出 bottom sheet, 会返回默认的列表，需要你调整后返回来，返回来的数据会用于 bottom sheet 显示。
typedef ChatUIKitMoreActionsBuilder<T> = List<ChatUIKitBottomSheetAction<T>>
    Function(BuildContext context, List<ChatUIKitBottomSheetAction<T>> actions);

/// 时间格式化
typedef TimeFormatterHandler = String? Function(
  BuildContext context,
  ChatUIKitTimeType type,
  int time,
);

/// 用于在详情页添加主要按钮事件，比如联系人详情，群组详情中添加音视频呼叫。会返回一个默认的列表，需要你调整后返回来，返回来的数据会用于菜单显示。
typedef ChatUIKitDetailContentActionsBuilder
    = List<ChatUIKitDetailContentAction>? Function(
        BuildContext context, List<ChatUIKitDetailContentAction>? defaultList);

/// 用于在 appBar 上添加事件，会返回默认的列表，需要你调整后返回来，返回来的数据会用于菜单显示。
typedef ChatUIKitAppBarActionsBuilder = List<ChatUIKitAppBarAction>? Function(
  BuildContext context,
  List<ChatUIKitAppBarAction>? defaultList,
);

/// 用于在联系人详情页添加 list item，会返回默认的列表，需要你调整后返回来，返回来的数据会用于菜单显示。
typedef ChatUIKitDetailItemBuilder = List<ChatUIKitDetailsListViewItemModel>
    Function(
  BuildContext context,
  ChatUIKitProfile? profile,
  List<ChatUIKitDetailsListViewItemModel> defaultItems,
);
