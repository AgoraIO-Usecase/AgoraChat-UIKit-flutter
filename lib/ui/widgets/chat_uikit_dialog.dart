import 'dart:math';
import '../../../chat_uikit.dart';

import 'package:flutter/material.dart';

const double defaultLeftRightPadding = 14;
Future<T?> showChatUIKitDialog<T>({
  required BuildContext context,
  List<ChatUIKitDialogItem<T>>? items,
  String? content,
  String? title,
  List<String>? hintsText,
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
        hintsText: hintsText,
        leftRightPadding: leftRightPadding ?? defaultLeftRightPadding,
        hiddenStyle: hiddenStyle,
        items: items,
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

enum ChatUIKitDialogItemType {
  confirm,
  inputConfirm,
  cancel,
  destructive,
}

class ChatUIKitDialogItem<T> {
  ChatUIKitDialogItem.cancel({
    required this.label,
    this.style,
    this.onTap,
  })  : type = ChatUIKitDialogItemType.cancel,
        onInputsTap = null;

  ChatUIKitDialogItem.confirm({
    required this.label,
    this.style,
    this.onTap,
  })  : type = ChatUIKitDialogItemType.confirm,
        onInputsTap = null;

  ChatUIKitDialogItem.inputsConfirm({
    required this.label,
    this.style,
    this.onInputsTap,
  })  : type = ChatUIKitDialogItemType.inputConfirm,
        onTap = null;

  ChatUIKitDialogItem.destructive({
    required this.label,
    this.style,
    this.onTap,
  })  : type = ChatUIKitDialogItemType.destructive,
        onInputsTap = null;

  ChatUIKitDialogItem({
    required this.type,
    required this.label,
    this.style,
    this.onTap,
    this.onInputsTap,
  });

  final ChatUIKitDialogItemType type;
  final String label;
  final TextStyle? style;
  final Future<void> Function()? onTap;
  final Future<void> Function(List<String> inputs)? onInputsTap;
}

class ChatUIKitDialog<T> extends StatefulWidget {
  const ChatUIKitDialog({
    this.items,
    this.title,
    this.content,
    this.titleStyle,
    this.contentStyle,
    this.hintsText,
    this.hiddenStyle,
    this.leftRightPadding = defaultLeftRightPadding,
    this.borderType = ChatUIKitDialogRectangleType.circular,
    super.key,
  });

  final String? title;
  final TextStyle? titleStyle;
  final String? content;
  final TextStyle? contentStyle;
  final List<ChatUIKitDialogItem<T>>? items;
  final ChatUIKitDialogRectangleType borderType;
  final List<String>? hintsText;
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
    widget.hintsText?.forEach((element) {
      _controllers.add(TextEditingController());
    });
    if (widget.items?.isNotEmpty == true) {
      for (var item in widget.items!) {
        if (item.type == ChatUIKitDialogItemType.inputConfirm ||
            item.type == ChatUIKitDialogItemType.confirm) {
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
          if (widget.hintsText?.isNotEmpty == true)
            () {
              List<Widget> list = [];
              for (var i = 0; i < widget.hintsText!.length; i++) {
                list.add(
                  Container(
                    margin: EdgeInsets.only(
                        top: 12,
                        left: widget.leftRightPadding,
                        right: widget.leftRightPadding),
                    decoration: BoxDecoration(
                      borderRadius: () {
                        if (widget.borderType ==
                            ChatUIKitDialogRectangleType.circular) {
                          return BorderRadius.circular(24);
                        } else if (widget.borderType ==
                            ChatUIKitDialogRectangleType.filletCorner) {
                          return BorderRadius.circular(4);
                        } else if (widget.borderType ==
                            ChatUIKitDialogRectangleType.rightAngle) {
                          return BorderRadius.circular(0);
                        }
                      }(),
                      color: () {
                        return (themeColor.isDark
                            ? themeColor.neutralColor3
                            : themeColor.neutralColor95);
                      }(),
                    ),
                    height: 48,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      child: TextField(
                        keyboardAppearance:
                            ChatUIKitTheme.of(context).color.isDark
                                ? Brightness.dark
                                : Brightness.light,
                        style: TextStyle(
                            fontWeight: themeFont.bodyLarge.fontWeight,
                            fontSize: themeFont.bodyLarge.fontSize,
                            color: themeColor.isDark
                                ? themeColor.neutralColor98
                                : themeColor.neutralColor1),
                        controller: _controllers[i],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontWeight: themeFont.bodyLarge.fontWeight,
                              fontSize: themeFont.bodyLarge.fontSize,
                              color: themeColor.isDark
                                  ? themeColor.neutralColor5
                                  : themeColor.neutralColor6),
                          hintText: widget.hintsText![i],
                          suffixIconConstraints: const BoxConstraints(),
                          suffixIcon: () {
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
                          }(),
                        ),
                      ),
                    ),
                  ),
                );
              }
              return Column(
                children: list,
              );
            }(),
          () {
            if (widget.items == null) {
              return Container();
            }
            List<Widget> widgets = [];
            for (var item in widget.items!) {
              widgets.add(
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (item.type == ChatUIKitDialogItemType.inputConfirm) {
                      if (item.onInputsTap == null) {
                        Navigator.of(context).pop();
                      } else {
                        if (confirmCount == 1 && _controllers.length == 1) {
                          if (_controllers.first.text.isNotEmpty == true) {
                            List<String> inputs = [];
                            for (var controller in _controllers) {
                              inputs.add(controller.text);
                            }
                            item.onInputsTap?.call(inputs);
                          }
                        } else {
                          List<String> inputs = [];
                          for (var controller in _controllers) {
                            inputs.add(controller.text);
                          }
                          item.onInputsTap?.call(inputs);
                        }
                      }
                    } else {
                      if (item.onTap != null) {
                        item.onTap?.call();
                      } else {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: () {
                        if (widget.borderType ==
                            ChatUIKitDialogRectangleType.circular) {
                          return BorderRadius.circular(24);
                        } else if (widget.borderType ==
                            ChatUIKitDialogRectangleType.filletCorner) {
                          return BorderRadius.circular(4);
                        } else if (widget.borderType ==
                            ChatUIKitDialogRectangleType.rightAngle) {
                          return BorderRadius.circular(0);
                        }
                      }(),
                      border: Border.all(
                        width: 1,
                        color: () {
                          if (item.type ==
                              ChatUIKitDialogItemType.destructive) {
                            return (themeColor.isDark
                                ? themeColor.errorColor6
                                : themeColor.errorColor5);
                          } else if (item.type ==
                              ChatUIKitDialogItemType.confirm) {
                            return (themeColor.isDark
                                ? themeColor.primaryColor6
                                : themeColor.primaryColor5);
                          } else if (item.type ==
                              ChatUIKitDialogItemType.inputConfirm) {
                            if (_controllers.length == 1 && confirmCount == 1) {
                              if (_controllers.first.text.isNotEmpty == true) {
                                return (themeColor.isDark
                                    ? themeColor.primaryColor6
                                    : themeColor.neutralColor95);
                              } else {
                                return (themeColor.isDark
                                    ? themeColor.neutralColor3
                                    : themeColor.neutralColor95);
                              }
                            } else {
                              return (themeColor.isDark
                                  ? themeColor.primaryColor6
                                  : themeColor.primaryColor5);
                            }
                          } else {
                            return (themeColor.isDark
                                ? themeColor.neutralColor4
                                : themeColor.neutralColor7);
                          }
                        }(),
                      ),
                      color: () {
                        if (item.type == ChatUIKitDialogItemType.destructive) {
                          return (themeColor.isDark
                              ? themeColor.errorColor6
                              : themeColor.errorColor5);
                        } else if (item.type ==
                            ChatUIKitDialogItemType.confirm) {
                          return (themeColor.isDark
                              ? themeColor.primaryColor6
                              : themeColor.primaryColor5);
                        } else if (item.type ==
                            ChatUIKitDialogItemType.inputConfirm) {
                          if (_controllers.length == 1 && confirmCount == 1) {
                            if (_controllers.first.text.isNotEmpty == true) {
                              return (themeColor.isDark
                                  ? themeColor.primaryColor6
                                  : themeColor.primaryColor5);
                            } else {
                              return (themeColor.isDark
                                  ? themeColor.neutralColor3
                                  : themeColor.neutralColor95);
                            }
                          } else {
                            return (themeColor.isDark
                                ? themeColor.primaryColor6
                                : themeColor.primaryColor5);
                          }
                        }
                      }(),
                    ),
                    child: Center(
                      child: Text(
                        item.label,
                        textScaler: TextScaler.noScaling,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: themeFont.headlineSmall.fontSize,
                          fontWeight: themeFont.headlineSmall.fontWeight,
                          color: () {
                            if (item.type ==
                                ChatUIKitDialogItemType.destructive) {
                              return (themeColor.isDark
                                  ? themeColor.neutralColor98
                                  : themeColor.neutralColor98);
                            } else if (item.type ==
                                ChatUIKitDialogItemType.confirm) {
                              return (themeColor.isDark
                                  ? themeColor.neutralColor98
                                  : themeColor.neutralColor98);
                            } else if (item.type ==
                                ChatUIKitDialogItemType.inputConfirm) {
                              if (_controllers.length == 1 &&
                                  confirmCount == 1) {
                                if (_controllers.first.text.isNotEmpty ==
                                    true) {
                                  return themeColor.isDark
                                      ? themeColor.neutralColor98
                                      : themeColor.neutralColor98;
                                } else {
                                  return (themeColor.isDark
                                      ? themeColor.neutralColor5
                                      : themeColor.neutralColor7);
                                }
                              } else {
                                return themeColor.isDark
                                    ? themeColor.neutralColor98
                                    : themeColor.neutralColor98;
                              }
                            } else {
                              return themeColor.isDark
                                  ? themeColor.neutralColor98
                                  : Colors.black;
                            }
                          }(),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            if (widget.items!.length > 2) {
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
}
