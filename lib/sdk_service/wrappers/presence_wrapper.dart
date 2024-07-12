import '../chat_sdk_wrapper.dart';

import 'package:flutter/foundation.dart';

mixin PresenceWrapper on ChatUIKitWrapperBase {
  @protected
  @override
  void addListeners() {
    super.addListeners();
    Client.getInstance.presenceManager.addEventHandler(
      sdkEventKey,
      PresenceEventHandler(
        onPresenceStatusChanged: onPresenceStatusChanged,
      ),
    );
  }

  @override
  void removeListeners() {
    super.removeListeners();
    Client.getInstance.presenceManager.removeEventHandler(sdkEventKey);
  }

  void onPresenceStatusChanged(List<Presence> list) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is PresenceObserver) {
        observer.onPresenceStatusChanged(list);
      }
    }
  }
}
