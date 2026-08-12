import '../../chat_sdk_service.dart';
import 'package:flutter/foundation.dart';

mixin RoomWrapper on ChatUIKitServiceBase {
  @protected
  @override
  void addListeners() {
    super.addListeners();
    Client.getInstance.chatRoomManager.addEventHandler(
      sdkEventKey,
      ChatRoomEventHandler(
        onAdminAddedFromChatRoom: onAdminAddedFromChatRoom,
        onAdminRemovedFromChatRoom: onAdminRemovedFromChatRoom,
        onAllChatRoomMemberMuteStateChanged:
            onAllChatRoomMemberMuteStateChanged,
        onAllowListAddedFromChatRoom: onAllowListAddedFromChatRoom,
        onAllowListRemovedFromChatRoom: onAllowListRemovedFromChatRoom,
        onAnnouncementChangedFromChatRoom: onAnnouncementChangedFromChatRoom,
        onChatRoomDestroyed: onChatRoomDestroyed,
        onMemberExitedFromChatRoom: onMemberExitedFromChatRoom,
        onMemberJoinedFromChatRoom: onMemberJoinedFromChatRoom,
        onMuteListAddedFromChatRoom: onMuteListAddedFromChatRoom,
        onMuteListRemovedFromChatRoom: onMuteListRemovedFromChatRoom,
        onOwnerChangedFromChatRoom: onOwnerChangedFromChatRoom,
        onRemovedFromChatRoom: onRemovedFromChatRoom,
        onSpecificationChanged: onSpecificationChanged,
        onAttributesUpdated: onAttributesUpdated,
        onAttributesRemoved: onAttributesRemoved,
      ),
    );
  }

  @protected
  void onAdminAddedFromChatRoom(
    String roomId,
    String admin,
  ) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is RoomObserver) {
        observer.onAdminAddedFromChatRoom(roomId, admin);
      }
    }
  }

  @protected
  void onAdminRemovedFromChatRoom(String roomId, String admin) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is RoomObserver) {
        observer.onAdminRemovedFromChatRoom(roomId, admin);
      }
    }
  }

  @protected
  void onAllChatRoomMemberMuteStateChanged(String roomId, bool isAllMuted) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is RoomObserver) {
        observer.onAllChatRoomMemberMuteStateChanged(roomId, isAllMuted);
      }
    }
  }

  @protected
  void onAllowListAddedFromChatRoom(String roomId, List<String> members) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is RoomObserver) {
        observer.onAllowListAddedFromChatRoom(roomId, members);
      }
    }
  }

  @protected
  void onAllowListRemovedFromChatRoom(String roomId, List<String> members) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is RoomObserver) {
        observer.onAllowListRemovedFromChatRoom(roomId, members);
      }
    }
  }

  @protected
  void onAnnouncementChangedFromChatRoom(String roomId, String? announcement) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is RoomObserver) {
        observer.onAnnouncementChangedFromChatRoom(roomId, announcement);
      }
    }
  }

  @protected
  void onChatRoomDestroyed(String roomId, String? roomName) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is RoomObserver) {
        observer.onChatRoomDestroyed(roomId, roomName);
      }
    }
  }

  @protected
  void onMemberExitedFromChatRoom(
      String roomId, String? roomName, String participant) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is RoomObserver) {
        observer.onMemberExitedFromChatRoom(roomId, roomName, participant);
      }
    }
  }

  @protected
  void onMemberJoinedFromChatRoom(
      String roomId, String participant, String? ext) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is RoomObserver) {
        observer.onMemberJoinedFromChatRoom(roomId, participant, ext);
      }
    }
  }

  @protected
  void onMuteListAddedFromChatRoom(String roomId, Map<String, int> mutes) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is RoomObserver) {
        observer.onMuteListAddedFromChatRoom(roomId, mutes);
      }
    }
  }

  @protected
  void onMuteListRemovedFromChatRoom(String roomId, List<String> mutes) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is RoomObserver) {
        observer.onMuteListRemovedFromChatRoom(roomId, mutes);
      }
    }
  }

  @protected
  void onOwnerChangedFromChatRoom(
      String roomId, String newOwner, String oldOwner) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is RoomObserver) {
        observer.onOwnerChangedFromChatRoom(roomId, newOwner, oldOwner);
      }
    }
  }

  @protected
  void onRemovedFromChatRoom(String roomId, String? roomName,
      String? participant, LeaveReason? reason) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is RoomObserver) {
        observer.onRemovedFromChatRoom(roomId, roomName, participant, reason);
      }
    }
  }

  @protected
  void onSpecificationChanged(ChatRoom room) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is RoomObserver) {
        observer.onSpecificationChanged(room);
      }
    }
  }

  @protected
  void onAttributesUpdated(
      String roomId, Map<String, String> attributes, String from) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is RoomObserver) {
        observer.onAttributesUpdated(roomId, attributes, from);
      }
    }
  }

  @protected
  void onAttributesRemoved(
      String roomId, List<String> removedKeys, String from) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is RoomObserver) {
        observer.onAttributesRemoved(roomId, removedKeys, from);
      }
    }
  }

  @override
  void removeListeners() {
    super.removeListeners();
    Client.getInstance.chatRoomManager.removeEventHandler(sdkEventKey);
  }
}
