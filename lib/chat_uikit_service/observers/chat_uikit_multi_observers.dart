import 'package:flutter/foundation.dart';

import '../../chat_uikit.dart';

mixin ChatUIKitMultiObservers on ChatSDKWrapper {
  @override
  void onGroupEvent(
    MultiDevicesEvent event,
    String groupId,
    List<String>? userIds,
  ) async {
    if (event == MultiDevicesEvent.GROUP_LEAVE) {
      ChatUIKitInsertTools.insertGroupLeaveMessage(groupId);
    }
    if (event == MultiDevicesEvent.GROUP_DESTROY) {
      ChatUIKitInsertTools.insertGroupDestroyMessage(groupId);
    }
    if (event == MultiDevicesEvent.GROUP_CREATE) {
      try {
        Group group = await ChatUIKit.instance.fetchGroupInfo(groupId: groupId);
        ChatUIKitInsertTools.insertCreateGroupMessage(group: group);
      } catch (e) {
        debugPrint('fetchGroupInfo error: $e');
      }
    }
    super.onGroupEvent(event, groupId, userIds);
  }

  @override
  void onContactEvent(MultiDevicesEvent event, String userId, String? ext) {
    if (event == MultiDevicesEvent.CONTACT_ACCEPT) {
      ChatUIKit.instance.onContactAdded(userId);
      ChatUIKitInsertTools.insertAddContactMessage(userId);
    }
    super.onContactEvent(event, userId, ext);
  }
}
