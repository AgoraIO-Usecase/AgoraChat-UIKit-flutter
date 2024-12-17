import '../../chat_uikit.dart';

import 'package:flutter/material.dart';

class GroupMembersView extends StatefulWidget {
  GroupMembersView.arguments(GroupMembersViewArguments arguments, {Key? key})
      : profile = arguments.profile,
        itemBuilder = arguments.itemBuilder,
        onSearchTap = arguments.onSearchTap,
        searchBarHideText = arguments.searchBarHideText,
        listViewBackground = arguments.listViewBackground,
        onTap = arguments.onTap,
        onLongPress = arguments.onLongPress,
        appBarModel = arguments.appBarModel,
        controller = arguments.controller,
        loadErrorMessage = arguments.loadErrorMessage,
        enableAppBar = arguments.enableAppBar,
        attributes = arguments.attributes,
        viewObserver = arguments.viewObserver,
        onSelectLetterChanged = arguments.onSelectLetterChanged,
        sortAlphabetical = arguments.sortAlphabetical,
        universalAlphabeticalLetter = arguments.universalAlphabeticalLetter,
        super(key: key);

  const GroupMembersView({
    required this.profile,
    this.itemBuilder,
    this.onSearchTap,
    this.searchBarHideText,
    this.listViewBackground,
    this.onTap,
    this.onLongPress,
    this.appBarModel,
    this.controller,
    this.loadErrorMessage,
    this.enableAppBar = true,
    this.attributes,
    this.viewObserver,
    this.onSelectLetterChanged,
    this.sortAlphabetical,
    this.universalAlphabeticalLetter = '#',
    super.key,
  });

  final ChatUIKitProfile profile;
  final void Function(BuildContext context, String? letter)?
      onSelectLetterChanged;

  /// 通讯录列表的字母排序默认字，默认为 '#'
  final String universalAlphabeticalLetter;

  /// 字母排序
  final String? sortAlphabetical;
  final GroupMemberListViewController? controller;
  final ChatUIKitAppBarModel? appBarModel;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? itemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)?
      onLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final String? loadErrorMessage;
  final bool enableAppBar;

  final String? attributes;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;

  @override
  State<GroupMembersView> createState() => _GroupMembersViewState();
}

