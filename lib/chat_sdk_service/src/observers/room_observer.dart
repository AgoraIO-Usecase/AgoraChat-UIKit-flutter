import '../../chat_sdk_service.dart';

abstract mixin class RoomObserver implements ChatUIKitObserverBase {
  void onAdminAddedFromChatRoom(String roomId, String admin) {}

  void onAdminRemovedFromChatRoom(String roomId, String admin) {}

  void onAllChatRoomMemberMuteStateChanged(String roomId, bool isAllMuted) {}

  void onAllowListAddedFromChatRoom(String roomId, List<String> members) {}

  void onAllowListRemovedFromChatRoom(String roomId, List<String> members) {}

  void onAnnouncementChangedFromChatRoom(String roomId, String? announcement) {}

  void onChatRoomDestroyed(String roomId, String? roomName) {}

  void onMemberExitedFromChatRoom(
      String roomId, String? roomName, String participant) {}

  void onMemberJoinedFromChatRoom(
      String roomId, String participant, String? ext) {}

  void onMuteListAddedFromChatRoom(String roomId, Map<String, int> mutes) {}

  void onMuteListRemovedFromChatRoom(String roomId, List<String> mutes) {}

  void onOwnerChangedFromChatRoom(
      String roomId, String newOwner, String oldOwner) {}

  void onRemovedFromChatRoom(String roomId, String? roomName,
      String? participant, LeaveReason? reason) {}

  void onSpecificationChanged(ChatRoom room) {}

  void onAttributesUpdated(
      String roomId, Map<String, String> attributes, String from) {}

  void onAttributesRemoved(
      String roomId, List<String> removedKeys, String from) {}
}
