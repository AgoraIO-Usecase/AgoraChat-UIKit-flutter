import '../../../chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitEditBar extends StatefulWidget {
  const ChatUIKitEditBar({
    this.text,
    this.focusNode,
    this.onInputTextChanged,
    super.key,
  });
  final FocusNode? focusNode;
  final String? text;
  final void Function(String text)? onInputTextChanged;
  @override
  State<ChatUIKitEditBar> createState() => _ChatUIKitEditBarState();
}

class _ChatUIKitEditBarState extends State<ChatUIKitEditBar>
    with ChatUIKitThemeMixin {
  TextEditingController textEditingController = TextEditingController();
  bool messageEditCanSend = false;

  @override
  void initState() {
    textEditingController.text = widget.text ?? '';
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    Widget content = Container(
      decoration: BoxDecoration(
        color: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    messageEditCanSend = value != widget.text;
                  });
                },
                showCursor: true,
                readOnly: false,
                autofocus: true,
                focusNode: widget.focusNode,
                controller: textEditingController,
                scrollPadding: EdgeInsets.zero,
                cursorWidth: 1,
                cursorHeight: 20,
                keyboardAppearance:
                    theme.color.isDark ? Brightness.dark : Brightness.light,
                maxLines: 4,
                minLines: 1,
                cursorColor: theme.color.isDark
                    ? theme.color.primaryColor6
                    : theme.color.primaryColor5,
                style: TextStyle(
                  color: theme.color.isDark
                      ? theme.color.neutralColor98
                      : theme.color.neutralColor1,
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
                  fillColor: theme.color.isDark
                      ? theme.color.neutralColor2
                      : theme.color.neutralColor95,
                  filled: true,
                  isDense: true,
                  hintText: 'Aa',
                  hintStyle: TextStyle(
                    color: theme.color.isDark
                        ? theme.color.neutralColor4
                        : theme.color.neutralColor6,
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
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              if (messageEditCanSend) {
                widget.onInputTextChanged?.call(textEditingController.text);
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Icon(
                Icons.check_circle,
                size: 30,
                color: theme.color.isDark
                    ? messageEditCanSend
                        ? theme.color.primaryColor6
                        : theme.color.neutralColor5
                    : messageEditCanSend
                        ? theme.color.primaryColor5
                        : theme.color.neutralColor7,
              ),
            ),
          )
        ],
      ),
    );
    Widget header = Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: ChatUIKitImageLoader.messageEdit(),
        ),
        const SizedBox(width: 2),
        Text(
          ChatUIKitLocal.messagesViewEditMessageTitle.localString(context),
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: theme.font.labelSmall.fontWeight,
              fontSize: theme.font.labelSmall.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralSpecialColor6
                  : theme.color.neutralSpecialColor5),
        ),
      ],
    );
    header = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
          color: theme.color.isDark
              ? theme.color.neutralColor2
              : theme.color.neutralColor9),
      child: header,
    );

    content = Column(
      children: [
        header,
        content,
      ],
    );
    return content;
  }
}
