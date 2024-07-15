import '../../chat_uikit.dart';
import '../../universal/inner_headers.dart';

import 'package:flutter/material.dart';

class GroupDeleteMembersView extends StatefulWidget {
  GroupDeleteMembersView.arguments(GroupDeleteMembersViewArguments arguments,
      {super.key})
      : listViewItemBuilder = arguments.listViewItemBuilder,
        onSearchTap = arguments.onSearchTap,
        searchBarHideText = arguments.searchBarHideText,
        listViewBackground = arguments.listViewBackground,
        onTap = arguments.onTap,
        onLongPress = arguments.onLongPress,
        appBarModel = arguments.appBarModel,
        controller = arguments.controller,
        enableAppBar = arguments.enableAppBar,
        groupId = arguments.groupId,
        viewObserver = arguments.viewObserver,
        attributes = arguments.attributes;

  const GroupDeleteMembersView({
    required this.groupId,
    this.listViewItemBuilder,
    this.onSearchTap,
    this.searchBarHideText,
    this.listViewBackground,
    this.onTap,
    this.onLongPress,
    this.appBarModel,
    this.controller,
    this.enableAppBar = true,
    this.attributes,
    this.viewObserver,
    super.key,
  });

  final String groupId;
  final GroupMemberListViewController? controller;
  final ChatUIKitAppBarModel? appBarModel;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? listViewItemBuilder;
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
  State<GroupDeleteMembersView> createState() => _GroupDeleteMembersViewState();
}

class _GroupDeleteMembersViewState extends State<GroupDeleteMembersView> {
  List<ChatUIKitProfile> selectedProfiles = [];
  late final GroupMemberListViewController controller;
  ChatUIKitAppBarModel? appBarModel;
  @override
  void initState() {
    super.initState();
    controller = widget.controller ??
        GroupMemberListViewController(
          groupId: widget.groupId,
          includeOwner: false,
        );
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
          ChatUIKitLocal.groupDeleteMembersViewTitle.localString(context),
      centerWidget: widget.appBarModel?.centerWidget,
      titleTextStyle: widget.appBarModel?.titleTextStyle,
      subtitle: widget.appBarModel?.subtitle,
      subTitleTextStyle: widget.appBarModel?.subTitleTextStyle,
      leadingActions: widget.appBarModel?.leadingActions ??
          widget.appBarModel?.leadingActionsBuilder?.call(context, null),
      trailingActions: widget.appBarModel?.trailingActions ??
          () {
            List<ChatUIKitAppBarAction> actions = [
              ChatUIKitAppBarAction(
                actionType: ChatUIKitActionType.remove,
                onTap: (context) {
                  if (selectedProfiles.isEmpty) {
                    return;
                  }
                  ensureDelete();
                },
                child: Text(
                  selectedProfiles.isEmpty
                      ? ChatUIKitLocal.groupDeleteMembersViewDelete
                          .localString(context)
                      : '${ChatUIKitLocal.groupDeleteMembersViewDelete.localString(context)}(${selectedProfiles.length})',
                  textScaler: TextScaler.noScaling,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: theme.color.isDark
                        ? selectedProfiles.isEmpty
                            ? theme.color.neutralColor5
                            : theme.color.errorColor6
                        : selectedProfiles.isEmpty
                            ? theme.color.neutralColor7
                            : theme.color.errorColor5,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    updateAppBarModel(theme);
    Widget content = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: widget.enableAppBar ? ChatUIKitAppBar.model(appBarModel!) : null,
      body: GroupMemberListView(
        groupId: widget.groupId,
        controller: controller,
        itemBuilder: widget.listViewItemBuilder ??
            (context, model) {
              return InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  tapContactInfo(model.profile);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 19.5, right: 15.5),
                  child: Row(
                    children: [
                      selectedProfiles.contains(model.profile)
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
                ),
              );
            },
        searchHideText: widget.searchBarHideText,
        background: widget.listViewBackground,
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
        ChatUIKitRouteNames.searchUsersView,
        SearchViewArguments(
          onTap: (ctx, profile) {
            Navigator.of(ctx).pop(profile);
          },
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

  void ensureDelete() async {
    showChatUIKitDialog(
      context: context,
      title: Strings.format(
          ChatUIKitLocal.groupDeleteMembersViewAlertTitle.localString(context),
          [selectedProfiles.length]),
      actionItems: [
        ChatUIKitDialogAction.cancel(
            label: ChatUIKitLocal.groupDeleteMembersViewAlertButtonCancel
                .localString(context)),
        ChatUIKitDialogAction.confirm(
            label: ChatUIKitLocal.groupDeleteMembersViewAlertButtonConfirm
                .localString(context),
            onTap: () async => Navigator.of(context).pop(true))
      ],
    ).then((value) {
      if (value == true) {
        Navigator.of(context).pop(selectedProfiles);
      }
    });
  }
}
