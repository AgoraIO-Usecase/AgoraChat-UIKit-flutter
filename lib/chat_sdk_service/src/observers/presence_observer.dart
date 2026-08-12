import '../../chat_sdk_service.dart';

abstract mixin class PresenceObserver implements ChatUIKitObserverBase {
  void onPresenceStatusChanged(List<Presence> list) {}
}
