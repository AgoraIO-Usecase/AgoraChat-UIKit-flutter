import '../../chat_uikit.dart';

mixin ChatUIKitMultiObservers on ChatSDKWrapper {
  @override
  void onGroupEvent(
    MultiDevicesEvent event,
    String groupId,
    List<String>? userIds,
  ) {
    if (event == MultiDevicesEvent.GROUP_LEAVE) {
      ChatUIKitInsertTools.insertGroupLeaveMessage(groupId);
    }
    if (event == MultiDevicesEvent.GROUP_DESTROY) {
      ChatUIKitInsertTools.insertGroupDestroyMessage(groupId);
    }
    super.onGroupEvent(event, groupId, userIds);
  }
}
