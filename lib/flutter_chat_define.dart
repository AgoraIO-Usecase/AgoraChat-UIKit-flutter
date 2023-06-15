import 'package:flutter/material.dart';

import 'agora_chat_uikit.dart';

typedef ChatWidgetBuilder = Widget Function(
    BuildContext context, String userId);

typedef ChatConversationWidgetBuilder = Widget? Function(
  BuildContext context,
  ChatConversation conversation,
);

typedef ChatConversationTextBuilder = String? Function(
  ChatConversation conversation,
);

typedef ChatMessageListItemBuilder = Widget? Function(
    BuildContext context, ChatMessageListItemModel model);

typedef ChatMessageTapAction = bool Function(
    BuildContext context, ChatMessage message);

typedef ChatConfirmDismissCallback = Future<bool> Function(
    BuildContext context);

typedef ChatConversationItemWidgetBuilder = Widget? Function(
    BuildContext context, int index, ChatConversation conversation);

typedef ChatConversationSortHandle = Future<List<ChatConversation>> Function(
    List<ChatConversation> beforeList);

typedef ChatPermissionRequest = Future<bool> Function(
    ChatUIKitPermission permission);

typedef ChatReplaceMessage = ChatMessage? Function(ChatMessage message);

typedef ChatReplaceMoreActions = List<ChatBottomSheetItem> Function(
    List<ChatBottomSheetItem> items);
