import 'package:agora_chat_uikit/chat_uikit/src/tools/safe_disposed.dart';
import 'package:flutter/foundation.dart';

class ChatUIKitViewObserver extends ChangeNotifier with SafeAreaDisposed {
  void refresh() {
    if (hasListeners) {
      notifyListeners();
    }
  }
}
