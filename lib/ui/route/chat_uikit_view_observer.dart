import 'package:flutter/foundation.dart';

import '../../tools/safe_disposed.dart';

class ChatUIKitViewObserver extends ChangeNotifier with SafeAreaDisposed {
  void refresh() {
    if (hasListeners) {
      notifyListeners();
    }
  }
}
