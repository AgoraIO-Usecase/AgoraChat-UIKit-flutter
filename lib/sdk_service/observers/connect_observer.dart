import '../chat_sdk_service.dart';

abstract mixin class ConnectObserver implements ChatUIKitObserverBase {
  void onConnected() {}
  void onDisconnected() {}
  void onUserDidLoginFromOtherDevice(LoginExtensionInfo info) {}
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
