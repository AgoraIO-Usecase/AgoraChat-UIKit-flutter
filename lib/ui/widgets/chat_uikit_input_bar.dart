import '../../../chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitInputBarController extends ChangeNotifier {
  late CustomTextEditingController _textEditingController;
  late FocusNode _focusNode;

  CustomTextEditingController get textEditingController =>
      _textEditingController;
  FocusNode get focusNode => _focusNode;

  bool get needMention => _textEditingController.needMention;

  bool get isAtAll => _textEditingController.isAtAll;

  bool get hasFocus => _focusNode.hasFocus;

  List<ChatUIKitProfile> get mentionList {
    return _textEditingController.getMentionList();
  }

  ChatUIKitInputBarController({String? text}) {
    _textEditingController = CustomTextEditingController(text: text);
    _focusNode = FocusNode();
  }

  String get text => _textEditingController.text;

  void setText(String text) {
    _textEditingController.text = text;
  }

  void clear() {
    _textEditingController.clear();
  }

  void deleteTextOnCursor() {
    _textEditingController.deleteTextOnCursor();
  }

  void atAll() {
    _textEditingController.atAll();
  }

  void at(ChatUIKitProfile profile) {
    _textEditingController.at(profile);
  }

  void addText(String newStr) {
    _textEditingController.addText(newStr);
  }

  void clearMentions() {
    _textEditingController.clearMentions();
  }

  void requestFocus() {
    _focusNode.requestFocus();
    update();
  }

  void unfocus() {
    _focusNode.unfocus();
    update();
  }

  void update() {
    notifyListeners();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

class ChatUIKitInputBar extends StatefulWidget {
  const ChatUIKitInputBar({
    required this.inputBarController,
    this.leading,
    this.trailing,
    this.editingLeading,
    this.editingTrailing,
    this.hintText,
    this.hintTextStyle,
    this.inputTextStyle,
    this.textCapitalization = TextCapitalization.sentences,
    this.mixHeight = 36,
    this.borderRadius,
    this.onChanged,
    this.autofocus = false,
    super.key,
  });

  final Widget? leading;
  final Widget? trailing;
  final Widget? editingLeading;
  final Widget? editingTrailing;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final TextStyle? inputTextStyle;
  final ChatUIKitInputBarController inputBarController;
  final BorderRadiusGeometry? borderRadius;
  final TextCapitalization textCapitalization;
  final void Function(String input)? onChanged;

  final double mixHeight;
  final bool autofocus;

  @override
  State<ChatUIKitInputBar> createState() => _ChatUIKitInputBarState();
}

class _ChatUIKitInputBarState extends State<ChatUIKitInputBar> {
  late ScrollController? scrollController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    widget.inputBarController.textEditingController.addListener(() {
      widget.inputBarController.update();
      textFieldOnChange();
    });
    widget.inputBarController.focusNode.addListener(() {
      widget.inputBarController.update();
    });
  }

  void textFieldOnChange() {
    if (scrollController?.positions.isNotEmpty == true) {
      scrollController!.jumpTo(scrollController!.position.maxScrollExtent);
    }
  }

  @override
  void didUpdateWidget(covariant ChatUIKitInputBar oldWidget) {
    if (oldWidget.inputBarController != widget.inputBarController) {
      oldWidget.inputBarController.dispose();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildLeading(),
        Expanded(child: _buildInputField()),
        _buildTrailing(),
      ],
    );

    content = Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      constraints: BoxConstraints(minHeight: widget.mixHeight),
      decoration: BoxDecoration(
        color: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
        border: Border(
            top: BorderSide(
                color: theme.color.isDark
                    ? theme.color.neutralColor2
                    : theme.color.neutralColor9,
                width: 0.5)),
      ),
      child: content,
    );

    return content;
  }

  Widget _buildInputField() {
    final theme = ChatUIKitTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.color.isDark
            ? theme.color.neutralColor2
            : theme.color.neutralColor95,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
      ),
      child: TextField(
        scrollController: scrollController,
        keyboardAppearance: ChatUIKitTheme.of(context).color.isDark
            ? Brightness.dark
            : Brightness.light,
        autofocus: widget.autofocus,
        onChanged: widget.onChanged,
        focusNode: widget.inputBarController.focusNode,
        textCapitalization: widget.textCapitalization,
        maxLines: 4,
        minLines: 1,
        style: widget.inputTextStyle ??
            TextStyle(
              color: theme.color.isDark
                  ? theme.color.neutralColor98
                  : theme.color.neutralColor1,
              fontSize: theme.font.bodyLarge.fontSize,
              fontWeight: theme.font.bodyLarge.fontWeight,
            ),
        scrollPadding: EdgeInsets.zero,
        controller: widget.inputBarController.textEditingController,
        cursorWidth: 1,
        cursorColor: theme.color.isDark
            ? theme.color.primaryColor6
            : theme.color.primaryColor5,
        cursorRadius: const Radius.circular(1),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: widget.hintText ?? 'Aa',
          hintStyle: widget.hintTextStyle ??
              TextStyle(
                color: theme.color.isDark
                    ? theme.color.neutralColor4
                    : theme.color.neutralColor6,
                fontSize: theme.font.bodyLarge.fontSize,
                fontWeight: theme.font.bodyLarge.fontWeight,
              ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
        ),
      ),
    );
  }

  Widget _buildLeading() {
    Widget content = widget.leading ?? const SizedBox(width: 0);
    content = Container(
        margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: SizedBox(
          height: widget.mixHeight - 8,
          child: content,
        ));
    return content;
  }

  Widget _buildTrailing() {
    Widget content = widget.trailing ?? const SizedBox(width: 0);
    content = Container(
        margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: SizedBox(
          height: widget.mixHeight - 8,
          child: content,
        ));
    return content;
  }
}
