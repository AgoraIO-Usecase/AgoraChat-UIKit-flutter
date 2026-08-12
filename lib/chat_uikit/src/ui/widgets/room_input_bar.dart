import 'dart:math';

import 'package:chat_uikit_theme/chat_uikit_theme.dart';
import 'package:agora_chat_uikit/chat_uikit/src/chat_uikit_settings.dart';
import 'package:agora_chat_uikit/chat_uikit/src/tools/chat_uikit_extension.dart';
import 'package:agora_chat_uikit/chat_uikit_localizations/chat_uikit_localizations.dart';
import 'package:agora_chat_uikit/chat_uikit_universal/chat_uikit_universal.dart';
import 'package:agora_chat_uikit/chatroom_uikit/chatroom_uikit.dart';
import 'package:flutter/material.dart';

class RoomInputBarController {
  void _attach(ChatRoomInputBarState state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  ChatRoomInputBarState? _state;
  void hiddenInputBar() {
    _state?.hiddenInputBar();
  }

  void requestFocus() {
    _state?.requestFocus();
  }
}

class ChatRoomInputBar extends StatefulWidget {
  ChatRoomInputBar({
    this.inputIcon,
    this.inputHint,
    this.leading,
    this.actions,
    this.textDirection,
    this.onSend,
    this.controller,
    this.textEditingController,
    this.bottomDistance = 0,
    super.key,
  }) {
    assert(
        actions == null || actions!.length <= 4, 'can\'t more than 4 actions');
  }

  final Widget? inputIcon;
  final String? inputHint;
  final Widget? leading;
  final List<Widget>? actions;
  final TextDirection? textDirection;
  final void Function(String msg)? onSend;
  final RoomInputBarController? controller;
  final TextEditingController? textEditingController;
  final double bottomDistance;

