import '../../../chat_uikit.dart';

import 'package:flutter/material.dart';

class SearchNotification extends Notification {
  SearchNotification(this.isSearch);
  final bool isSearch;
}

typedef ListViewSearchBuilder = Widget Function(
  BuildContext context,
  String? searchKeyword,
  List<ChatUIKitListItemModelBase> list,
);

class ChatUIKitSearchWidget extends StatefulWidget {
  const ChatUIKitSearchWidget({
    required this.builder,
    required this.searchHideText,
    required this.list,
    this.enableSearch = true,
    this.autoFocus = false,
    super.key,
  });
  final ListViewSearchBuilder builder;
  final String searchHideText;
  final bool enableSearch;
  final List<ChatUIKitListItemModelBase> list;
  final bool autoFocus;

  @override
  State<ChatUIKitSearchWidget> createState() => _ChatUIKitSearchWidgetState();
}

class _ChatUIKitSearchWidgetState extends State<ChatUIKitSearchWidget>
    with ChatUIKitThemeMixin {
  late final List<ChatUIKitListItemModelBase> list;
  TextEditingController searchController = TextEditingController();
  bool isSearch = false;
  bool isShowClear = false;
  ValueNotifier<String> searchKeyword = ValueNotifier('');
  @override
  void initState() {
    super.initState();
    list = widget.list;
    isSearch = widget.autoFocus;
    searchController.addListener(() {
      searchKeyword.value = searchController.text;
    });
  }

  @override
  void didUpdateWidget(covariant ChatUIKitSearchWidget oldWidget) {
    if (widget.list != oldWidget.list) {
      list.clear();
      list.addAll(widget.list);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    if (!widget.enableSearch) {
      return widget.builder(context, '', list);
    }

    Widget content = Column(
      children: [
        isSearch ? searchTextInputBar() : searchBar(),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: searchKeyword,
            builder: (context, keyword, child) {
              if (keyword.isEmpty) {
                return widget.builder(context, keyword, []);
              } else {
                List<ChatUIKitListItemModelBase> searched = [];
                for (var item in list) {
                  if (item is NeedSearch) {
                    if (item.showName
                        .toLowerCase()
                        .contains(keyword.toLowerCase())) {
                      searched.add(item);
                    }
                  }
                }
                return widget.builder(context, keyword, searched);
              }
            },
          ),
        ),
      ],
    );

    return content;
  }

  Widget searchTextInputBar() {
    return SizedBox(
      height: 44,
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 4, 0, 4),
        height: 36,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(6, 7, 0, 7),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      CornerRadiusHelper.searchBarRadius(36)),
                  color: theme.color.isDark
                      ? theme.color.neutralColor2
                      : theme.color.neutralColor95,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ChatUIKitImageLoader.search(
                      width: 22,
                      height: 22,
                      color: theme.color.neutralColor3,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: TextField(
                        keyboardAppearance: theme.color.isDark
                            ? Brightness.dark
                            : Brightness.light,
                        autofocus: true,
                        style: TextStyle(
                            fontWeight: theme.font.bodyLarge.fontWeight,
                            fontSize: theme.font.bodyLarge.fontSize,
                            color: theme.color.isDark
                                ? theme.color.neutralColor98
                                : theme.color.neutralColor1),
                        controller: searchController,
                        scrollPadding: EdgeInsets.zero,
                        decoration: InputDecoration(
                          hintText: widget.searchHideText,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          hintStyle: TextStyle(
                            color: theme.color.isDark
                                ? theme.color.neutralColor4
                                : theme.color.neutralColor6,
                          ),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: searchKeyword,
                      builder: (context, value, child) {
                        if (value.isEmpty) {
                          return const SizedBox();
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                searchController.clear();
                              },
                              child: Icon(
                                Icons.cancel,
                                size: 22,
                                color: theme.color.isDark
                                    ? theme.color.neutralColor7
                                    : theme.color.neutralColor3,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                safeSetState(() {
                  isSearch = false;
                });
                searchController.clear();
                SearchNotification(isSearch).dispatch(context);
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(
                  ChatUIKitLocal.searchWidgetCancel.localString(context),
                  overflow: TextOverflow.ellipsis,
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    color: theme.color.isDark
                        ? theme.color.primaryColor6
                        : theme.color.primaryColor5,
                    fontWeight: theme.font.bodyLarge.fontWeight,
                    fontSize: theme.font.bodyLarge.fontSize,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return SizedBox(
      height: 44,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          safeSetState(() {
            isSearch = true;
          });
          SearchNotification(isSearch).dispatch(context);
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(CornerRadiusHelper.searchBarRadius(36)),
            color: theme.color.isDark
                ? theme.color.neutralColor2
                : theme.color.neutralColor95,
          ),
          height: 36,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ChatUIKitImageLoader.search(
                  width: 22,
                  height: 22,
                  color: theme.color.neutralColor3,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.searchHideText,
                  overflow: TextOverflow.ellipsis,
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    color: theme.color.isDark
                        ? theme.color.neutralColor4
                        : theme.color.neutralColor6,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}
