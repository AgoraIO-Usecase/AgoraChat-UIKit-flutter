import '../../chat_uikit.dart';
import '../../tools/safe_disposed.dart';
import '../../universal/inner_headers.dart';

import 'package:flutter/foundation.dart';

class ThreadMembersViewController extends ChangeNotifier
    with SafeAreaDisposed, ChatUIKitProviderObserver {
  final ChatThread thread;
  bool loadFinished = false;
  bool fetching = false;
  String? cursor;
  final int pageSize;

  List<ContactItemModel> modelsList = [];

  ThreadMembersViewController({
    required this.thread,
    this.pageSize = 20,
  }) {
    ChatUIKitProvider.instance.addObserver(this);
  }

  @override
  void dispose() {
    ChatUIKitProvider.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> fetchMembers() async {
    if (fetching || loadFinished) {
      return;
    }
    fetching = true;
    try {
      CursorResult<String> result =
          await ChatUIKit.instance.fetchChatThreadMembers(
        chatThreadId: thread.threadId,
        cursor: cursor,
        limit: pageSize,
      );

      Map<String, ChatUIKitProfile> map =
          ChatUIKitProvider.instance.getProfiles(
        result.data.map((e) => ChatUIKitProfile.contact(id: e)).toList(),
      );

      for (var item in result.data) {
        ContactItemModel info = ContactItemModel.fromProfile(map[item]!);
        modelsList.add(info);
      }

      if (result.data.length < pageSize) {
        loadFinished = true;
      }
      cursor = result.cursor;
    } catch (e) {
      chatPrint('fetchChatThreadMembers error: $e');
    } finally {
      fetching = false;
      refresh();
    }
  }

  void refresh() {
    notifyListeners();
  }

  @override
  void onProfilesUpdate(Map<String, ChatUIKitProfile> map) {
    if (modelsList.any((element) => map.keys.contains(element.profile.id))) {
      for (var i = 0; i < modelsList.length; i++) {
        modelsList[i].profile = map[modelsList[i].profile.id]!;
      }
      refresh();
    }
  }
}