  @override
  State<ChatRoomInputBar> createState() => ChatRoomInputBarState();
}

enum InputType {
  normal,
  text,
  emoji,
}

class ChatRoomInputBarState extends State<ChatRoomInputBar>
    with ChatUIKitThemeMixin {
  late RoomInputBarController controller;
  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? RoomInputBarController();
    controller._attach(this);
    focusNode = FocusNode();
    textEditingController =
        widget.textEditingController ?? TextEditingController();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          _inputType = InputType.text;
        });
      }
    });
  }

  void hiddenInputBar() {
    setState(() {
      _inputType = InputType.normal;
    });
  }

  void requestFocus() {
    setState(() {
      _inputType = InputType.text;
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    textEditingController.dispose();
    controller._detach();
    super.dispose();
  }

  InputType _inputType = InputType.normal;

  late TextEditingController textEditingController;

  late FocusNode focusNode;

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _inputType == InputType.normal ? normalWidget() : inputWidget(),
        faceWidget(),
      ],
    );

    content = Padding(
      padding: focusNode.hasFocus
          ? EdgeInsets.only(
              bottom: max(
                  MediaQuery.of(context).viewInsets.bottom -
                      widget.bottomDistance,
                  0))
          : EdgeInsets.zero,
      child: content,
    );

    return content;
  }

  Widget interiorWidget() {
    return InkWell(
      onTap: () {
        setState(() {
          _inputType = InputType.text;
        });
        focusNode.requestFocus();
      },
      child: Row(
        textDirection: widget.textDirection,
        children: [
          Container(
            margin: const EdgeInsets.all(4),
            width: 24,
            child: widget.inputIcon ??
                ChatRoomImageLoader.roomInputChat(
                  color: const Color.fromRGBO(255, 255, 255, 0.8),
                ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 4, left: 4),
              child: Text(
                widget.inputHint ?? ChatUIKitLocal.roomInputHint.localString(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color.fromRGBO(255, 255, 255, 0.8),
                  fontSize: theme.font.bodyLarge.fontSize,
                  fontWeight: theme.font.bodyLarge.fontWeight,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget constrained(Widget child) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: theme.color.isDark
            ? theme.color.barrageColor2
            : theme.color.barrageColor1,
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }

  Widget normalWidget() {
    List<Widget> children = [];
    if (widget.leading != null) {
      children.add(Padding(
        padding: const EdgeInsets.only(left: 8),
        child: constrained(widget.leading!),
      ));
    }

    CornerRadius radius = ChatUIKitSettings.inputBarRadius;

    double height = 38;
    double circle = height /
        () {
          if (radius == CornerRadius.extraSmall) {
            return 16;
          } else if (radius == CornerRadius.small) {
            return 8;
          } else if (radius == CornerRadius.medium) {
            return 4;
          } else {
            return 2;
          }
        }();

    Widget content = Container(
      height: height,
      padding: const EdgeInsets.only(left: 4, right: 4),
      decoration: BoxDecoration(
        color: theme.color.isDark
            ? theme.color.barrageColor2
            : theme.color.barrageColor1,
        borderRadius: BorderRadius.circular(circle),
      ),
      child: interiorWidget(),
    );

    content = Expanded(
        child: Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: content,
    ));

    children.add(content);

    if (widget.actions != null) {
      children.addAll(
        widget.actions!.map(
          (e) => Padding(
            padding: const EdgeInsets.only(left: 8),
            child: constrained(e),
          ),
        ),
      );
    }

    content = Row(
      textDirection: widget.textDirection,
      children: children,
    );

    content = Container(
      padding: const EdgeInsets.only(left: 8, right: 16),
      height: 54,
      child: content,
    );

    return content;
  }

  Widget inputWidget() {
    List<Widget> list = [];

    CornerRadius radius = ChatUIKitSettings.inputBarRadius;

    double height = 38;
    double circle = height /
        () {
          if (radius == CornerRadius.extraSmall) {
            return 16;
          } else if (radius == CornerRadius.small) {
            return 8;
          } else if (radius == CornerRadius.medium) {
            return 4;
          } else {
            return 2;
          }
        }();

    list.add(
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: (theme.color.isDark
                ? theme.color.neutralColor2
                : theme.color.neutralColor95),
            borderRadius: BorderRadius.circular(circle),
          ),
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            textDirection: widget.textDirection,
            keyboardAppearance:
                theme.color.isDark ? Brightness.dark : Brightness.light,
            maxLines: 4,
            minLines: 1,
            style: TextStyle(
              color: (theme.color.isDark
                  ? theme.color.neutralColor98
                  : theme.color.neutralColor1),
              fontSize: theme.font.bodyLarge.fontSize,
              fontWeight: theme.font.bodyLarge.fontWeight,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
            controller: textEditingController,
            focusNode: focusNode,
            onTap: () {},
          ),
        ),
      ),
    );

    List<Widget> trailing = [];
    trailing.add(
      InkWell(
        onTap: () {
          setState(() {
            _inputType = _inputType == InputType.emoji
                ? InputType.text
                : InputType.emoji;
            if (_inputType == InputType.emoji) {
              focusNode.unfocus();
            } else {
              focusNode.requestFocus();
            }
          });
        },
        child: () {
          return _inputType == InputType.emoji
              ? ChatRoomImageLoader.roomKeyboard(
                  color: (theme.color.isDark
                      ? theme.color.neutralColor98
                      : theme.color.neutralColor1),
                )
              : ChatRoomImageLoader.roomFace(
                  color: (theme.color.isDark
                      ? theme.color.neutralColor98
                      : theme.color.neutralColor1),
                );
        }(),
      ),
    );

    trailing.add(InkWell(
      onTap: () {
        widget.onSend!.call(textEditingController.text);
        textEditingController.text = '';
        setState(() {
          _inputType = InputType.normal;
        });
      },
      child: ChatRoomImageLoader.roomSend(),
    ));

    list.addAll(trailing.map(
      (e) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 11),
          child: ConstrainedBox(
            constraints: BoxConstraints.loose(const Size(30, 30)),
            child: e,
          ),
        );
      },
    ).toList());

    Widget content = Row(
      textDirection: widget.textDirection,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: list,
    );

    content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: (theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98),
      child: content,
    );

    return content;
  }

  Widget faceWidget() {
    Widget content = AnimatedContainer(
      onEnd: () {},
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
      height: _inputType == InputType.emoji ? 280 : 0,
      child: Container(
        color: (theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98),
        child: ChatInputEmoji(
          deleteOnTap: () {
            TextSelection selection = textEditingController.selection;
            TextEditingValue value = textEditingController.value;
            if (selection.baseOffset != selection.extentOffset) {
              textEditingController.text = textEditingController.text
                  .replaceRange(selection.start, selection.end, '');
              textEditingController.selection = TextSelection.fromPosition(
                  TextPosition(offset: selection.start));
            } else if (selection.baseOffset == 0) {
              return;
            } else if (selection.baseOffset != value.text.length) {
              String subText = value.text.substring(0, selection.start);
              subText = subText.characters.skipLast(1).toString();
              String text = subText.characters.skipLast(1).toString() +
                  value.text.substring(selection.start);
              TextSelection newSelection = TextSelection.fromPosition(
                  TextPosition(offset: subText.length));

              textEditingController.value = TextEditingValue(
                text: text,
                selection: newSelection,
              );
            } else {
              String text = value.text.characters.skipLast(1).toString();
              TextSelection newSelection =
                  TextSelection.fromPosition(TextPosition(offset: text.length));

              textEditingController.value = TextEditingValue(
                text: text,
                selection: newSelection,
              );
            }
          },
          emojiClicked: (emoji) {
            TextSelection selection = textEditingController.selection;
            if (selection.baseOffset != selection.extentOffset) {
              textEditingController.text = textEditingController.text
                  .replaceRange(selection.start, selection.end, emoji);
              textEditingController.selection = TextSelection.fromPosition(
                  TextPosition(offset: selection.start + emoji.length));
            } else if (selection.baseOffset == 0) {
              textEditingController.text =
                  emoji + textEditingController.text.substring(selection.start);
              textEditingController.selection = TextSelection.fromPosition(
                  TextPosition(offset: selection.start + emoji.length));
            } else {
              textEditingController.text =
                  textEditingController.text.substring(0, selection.start) +
                      emoji +
                      textEditingController.text.substring(selection.start);
              textEditingController.selection = TextSelection.fromPosition(
                  TextPosition(offset: selection.start + emoji.length));
            }
          },
        ),
      ),
    );

    return content;
  }
}

