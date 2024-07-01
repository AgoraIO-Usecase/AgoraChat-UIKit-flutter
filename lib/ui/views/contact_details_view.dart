import '../../chat_uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactDetailsView extends StatefulWidget {
  ContactDetailsView.arguments(ContactDetailsViewArguments arguments,
      {super.key})
      : profile = arguments.profile,
        onMessageDidClear = arguments.onMessageDidClear,
        appBarModel = arguments.appBarModel,
        contentActionsBuilder = arguments.actionsBuilder,
        detailsListViewItemsBuilder = arguments.detailsListViewItemsBuilder,
        moreActionsBuilder = arguments.moreActionsBuilder,
        viewObserver = arguments.viewObserver,
        enableAppBar = arguments.enableAppBar,
        onContactDeleted = arguments.onContactDeleted,
        attributes = arguments.attributes;

  const ContactDetailsView({
    required this.profile,
    this.contentActionsBuilder,
    this.onMessageDidClear,
    this.appBarModel,
    this.attributes,
    this.viewObserver,
    this.onContactDeleted,
    this.detailsListViewItemsBuilder,
    this.moreActionsBuilder,
    this.enableAppBar = true,
    super.key,
  });

  final ChatUIKitProfile profile;
  final ChatUIKitDetailContentActionsBuilder? contentActionsBuilder;
  final VoidCallback? onMessageDidClear;
  final VoidCallback? onContactDeleted;
  final ChatUIKitAppBarModel? appBarModel;
  final String? attributes;
  final ChatUIKitDetailItemBuilder? detailsListViewItemsBuilder;
  final ChatUIKitViewObserver? viewObserver;

  /// 更多操作构建器，用于构建更多操作的菜单，如果不设置将会使用默认的菜单。
  final ChatUIKitMoreActionsBuilder<bool>? moreActionsBuilder;

  final bool enableAppBar;

  @override
  State<ContactDetailsView> createState() => _ContactDetailsViewState();
}

class _ContactDetailsViewState extends State<ContactDetailsView>
    with ChatUIKitProviderObserver {
  ValueNotifier<bool> isNotDisturb = ValueNotifier<bool>(false);
  ChatUIKitProfile? profile;

  ChatUIKitAppBarModel? appBarModel;

  @override
  void initState() {
    super.initState();
    widget.viewObserver?.addListener(() {
      setState(() {});
    });
    profile = widget.profile;

    ChatUIKitProvider.instance.addObserver(this);
    isNotDisturb.value =
        ChatUIKitContext.instance.conversationIsMute(profile!.id);
    fetchInfo();
  }

  void fetchInfo() async {
    Conversation conversation = await ChatUIKit.instance.createConversation(
        conversationId: profile!.id, type: ConversationType.Chat);
    Map<String, ChatSilentModeResult> map = await ChatUIKit.instance
        .fetchSilentModel(conversations: [conversation]);
    isNotDisturb.value = map.values.first.remindType != ChatPushRemindType.ALL;
  }

  @override
  void dispose() {
    widget.viewObserver?.dispose();
    ChatUIKitProvider.instance.removeObserver(this);
    isNotDisturb.dispose();
    super.dispose();
  }

  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  @override
  void onProfilesUpdate(
    Map<String, ChatUIKitProfile> map,
  ) {
    if (map.keys.contains(profile?.id)) {
      safeSetState(() {
        profile = map[profile!.id];
      });
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
      centerTitle: widget.appBarModel?.centerTitle ?? true,
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

    Widget easeId = Text(
      'ID: ${profile!.id}',
      overflow: TextOverflow.ellipsis,
      textScaler: TextScaler.noScaling,
      maxLines: 1,
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
            ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.userIdCopied);
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

    List<ChatUIKitDetailContentAction> defaultActions = [
      ChatUIKitDetailContentAction(
        title: ChatUIKitLocal.contactDetailViewSend.localString(context),
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
        widget.contentActionsBuilder?.call(context, defaultActions) ??
            defaultActions;
    assert(actions.length <= 5, 'The maximum number of actions is 5');

    Widget content = Column(
      children: [
        const SizedBox(height: 20),
        avatar,
        const SizedBox(height: 12),
        name,
        const SizedBox(height: 4),
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

    models.add(
      ChatUIKitDetailsListViewItemModel(
        title:
            ChatUIKitLocal.contactDetailViewDoNotDisturb.localString(context),
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
                      type: ConversationType.Chat,
                      param: ChatSilentModeParam.remindType(
                          ChatPushRemindType.MENTION_ONLY));
                } else {
                  await ChatUIKit.instance.clearSilentMode(
                      conversationId: profile!.id, type: ConversationType.Chat);
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

    models.add(ChatUIKitDetailsListViewItemModel(
      title:
          ChatUIKitLocal.contactDetailViewClearChatHistory.localString(context),
      onTap: clearAllHistory,
    ));

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
      title: ChatUIKitLocal.contactDetailViewClearChatHistoryAlertTitle
          .localString(context),
      content: ChatUIKitLocal.contactDetailViewClearChatHistoryAlertSubTitle
          .localString(context),
      context: context,
      items: [
        ChatUIKitDialogItem.cancel(
          label: ChatUIKitLocal
              .contactDetailViewClearChatHistoryAlertButtonCancel
              .localString(context),
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.confirm(
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
        conversationId: widget.profile.id,
      );
      widget.onMessageDidClear?.call();
    }
  }

  void showBottom() async {
    List<ChatUIKitBottomSheetAction<bool>>? list = [
      ChatUIKitBottomSheetAction.destructive(
        actionType: ChatUIKitActionType.delete,
        label: ChatUIKitLocal.contactDetailViewDelete.localString(context),
        onTap: () async {
          Navigator.of(context).pop(true);
          return true;
        },
      ),
    ];

    list = widget.moreActionsBuilder?.call(context, list) ?? list;

    bool? ret = await showChatUIKitBottomSheet(
      cancelLabel:
          ChatUIKitLocal.conversationsViewMenuCancel.localString(context),
      context: context,
      items: list,
    );

    if (ret == true) {
      deleteContact();
    }
  }

  Widget statusAvatar() {
    return ChatUIKitAvatar(
      avatarUrl: profile!.avatarUrl,
      size: 100,
    );
  }

  void deleteContact() async {
    final ret = await showChatUIKitDialog(
      title:
          ChatUIKitLocal.contactDetailViewDeleteAlertTitle.localString(context),
      content: ChatUIKitLocal.contactDetailViewDeleteAlertSubTitle
          .localString(context),
      context: context,
      items: [
        ChatUIKitDialogItem.cancel(
          label: ChatUIKitLocal.contactDetailViewDeleteAlertButtonCancel
              .localString(context),
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.confirm(
          label: ChatUIKitLocal.contactDetailViewDeleteAlertButtonConfirm
              .localString(context),
          onTap: () async {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
    if (ret == true) {
      ChatUIKit.instance.deleteContact(userId: profile!.id).then((value) {
        widget.onContactDeleted?.call();
        ChatUIKit.instance.deleteLocalConversation(conversationId: profile!.id);
        ChatUIKitRoute.pop(context);
      }).catchError((e) {});
    }
  }
}
