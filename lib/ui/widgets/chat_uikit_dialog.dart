import 'dart:math';
import 'package:flutter/services.dart';

import '../../../chat_uikit.dart';

import 'package:flutter/material.dart';

const double defaultLeftRightPadding = 14;
Future<T?> showChatUIKitDialog<T>({
  required BuildContext context,
  required List<ChatUIKitDialogAction<T>> actionItems,
  String? content,
  String? title,
  List<ChatUIKitDialogInputContentItem>? inputItems,
  TextStyle? hiddenStyle,
  double? leftRightPadding,
  Color barrierColor = Colors.black54,
  bool barrierDismissible = true,
  ChatUIKitDialogRectangleType? borderType,
}) async {
  ChatUIKitDialogRectangleType type =
      borderType ?? ChatUIKitSettings.dialogRectangleType;
  return showDialog(
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (context) {
      return ChatUIKitDialog(
        title: title,
        content: content,
        inputItems: inputItems,
        leftRightPadding: leftRightPadding ?? defaultLeftRightPadding,
        hiddenStyle: hiddenStyle,
        actionItems: actionItems,
        borderType: type,
      );
    },
  );
}

enum ChatUIKitDialogRectangleType {
  circular,
  filletCorner,
  rightAngle,
}

enum ChatUIKitDialogActionType {
  confirm,
  inputConfirm,
  cancel,
  destructive,
}

class ChatUIKitDialogAction<T> {
  ChatUIKitDialogAction.cancel({
    required this.label,
    this.style,
    this.onTap,
  })  : type = ChatUIKitDialogActionType.cancel,
        onInputsTap = null;

  ChatUIKitDialogAction.confirm({
    required this.label,
    this.style,
    this.onTap,
  })  : type = ChatUIKitDialogActionType.confirm,
        onInputsTap = null;

  ChatUIKitDialogAction.inputsConfirm({
    required this.label,
    this.style,
    this.onInputsTap,
  })  : type = ChatUIKitDialogActionType.inputConfirm,
        onTap = null;

  ChatUIKitDialogAction.destructive({
    required this.label,
    this.style,
    this.onTap,
  })  : type = ChatUIKitDialogActionType.destructive,
        onInputsTap = null;

  ChatUIKitDialogAction({
    required this.type,
    required this.label,
    this.style,
    this.onTap,
    this.onInputsTap,
  });

  final ChatUIKitDialogActionType type;
  final String label;
  final TextStyle? style;
  final Future<void> Function()? onTap;
  final Future<void> Function(List<String> inputs)? onInputsTap;
}

class ChatUIKitDialogInputContentItem {
  ChatUIKitDialogInputContentItem({
    this.hintText,
    this.maxLength = -1,
    this.minLength = -1,
    this.clearOnTap = false,
  });

  final String? hintText;
  final bool clearOnTap;
  final int maxLength;
  final int minLength;
}

class ChatUIKitDialog<T> extends StatefulWidget {
  const ChatUIKitDialog({
    required this.actionItems,
    this.title,
    this.content,
    this.titleStyle,
    this.contentStyle,
    this.inputItems,
    this.hiddenStyle,
    this.leftRightPadding = defaultLeftRightPadding,
    this.borderType = ChatUIKitDialogRectangleType.circular,
    super.key,
  });

  final String? title;
  final TextStyle? titleStyle;
  final String? content;
  final TextStyle? contentStyle;
  final List<ChatUIKitDialogAction<T>> actionItems;
  final ChatUIKitDialogRectangleType borderType;
  final List<ChatUIKitDialogInputContentItem>? inputItems;
  final double leftRightPadding;

  final TextStyle? hiddenStyle;

  @override
  State<ChatUIKitDialog> createState() => _ChatUIKitDialogState();
}

