import '../../chat_uikit.dart';
import '../../universal/inner_headers.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroupDetailsView extends StatefulWidget {
  GroupDetailsView.arguments(
    GroupDetailsViewArguments arguments, {
    super.key,
  })  : profile = arguments.profile,
        appBarModel = arguments.appBarModel,
        enableAppBar = arguments.enableAppBar,
        contentActionsBuilder = arguments.actionsBuilder,
        onMessageDidClear = arguments.onMessageDidClear,
        viewObserver = arguments.viewObserver,
        detailsListViewItemsBuilder = arguments.detailsListViewItemsBuilder,
        rightTopMoreActionsBuilder = arguments.moreActionsBuilder,
        attributes = arguments.attributes;

  const GroupDetailsView({
    required this.profile,
    this.contentActionsBuilder,
    this.appBarModel,
    this.enableAppBar = true,
    this.attributes,
    this.onMessageDidClear,
    this.detailsListViewItemsBuilder,
    this.rightTopMoreActionsBuilder,
    this.viewObserver,
    super.key,
  });
  final ChatUIKitDetailContentActionsBuilder? contentActionsBuilder;
  final ChatUIKitProfile profile;
  final ChatUIKitAppBarModel? appBarModel;
  final bool enableAppBar;
  final String? attributes;
  final VoidCallback? onMessageDidClear;
  final ChatUIKitDetailItemBuilder? detailsListViewItemsBuilder;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;

  /// 更多操作构建器，用于构建更多操作的菜单，如果不设置将会使用默认的菜单。
  final ChatUIKitMoreActionsBuilder? rightTopMoreActionsBuilder;

  @override
  State<GroupDetailsView> createState() => _GroupDetailsViewState();
}

