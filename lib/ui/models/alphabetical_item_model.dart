import '../../chat_uikit.dart';
import 'package:flutter/widgets.dart';

class AlphabeticalItemModel with ChatUIKitListItemModelBase {
  final String alphabetical;
  final double height;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  AlphabeticalItemModel(
    this.alphabetical, {
    this.height = 32,
    this.textStyle,
    this.backgroundColor,
  });

  @override
  String get showName => alphabetical;
}
