import '../../chat_uikit.dart';
import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  SearchView.arguments(
    SearchViewArguments arguments, {
    super.key,
  })  : searchData = arguments.searchData,
        searchHideText = arguments.searchHideText,
        itemBuilder = arguments.itemBuilder,
        onTap = arguments.onTap,
        enableMulti = arguments.enableMulti,
        cantChangeSelected = arguments.cantChangeSelected,
        canChangeSelected = arguments.canChangeSelected,
        selectedTitle = arguments.selectedTitle,
        viewObserver = arguments.viewObserver,
        attributes = arguments.attributes;

  const SearchView({
    required this.searchData,
    required this.searchHideText,
    this.itemBuilder,
    this.onTap,
    this.enableMulti = false,
    this.cantChangeSelected,
    this.canChangeSelected,
    this.selectedTitle,
    this.viewObserver,
    this.attributes,
    super.key,
  });

  final List<NeedSearch> searchData;
  final bool enableMulti;
  final String searchHideText;
  final void Function(BuildContext context, ChatUIKitProfile profile)? onTap;
  final Widget Function(BuildContext context, ChatUIKitProfile profile,
      String? searchKeyword)? itemBuilder;

  final List<ChatUIKitProfile>? cantChangeSelected;
  final List<ChatUIKitProfile>? canChangeSelected;
  final String? selectedTitle;
  final String? attributes;
  final ChatUIKitViewObserver? viewObserver;

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with ChatUIKitThemeMixin {
  ValueNotifier<List<ChatUIKitProfile>> selectedProfiles = ValueNotifier([]);

  @override
  void initState() {
    super.initState();

    widget.viewObserver?.addListener(() {
      setState(() {});
    });
    if (widget.canChangeSelected?.isNotEmpty == true) {
      selectedProfiles.value = widget.canChangeSelected!;
    }
  }

  @override
  void dispose() {
    widget.viewObserver?.dispose();
    super.dispose();
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    Widget? content;
    if (widget.enableMulti) {
      content = ValueListenableBuilder(
        valueListenable: selectedProfiles,
        builder: (context, value, child) {
          return ChatUIKitSearchWidget(
            searchHideText: widget.searchHideText,
            list: widget.searchData,
            autoFocus: true,
            builder: (context, searchKeyword, list) {
              return ChatUIKitListView(
                list: list,
                type: list.isEmpty
                    ? ChatUIKitListViewType.empty
                    : ChatUIKitListViewType.normal,
                enableSearchBar: false,
                itemBuilder: (context, model) {
                  if (model is NeedSearch) {
                    return InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        tapContactInfo(model.profile);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 19.5, right: 15.5),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                widget.cantChangeSelected != null &&
                                        widget.cantChangeSelected!.any(
                                                (element) =>
                                                    element.id ==
                                                    model.profile.id) ==
                                            true
                                    ? Icon(
                                        Icons.check_box,
                                        size: 28,
                                        color: theme.color.isDark
                                            ? theme.color.primaryColor6
                                            : theme.color.primaryColor5,
                                      )
                                    : value.contains(model.profile)
                                        ? Icon(
                                            Icons.check_box,
                                            size: 28,
                                            color: theme.color.isDark
                                                ? theme.color.primaryColor6
                                                : theme.color.primaryColor5,
                                          )
                                        : Icon(
                                            Icons.check_box_outline_blank,
                                            size: 28,
                                            color: theme.color.isDark
                                                ? theme.color.neutralColor4
                                                : theme.color.neutralColor7,
                                          ),
                                ChatUIKitSearchListViewItem(
                                  profile: model.profile,
                                ),
                              ],
                            ),
                            if (widget.cantChangeSelected?.any((element) =>
                                    element.id == model.profile.id) ==
                                true)
                              Opacity(
                                opacity: 0.6,
                                child: Container(
                                  color: theme.color.isDark
                                      ? theme.color.neutralColor1
                                      : theme.color.neutralColor98,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              );
            },
          );
        },
      );
    } else {
      content = ChatUIKitSearchWidget(
        searchHideText: widget.searchHideText,
        list: widget.searchData,
        autoFocus: true,
        builder: (context, searchKeyword, list) {
          return ChatUIKitListView(
            list: list,
            type: list.isEmpty
                ? ChatUIKitListViewType.empty
                : ChatUIKitListViewType.normal,
            enableSearchBar: false,
            itemBuilder: (context, model) {
              if (model is NeedSearch) {
                if (widget.itemBuilder != null) {
                  return widget.itemBuilder!
                      .call(context, model.profile, searchKeyword);
                }

                return InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.of(context).pop(model.profile);
                  },
                  child: ChatUIKitSearchListViewItem(
                    profile: model.profile,
                    highlightWord: searchKeyword,
                  ),
                );
              }
              return const SizedBox();
            },
          );
        },
      );
    }

    content = NotificationListener(
      child: content,
      onNotification: (notification) {
        if (notification is SearchNotification) {
          if (!notification.isSearch) {
            if (widget.enableMulti) {
              List<ChatUIKitProfile> list = [];
              list.addAll(selectedProfiles.value);
              Navigator.of(context).pop(list);
            } else {
              Navigator.of(context).pop();
            }
          }
        }
        return false;
      },
    );

    content = Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      body: SafeArea(child: content),
    );

    return content;
  }

  void tapContactInfo(ChatUIKitProfile profile) {
    if (widget.cantChangeSelected
            ?.where((element) => element.id == profile.id)
            .isNotEmpty ==
        true) {
      return;
    }
    List<ChatUIKitProfile> list = selectedProfiles.value;
    if (list.contains(profile)) {
      list.remove(profile);
    } else {
      list.add(profile);
    }
    selectedProfiles.value = [...list];
  }
}
