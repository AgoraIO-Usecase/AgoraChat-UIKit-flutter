import '../../chat_sdk_service.dart';

abstract mixin class ContactObserver implements ChatUIKitObserverBase {
  void onContactAdded(String userId) {}
  void onContactDeleted(String userId) {}
  void onContactRequestReceived(String userId, String? reason) {}
  void onFriendRequestAccepted(String userId) {}
  void onFriendRequestDeclined(String userId) {}
  void onFriendRequestCountChanged(int count) {}
  void onBlockedContactAdded(String userId) {}
  void onBlockedContactDeleted(String userId) {}
}
