import '../../../../chat_uikit.dart';

mixin ChatUIKitGroupObservers on ChatSDKService {
  @override
  void onGroupDestroyed(String groupId, String? groupName) async {
    await ChatUIKitInsertTools.insertGroupDestroyMessage(groupId);
    super.onGroupDestroyed(groupId, groupName);
  }

  @override
  void onUserRemovedFromGroup(String groupId, String? groupName) async {
    await ChatUIKitInsertTools.insertGroupKickedMessage(groupId);
    super.onUserRemovedFromGroup(groupId, groupName);
  }
}
