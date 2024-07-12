import '../chat_sdk_wrapper.dart';

abstract mixin class GroupObserver implements ChatUIKitObserverBase {
  void onAdminAddedFromGroup(String groupId, String admin) {}
  void onAdminRemovedFromGroup(String groupId, String admin) {}
  void onAllGroupMemberMuteStateChanged(String groupId, bool isAllMuted) {}
  void onAllowListAddedFromGroup(String groupId, List<String> members) {}
  void onAllowListRemovedFromGroup(String groupId, List<String> members) {}
  void onAnnouncementChangedFromGroup(String groupId, String announcement) {}
  void onAutoAcceptInvitationFromGroup(
      String groupId, String inviter, String? inviteMessage) {}
  void onGroupDestroyed(String groupId, String? groupName) {}
  void onInvitationAcceptedFromGroup(
      String groupId, String invitee, String? reason) {}
  void onInvitationDeclinedFromGroup(
      String groupId, String invitee, String? reason) {}
  void onInvitationReceivedFromGroup(
      String groupId, String? groupName, String inviter, String? reason) {}
  void onMemberExitedFromGroup(String groupId, String member) {}
  void onMemberJoinedFromGroup(String groupId, String member) {}
  void onMuteListAddedFromGroup(
      String groupId, List<String> mutes, int? muteExpire) {}
  void onMuteListRemovedFromGroup(String groupId, List<String> mutes) {}
  void onOwnerChangedFromGroup(
      String groupId, String newOwner, String oldOwner) {}
  void onRequestToJoinAcceptedFromGroup(
      String groupId, String? groupName, String accepter) {}
  void onRequestToJoinDeclinedFromGroup(String groupId, String? groupName,
      String? decliner, String? reason, String? applicant) {}
  void onRequestToJoinReceivedFromGroup(
      String groupId, String? groupName, String applicant, String? reason) {}
  void onSharedFileAddedFromGroup(String groupId, GroupSharedFile sharedFile) {}
  void onSpecificationDidUpdate(Group group) {}
  void onDisableChanged(String groupId, bool isDisable) {}
  void onSharedFileDeletedFromGroup(String groupId, String fileId) {}
  void onUserRemovedFromGroup(String groupId, String? groupName) {}
  void onAttributesChangedOfGroupMember(String groupId, String userId,
      Map<String, String>? attributes, String? operatorId) {}
  void onGroupCreatedByMyself(Group group) {}
  void onGroupNameChangedByMeSelf(Group group) {}
}
