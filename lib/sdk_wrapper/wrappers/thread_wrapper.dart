import '../chat_sdk_wrapper.dart';

import 'package:flutter/foundation.dart';

mixin ThreadWrapper on ChatUIKitWrapperBase {
  @protected
  @override
  void addListeners() {
    super.addListeners();
    Client.getInstance.chatThreadManager.addEventHandler(
      sdkEventKey,
      ChatThreadEventHandler(
        onChatThreadCreate: onChatThreadCreate,
        onChatThreadDestroy: onChatThreadDestroy,
        onChatThreadUpdate: onChatThreadUpdate,
        onUserKickOutOfChatThread: onUserKickOutOfChatThread,
      ),
    );
  }

  @override
  void removeListeners() {
    super.removeListeners();
    Client.getInstance.chatThreadManager.removeEventHandler(sdkEventKey);
  }

  void onChatThreadCreate(ChatThreadEvent event) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ThreadObserver) {
        observer.onChatThreadCreate(event);
      }
    }
  }

  void onChatThreadDestroy(ChatThreadEvent event) {
    // SDKWrapperTools.insertThreadEventMessage(event: event);
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ThreadObserver) {
        observer.onChatThreadDestroy(event);
      }
    }
  }

  void onChatThreadUpdate(ChatThreadEvent event) {
    // SDKWrapperTools.insertThreadEventMessage(event: event);
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ThreadObserver) {
        observer.onChatThreadUpdate(event);
      }
    }
  }

  void onUserKickOutOfChatThread(ChatThreadEvent event) {
    // SDKWrapperTools.insertThreadEventMessage(event: event);
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ThreadObserver) {
        observer.onUserKickOutOfChatThread(event);
      }
    }
  }
}
