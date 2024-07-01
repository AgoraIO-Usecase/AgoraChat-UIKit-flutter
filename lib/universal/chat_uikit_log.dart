import 'package:flutter/widgets.dart';

bool enableLog = false;

void chatPrint(String message) {
  if (enableLog) {
    debugPrint('ChatUIKit: $message');
  }
}

void chatPrintStack() {
  if (enableLog) {
    debugPrintStack();
  }
}
