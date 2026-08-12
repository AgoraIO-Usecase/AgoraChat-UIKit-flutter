import 'package:chat_uikit_theme/chat_uikit_theme.dart';
import 'package:agora_chat_uikit/chat_uikit/src/tools/chat_uikit_extension.dart';
import 'package:agora_chat_uikit/chat_uikit_localizations/chat_uikit_localizations.dart';
import 'package:flutter/material.dart';

class ChatRoomUIKitBottomSheet extends StatelessWidget {
  const ChatRoomUIKitBottomSheet({
    required this.items,
    this.title,
    this.titleStyle,
    this.cancelStyle,
    super.key,
  });

  final String? title;
  final TextStyle? titleStyle;
  final List<ChatBottomSheetItem> items;
  final TextStyle? cancelStyle;
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      onClosing: () {},
      builder: (context) {
        return _build(context);
      },
    );
  }

  Widget _build(BuildContext context) {
    final theme = ChatUIKitTheme.instance;
    TextStyle? normalStyle = TextStyle(
      fontWeight: theme.font.bodyLarge.fontWeight,
      fontSize: theme.font.bodyLarge.fontSize,
      color: (theme.color.isDark
          ? theme.color.primaryColor6
          : theme.color.primaryColor5),
    );

    TextStyle? destructive = TextStyle(
      fontWeight: theme.font.bodyLarge.fontWeight,
      fontSize: theme.font.bodyLarge.fontSize,
      color: (theme.color.isDark
          ? theme.color.errorColor6
          : theme.color.errorColor5),
    );

    List<Widget> list = [];

    list.add(
      Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          color: (theme.color.isDark
              ? theme.color.neutralColor3
              : theme.color.neutralColor8),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
        height: 5,
        width: 36,
      ),
    );

    if (title != null) {
      list.add(Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Text(
          title!,
          style: titleStyle ??
              TextStyle(
                fontWeight: theme.font.labelMedium.fontWeight,
                fontSize: theme.font.labelMedium.fontSize,
                color: (theme.color.isDark
                    ? theme.color.neutralColor6
                    : theme.color.neutralColor5),
              ),
        ),
      ));
    }

    for (var element in items) {
      if (element != items[0] || title?.isNotEmpty == true) {
        list.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: .5,
              color: (theme.color.isDark
                  ? theme.color.neutralColor2
                  : theme.color.neutralColor9),
            ),
          ),
        );
      }

      list.add(
        InkWell(
          onTap: () {
            element.onTap();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 17),
            alignment: Alignment.center,
            child: Text(
              element.label,
              style: element.style ??
                  (element.type == ChatBottomSheetItemType.normal
                      ? normalStyle
                      : destructive),
            ),
          ),
        ),
      );
    }

    list.add(Container(
      height: 8,
      color: (theme.color.isDark
          ? theme.color.neutralColor0
          : theme.color.neutralColor95),
    ));
    list.add(
      InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 17),
          alignment: Alignment.center,
          child: Text(
            ChatUIKitLocal.chatroomBottomSheetCancel.localString(context),
            style: cancelStyle ??
                TextStyle(
                  fontWeight: theme.font.titleMedium.fontWeight,
                  fontSize: theme.font.titleMedium.fontSize,
                  color: (theme.color.isDark
                      ? theme.color.primaryColor6
                      : theme.color.primaryColor5),
                ),
          ),
        ),
      ),
    );

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: list,
    );

    content = SafeArea(child: content);

    content = Container(
      decoration: BoxDecoration(
        color: (theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98),
      ),
      child: content,
    );

    return content;
  }
}

enum ChatBottomSheetItemType {
  normal,
  done,
  destructive,
}

class ChatBottomSheetItem {
  ChatBottomSheetItem.destructive({
    required this.label,
    required this.onTap,
    this.style,
  }) : type = ChatBottomSheetItemType.destructive;

  ChatBottomSheetItem.normal({
    required this.label,
    required this.onTap,
    this.style,
  }) : type = ChatBottomSheetItemType.normal;

  const ChatBottomSheetItem({
    required this.label,
    this.style,
    required this.onTap,
    required this.type,
  });

  final ChatBottomSheetItemType type;
  final String label;
  final TextStyle? style;
  final VoidCallback onTap;
}
