import '../chat_sdk_wrapper.dart';
import 'package:flutter/foundation.dart';

mixin ConnectWrapper on ChatUIKitWrapperBase {
  @protected
  @override
  void addListeners() {
    super.addListeners();
    Client.getInstance.addConnectionEventHandler(
      sdkEventKey,
      ConnectionEventHandler(
        onConnected: onConnected,
        onDisconnected: onDisconnected,
        onUserDidLoginFromOtherDevice: onUserDidLoginFromOtherDevice,
        onUserDidRemoveFromServer: onUserDidRemoveFromServer,
        onUserDidForbidByServer: onUserDidForbidByServer,
        onUserDidChangePassword: onUserDidChangePassword,
        onUserDidLoginTooManyDevice: onUserDidLoginTooManyDevice,
        onUserKickedByOtherDevice: onUserKickedByOtherDevice,
        onUserAuthenticationFailed: onUserAuthenticationFailed,
        onTokenWillExpire: onTokenWillExpire,
        onTokenDidExpire: onTokenDidExpire,
        onAppActiveNumberReachLimit: onAppActiveNumberReachLimit,
      ),
    );
  }

  @override
  void removeListeners() {
    super.removeListeners();
    Client.getInstance.removeConnectionEventHandler(sdkEventKey);
  }

  @protected
  void onConnected() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ConnectObserver) {
        observer.onConnected();
      }
    }
  }

  @protected
  void onDisconnected() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ConnectObserver) {
        observer.onDisconnected();
      }
    }
  }

  void onUserDidLoginFromOtherDevice(String deviceName) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ConnectObserver) {
        observer.onUserDidLoginFromOtherDevice(deviceName);
      }
    }
  }

  @protected
  void onUserDidRemoveFromServer() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onUserDidRemoveFromServer();
    }
  }

  @protected
  void onUserDidForbidByServer() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ConnectObserver) {
        observer.onUserDidForbidByServer();
      }
    }
  }

  @protected
  void onUserDidChangePassword() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ConnectObserver) {
        observer.onUserDidChangePassword();
      }
    }
  }

  @protected
  void onUserDidLoginTooManyDevice() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ConnectObserver) {
        observer.onUserDidLoginTooManyDevice();
      }
    }
  }

  @protected
  void onUserKickedByOtherDevice() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ConnectObserver) {
        observer.onUserKickedByOtherDevice();
      }
    }
  }

  @protected
  void onUserAuthenticationFailed() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ConnectObserver) {
        observer.onUserAuthenticationFailed();
      }
    }
  }

  @protected
  void onTokenWillExpire() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ConnectObserver) {
        observer.onTokenWillExpire();
      }
    }
  }

  @protected
  void onTokenDidExpire() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ConnectObserver) {
        observer.onTokenDidExpire();
      }
    }
  }

  @protected
  void onAppActiveNumberReachLimit() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ConnectObserver) {
        observer.onAppActiveNumberReachLimit();
      }
    }
  }
}
