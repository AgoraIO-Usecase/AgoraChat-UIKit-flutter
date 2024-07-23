import 'dart:math';

import 'package:flutter/material.dart';

import '../../chat_uikit.dart';
import '../../universal/inner_headers.dart';

/// 会话列表控制器
class ConversationListViewController
    with ChatUIKitListViewControllerBase, ChatObserver, MultiObserver {
  ConversationListViewController({
    this.willShowHandler,
  }) {
    ChatUIKit.instance.addObserver(this);
  }

  /// 一次从服务器获取的会话列表数量，默认为 `50`。
  final int pageSize = 50;

  /// 会话列表显示前的回调，你可以在这里对会话列表进行处理，比如排序或者加减等。如果不设置将会直接显示。
  final ConversationListViewShowHandler? willShowHandler;

  String? cursor;

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onMessagesReceived(List<Message> messages) async {
    reload();
  }

  @override
  void onMessageContentChanged(
      Message message, String operatorId, int operationTime) {
    int index = list.cast<ConversationItemModel>().indexWhere((element) {
      return element.lastMessage?.msgId == message.msgId;
    });

    if (index != -1) {
      list.cast<ConversationItemModel>()[index] =
          list.cast<ConversationItemModel>()[index].copyWith(
                lastMessage: message,
              );
    }

    refresh();
  }

  @override
  void onMessagesRecalled(List<Message> recalled, List<Message> replaces) {
    List<String> recalledIds = recalled.map((e) => e.msgId).toList();
    bool has = list.cast<ConversationItemModel>().any((element) {
      return recalledIds.contains(element.lastMessage?.msgId ?? "");
    });
    if (has) {
      reload();
    }
  }

  @override
  void onConversationsUpdate() {
    reload();
  }

  Future<void> deleteConversation({required String conversationId}) async {
    int index = list.indexWhere((element) {
      return (element as ConversationItemModel).profile.id == conversationId;
    });
    if (index != -1) {
      list.removeAt(index);
      await refresh();
      await ChatUIKit.instance.deleteLocalConversation(
        conversationId: conversationId,
      );
    }
  }

  Future<void> pinConversation({
    required String conversationId,
    required bool isPinned,
  }) async {
    int index = list.indexWhere((element) {
      return (element as ConversationItemModel).profile.id == conversationId;
    });
    if (index != -1) {
      ConversationItemModel item = list[index] as ConversationItemModel;
      item = item.copyWith(pinned: !item.pinned);
      list[index] = item;
      await refresh();
      await ChatUIKit.instance.pinConversation(
        conversationId: conversationId,
        isPinned: isPinned,
      );
    }
  }

  Future<void> markConversationAsRead(String conversationId) async {
    try {
      Conversation? conv = await ChatUIKit.instance
          .getConversation(conversationId: conversationId);
      await conv?.markAllMessagesAsRead();
      await ChatUIKit.instance
          .sendConversationReadAck(conversationId: conversationId);
      reload();
    } catch (e) {
      chatPrint('conversation list markConversationAsRead: $e');
    }
  }

  @override
  void onConversationEvent(
      MultiDevicesEvent event, String conversationId, ConversationType type) {
    if (event == MultiDevicesEvent.CONVERSATION_DELETE ||
        event == MultiDevicesEvent.CONVERSATION_PINNED ||
        event == MultiDevicesEvent.CONVERSATION_UNPINNED) {
      fetchItemList();
    }
  }

  /// 获取会话列表，会优先从本地获取，如果本地没有，并且没有从服务器获取过，则从服务器获取。
  ///`force` (bool) 是否强制从服务器获取，默认为 `false`。
  @override
  Future<void> fetchItemList({bool force = false}) async {
    loadingType.value = ChatUIKitListViewType.loading;
    List<Conversation> items = await ChatUIKit.instance.getAllConversations();
    try {
      if ((items.isEmpty &&
              !ChatUIKitContext.instance.isConversationLoadFinished()) ||
          force == true) {
        await fetchConversations();
        items = await ChatUIKit.instance.getAllConversations();
      }
      items = await clearEmptyConversations(items);
      List<ConversationItemModel> tmp =
          await mapperToConversationModelItems(items);
      list.clear();
      list.addAll(tmp);
      list = willShowHandler?.call(list.cast<ConversationItemModel>()) ?? list;

      if (list.isEmpty) {
        loadingType.value = ChatUIKitListViewType.empty;
      } else {
        loadingType.value = ChatUIKitListViewType.normal;
      }
    } catch (e) {
      chatPrint('conversation list fetchItemList: $e');
      loadingType.value = ChatUIKitListViewType.error;
    }
  }

  /// 从新从本地获取会话列表
  @override
  Future<void> reload() async {
    loadingType.value = ChatUIKitListViewType.refresh;
    List<Conversation> items = await ChatUIKit.instance.getAllConversations();
    items = await clearEmptyConversations(items);
    List<ConversationItemModel> tmp =
        await mapperToConversationModelItems(items);
    list.clear();
    list.addAll(tmp);
    list = willShowHandler?.call(list.cast<ConversationItemModel>()) ?? list;
    if (list.isEmpty) {
      loadingType.value = ChatUIKitListViewType.empty;
    } else {
      loadingType.value = ChatUIKitListViewType.normal;
    }
  }

  Future<List<Conversation>> clearEmptyConversations(
      List<Conversation> list) async {
    List<Conversation> tmp = [];
    for (var item in list) {
      final latest = await item.latestMessage();
      final unreadCount = await item.unreadCount();
      if (latest != null || unreadCount > 0) {
        tmp.add(item);
      }
    }
    return tmp;
  }

  bool hasFetchPinned = false;
  Future<List<Conversation>> fetchConversations() async {
    List<Conversation> items = [];
    if (!hasFetchPinned) {
      try {
        CursorResult<Conversation> result =
            await ChatUIKit.instance.fetchPinnedConversations(
          pageSize: 50,
        );
        items.addAll(result.data);
      } catch (e) {
        debugPrint('fetchConversations error: $e');
      }
      hasFetchPinned = true;
    }
    bool hasError = false;
    try {
      CursorResult<Conversation> result =
          await ChatUIKit.instance.fetchConversations(
        pageSize: pageSize,
        cursor: cursor,
      );
      cursor = result.cursor;
      items.addAll(result.data);
      if (result.data.length < pageSize || cursor == '') {
        ChatUIKitContext.instance.setConversationLoadFinished();
        hasMore = false;
      }
    } catch (e) {
      ChatUIKitContext.instance.setConversationLoadFinished();
      hasError = true;
      debugPrint('fetchConversations error: $e');
    }

    await updateConversationMuteType(items);

    if (hasMore && !hasError) {
      List<Conversation> tmp = await fetchConversations();
      items.addAll(tmp);
    }
    return items;
  }

  Future<void> updateConversationMuteType(List<Conversation> items) async {
    try {
      List<List<Conversation>> data = [];
      int index = 0;
      while (index < items.length) {
        int intMin = min((index + 20), items.length);
        data.add(items.sublist(index, intMin));
        index += intMin;
      }
      for (var list in data) {
        if (list.isEmpty) continue;
        await ChatUIKit.instance.fetchSilentModel(conversations: list);
      }
    } catch (e) {
      debugPrint('fetchConversations error: $e');
    }
  }

  Future<List<ConversationItemModel>> mapperToConversationModelItems(
      List<Conversation> conversations) async {
    List<ChatUIKitProfile> tmp = () {
      List<ChatUIKitProfile> ret = [];
      for (var item in conversations) {
        if (item.type == ConversationType.GroupChat) {
          ret.add(ChatUIKitProfile.group(id: item.id));
        } else if (item.type == ConversationType.Chat) {
          ret.add(ChatUIKitProfile.contact(id: item.id));
        }
      }
      return ret;
    }();

    Map<String, ChatUIKitProfile> profilesMap =
        ChatUIKitProvider.instance.getProfiles(tmp);
    List<ConversationItemModel> list = [];
    for (var item in conversations) {
      ConversationItemModel info = await ConversationItemModel.fromConversation(
        item,
        profilesMap[item.id]!,
      );
      list.add(info);
    }
    return list;
  }
}
