import '../chat_sdk_wrapper.dart';

abstract mixin class PresenceObserver implements ChatUIKitObserverBase {
  void onPresenceStatusChanged(List<Presence> list) {}
}
