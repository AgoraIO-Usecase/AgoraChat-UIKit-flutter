import '../chat_sdk_wrapper.dart';
import 'package:flutter/foundation.dart';

mixin MessageWrapper on ChatUIKitWrapperBase {
  @protected
  @override
  void addListeners() {
    super.addListeners();
    Client.getInstance.chatManager.addMessageEvent(
      sdkEventKey,
      MessageEvent(
        onSuccess: onSuccess,
        onError: onError,
        onProgress: onProgress,
      ),
    );
  }

  @override
  void removeListeners() {
    super.removeListeners();
    Client.getInstance.chatManager.removeMessageEvent(sdkEventKey);
  }

  @protected
  void onSuccess(String msgId, Message msg) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is MessageObserver) {
        observer.onSuccess(msgId, msg);
      }
    }
  }

  @protected
  void onError(String msgId, Message msg, ChatError error) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is MessageObserver) {
        observer.onError(msgId, msg, error);
      }
    }
  }

  @protected
  void onProgress(String msgId, int progress) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is MessageObserver) {
        observer.onProgress(msgId, progress);
      }
    }
  }
}
