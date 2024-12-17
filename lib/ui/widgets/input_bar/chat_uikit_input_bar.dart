import '../../../chat_uikit.dart';
import 'chat_uikit_input_bar_theme.dart';
import 'package:flutter/material.dart';

import 'chat_uikit_selection_controls.dart';

class ChatUIKitInputBar extends StatefulWidget {
  const ChatUIKitInputBar({
    required this.keyboardPanelController,
    this.leftItems,
    this.rightItems,
    this.bottomPanels = const <ChatUIKitBottomPanelData>[],
    this.onPanelChanged,
    this.maintainBottomViewPadding = false,
    this.onInputTextChanged,
    this.readOnly = false,
    super.key,
  });
  final List<Widget>? leftItems;
  final List<Widget>? rightItems;
  final List<ChatUIKitBottomPanelData> bottomPanels;
  final ChatUIKitKeyboardPanelController keyboardPanelController;
  final void Function(String text)? onInputTextChanged;
  final void Function(ChatUIKitKeyboardPanelType panelType)? onPanelChanged;
  final bool maintainBottomViewPadding;
  final bool readOnly;

  @override
  State<ChatUIKitInputBar> createState() => _ChatUIKitInputBarState();
}

class _ChatUIKitInputBarState extends State<ChatUIKitInputBar>
    with ChatUIKitThemeMixin {
  late final ChatUIKitKeyboardPanelController keyboardPanelController;
  ChatUIKitKeyboardPanelType currentPanelType = ChatUIKitKeyboardPanelType.none;

  @override
  void initState() {
    super.initState();
    keyboardPanelController = widget.keyboardPanelController;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    ChatUIKitInputBarTheme? inputTheme = Theme.of(context).extension();

    Widget content = Container(
      decoration: BoxDecoration(
        color: inputTheme?.backgroundColor ??
            (theme.color.isDark
                ? theme.color.neutralColor1
                : theme.color.neutralColor98),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.leftItems != null) ...widget.leftItems!,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: Listener(
                onPointerUp: (event) {
                  if (keyboardPanelController.readOnly) {
                    keyboardPanelController
                        .switchPanel(ChatUIKitKeyboardPanelType.keyboard);
                    keyboardPanelController.readOnly = false;
                  }
                },
                child: TextField(
                  selectionControls: ChatUIKitSelectionControls(
                      selectionColor: inputTheme?.inputSelectionColor ??
                          (ChatUIKitTheme.instance.color.isDark
                              ? ChatUIKitTheme.instance.color.primaryColor6
                              : ChatUIKitTheme.instance.color.primaryColor5)),
                  onChanged: (value) {
                    widget.onInputTextChanged?.call(value);
                  },
                  showCursor: true,
                  readOnly: keyboardPanelController.readOnly,
                  focusNode: keyboardPanelController.inputPanelFocusNode,
                  controller:
                      keyboardPanelController.inputTextEditingController,
                  scrollPadding: EdgeInsets.zero,
                  cursorWidth: 1,
                  cursorHeight: 20,
                  keyboardAppearance:
                      theme.color.isDark ? Brightness.dark : Brightness.light,
                  maxLines: 4,
                  minLines: 1,
                  cursorColor: inputTheme?.inputCursorColor ??
                      (theme.color.isDark
                          ? theme.color.primaryColor6
                          : theme.color.primaryColor5),
                  style: TextStyle(
                    color: inputTheme?.inputTextColor ??
                        (theme.color.isDark
                            ? theme.color.neutralColor98
                            : theme.color.neutralColor1),
                    fontSize: theme.font.bodyLarge.fontSize,
                    fontWeight: theme.font.bodyLarge.fontWeight,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(
                        CornerRadiusHelper.inputBarRadius(36),
                      ), // 设置圆角大小
                    ),
                    fillColor: inputTheme?.inputBackgroundColor ??
                        (theme.color.isDark
                            ? theme.color.neutralColor2
                            : theme.color.neutralColor95),
                    filled: true,
                    isDense: true,
                    hintText: 'Aa',
                    hintStyle: TextStyle(
                      color: inputTheme?.inputHintTextColor ??
                          (theme.color.isDark
                              ? theme.color.neutralColor4
                              : theme.color.neutralColor6),
                      fontSize: theme.font.bodyLarge.fontSize,
                      fontWeight: theme.font.bodyLarge.fontWeight,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 7,
                      horizontal:
                          ChatUIKitSettings.inputBarRadius == CornerRadius.large
                              ? 18
                              : 8,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.rightItems != null) ...widget.rightItems!,
        ],
      ),
    );

    content = Column(
      children: [
        content,
        ChatUIKitKeyboardPanel(
          maintainBottomViewPadding: widget.maintainBottomViewPadding,
          controller: keyboardPanelController,
          bottomPanels: widget.bottomPanels,
          onPanelChanged: (panelType, readOnly) {
            if (keyboardPanelController.readOnly != readOnly) {
              keyboardPanelController.readOnly = readOnly;
              setState(() {});
            }
            widget.onPanelChanged?.call(panelType);
            currentPanelType = panelType;
          },
        )
      ],
    );

    return content;
  }
}
