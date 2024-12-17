import 'package:flutter/material.dart';

class ChatUIKitInputBarTheme extends ThemeExtension<ChatUIKitInputBarTheme> {
  final Color? backgroundColor;
  final Color? inputBackgroundColor;
  final Color? inputTextColor;
  final Color? inputHintTextColor;
  final Color? inputCursorColor;
  final Color? inputSelectionColor;

  ChatUIKitInputBarTheme({
    this.backgroundColor,
    this.inputBackgroundColor,
    this.inputTextColor,
    this.inputHintTextColor,
    this.inputCursorColor,
    this.inputSelectionColor,
  });

  @override
  ThemeExtension<ChatUIKitInputBarTheme> copyWith({
    Color? backgroundColor,
    Color? inputBackgroundColor,
    Color? inputTextColor,
    Color? inputHintTextColor,
    Color? inputCursorColor,
    Color? inputSelectionColor,
  }) {
    return ChatUIKitInputBarTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      inputBackgroundColor: inputBackgroundColor ?? this.inputBackgroundColor,
      inputTextColor: inputTextColor ?? this.inputTextColor,
      inputHintTextColor: inputHintTextColor ?? this.inputHintTextColor,
      inputCursorColor: inputCursorColor ?? this.inputCursorColor,
      inputSelectionColor: inputSelectionColor ?? this.inputSelectionColor,
    );
  }

  @override
  ChatUIKitInputBarTheme lerp(
      covariant ChatUIKitInputBarTheme? other, double t) {
    return ChatUIKitInputBarTheme(
      backgroundColor: Color.lerp(backgroundColor, other?.backgroundColor, t),
      inputBackgroundColor:
          Color.lerp(inputBackgroundColor, other?.inputBackgroundColor, t),
      inputTextColor: Color.lerp(inputTextColor, other?.inputTextColor, t),
      inputHintTextColor:
          Color.lerp(inputHintTextColor, other?.inputHintTextColor, t),
      inputCursorColor:
          Color.lerp(inputCursorColor, other?.inputCursorColor, t),
      inputSelectionColor:
          Color.lerp(inputSelectionColor, other?.inputSelectionColor, t),
    );
  }
}
