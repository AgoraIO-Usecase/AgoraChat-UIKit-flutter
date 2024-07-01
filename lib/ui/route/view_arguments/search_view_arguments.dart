import '../../../chat_uikit.dart';
import 'package:flutter/widgets.dart';

class SearchViewArguments implements ChatUIKitViewArguments {
  SearchViewArguments({
    required this.searchData,
    required this.searchHideText,
    this.onTap,
    this.itemBuilder,
    this.enableMulti = false,
    this.cantChangeSelected,
    this.canChangeSelected,
    this.selectedTitle,
    this.viewObserver,
    this.attributes,
  });

  final List<NeedSearch> searchData;
  final String searchHideText;
  final void Function(BuildContext context, ChatUIKitProfile profile)? onTap;
  final Widget Function(BuildContext context, ChatUIKitProfile profile,
      String? searchKeyword)? itemBuilder;
  final bool enableMulti;
  final List<ChatUIKitProfile>? cantChangeSelected;
  final List<ChatUIKitProfile>? canChangeSelected;
  final String? selectedTitle;

  @override
  String? attributes;

  @override
  ChatUIKitViewObserver? viewObserver;

  SearchViewArguments copyWith({
    List<NeedSearch>? searchData,
    String? searchHideText,
    void Function(BuildContext context, ChatUIKitProfile profile)? onTap,
    Widget Function(BuildContext context, ChatUIKitProfile profile,
            String? searchKeyword)?
        itemBuilder,
    bool? enableMulti,
    List<ChatUIKitProfile>? cantChangeSelected,
    List<ChatUIKitProfile>? canChangeSelected,
    String? selectedTitle,
    ChatUIKitViewObserver? viewObserver,
    String? attributes,
  }) {
    return SearchViewArguments(
      searchData: searchData ?? this.searchData,
      searchHideText: searchHideText ?? this.searchHideText,
      onTap: onTap ?? this.onTap,
      itemBuilder: itemBuilder ?? this.itemBuilder,
      enableMulti: enableMulti ?? this.enableMulti,
      cantChangeSelected: cantChangeSelected ?? this.cantChangeSelected,
      canChangeSelected: canChangeSelected ?? this.canChangeSelected,
      selectedTitle: selectedTitle ?? this.selectedTitle,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
    );
  }
}