class _GroupDetailsViewState extends State<GroupDetailsView>
    with GroupObserver, MultiObserver, ChatUIKitProviderObserver {
  ValueNotifier<bool> isNotDisturb = ValueNotifier<bool>(false);
  int memberCount = 0;
  Group? group;
  ChatUIKitProfile? profile;
  ChatUIKitAppBarModel? appBarModel;

  @override
  void initState() {
    super.initState();

    ChatUIKit.instance.addObserver(this);
    ChatUIKitProvider.instance.addObserver(this);
    widget.viewObserver?.addListener(() {
      setState(() {});
    });

    profile = widget.profile;
    fetchGroupInfos();
  }

  void fetchGroupInfos() {
    isNotDisturb.value =
        ChatUIKitContext.instance.conversationIsMute(profile!.id);
    fetchGroup();
  }

  @override
  void dispose() {
    widget.viewObserver?.dispose();
    ChatUIKit.instance.removeObserver(this);
    ChatUIKitProvider.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onProfilesUpdate(Map<String, ChatUIKitProfile> map) {
    if (map.keys.contains(profile!.id)) {
      profile = map[profile!.id];
      safeSetState(() {});
    }
  }

  @override
  void onMemberJoinedFromGroup(String groupId, String member) {
    if (groupId == profile!.id) {
      memberCount += 1;
    }
  }

  @override
  void onMemberExitedFromGroup(String groupId, String member) {
    if (groupId == profile!.id) {
      memberCount -= 1;
    }
  }

  @override
  void onOwnerChangedFromGroup(
      String groupId, String newOwner, String oldOwner) {
    if (groupId == profile!.id) {
      fetchGroup();
    }
  }

  @override
  void onSpecificationDidUpdate(Group group) {
    if (group.groupId == profile!.id) {
      fetchGroup();
    }
  }

  @override
  void onGroupEvent(
      MultiDevicesEvent event, String groupId, List<String>? userIds) {
    if (groupId == profile!.id) {
      if (event == MultiDevicesEvent.GROUP_LEAVE) {
        ChatUIKitRoute.popToGroupsView(
          context,
          model: ChatUIKitRouteBackModel.remove(profile!.id),
        );
      }

      if (event == MultiDevicesEvent.GROUP_DESTROY) {
        ChatUIKitRoute.popToGroupsView(
          context,
          model: ChatUIKitRouteBackModel.remove(profile!.id),
        );
      }

      if (event == MultiDevicesEvent.GROUP_ASSIGN_OWNER) {
        fetchGroup();
      }
    }
  }

  void fetchGroup() async {
    try {
      // 本地不准，暂时不使用本地数据。
      // group = await ChatUIKit.instance.getGroup(groupId: profile!.id);
      group = await ChatUIKit.instance.fetchGroupInfo(groupId: profile!.id);
      memberCount = group?.memberCount ?? 0;
      safeSetState(() {});
    } on ChatError catch (e) {
      chatPrint(e.toString());
    }
  }

  void fetchSilentInfo() async {
    try {
      Conversation conversation = await ChatUIKit.instance.createConversation(
          conversationId: profile!.id, type: ConversationType.GroupChat);
      Map<String, ChatSilentModeResult> map = await ChatUIKit.instance
          .fetchSilentModel(conversations: [conversation]);
      isNotDisturb.value =
          map.values.first.remindType != ChatPushRemindType.ALL;
    } on ChatError catch (e) {
      chatPrint(e.toString());
    }
  }

  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  void updateAppBarModel(ChatUIKitTheme theme) {
    appBarModel = ChatUIKitAppBarModel(
      title: widget.appBarModel?.title,
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
                actionType: ChatUIKitActionType.more,
                onTap: (context) {
                  showBottom();
                },
                child: Icon(
                  Icons.more_vert,
                  size: 24,
                  color: theme.color.isDark
                      ? theme.color.neutralColor95
                      : theme.color.neutralColor3,
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
        appBar:
            widget.enableAppBar ? ChatUIKitAppBar.model(appBarModel!) : null,
        body: _buildContent());

    return content;
  }

  Widget _buildContent() {
    final theme = ChatUIKitTheme.of(context);
    Widget avatar = statusAvatar();

    Widget name = Text(
      profile!.showName,
      overflow: TextOverflow.ellipsis,
      textScaler: TextScaler.noScaling,
      maxLines: 1,
      style: TextStyle(
        fontSize: theme.font.headlineLarge.fontSize,
        fontWeight: theme.font.headlineLarge.fontWeight,
        color: theme.color.isDark
            ? theme.color.neutralColor100
            : theme.color.neutralColor1,
      ),
    );

    Widget desc = group?.description?.isNotEmpty == true
        ? Text(
            group?.description ?? '',
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            textScaler: TextScaler.noScaling,
            maxLines: 3,
            style: TextStyle(
              fontSize: theme.font.bodySmall.fontSize,
              fontWeight: theme.font.bodySmall.fontWeight,
              color: theme.color.isDark
                  ? theme.color.neutralColor95
                  : theme.color.neutralColor3,
            ),
          )
        : const SizedBox();

    Widget easeId = Text(
      'ID: ${profile!.id}',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      textScaler: TextScaler.noScaling,
      style: TextStyle(
        fontSize: theme.font.bodySmall.fontSize,
        fontWeight: theme.font.bodySmall.fontWeight,
        color: theme.color.isDark
            ? theme.color.neutralColor5
            : theme.color.neutralColor7,
      ),
    );

    Widget row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        easeId,
        const SizedBox(width: 2),
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            Clipboard.setData(ClipboardData(text: profile!.id));
            ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.groupIdCopied);
          },
          child: Icon(
            Icons.file_copy_sharp,
            size: 16,
            color: theme.color.isDark
                ? theme.color.neutralColor5
                : theme.color.neutralColor7,
          ),
        ),
      ],
    );

    List<Widget> items = [];

    List<ChatUIKitDetailContentAction> defaultList = [
      ChatUIKitDetailContentAction(
        title: ChatUIKitLocal.groupDetailViewSend.localString(context),
        icon: 'assets/images/chat.png',
        iconSize: const Size(32, 32),
        packageName: ChatUIKitImageLoader.packageName,
        onTap: (context) {
          ChatUIKitRoute.pushOrPushNamed(
            context,
            ChatUIKitRouteNames.messagesView,
            MessagesViewArguments(
              profile: widget.profile,
              attributes: widget.attributes,
            ),
          );
        },
      ),
      ChatUIKitDetailContentAction(
        title: ChatUIKitLocal.contactDetailViewSearch.localString(context),
        icon: 'assets/images/search_history.png',
        packageName: ChatUIKitImageLoader.packageName,
        iconSize: const Size(32, 32),
        onTap: (context) {
          ChatUIKitRoute.pushOrPushNamed(
            context,
            ChatUIKitRouteNames.searchHistoryView,
            SearchHistoryViewArguments(
              profile: widget.profile,
              attributes: widget.attributes,
            ),
          ).then((value) {
            if (value != null && value is Message) {
              ChatUIKitRoute.pushOrPushNamed(
                context,
                ChatUIKitRouteNames.messagesView,
                MessagesViewArguments(
                  profile: widget.profile,
                  attributes: widget.attributes,
                  controller: MessagesViewController(
                    profile: widget.profile,
                    searchedMsg: value,
                  ),
                ),
              );
            }
          });
        },
      ),
    ];

    List<ChatUIKitDetailContentAction> actions =
        widget.contentActionsBuilder?.call(context, defaultList) ?? defaultList;
    assert(actions.length <= 5, 'The maximum number of actions is 5');

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        avatar,
        const SizedBox(height: 12),
        name,
        const SizedBox(height: 4),
        if (group?.description?.isNotEmpty == true) desc,
        if (group?.description?.isNotEmpty == true) const SizedBox(height: 4),
        row,
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: LayoutBuilder(builder: (context, constraints) {
            double maxWidth = () {
              if (actions.length > 2) {
                return (constraints.maxWidth - 24 - actions.length * 8) /
                    actions.length;
              } else {
                return 114.0;
              }
            }();
            for (var action in actions) {
              items.add(
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () => action.onTap?.call(context),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: theme.color.isDark
                          ? theme.color.neutralColor3
                          : theme.color.neutralColor95,
                    ),
                    constraints: BoxConstraints(minWidth: maxWidth),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: action.iconSize?.width ?? 24,
                          height: action.iconSize?.height ?? 24,
                          child: Image.asset(
                            action.icon,
                            color: theme.color.isDark
                                ? theme.color.primaryColor6
                                : theme.color.primaryColor5,
                            package: action.packageName,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          action.title ?? '',
                          textScaler: TextScaler.noScaling,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: theme.font.bodySmall.fontSize,
                            fontWeight: theme.font.bodySmall.fontWeight,
                            color: theme.color.isDark
                                ? theme.color.primaryColor6
                                : theme.color.primaryColor5,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: items,
            );
          }),
        ),
        const SizedBox(height: 20),
      ],
    );

    List<ChatUIKitDetailsListViewItemModel> models = [];

    models.add(ChatUIKitDetailsListViewItemModel(
      title: ChatUIKitLocal.groupDetailViewMember.localString(context),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            () {
              if (memberCount == 0) {
                return const SizedBox();
              } else {
                return Text(
                  '$memberCount',
                  textScaler: TextScaler.noScaling,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.color.isDark
                        ? theme.color.neutralColor6
                        : theme.color.neutralColor5,
                    fontSize: theme.font.labelLarge.fontSize,
                    fontWeight: theme.font.labelLarge.fontWeight,
                  ),
                );
              }
            }(),
            Icon(
              Icons.arrow_forward_ios,
              color: theme.color.isDark
                  ? theme.color.neutralColor5
                  : theme.color.neutralColor7,
              size: 18,
            )
          ],
        ),
      ),
      onTap: () {
        ChatUIKitRoute.pushOrPushNamed(
          context,
          ChatUIKitRouteNames.groupMembersView,
          GroupMembersViewArguments(
            profile: widget.profile,
            attributes: widget.attributes,
          ),
        );
      },
    ));

    models.add(
      ChatUIKitDetailsListViewItemModel(
        title: ChatUIKitLocal.groupDetailViewDoNotDisturb.localString(context),
        trailing: ValueListenableBuilder(
          valueListenable: isNotDisturb,
          builder: (context, value, child) {
            return CupertinoSwitch(
              value: isNotDisturb.value,
              activeColor: theme.color.isDark
                  ? theme.color.primaryColor6
                  : theme.color.primaryColor5,
              trackColor: theme.color.isDark
                  ? theme.color.neutralColor3
                  : theme.color.neutralColor9,
              onChanged: (value) async {
                if (value == true) {
                  await ChatUIKit.instance.setSilentMode(
                      conversationId: profile!.id,
                      type: ConversationType.GroupChat,
                      param: ChatSilentModeParam.remindType(
                          ChatPushRemindType.MENTION_ONLY));
                } else {
                  await ChatUIKit.instance.clearSilentMode(
                      conversationId: profile!.id,
                      type: ConversationType.GroupChat);
                }
                safeSetState(() {
                  isNotDisturb.value = value;
                });
              },
            );
          },
        ),
      ),
    );

    models.add(
      ChatUIKitDetailsListViewItemModel(
        title:
            ChatUIKitLocal.groupDetailViewClearChatHistory.localString(context),
        onTap: clearAllHistory,
      ),
    );

    if (group?.permissionType == GroupPermissionType.Owner) {
      models.add(ChatUIKitDetailsListViewItemModel.space());
      models.add(
        ChatUIKitDetailsListViewItemModel(
          title: ChatUIKitLocal.groupDetailViewGroupName.localString(context),
          onTap: changeGroupName,
          trailing: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  group?.name ?? "",
                  overflow: TextOverflow.ellipsis,
                  textScaler: TextScaler.noScaling,
                  maxLines: 1,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: theme.color.isDark
                        ? theme.color.neutralColor6
                        : theme.color.neutralColor5,
                    fontSize: theme.font.labelLarge.fontSize,
                    fontWeight: theme.font.labelLarge.fontWeight,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                Icons.arrow_forward_ios,
                color: theme.color.isDark
                    ? theme.color.neutralColor5
                    : theme.color.neutralColor7,
                size: 18,
              )
            ],
          ),
        ),
      );
      models.add(
        ChatUIKitDetailsListViewItemModel(
          title: ChatUIKitLocal.groupDetailViewDescription.localString(context),
          onTap: changeGroupDesc,
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  group?.description ?? "",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    color: theme.color.isDark
                        ? theme.color.neutralColor6
                        : theme.color.neutralColor5,
                    fontSize: theme.font.labelLarge.fontSize,
                    fontWeight: theme.font.labelLarge.fontWeight,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                Icons.arrow_forward_ios,
                color: theme.color.isDark
                    ? theme.color.neutralColor5
                    : theme.color.neutralColor7,
                size: 18,
              )
            ],
          ),
        ),
      );
    }

    models =
        widget.detailsListViewItemsBuilder?.call(context, profile, models) ??
            models;

    List<Widget> list = models.map((e) {
      if (e.type == ChatUIKitDetailsListViewItemModelType.normal) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: () {
            if (e.onTap != null) {
              return InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: e.onTap,
                child: ChatUIKitDetailsListViewItem(
                  title: e.title!,
                  trailing: e.trailing,
                ),
              );
            } else {
              return ChatUIKitDetailsListViewItem(
                title: e.title!,
                trailing: e.trailing,
              );
            }
          }(),
        );
      } else {
        return Container(
          height: 20,
          color: theme.color.isDark
              ? theme.color.neutralColor3
              : theme.color.neutralColor95,
        );
      }
    }).toList();

    content = ListView(
      children: [
        content,
        ...list,
      ],
    );

    return content;
  }

  void clearAllHistory() async {
    final ret = await showChatUIKitDialog(
      title:
          ChatUIKitLocal.groupDetailViewClearChatHistory.localString(context),
      context: context,
      actionItems: [
        ChatUIKitDialogAction.cancel(
          label: ChatUIKitLocal.groupDetailViewClearChatHistoryAlertButtonCancel
              .localString(context),
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogAction.confirm(
          label: ChatUIKitLocal
              .contactDetailViewClearChatHistoryAlertButtonConfirm
              .localString(context),
          onTap: () async {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
    if (ret == true) {
      await ChatUIKit.instance.deleteLocalConversation(
        conversationId: profile!.id,
      );

      widget.onMessageDidClear?.call();
    }
  }

  void showBottom() async {
    List<ChatUIKitBottomSheetAction> list = [];
    if (group?.permissionType == GroupPermissionType.Owner) {
      list.add(
        ChatUIKitBottomSheetAction.normal(
          actionType: ChatUIKitActionType.transferOwner,
          label:
              ChatUIKitLocal.groupDetailViewTransferGroup.localString(context),
          onTap: () async {
            Navigator.of(context).pop();
            changeOwner();
          },
        ),
      );
      list.add(
        ChatUIKitBottomSheetAction.destructive(
          actionType: ChatUIKitActionType.disbandGroup,
          label:
              ChatUIKitLocal.groupDetailViewDisbandGroup.localString(context),
          onTap: () async {
            Navigator.of(context).pop();
            destroyGroup();
          },
        ),
      );
    } else {
      list.add(
        ChatUIKitBottomSheetAction.destructive(
          actionType: ChatUIKitActionType.leave,
          label: ChatUIKitLocal.groupDetailViewLeaveGroup.localString(context),
          onTap: () async {
            Navigator.of(context).pop();
            leaveGroup();
          },
        ),
      );
    }

    list = widget.rightTopMoreActionsBuilder?.call(context, list) ?? list;

    showChatUIKitBottomSheet(
      cancelLabel: ChatUIKitLocal.groupDetailViewCancel.localString(context),
      context: context,
      items: list,
    );
  }

  Widget statusAvatar() {
    // 暂时不需要订阅
    return ChatUIKitAvatar(
      avatarUrl: profile!.avatarUrl,
      size: 100,
    );
  }

  void destroyGroup() async {
    final ret = await showChatUIKitDialog(
      title:
          ChatUIKitLocal.groupDetailViewDisbandAlertTitle.localString(context),
      content: ChatUIKitLocal.groupDetailViewDisbandAlertSubTitle
          .localString(context),
      context: context,
      actionItems: [
        ChatUIKitDialogAction.cancel(
          label: ChatUIKitLocal.groupDetailViewDisbandAlertButtonCancel
              .localString(context),
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogAction.confirm(
          label: ChatUIKitLocal.groupDetailViewDisbandAlertButtonConfirm
              .localString(context),
          onTap: () async {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
    if (ret == true) {
      ChatUIKit.instance.destroyGroup(groupId: profile!.id).then((value) {
        ChatUIKitRoute.popToGroupsView(
          context,
          model: ChatUIKitRouteBackModel.remove(profile!.id),
        );
      }).catchError((e) {});
    }
  }

  void leaveGroup() async {
    final ret = await showChatUIKitDialog(
      title: ChatUIKitLocal.groupDetailViewLeaveAlertTitle.localString(context),
      content:
          ChatUIKitLocal.groupDetailViewLeaveAlertSubTitle.localString(context),
      context: context,
      actionItems: [
        ChatUIKitDialogAction.cancel(
          label: ChatUIKitLocal.groupDetailViewLeaveAlertButtonCancel
              .localString(context),
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogAction.confirm(
          label: ChatUIKitLocal.groupDetailViewLeaveAlertButtonConfirm
              .localString(context),
          onTap: () async {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
    if (ret == true) {
      ChatUIKit.instance.leaveGroup(groupId: profile!.id).then((value) {
        ChatUIKitRoute.popToGroupsView(
          context,
          model: ChatUIKitRouteBackModel.remove(profile!.id),
        );
      }).catchError((e) {});
    }
  }

  void changeOwner() async {
    final ret = await ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.groupChangeOwnerView,
      GroupChangeOwnerViewArguments(
        groupId: profile!.id,
        attributes: widget.attributes,
      ),
    );

    if (ret == true) {
      fetchGroup();
    }
  }

  void changeGroupName() {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.changeInfoView,
      ChangeInfoViewArguments(
        appBarModel: ChatUIKitAppBarModel(
          title: ChatUIKitLocal.groupDetailViewGroupName.localString(context),
        ),
        maxLength: 32,
        attributes: widget.attributes,
        inputTextCallback: () async {
          if (group?.groupId != null) {
            return group!.name ?? '';
          }
          return null;
        },
      ),
    ).then((value) {
      if (value is String) {
        ChatUIKit.instance
            .changeGroupName(groupId: group!.groupId, name: value)
            .then((_) {
          fetchGroup();
        }).catchError((e) {});
      }
    });
  }

  void changeGroupDesc() {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.changeInfoView,
      ChangeInfoViewArguments(
        appBarModel: ChatUIKitAppBarModel(
          title: ChatUIKitLocal.groupDetailViewDescription.localString(context),
        ),
        maxLength: 256,
        attributes: widget.attributes,
        inputTextCallback: () async {
          if (group?.groupId != null) {
            return group!.description ?? '';
          }
          return null;
        },
      ),
    ).then((value) {
      if (value is String) {
        ChatUIKit.instance
            .changeGroupDescription(groupId: group!.groupId, desc: value)
            .then((_) {
          fetchGroup();
        }).catchError((e) {
          chatPrint(e.toString());
        });
      }
    });
  }
}
