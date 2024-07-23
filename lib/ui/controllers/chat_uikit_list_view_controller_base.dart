import '../../chat_uikit.dart';
import 'package:flutter/material.dart';

abstract mixin class ChatUIKitListViewControllerBase {
  ValueNotifier<ChatUIKitListViewType> loadingType =
      ValueNotifier(ChatUIKitListViewType.normal);

  bool hasMore = true;
  bool hasDisposed = false;

  Future<void> fetchItemList({bool force = false}) async {
    return;
  }

  Future<void> fetchMoreItemList() async {
    return;
  }

  Future<void> refresh() async {
    if (hasDisposed) return;
    loadingType.value = ChatUIKitListViewType.refresh;
    if (list.isEmpty) {
      loadingType.value = ChatUIKitListViewType.empty;
    } else {
      loadingType.value = ChatUIKitListViewType.normal;
    }
  }

  Future<void> reload() async {}

  void dispose() {
    if (hasDisposed) return;
    hasDisposed = true;
    loadingType.dispose();
  }

  List<ChatUIKitListItemModelBase> list = [];
}
