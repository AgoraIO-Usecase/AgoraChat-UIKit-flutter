import 'package:chat_uikit_theme/chat_uikit_theme.dart';

import 'package:flutter/material.dart';

class ChatBottomSheetBackground extends StatefulWidget {
  const ChatBottomSheetBackground(
      {required this.child, this.showGrip = true, super.key});

  final Widget child;
  final bool showGrip;

  @override
  State<ChatBottomSheetBackground> createState() =>
      _ChatBottomSheetBackgroundState();
}

class _ChatBottomSheetBackgroundState extends State<ChatBottomSheetBackground>
    with ChatUIKitThemeMixin {
  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    return Container(
      color: (theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              color: widget.showGrip
                  ? (theme.color.isDark
                      ? theme.color.neutralColor3
                      : theme.color.neutralColor8)
                  : Colors.transparent,
            ),
            margin: const EdgeInsets.symmetric(vertical: 6),
            height: 5,
            width: 36,
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
