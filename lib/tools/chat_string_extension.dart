import '../chat_uikit_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

extension StringExtension on String {
  String localString(BuildContext context) => getString(context);

  bool hasURL() {
    final urlRegex = ChatUIKitSettings.defaultUrlRegExp;
    return urlRegex.hasMatch(this);
  }
}
