import 'package:flutter/foundation.dart';

mixin SafeAreaDisposed on ChangeNotifier {
  bool _disposed = false;
  @override
  void notifyListeners() {
    if (_disposed) return;
    super.notifyListeners();
  }

  @override
  bool get hasListeners {
    if (_disposed) return false;
    return super.hasListeners;
  }

  @override
  void addListener(VoidCallback listener) {
    if (_disposed) return;
    super.addListener(listener);
  }

  @override
  removeListener(VoidCallback listener) {
    if (_disposed) return;
    super.removeListener(listener);
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    super.dispose();
  }
}
