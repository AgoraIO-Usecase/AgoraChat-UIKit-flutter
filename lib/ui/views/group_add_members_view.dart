import '../../chat_uikit.dart';

import 'package:flutter/material.dart';

class GroupAddMembersView extends StatefulWidget {
  GroupAddMembersView.arguments(GroupAddMembersViewArguments arguments,
      {super.key})
      : itemBuilder = arguments.itemBuilder,
        onSearchTap = arguments.onSearchTap,
        searchBarHideText = arguments.searchBarHideText,
        listViewBackground = arguments.listViewBackground,
        onTap = arguments.onTap,
        onLongPress = arguments.onLongPress,
        appBarModel = arguments.appBarModel,
        controller = arguments.controller,
        groupId = arguments.groupId,
        enableAppBar = arguments.enableAppBar,
        inGroupMembers = arguments.inGroupMembers,
        viewObserver = arguments.viewObserver,
        attributes = arguments.attributes;

  const GroupAddMembersView({
    required this.groupId,
    this.itemBuilder,
    this.onSearchTap,
    this.searchBarHideText,
    this.listViewBackground,
    this.onTap,
    this.onLongPress,
    this.appBarModel,
    this.controller,
    this.inGroupMembers,
    this.enableAppBar = true,
    this.viewObserver,
    this.attributes,
    super.key,
  });

  final String groupId;
  final ContactListViewController? controller;
  final ChatUIKitAppBarModel? appBarModel;
  final void Function(List<ContactItemModel> data)? onSearchTap;
  final List<ChatUIKitProfile>? inGroupMembers;
  final ChatUIKitContactItemBuilder? itemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)?
      onLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final bool enableAppBar;
  final String? attributes;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;

  @override
  State<GroupAddMembersView> createState() => _GroupAddMembersViewState();
}

class _GroupAddMembersViewState extends State<GroupAddMembersView>
    with ChatUIKitThemeMixin {
  late final ContactListViewController controller;
  List<ChatUIKitProfile> selectedProfiles = [];
  ChatUIKitAppBarModel? appBarModel;
  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? ContactListViewController();
    widget.viewObserver?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.viewObserver?.dispose();
    super.dispose();
  }

  void updateAppBarModel(ChatUIKitTheme theme) {
    appBarModel = ChatUIKitAppBarModel(
      title: widget.appBarModel?.title ??
          ChatUIKitLocal.groupAddMembersViewTitle.localString(context),
      centerWidget: widget.appBarModel?.centerWidget,
      titleTextStyle: widget.appBarModel?.titleTextStyle,
      subtitle: widget.appBarModel?.subtitle,
      subTitleTextStyle: widget.appBarModel?.subTitleTextStyle,
      leadingActions: widget.appBarModel?.leadingActions ??
          widget.appBarModel?.leadingActionsBuilder?.call(context, null),
      trailingActions: () {
        List<ChatUIKitAppBarAction> actions = [
          ChatUIKitAppBarAction(
            actionType: ChatUIKitActionType.add,
            onTap: (context) {
              if (selectedProfiles.isEmpty) {
                return;
              }
              Navigator.of(context).pop(selectedProfiles);
            },
            child: Text(
              selectedProfiles.isEmpty
                  ? ChatUIKitLocal.groupAddMembersViewAdd.localString(context)
                  : '${ChatUIKitLocal.groupAddMembersViewAdd.localString(context)}(${selectedProfiles.length})',
              textScaler: TextScaler.noScaling,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: theme.color.isDark
                    ? theme.color.primaryColor6
                    : theme.color.primaryColor5,
                fontWeight: theme.font.labelMedium.fontWeight,
                fontSize: theme.font.labelMedium.fontSize,
              ),
            ),
          )
        ];
        return widget.appBarModel?.trailingActionsBuilder
                ?.call(context, actions) ??
            actions;
      }(),
      showBackButton: widget.appBarModel?.showBackButton ?? true,
      onBackButtonPressed: widget.appBarModel?.onBackButtonPressed,
      centerTitle: widget.appBarModel?.centerTitle ?? false,
      systemOverlayStyle: widget.appBarModel?.systemOverlayStyle,
      backgroundColor: widget.appBarModel?.backgroundColor,
      bottomLine: widget.appBarModel?.bottomLine,
      bottomLineColor: widget.appBarModel?.bottomLineColor,
    );
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    updateAppBarModel(theme);
    Widget content = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: widget.enableAppBar ? ChatUIKitAppBar.model(appBarModel!) : null,
      body: ContactListView(
        controller: controller,
        itemBuilder: widget.itemBuilder ??
            (context, model) {
              return InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  if (widget.inGroupMembers
                          ?.any((element) => element.id == model.profile.id) !=
                      true) {
                    tapContactInfo(model.profile);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 19.5, right: 15.5),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          widget.inGroupMembers?.any((element) =>
                                      element.id == model.profile.id) ==
                                  true
                              ? Icon(
                                  Icons.check_box,
                                  size: 28,
                                  color: theme.color.isDark
                                      ? theme.color.primaryColor6
                                      : theme.color.primaryColor5,
                                )
                              : selectedProfiles.contains(model.profile)
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
                          Expanded(child: ChatUIKitContactListViewItem(model))
                        ],
                      ),
                      if (widget.inGroupMembers?.any(
                              (element) => element.id == model.profile.id) ==
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
            },
        searchBarHideText: widget.searchBarHideText,
        emptyBackground: widget.listViewBackground,
        onSearchTap: widget.onSearchTap ?? onSearchTap,
      ),
    );

    return content;
  }

  void onSearchTap(List<ContactItemModel> data) async {
    List<NeedSearch> list = [];
    for (var item in data) {
      list.add(item);
    }
    ChatUIKitRoute.pushOrPushNamed(
        context,
        ChatUIKitRouteNames.searchView,
        SearchViewArguments(
          onTap: (ctx, profile) {
            Navigator.of(ctx).pop(profile);
          },
          cantChangeSelected: widget.inGroupMembers,
          canChangeSelected: selectedProfiles,
          searchHideText:
              ChatUIKitLocal.createGroupViewSearchContact.localString(context),
          searchData: list,
          enableMulti: true,
          attributes: widget.attributes,
        )).then(
      (value) {
        if (value is List<ChatUIKitProfile>) {
          selectedProfiles = [...value];
          setState(() {});
        }
      },
    );
  }

  void tapContactInfo(ChatUIKitProfile profile) {
    List<ChatUIKitProfile> list = selectedProfiles;
    if (list.contains(profile)) {
      list.remove(profile);
    } else {
      list.add(profile);
    }
    selectedProfiles = [...list];
    setState(() {});
  }
}