class _GroupMembersViewState extends State<GroupMembersView>
    with GroupObserver, ChatUIKitThemeMixin {
  late final GroupMemberListViewController controller;
  List<ContactItemModel>? addedBuffers;
  List<ContactItemModel>? deleteBuffer;
  ValueNotifier<int> memberCount = ValueNotifier<int>(0);
  ChatUIKitAppBarModel? appBarModel;
  Group? group;
  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    controller = widget.controller ??
        GroupMemberListViewController(groupId: widget.profile.id);
    widget.viewObserver?.addListener(() {
      setState(() {});
    });
    fetchGroup();
  }

  @override
  void dispose() {
    widget.viewObserver?.dispose();
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onMemberJoinedFromGroup(String groupId, String member) {
    memberCount.value = memberCount.value + 1;
  }

  @override
  void onMemberExitedFromGroup(String groupId, String member) {
    memberCount.value = memberCount.value - 1;
  }

  void fetchGroup() async {
    try {
      group = await ChatUIKit.instance.getGroup(groupId: widget.profile.id);
      group ??=
          await ChatUIKit.instance.fetchGroupInfo(groupId: widget.profile.id);
      memberCount.value = group?.memberCount ?? 0;
      setState(() {});
      // ignore: empty_catches
    } catch (e) {}
  }

  void updateAppBarModel(ChatUIKitTheme theme) {
    appBarModel = ChatUIKitAppBarModel(
      title: widget.appBarModel?.title,
      centerWidget: widget.appBarModel?.centerWidget ??
          ValueListenableBuilder(
            valueListenable: memberCount,
            builder: (context, value, child) {
              if (memberCount.value == 0) {
                return Text(
                  widget.appBarModel?.title ??
                      ChatUIKitLocal.groupMembersViewTitle.localString(context),
                  textScaler: TextScaler.noScaling,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.color.isDark
                        ? theme.color.neutralColor98
                        : theme.color.neutralColor1,
                    fontWeight: theme.font.titleMedium.fontWeight,
                    fontSize: theme.font.titleMedium.fontSize,
                  ),
                );
              } else {
                return Text(
                  '${ChatUIKitLocal.groupMembersViewTitle.localString(context)}(${memberCount.value})',
                  textScaler: TextScaler.noScaling,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.color.isDark
                        ? theme.color.neutralColor98
                        : theme.color.neutralColor1,
                    fontWeight: theme.font.titleMedium.fontWeight,
                    fontSize: theme.font.titleMedium.fontSize,
                  ),
                );
              }
            },
          ),
      titleTextStyle: widget.appBarModel?.titleTextStyle,
      subtitle: widget.appBarModel?.subtitle,
      subTitleTextStyle: widget.appBarModel?.subTitleTextStyle,
      leadingActions: widget.appBarModel?.leadingActions ??
          widget.appBarModel?.leadingActionsBuilder?.call(context, null),
      trailingActions: () {
        List<ChatUIKitAppBarAction> actions = [];

        if (group?.permissionType == GroupPermissionType.Owner) {
          actions.add(
            ChatUIKitAppBarAction(
              actionType: ChatUIKitActionType.add,
              onTap: (context) {
                pushToAddMember();
              },
              child: Icon(
                Icons.person_add_alt_1_outlined,
                color: theme.color.isDark
                    ? theme.color.neutralColor9
                    : theme.color.neutralColor3,
                size: 24,
              ),
            ),
          );
          actions.add(ChatUIKitAppBarAction(
            actionType: ChatUIKitActionType.remove,
            onTap: (context) {
              pushToRemoveMember();
            },
            child: Icon(
              Icons.person_remove_alt_1_outlined,
              color: theme.color.isDark
                  ? theme.color.neutralColor9
                  : theme.color.neutralColor3,
              size: 24,
            ),
          ));
          actions = widget.appBarModel?.trailingActionsBuilder
                  ?.call(context, actions) ??
              actions;
        }
        return actions;
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
      body: SafeArea(
        child: GroupMemberListView(
          groupId: widget.profile.id,
          controller: controller,
          onSelectLetterChanged: widget.onSelectLetterChanged,
          universalAlphabeticalLetter: widget.universalAlphabeticalLetter,
          sortAlphabetical: widget.sortAlphabetical,
          itemBuilder: widget.itemBuilder,
          searchBarHideText: widget.searchBarHideText,
          emptyBackground: widget.listViewBackground,
          onTap: widget.onTap ??
              (context, model) {
                onMemberTap(context, model.profile);
              },
          onSearchTap: widget.onSearchTap ?? onSearchTap,
        ),
      ),
    );

    return content;
  }

  Widget actionsWidget() {
    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: pushToAddMember,
          child: Icon(
            Icons.person_add_alt_1_outlined,
            color: theme.color.isDark
                ? theme.color.neutralColor9
                : theme.color.neutralColor3,
            size: 24,
          ),
        ),
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: pushToRemoveMember,
          child: Icon(
            Icons.person_remove_alt_1_outlined,
            color: theme.color.isDark
                ? theme.color.neutralColor9
                : theme.color.neutralColor3,
            size: 24,
          ),
        )
      ],
    );

    content = Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      width: 74,
      height: 36,
      child: content,
    );
    return content;
  }

  void onMemberTap(BuildContext context, ChatUIKitProfile profile) async {
    // 如果是自己
    if (profile.id == ChatUIKit.instance.currentUserId) {
      pushToCurrentUser(profile);
      return;
    }

    List<String> contacts = await ChatUIKit.instance.getAllContactIds();
    if (contacts.contains(profile.id)) {
      pushContactDetails(profile);
    } else {
      pushNewRequestDetails(profile);
    }
  }

  // 处理点击自己头像和点击自己名片
  void pushToCurrentUser(ChatUIKitProfile profile) {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.currentUserInfoView,
      CurrentUserInfoViewArguments(
        profile: profile,
        attributes: widget.attributes,
      ),
    );
  }

  void pushContactDetails(ChatUIKitProfile profile) {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.contactDetailsView,
      ContactDetailsViewArguments(
        profile: profile,
        attributes: widget.attributes,
      ),
    );
  }

  void pushNewRequestDetails(ChatUIKitProfile profile) {
    Navigator.of(context).pushNamed(
      ChatUIKitRouteNames.newRequestDetailsView,
      arguments: NewRequestDetailsViewArguments(
        profile: profile,
        attributes: widget.attributes,
      ),
    );
  }

  void pushToAddMember() async {
    List<ChatUIKitProfile> members = [];

    List list = controller.list;
    for (var element in list) {
      if (element is ContactItemModel) {
        members.add(element.profile);
      }
    }

    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.groupAddMembersView,
      GroupAddMembersViewArguments(
        groupId: widget.profile.id,
        inGroupMembers: members,
        attributes: widget.attributes,
      ),
    ).then((value) {
      if (value != null && value is List<ChatUIKitProfile>) {
        List<ContactItemModel> models = [];
        List<String> userIds = [];
        for (var item in value) {
          userIds.add(item.id);
          models.add(ContactItemModel(profile: item));
        }
        ChatUIKit.instance.addGroupMembers(
          groupId: widget.profile.id,
          members: userIds,
        );

        controller.list.addAll(models);
        controller.refresh();
      }
    }).catchError((e) {});
  }

  void pushToRemoveMember() {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.groupDeleteMembersView,
      GroupDeleteMembersViewArguments(
        groupId: widget.profile.id,
        attributes: widget.attributes,
      ),
    ).then((value) {
      if (value != null && value is List<ChatUIKitProfile>) {
        List<String> userIds = [];
        for (var item in value) {
          userIds.add(item.id);
        }
        ChatUIKit.instance.deleteGroupMembers(
          groupId: widget.profile.id,
          members: userIds,
        );

        for (var userId in userIds) {
          controller.list.removeWhere((element) {
            return (element is ContactItemModel &&
                element.profile.id == userId);
          });
        }
        controller.refresh();
      }
    }).catchError((e) {});
  }

  void onSearchTap(List<ContactItemModel> data) async {
    List<NeedSearch> list = [];
    for (var item in data) {
      list.add(item);
    }

    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.searchGroupMembersView,
      SearchGroupMembersViewArguments(
        attributes: widget.attributes,
        itemBuilder: (context, profile, searchKeyword) {
          return InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              onMemberTap(context, profile);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 19.5, right: 15.5),
              child: ChatUIKitSearchListViewItem(
                profile: profile,
                highlightWord: searchKeyword,
              ),
            ),
          );
        },
        searchHideText: ChatUIKitLocal.groupMembersSearch.localString(context),
        searchData: list,
      ),
    );
  }
}