class _ChatUIKitDialogState extends State<ChatUIKitDialog> {
  final List<TextEditingController> _controllers = [];
  int confirmCount = 0;
  @override
  void initState() {
    super.initState();
    widget.inputItems?.forEach((element) {
      _controllers.add(TextEditingController());
    });
    if (widget.actionItems.isNotEmpty == true) {
      for (var item in widget.actionItems) {
        if (item.type == ChatUIKitDialogActionType.inputConfirm ||
            item.type == ChatUIKitDialogActionType.confirm) {
          confirmCount++;
        }
      }
    }

    for (var element in _controllers) {
      element.addListener(() {
        safeSetState(() {});
      });
    }
  }

  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  @override
  void dispose() {
    for (var element in _controllers) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = min(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height) -
        50;
    return Dialog(
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(() {
          switch (widget.borderType) {
            case ChatUIKitDialogRectangleType.circular:
              return 20.0;
            case ChatUIKitDialogRectangleType.filletCorner:
              return 8.0;
            case ChatUIKitDialogRectangleType.rightAngle:
              return 0.0;
          }
        }()),
      ),
      child: SizedBox(
        width: width,
        child: _buildContent(context),
      ),
    );
  }

  _buildContent(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    final themeColor = ChatUIKitTheme.of(context).color;
    final themeFont = ChatUIKitTheme.of(context).font;

    Widget contentWidget = Container(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 16),
      color: (themeColor.isDark
          ? themeColor.neutralColor2
          : themeColor.neutralColor98),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title?.isNotEmpty == true)
            Padding(
              padding: EdgeInsets.only(
                  top: 12,
                  left: widget.leftRightPadding,
                  right: widget.leftRightPadding),
              child: Text(
                widget.title!,
                textScaler: TextScaler.noScaling,
                textAlign: TextAlign.center,
                style: widget.titleStyle ??
                    TextStyle(
                      fontWeight: themeFont.headlineMedium.fontWeight,
                      fontSize: themeFont.headlineMedium.fontSize,
                      color: themeColor.isDark
                          ? themeColor.neutralColor98
                          : Colors.black,
                    ),
              ),
            ),
          if (widget.content?.isNotEmpty == true)
            Container(
              padding: EdgeInsets.only(
                  top: 12,
                  left: widget.leftRightPadding,
                  right: widget.leftRightPadding),
              child: Text(
                widget.content!,
                textScaler: TextScaler.noScaling,
                textAlign: TextAlign.center,
                style: widget.contentStyle ??
                    TextStyle(
                      fontWeight: themeFont.labelMedium.fontWeight,
                      fontSize: themeFont.labelMedium.fontSize,
                      color: (themeColor.isDark
                          ? themeColor.neutralColor6
                          : themeColor.neutralColor5),
                    ),
              ),
            ),
          if (widget.inputItems?.isNotEmpty == true) inputContents(),
          () {
            List<Widget> widgets = actionsWidget(theme);
            if (widget.actionItems.length > 2) {
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  widget.leftRightPadding,
                  10,
                  widget.leftRightPadding,
                  8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: () {
                    return widgets
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: e,
                          ),
                        )
                        .toList();
                  }(),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: () {
                    return widgets
                        .map(
                          (e) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 12, 6, 0),
                              child: e,
                            ),
                          ),
                        )
                        .toList();
                  }(),
                ),
              );
            }
          }()
        ],
      ),
    );

    contentWidget = ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [contentWidget],
    );
    contentWidget = Scrollbar(
      child: contentWidget,
    );
    return contentWidget;
  }

  // 当有需要输入的内容时，会使用这个组件
  Widget inputContents() {
    final theme = ChatUIKitTheme.of(context);
    final themeColor = theme.color;
    final themeFont = theme.font;

    final borderRadius = () {
      if (widget.borderType == ChatUIKitDialogRectangleType.circular) {
        return BorderRadius.circular(24);
      } else if (widget.borderType ==
          ChatUIKitDialogRectangleType.filletCorner) {
        return BorderRadius.circular(4);
      } else if (widget.borderType == ChatUIKitDialogRectangleType.rightAngle) {
        return BorderRadius.circular(0);
      }
    }();

    final textStyle = TextStyle(
        fontWeight: themeFont.bodyLarge.fontWeight,
        fontSize: themeFont.bodyLarge.fontSize,
        color: themeColor.isDark
            ? themeColor.neutralColor98
            : themeColor.neutralColor1);

    final hightLightStyle = TextStyle(
        fontWeight: themeFont.bodyLarge.fontWeight,
        fontSize: themeFont.bodyLarge.fontSize,
        color: themeColor.isDark
            ? themeColor.neutralColor5
            : themeColor.neutralColor6);

    List<Widget> list = [];
    for (var i = 0; i < widget.inputItems!.length; i++) {
      ChatUIKitDialogInputContentItem item = widget.inputItems![i];
      list.add(
        Container(
          margin: EdgeInsets.only(
            top: 12,
            left: widget.leftRightPadding,
            right: widget.leftRightPadding,
          ),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: themeColor.isDark
                ? themeColor.neutralColor3
                : themeColor.neutralColor95,
          ),
          height: 48,
          child: Padding(
            padding: const EdgeInsets.only(left: 14, right: 14),
            child: TextField(
              keyboardAppearance: ChatUIKitTheme.of(context).color.isDark
                  ? Brightness.dark
                  : Brightness.light,
              style: textStyle,
              controller: _controllers[i],
              inputFormatters: [
                LengthLimitingTextInputFormatter(item.maxLength)
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: hightLightStyle,
                hintText: item.hintText,
                suffix: item.maxLength == -1
                    ? null
                    : Text(
                        '${_controllers[i].text.length}/${item.maxLength}',
                      ),
                suffixIconConstraints: const BoxConstraints(),
                suffixIcon: item.clearOnTap
                    ? () {
                        if (_controllers[i].text.isNotEmpty) {
                          return InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              _controllers[i].clear();
                            },
                            child: Icon(
                              Icons.cancel,
                              color: themeColor.isDark
                                  ? themeColor.neutralColor8
                                  : themeColor.neutralColor3,
                            ),
                          );
                        }
                      }()
                    : null,
              ),
            ),
          ),
        ),
      );
    }

    return Column(children: list);
  }

  List<Widget> actionsWidget(ChatUIKitTheme theme) {
    final themeColor = theme.color;

    List<Widget> widgets = [];

    // 按钮圆角
    final borderRadius = () {
      if (widget.borderType == ChatUIKitDialogRectangleType.circular) {
        return BorderRadius.circular(24);
      } else if (widget.borderType ==
          ChatUIKitDialogRectangleType.filletCorner) {
        return BorderRadius.circular(4);
      } else if (widget.borderType == ChatUIKitDialogRectangleType.rightAngle) {
        return BorderRadius.circular(0);
      }
    }();

    // 取消按钮颜色
    Color cancelColor = themeColor.isDark
        ? themeColor.neutralColor2
        : themeColor.neutralColor98;
    // 取消按钮文字颜色
    Color cancelTextColor = themeColor.isDark
        ? themeColor.neutralColor95
        : themeColor.neutralColor3;
    // 取消按钮边框颜色
    Color cancelBorderColor =
        themeColor.isDark ? themeColor.neutralColor4 : themeColor.neutralColor7;

    // 破坏性按钮颜色
    Color destructiveColor =
        themeColor.isDark ? themeColor.errorColor6 : themeColor.errorColor5;

    // 破坏性按钮文字颜色
    Color destructiveTextColor = theme.color.neutralColor98;

    // 破坏性按钮边框颜色
    Color destructiveBorderColor =
        themeColor.isDark ? themeColor.errorColor6 : themeColor.errorColor5;

    // 确认按钮颜色
    Color confirmColor =
        themeColor.isDark ? themeColor.primaryColor6 : themeColor.primaryColor5;

    Color confirmTextColor = theme.color.neutralColor98;

    Color confirmBorderColor = themeColor.isDark
        ? themeColor.primaryColor6
        : themeColor.neutralColor95;

    // 确认按钮被禁止时颜色
    Color confirmForbiddenColor = theme.color.isDark
        ? theme.color.neutralColor3
        : theme.color.neutralColor95;

    // 确认按钮被禁止时文字颜色
    Color confirmForbiddenTextColor =
        themeColor.isDark ? themeColor.neutralColor5 : themeColor.neutralColor7;

    // 确认按钮被禁止时边框颜色
    Color confirmForbiddenBorderColor = themeColor.isDark
        ? themeColor.neutralColor3
        : themeColor.neutralColor95;

    for (var action in widget.actionItems) {
      if (action.type == ChatUIKitDialogActionType.inputConfirm) {
        bool canTap = true;
        for (var i = 0; i < _controllers.length; i++) {
          final item = widget.inputItems![i];
          canTap = (_controllers[i].text.length <= item.maxLength ||
                  item.maxLength < 0) &&
              _controllers[i].text.length > item.minLength;
          if (canTap == false) break;
        }
        widgets.add(
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: canTap
                ? () {
                    List<String> inputs = [];
                    for (var controller in _controllers) {
                      inputs.add(controller.text);
                    }
                    action.onInputsTap?.call(inputs);
                  }
                : null,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: Border.all(
                  width: 1,
                  color:
                      canTap ? confirmBorderColor : confirmForbiddenBorderColor,
                ),
                color: canTap ? confirmColor : confirmForbiddenColor,
              ),
              child: Center(
                child: Text(
                  action.label,
                  textScaler: TextScaler.noScaling,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: theme.font.headlineSmall.fontSize,
                    fontWeight: theme.font.headlineSmall.fontWeight,
                    color:
                        canTap ? confirmTextColor : confirmForbiddenTextColor,
                  ),
                ),
              ),
            ),
          ),
        );
      } else if (action.type == ChatUIKitDialogActionType.confirm) {
        widgets.add(
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              if (action.onTap == null) {
                Navigator.of(context).pop();
              } else {
                action.onTap?.call();
              }
            },
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: Border.all(
                  width: 1,
                  color: confirmBorderColor,
                ),
                color: confirmColor,
              ),
              child: Center(
                child: Text(
                  action.label,
                  textScaler: TextScaler.noScaling,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: theme.font.headlineSmall.fontSize,
                    fontWeight: theme.font.headlineSmall.fontWeight,
                    color: confirmTextColor,
                  ),
                ),
              ),
            ),
          ),
        );
      } else if (action.type == ChatUIKitDialogActionType.destructive) {
        widgets.add(
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              if (action.onTap == null) {
                Navigator.of(context).pop();
              } else {
                action.onTap?.call();
              }
            },
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: Border.all(
                  width: 1,
                  color: destructiveBorderColor,
                ),
                color: destructiveColor,
              ),
              child: Center(
                child: Text(
                  action.label,
                  textScaler: TextScaler.noScaling,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: theme.font.headlineSmall.fontSize,
                    fontWeight: theme.font.headlineSmall.fontWeight,
                    color: destructiveTextColor,
                  ),
                ),
              ),
            ),
          ),
        );
      } else if (action.type == ChatUIKitDialogActionType.cancel) {
        widgets.add(
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              if (action.onTap == null) {
                Navigator.of(context).pop();
              } else {
                action.onTap?.call();
              }
            },
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: Border.all(
                  width: 1,
                  color: cancelBorderColor,
                ),
                color: cancelColor,
              ),
              child: Center(
                child: Text(
                  action.label,
                  textScaler: TextScaler.noScaling,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: theme.font.headlineSmall.fontSize,
                    fontWeight: theme.font.headlineSmall.fontWeight,
                    color: cancelTextColor,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
    return widgets;
  }

  // 当按钮数量超过两个时，会使用竖向排列
  Widget columnActions() {
    return Container();
  }

  // 当按钮数量小于等于两个时，会使用横向排列
  Widget rowActions() {
    List<Widget> widgets = [];
    if (widget.inputItems?.isNotEmpty == true) {
      // 因为当有输入框时，就会为每一个输入框分配 controller，所以此处输入框数量等于 controller 数量，并且顺序一致。
      for (var i = 0; i < _controllers.length; i++) {
        ChatUIKitDialogInputContentItem item = widget.inputItems![i];
        if (item.maxLength < _controllers[i].text.length ||
            item.minLength > _controllers[i].text.length) {
          widgets.add(Container());
        }
      }
    }
    return Container();
  }
}
