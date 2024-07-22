import '../../../chat_uikit.dart';
import 'dart:math';
import 'package:flutter/material.dart';

const double letterHeight = 16;
const double letterWidth = 16;

const defaultLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ#';

class ChatUIKitAlphabeticalWidget extends StatefulWidget {
  const ChatUIKitAlphabeticalWidget({
    required this.list,
    required this.scrollController,
    required this.builder,
    this.groupId,
    this.enableSorting = true,
    this.showAlphabetical = true,
    this.selectionTextStyle,
    this.selectionHeight = 32,
    this.selectionBackgroundColor,
    this.universalAlphabeticalLetter = '#',
    this.sortAlphabetical,
    this.rightPadding = 2,
    this.onSelectLetterChanged,
    this.highlight = true,
    this.highlightColor,
    this.listViewHasSearchBar = true,
    this.beforeWidgets,
    this.itemModelBuilder,
    super.key,
  });

  final String? sortAlphabetical;
  final TextStyle? selectionTextStyle;
  final double selectionHeight;
  final Color? selectionBackgroundColor;
  final bool showAlphabetical;
  final List<Widget>? beforeWidgets;
  final String universalAlphabeticalLetter;
  final ListViewBuilder builder;
  final bool enableSorting;
  final double rightPadding;
  final ScrollController scrollController;
  final void Function(BuildContext context, String? letter)?
      onSelectLetterChanged;
  final bool listViewHasSearchBar;
  final bool highlight;
  final Color? highlightColor;
  final String? groupId;
  final List<ChatUIKitListItemModelBase> list;
  final AlphabeticalItemModel? Function(String alphabetical)? itemModelBuilder;

  @override
  State<ChatUIKitAlphabeticalWidget> createState() =>
      _ChatUIKitAlphabeticalWidgetState();
}