class ChatRoomTextEditingController extends TextEditingController {
  List<EmojiIndex> includeEmojis = [];

  ChatRoomTextEditingController() {
    debugPrint('ChatRoomTextEditingController');
  }

  @override
  set value(TextEditingValue newValue) {
    assert(
      !newValue.composing.isValid || newValue.isComposingRangeValid,
      'New TextEditingValue $newValue has an invalid non-empty composing range '
      '${newValue.composing}. It is recommended to use a valid composing range, '
      'even for readonly text fields',
    );
    super.value = newValue;
  }

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    int firstIndex = 0;
    includeEmojis.clear();
    do {
      firstIndex = text.indexOf('[', firstIndex);
      if (firstIndex != -1 && text.isNotEmpty) {
        final secondIndex = text.indexOf(']', firstIndex);
        if (secondIndex != -1) {
          String subTxt = text.substring(firstIndex, secondIndex + 1);
          if (EmojiMapping.emojis.contains(subTxt)) {
            includeEmojis.add(EmojiIndex(
              index: firstIndex,
              length: subTxt.length,
              emoji: subTxt,
            ));
          }
        } else {
          break;
        }
        firstIndex = secondIndex + 1;
      }
    } while (firstIndex != -1);

    List<InlineSpan> tp = [];

    if (includeEmojis.isNotEmpty) {
      int index = 0;
      for (var item in includeEmojis) {
        if (item.index > index) {
          tp.add(TextSpan(
            text: text.substring(index, item.index),
            style: style,
          ));
        }
        tp.add(
          WidgetSpan(
            child: ChatRoomImageLoader.roomEmoji(item.emoji, size: 20),
          ),
        );
        index = item.index + item.length;
      }
      if (index < text.length) {
        tp.add(TextSpan(
          text: text.substring(index, text.length),
          style: style,
        ));
      }
    } else {
      tp.add(TextSpan(
        text: text,
        style: style,
      ));
    }

    return TextSpan(children: tp);
  }
}

class EmojiIndex {
  int index;
  int length;
  String emoji;
  EmojiIndex({
    required this.index,
    required this.length,
    required this.emoji,
  });
}
