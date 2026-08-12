import 'package:chat_uikit_theme/chat_uikit_theme.dart';
import 'package:flutter/material.dart';

enum ChatDialogRectangleBorderType {
  circular,
  filletCorner,
  rightAngle,
}

Future<T> showChatDialog<T>(
  BuildContext context, {
  required List<ChatDialogItem<dynamic>> items,
  String? subTitle,
  String? title,
  List<String>? hiddenList,
  Color barrierColor = Colors.black54,
  ChatDialogRectangleBorderType borderType =
      ChatDialogRectangleBorderType.circular,
}) async {
  return await showDialog(
    barrierColor: barrierColor,
    context: context,
    builder: (context) {
      return ChatRoomDialog(
        title: title,
        subTitle: subTitle,
        hiddenList: hiddenList,
        items: items,
        borderType: borderType,
      );
    },
  );
}

class ChatRoomDialog<T> extends StatelessWidget {
  const ChatRoomDialog({
    required this.items,
    this.subTitle,
    this.title,
    this.hiddenList,
    this.borderType = ChatDialogRectangleBorderType.circular,
    super.key,
  });

  final String? title;
  final String? subTitle;
  final List<ChatDialogItem> items;
  final ChatDialogRectangleBorderType borderType;
  final List<String>? hiddenList;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 50;
    return Dialog(
      elevation: 0,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(() {
          switch (borderType) {
            case ChatDialogRectangleBorderType.circular:
              return 16.0;
            case ChatDialogRectangleBorderType.filletCorner:
              return 8.0;
            case ChatDialogRectangleBorderType.rightAngle:
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
    final theme = ChatUIKitTheme.instance;
    Widget content = Container(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 16),
      color: (theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
              child: Text(
                title!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: theme.font.titleLarge.fontWeight,
                  fontSize: theme.font.titleLarge.fontSize,
                  color: theme.color.isDark
                      ? theme.color.neutralColor98
                      : Colors.black,
                ),
              ),
            ),
          if (subTitle?.isNotEmpty == true)
            Container(
              padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
              child: Text(
                subTitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: theme.font.labelMedium.fontWeight,
                  fontSize: theme.font.labelMedium.fontSize,
                  color: (theme.color.isDark
                      ? theme.color.neutralColor6
                      : theme.color.neutralColor5),
                ),
              ),
            ),
          () {
            if (items.isEmpty) return Container();
            List<Widget> widgets = [];
            for (var item in items) {
              widgets.add(
                InkWell(
                  onTap: item.onTap,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: () {
                        if (borderType ==
                            ChatDialogRectangleBorderType.circular) {
                          return BorderRadius.circular(24);
                        } else if (borderType ==
                            ChatDialogRectangleBorderType.filletCorner) {
                          return BorderRadius.circular(4);
                        } else if (borderType ==
                            ChatDialogRectangleBorderType.rightAngle) {
                          return BorderRadius.circular(0);
                        }
                      }(),
                      border: Border.all(
                        width: 1,
                        color: () {
                          if (item.type == ChatDialogItemType.destructive) {
                            return (theme.color.isDark
                                ? theme.color.errorColor6
                                : theme.color.errorColor5);
                          } else if (item.type == ChatDialogItemType.confirm) {
                            return (theme.color.isDark
                                ? theme.color.primaryColor6
                                : theme.color.primaryColor5);
                          } else {
                            return (theme.color.isDark
                                ? theme.color.neutralColor4
                                : theme.color.neutralColor7);
                          }
                        }(),
                      ),
                      color: () {
                        if (item.type == ChatDialogItemType.destructive) {
                          return (theme.color.isDark
                              ? theme.color.errorColor6
                              : theme.color.errorColor5);
                        } else if (item.type == ChatDialogItemType.confirm) {
                          return (theme.color.isDark
                              ? theme.color.primaryColor6
                              : theme.color.primaryColor5);
                        }
                      }(),
                    ),
                    child: Center(
                      child: Text(
                        () {
                          switch (item.type) {
                            case ChatDialogItemType.destructive:
                              return item.label ??
                                  // 国际化
                                  'ChatroomLocal.dialogDelete.getString(context)';
                            case ChatDialogItemType.confirm:
                              return item.label ??
                                  // 国际化
                                  'ChatroomLocal.dialogConfirm.getString(context)';
                            case ChatDialogItemType.normal:
                              return item.label ??
                                  // 国际化
                                  'ChatroomLocal.dialogCancel.getString(context)';
                          }
                        }(),
                        style: TextStyle(
                          fontSize: theme.font.headlineSmall.fontSize,
                          fontWeight: theme.font.headlineSmall.fontWeight,
                          color: () {
                            if (item.type == ChatDialogItemType.destructive) {
                              return (theme.color.isDark
                                  ? theme.color.neutralColor98
                                  : theme.color.neutralColor98);
                            } else if (item.type ==
                                ChatDialogItemType.confirm) {
                              return (theme.color.isDark
                                  ? theme.color.neutralColor98
                                  : theme.color.neutralColor98);
                            } else {
                              return theme.color.isDark
                                  ? theme.color.neutralColor98
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
            if (items.length > 2) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(12, 20, 12, 8),
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
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
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

    content = ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [content],
    );
    content = Scrollbar(
      child: content,
    );
    return content;
  }
}

enum ChatDialogItemType {
  confirm,
  normal,
  destructive,
}

class ChatDialogItem<T> {
  ChatDialogItem.destructive({
    this.label,
    required this.onTap,
    this.style,
  }) : type = ChatDialogItemType.destructive;

  ChatDialogItem.cancel({
    this.label,
    required this.onTap,
    this.style,
  }) : type = ChatDialogItemType.normal;

  ChatDialogItem.confirm({
    this.label,
    required this.onTap,
    this.style,
  }) : type = ChatDialogItemType.confirm;

  const ChatDialogItem({
    required this.label,
    this.style,
    required this.onTap,
    required this.type,
  });

  final ChatDialogItemType type;
  final String? label;
  final TextStyle? style;
  final Future<T> Function()? onTap;
}
