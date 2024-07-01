import '../../../chat_uikit.dart';
import 'package:flutter/material.dart';

enum ChatUIKitButtonType {
  primary,
  neutral,
  destructive,
}

class ChatUIKitButton extends StatelessWidget {
  const ChatUIKitButton.primary(
    this.text, {
    this.onTap,
    this.fontWeight,
    this.fontSize,
    this.radius = 0,
    this.borderWidth = 1,
    super.key,
  }) : type = ChatUIKitButtonType.primary;

  const ChatUIKitButton.neutral(
    this.text, {
    this.onTap,
    this.fontWeight,
    this.fontSize,
    this.radius = 0,
    this.borderWidth = 1,
    super.key,
  }) : type = ChatUIKitButtonType.neutral;

  const ChatUIKitButton.destructive(
    this.text, {
    this.onTap,
    this.fontWeight,
    this.fontSize,
    this.radius = 0,
    this.borderWidth = 1,
    super.key,
  }) : type = ChatUIKitButtonType.destructive;

  const ChatUIKitButton(
    this.text, {
    this.onTap,
    required this.type,
    this.fontWeight,
    this.fontSize,
    this.radius = 0,
    this.borderWidth = 1,
    super.key,
  });
  final String text;
  final VoidCallback? onTap;
  final ChatUIKitButtonType type;
  final double radius;
  final double borderWidth;
  final FontWeight? fontWeight;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: () {
              switch (type) {
                case ChatUIKitButtonType.primary:
                  return primaryBorderColor(theme);
                case ChatUIKitButtonType.neutral:
                  return neutralBorderColor(theme);
                case ChatUIKitButtonType.destructive:
                  return destructiveBorderColor(theme);
              }
            }(),
            width: borderWidth,
          ),
          color: () {
            switch (type) {
              case ChatUIKitButtonType.primary:
                return primaryBgColor(theme);
              case ChatUIKitButtonType.neutral:
                return neutralBgColor(theme);
              case ChatUIKitButtonType.destructive:
                return destructiveBgColor(theme);
            }
          }(),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: fontWeight,
            fontSize: fontSize,
            color: () {
              switch (type) {
                case ChatUIKitButtonType.primary:
                  return primaryTextColor(theme);
                case ChatUIKitButtonType.neutral:
                  return neutralTextColor(theme);
                case ChatUIKitButtonType.destructive:
                  return destructiveTextColor(theme);
              }
            }(),
          ),
        ),
      ),
    );
  }

  Color primaryBorderColor(ChatUIKitTheme theme) {
    return (theme.color.isDark
        ? theme.color.primaryColor6
        : theme.color.primaryColor5);
  }

  Color neutralBorderColor(ChatUIKitTheme theme) {
    return (theme.color.isDark
        ? theme.color.neutralColor4
        : theme.color.neutralColor7);
  }

  Color destructiveBorderColor(ChatUIKitTheme theme) {
    return (theme.color.isDark
        ? theme.color.neutralColor4
        : theme.color.neutralColor7);
  }

  Color primaryTextColor(ChatUIKitTheme theme) {
    return (theme.color.isDark
        ? theme.color.neutralColor1
        : theme.color.neutralColor98);
  }

  Color neutralTextColor(ChatUIKitTheme theme) {
    return (theme.color.isDark
        ? theme.color.neutralColor95
        : theme.color.neutralColor3);
  }

  Color destructiveTextColor(ChatUIKitTheme theme) {
    return (theme.color.isDark
        ? theme.color.errorColor6
        : theme.color.errorColor5);
  }

  Color primaryBgColor(ChatUIKitTheme theme) {
    return (theme.color.isDark
        ? theme.color.primaryColor6
        : theme.color.primaryColor5);
  }

  Color neutralBgColor(ChatUIKitTheme theme) {
    return (theme.color.isDark
        ? theme.color.neutralColor1
        : theme.color.neutralColor98);
  }

  Color destructiveBgColor(ChatUIKitTheme theme) {
    return (theme.color.isDark
        ? theme.color.neutralColor1
        : theme.color.neutralColor98);
  }
}
