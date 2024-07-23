import '../../chat_uikit.dart';
import '../../tools/safe_disposed.dart';
import '../../universal/inner_headers.dart';

import 'package:flutter/foundation.dart';

class ThreadMembersViewController extends ChangeNotifier with SafeAreaDisposed {
  final ChatThread thread;
  bool loadFinished = false;
  bool fetching = false;
  String? cursor;
  final int pageSize;

  List<ContactItemModel> modelsList = [];

  ThreadMembersViewController({
    required this.thread,
    this.pageSize = 20,
  });

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
}
