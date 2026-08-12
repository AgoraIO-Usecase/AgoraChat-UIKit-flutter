import '../../chat_sdk_service.dart';
import 'package:flutter/foundation.dart';

mixin ContactWrapper on ChatUIKitServiceBase {
  @protected
  @override
  void addListeners() {
    super.addListeners();
    Client.getInstance.contactManager.addEventHandler(
      sdkEventKey,
      ContactEventHandler(
        onContactAdded: onContactAdded,
        onContactDeleted: onContactDeleted,
        onContactInvited: onContactRequestReceived,
        onFriendRequestAccepted: onFriendRequestAccepted,
        onFriendRequestDeclined: onFriendRequestDeclined,
      ),
    );
  }

  @override
  void removeListeners() {
    super.removeListeners();
    Client.getInstance.contactManager.removeEventHandler(sdkEventKey);
  }

  @protected
  void onContactAdded(String userId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ContactObserver) {
        observer.onContactAdded(userId);
      }
    }
  }

  @protected
  void onContactDeleted(String userId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ContactObserver) {
        observer.onContactDeleted(userId);
      }
    }
  }

  @protected
  void onContactRequestReceived(String userId, String? reason) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ContactObserver) {
        observer.onContactRequestReceived(userId, reason);
      }
    }
  }

  @protected
  void onFriendRequestAccepted(String userId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ContactObserver) {
        observer.onFriendRequestAccepted(userId);
      }
    }
  }

  @protected
  void onFriendRequestDeclined(String userId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ContactObserver) {
        observer.onFriendRequestDeclined(userId);
      }
    }
  }

  void onFriendRequestCountChanged(int count) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ContactObserver) {
        observer.onFriendRequestCountChanged(count);
      }
    }
  }

  void onBlockedContactAdded(String userId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ContactObserver) {
        observer.onBlockedContactAdded(userId);
      }
    }
  }

  void onBlockedContactDeleted(String userId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ContactObserver) {
        observer.onBlockedContactDeleted(userId);
      }
    }
  }
}
