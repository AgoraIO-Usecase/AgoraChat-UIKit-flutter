import '../chat_sdk_service.dart';

abstract mixin class ConnectObserver implements ChatUIKitObserverBase {
  void onConnected() {}
  void onDisconnected() {}
  void onUserDidLoginFromOtherDevice(String deviceName) {}
  void onUserDidRemoveFromServer() {}
  void onUserDidForbidByServer() {}
  void onUserDidChangePassword() {}
  void onUserDidLoginTooManyDevice() {}
  void onUserKickedByOtherDevice() {}
  void onUserAuthenticationFailed() {}
  void onTokenWillExpire() {}
  void onTokenDidExpire() {}
  void onAppActiveNumberReachLimit() {}
}