class _ChatUIKitAlphabeticalWidgetState
    extends State<ChatUIKitAlphabeticalWidget> {
  List<String> targets = [];
  String? latestSelected;
  ValueNotifier<int> selectIndex = ValueNotifier(-1);
  bool onTouch = false;

  Map<String, double> positionMap = {};

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(listDidMove);
  }

  void listDidMove() {
    if (onTouch || !widget.highlight || !widget.enableSorting) return;
    for (var str in targets) {
      double? position = positionMap[str];
      if (position != null && position != 0) {
        if (widget.scrollController.offset >= position) {
          latestSelected = str;
          selectIndex.value = targets.indexOf(str);
        }
      }
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(listDidMove);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ChatUIKitAlphabeticalWidget oldWidget) {
    widget.scrollController.removeListener(listDidMove);
    widget.scrollController.addListener(listDidMove);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enableSorting || widget.list.isEmpty) {
      return widget.builder.call(
        context,
        widget.list,
      );
    }

    Widget content = widget.builder.call(
      context,
      sortList(),
    );

    if (widget.showAlphabetical) {
      content = Stack(
        children: [
          content,
          Positioned(
            top: 0,
            bottom: 0,
            width: 30,
            right: widget.rightPadding,
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return letterWidget(constraints.maxHeight);
                },
              ),
            ),
          ),
        ],
      );
    }

    return content;
  }

  Widget letterWidget(double height) {
    MediaQuery.of(context);
    if (targets.length * letterHeight > height) {
      List<String> tmp = [];
      for (var i = 0; i < targets.length; i++) {
        if (i % 3 == 0) {
          tmp.add(targets[i]);
          tmp.add("·");
        }
      }
      targets = tmp;
    }

    final theme = ChatUIKitTheme.of(context);
    List<Widget> letters = [];
    for (var i = 0; i < targets.length; i++) {
      final element = targets[i];
      letters.add(
        ValueListenableBuilder(
          valueListenable: selectIndex,
          builder: (context, value, child) {
            bool selected = false;
            if (widget.highlight) {
              selected = (value == i) && targets[i] != '·';
            }
            Widget? content = Container(
              clipBehavior: Clip.hardEdge,
              width: letterWidth,
              height: letterHeight,
              decoration: BoxDecoration(
                color: selected
                    ? widget.highlightColor ??
                        (theme.color.isDark
                            ? theme.color.primaryColor6
                            : theme.color.primaryColor5)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(letterHeight / 2),
              ),
              child: Center(
                child: Text(
                  element.substring(0, 1).toUpperCase(),
                  textAlign: TextAlign.right,
                  textScaler: TextScaler.noScaling,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected
                        ? (theme.color.isDark
                            ? theme.color.neutralColor98
                            : theme.color.neutralColor98)
                        : (theme.color.isDark
                            ? theme.color.neutralColor6
                            : theme.color.neutralColor5),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            );

            return content;
          },
        ),
      );
    }

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: letters,
    );

    // 设置最大响应宽度为100, 如果不使用空白色填充，则会导致点击事件无法触发
    content = Container(
      color: Colors.transparent,
      width: 100,
      child: content,
    );

    content = GestureDetector(
      child: content,
      onVerticalDragDown: (details) {
        onSelected(targets[getIndex(details.localPosition)]);
      },
      onVerticalDragUpdate: (details) {
        onSelected(targets[getIndex(details.localPosition)]);
      },
      onVerticalDragCancel: () {
        cancelSelected();
      },
      onLongPressUp: () {
        cancelSelected();
      },
      onLongPressStart: (details) {
        onSelected(targets[getIndex(details.localPosition)]);
      },
      onLongPressMoveUpdate: (details) {
        onSelected(targets[getIndex(details.localPosition)]);
      },
      onVerticalDragEnd: (details) {
        cancelSelected();
      },
    );

    content = Center(
      child: content,
    );

    return content;
  }

  int getIndex(Offset localPosition) {
    double y = localPosition.dy;
    int index = (y ~/ letterHeight).clamp(0, targets.length - 1);
    selectIndex.value = index;
    return index;
  }

  void onSelected(String str) {
    if (latestSelected == str) {
      return;
    }
    onTouch = true;
    if (str == '·') {
      return;
    }
    widget.onSelectLetterChanged?.call(context, str);
    latestSelected = str;
    moveTo(str);
  }

  void cancelSelected() {
    onTouch = false;
    // latestSelected = null;
    // selectIndex.value = -1;
    widget.onSelectLetterChanged?.call(context, null);
  }

  List<ChatUIKitListItemModelBase> sortList() {
    targets.clear();

    List<String> targetList = List.from(
        widget.sortAlphabetical?.characters.toList() ??
            ChatUIKitSettings.sortAlphabetical.characters.toList());

    List<ChatUIKitListItemModelBase> ret = [];

    List<NeedAlphabetical> tmp =
        widget.list.whereType<NeedAlphabetical>().toList();

    Map<String, List<NeedAlphabetical>> map = {};
    for (var letter in targetList) {
      map[letter] = [];
    }
    map[widget.universalAlphabeticalLetter] = [];

    for (var item in tmp) {
      String? letter = ChatUIKitAlphabetSortHelper.instance.sortHandler
          ?.call(widget.groupId, item.profile.id, item.showName);

      letter ??= item.firstLetter;

      letter = letter.toUpperCase();

      if (targetList.any((element) => element.startsWith(letter!))) {
        map[letter]?.add(item);
      } else {
        map[widget.universalAlphabeticalLetter]?.add(item);
      }
    }
    // 对序列内容排序
    for (var item in map.keys) {
      map[item]!.sort((a, b) => a.showName.compareTo(b.showName));
    }

    // 清空空序列
    map.removeWhere((key, value) => value.isEmpty);

    // 修改special位置，如果target中没有special，则把special在最后。
    if (!targetList.contains(widget.universalAlphabeticalLetter)) {
      targetList.add(widget.universalAlphabeticalLetter);
    }

    // 清空不存在的target
    targetList.removeWhere((element) => !map.containsKey(element));

    positionMap.clear();

    // 索引初始位置
    double position = widget.listViewHasSearchBar ? 44 : 0;

    if (widget.beforeWidgets?.isNotEmpty == true) {
      for (var beforeItem in widget.beforeWidgets!) {
        if (beforeItem is NeedAlphabeticalWidget) {
          position += beforeItem.itemHeight;
        }
      }
    }

    // 计算index 位置 转为最终序列
    for (var item in targetList) {
      positionMap[item] = position;
      final letterModel = widget.itemModelBuilder?.call(item) ??
          AlphabeticalItemModel(
            item.toUpperCase(),
            textStyle: widget.selectionTextStyle,
            height: widget.selectionHeight,
            backgroundColor: widget.selectionBackgroundColor,
          );
      ret.add(letterModel);
      position += letterModel.height;
      List<NeedAlphabetical> list = map[item]!;
      for (var element in list) {
        NeedAlphabetical model = element;
        ret.add(model);
        position += model.itemHeight;
      }

      targets.add(item);
    }

    return ret;
  }

  void moveTo(String alphabetical) {
    if (!onTouch) {
      return;
    }
    if (!positionMap.containsKey(alphabetical)) {
      return;
    }
    double position = positionMap[alphabetical]!;

    position = min(position, widget.scrollController.position.maxScrollExtent);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.scrollController.jumpTo(position);
    });
  }
}
