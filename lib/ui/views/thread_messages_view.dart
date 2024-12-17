// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../chat_uikit.dart';
import '../../universal/inner_headers.dart';

class ThreadMessagesView extends StatefulWidget {
  ThreadMessagesView.arguments(
    ThreadMessagesViewArguments arguments, {
    super.key,
  })  : attributes = arguments.attributes,
        viewObserver = arguments.viewObserver,
        controller = arguments.controller,
        appBarModel = arguments.appBarModel,
        enableAppBar = arguments.enableAppBar,
        inputController = arguments.inputController,
        morePressActions = arguments.morePressActions,
        onMoreActionsItemsHandler = arguments.onMoreActionsItemsHandler,
        longPressActions = arguments.longPressActions,
        onItemLongPressHandler = arguments.onItemLongPressHandler,
        forceLeft = arguments.forceLeft,
        emojiWidget = arguments.emojiWidget,
        replyBarBuilder = arguments.replyBarBuilder,
        quoteBuilder = arguments.quoteBuilder,
        alertItemBuilder = arguments.alertItemBuilder,
        onErrorBtnTapHandler = arguments.onErrorBtnTapHandler,
        bubbleBuilder = arguments.bubbleBuilder,
        bubbleContentBuilder = arguments.bubbleContentBuilder,
        multiSelectBottomBar = arguments.multiSelectBottomBar,
        onReactionItemTap = arguments.onReactionItemTap,
        onReactionInfoTap = arguments.onReactionInfoTap,
        reactionItemsBuilder = arguments.reactionItemsBuilder,
        showMessageItemAvatar = arguments.showMessageItemAvatar,
        showMessageItemNickname = arguments.showMessageItemNickname,
        onItemTap = arguments.onItemTap,
        onItemLongPress = arguments.onItemLongPress,
        onDoubleTap = arguments.onDoubleTap,
        onAvatarTap = arguments.onAvatarTap,
        onAvatarLongPress = arguments.onAvatarLongPress,
        onNicknameTap = arguments.onNicknameTap,
        inputBar = arguments.inputBar,
        itemBuilder = arguments.itemBuilder,
        rightTopMoreActionsBuilder = arguments.rightTopMoreActionsBuilder;

  const ThreadMessagesView({
    this.attributes,
    this.viewObserver,
    required this.controller,
    this.appBarModel,
    this.enableAppBar = true,
    this.inputController,
    this.morePressActions,
    this.onMoreActionsItemsHandler,
    this.longPressActions,
    this.onItemLongPressHandler,
    this.forceLeft,
    this.emojiWidget,
    this.replyBarBuilder,
    this.quoteBuilder,
    super.key,
    this.inputBar,
    this.showMessageItemAvatar,
    this.showMessageItemNickname,
    this.onItemTap,
    this.onItemLongPress,
    this.onDoubleTap,
    this.onAvatarTap,
    this.onAvatarLongPress,
    this.onNicknameTap,
    this.itemBuilder,
    this.alertItemBuilder,
    this.onErrorBtnTapHandler,
    this.bubbleBuilder,
    this.bubbleContentBuilder,
    this.multiSelectBottomBar,
    this.onReactionItemTap,
    this.onReactionInfoTap,
    this.reactionItemsBuilder,
    this.rightTopMoreActionsBuilder,
  });

  final ChatUIKitKeyboardPanelController? inputController;

  final ThreadMessagesViewController controller;

  final ChatUIKitAppBarModel? appBarModel;

  /// 是否显示AppBar, 默认为 `true`。 当为 `false` 时将不会显示AppBar。同时也会影响到是否显示标题。
  final bool enableAppBar;

  /// 自定义输入框, 如果设置后将会替换默认的输入框。详细参考 [ChatUIKitInputBar]。
  final Widget? inputBar;

  /// 是否显示头像, 默认为 `true`。 如果设置为 `false` 将不会显示头像。
  final MessageItemShowHandler? showMessageItemAvatar;

  /// 是否显示昵称, 默认为 `true`。如果设置为 `false` 将不会显示昵称。
  final MessageItemShowHandler? showMessageItemNickname;

  /// 消息点击事件, 如果设置后消息点击事件将直接回调，如果不处理可以返回 `false`。
  final MessageItemGlobalPositionTapHandler? onItemTap;

  /// 消息长按事件, 如果设置后消息长按事件将直接回调，返回 `true` 表示处理你需要处理，返回 `false` 则会执行默认的长按事件。
  final MessageItemGlobalPositionTapHandler? onItemLongPress;

  /// 消息双击事件,如果设置后消息双击事件将直接回调，如果不处理可以返回 `false`。
  final MessageItemGlobalPositionTapHandler? onDoubleTap;

  /// 头像点击事件，如果设置后头像点击事件将直接回调，如果不处理可以返回 `false`。
  final MessageItemTapHandler? onAvatarTap;

  /// 头像长按事件，如果设置后头像长按事件将直接回调，如果不处理可以返回 `false`。
  final MessageItemTapHandler? onAvatarLongPress;

  /// 昵称点击事件， 如果设置后昵称点击事件将直接回调，如果不处理可以返回 `false`。
  final MessageItemTapHandler? onNicknameTap;

  /// 消息 `item` 构建器, 如果设置后需要显示消息时会直接回调，如果不处理可以返回 `null`。
  final MessageItemBuilder? itemBuilder;

  /// 提示消息构建器， 如果设置后需要显示提示消息时会直接回调，如果不处理可以返回 `null`。
  final MessageItemBuilder? alertItemBuilder;

  /// 更多按钮点击事件列表，如果设置后将会替换默认的更多按钮点击事件列表。详细参考 [ChatUIKitEventAction]。
  final List<ChatUIKitEventAction>? morePressActions;

  /// 更多按钮点击事件， 如果设置后将会替换默认的更多按钮点击事件。详细参考 [ChatUIKitEventAction]。
  final MessagesViewMorePressHandler? onMoreActionsItemsHandler;

  /// 消息长按事件列表，如果设置后将会替换默认的消息长按事件列表。详细参考 [ChatUIKitEventAction]。
  final List<ChatUIKitEventAction>? longPressActions;

  /// 消息长按事件回调， 如果设置后将会替换默认的消息长按事件回调。当长按时会回调 [longPressActions] 中设置的事件，需要返回一个列表用于替换，如果不返回则不会显示长按。
  final MessagesViewItemLongPressPositionHandler? onItemLongPressHandler;

  /// 更多操作构建器，用于构建更多操作的菜单，如果不设置将会使用默认的菜单。
  final ChatUIKitMoreActionsBuilder? rightTopMoreActionsBuilder;

  /// 强制消息靠左，默认为 `false`， 设置后自己发的消息也会在左侧显示。
  final bool? forceLeft;

  /// 表情控件，如果设置后将会替换默认的表情控件。详细参考 [ChatUIKitEmojiPanel]。
  final Widget? emojiWidget;

  /// 回复消息输入控件构建器，如果设置后将会替换默认的回复消息输入控件构建器。详细参考 [ChatUIKitReplyBar]。
  final MessageItemBuilder? replyBarBuilder;

  /// 引用消息构建器，如果设置后将会替换默认的引用消息样式。
  final Widget Function(BuildContext context, QuoteModel model)? quoteBuilder;

  /// 错误消息点击事件，如果设置后将会替换默认的错误消息点击事件。如果不处理可以返回 `false`。默认行为为重新发送消息。
  final MessageItemTapHandler? onErrorBtnTapHandler;

  /// 气泡构建器，如果设置后将会替换默认的气泡构建器。详细参考 [MessageItemBubbleBuilder]。
  final MessageItemBubbleBuilder? bubbleBuilder;

  /// 气泡内容构建器，如果设置后将会替换默认的气泡内容构建器。详细参考 [MessageItemBuilder]。
  final MessageItemBuilder? bubbleContentBuilder;

  /// View 附加属性，设置后的内容将会带入到下一个页面。
  final String? attributes;

  /// 多选时显示的 bottom bar
  final Widget? multiSelectBottomBar;

  final MessageReactionItemTapHandler? onReactionItemTap;

  final MessageItemTapHandler? onReactionInfoTap;

  final MessageItemBuilder? reactionItemsBuilder;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;

  @override
  State<ThreadMessagesView> createState() => _ThreadMessagesViewState();
}

class _ThreadMessagesViewState extends State<ThreadMessagesView>
    with ThreadObserver, ChatUIKitProviderObserver, ChatUIKitThemeMixin {
  String? title;
  late ThreadMessagesViewController controller;
  late final ChatUIKitKeyboardPanelController inputController;
  bool showEmoji = false;
  bool showMoreBtn = true;

  bool messageEditCanSend = false;
  Message? editMessage;
  MessageModel? replyMessage;
  Message? _playingMessage;
  late final ImagePicker _picker;
  late final AudioPlayer _player;
  late final AutoScrollController _scrollController;
  ChatUIKitAppBarModel? appBarModel;
  ChatUIKitPopupMenuController? popupMenuController;
  final Duration _keyboardPanelSwitchDuration =
      const Duration(milliseconds: 150);

  ValueNotifier<ChatUIKitKeyboardPanelType> currentPanelType =
      ValueNotifier(ChatUIKitKeyboardPanelType.none);

  CustomTextEditingController? get editController {
    if (inputController.inputTextEditingController
        is CustomTextEditingController) {
      return inputController.inputTextEditingController
          as CustomTextEditingController;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  setup() {
    ChatUIKitProvider.instance.addObserver(this);
    ChatUIKit.instance.addObserver(this);
    controller = widget.controller;
    controller.addListener(() {
      setState(() {});
    });

    inputController = widget.inputController ??
        ChatUIKitKeyboardPanelController(
            inputTextEditingController: CustomTextEditingController());

    _scrollController = AutoScrollController();
    widget.viewObserver?.addListener(() {
      setState(() {});
    });

    _picker = ImagePicker();
    _player = AudioPlayer();

    if (ChatUIKitSettings.messageLongPressMenuStyle ==
        ChatUIKitMessageLongPressMenuStyle.popupMenu) {
      popupMenuController = ChatUIKitPopupMenuController();
    }
    loadThreadMessages();
    currentPanelType.addListener(() {
      popupMenuController?.hideMenu();
    });
  }

  void loadThreadMessages() {
    controller.fetchItemList();
  }

  @override
  void dispose() {
    ChatUIKitProvider.instance.removeObserver(this);
    ChatUIKit.instance.removeObserver(this);
    inputController.dispose();
    widget.viewObserver?.dispose();
    super.dispose();
  }

  @override
  void onProfilesUpdate(Map<String, ChatUIKitProfile> map) {
    controller.userMap.addAll(map);
    setState(() {});
  }

  void updateAppBarModel() {
    appBarModel = ChatUIKitAppBarModel(
      title: controller.title(appBarModel?.title),
      centerWidget: widget.appBarModel?.centerWidget,
      titleTextStyle: widget.appBarModel?.titleTextStyle,
      subtitle: widget.appBarModel?.subtitle,
      subTitleTextStyle: widget.appBarModel?.subTitleTextStyle,
      leadingActions: widget.appBarModel?.leadingActions ??
          widget.appBarModel?.leadingActionsBuilder?.call(context, null),
      trailingActions: () {
        List<ChatUIKitAppBarAction> actions = [
          ChatUIKitAppBarAction(
            actionType: ChatUIKitActionType.cancel,
            onTap: (context) {
              if (controller.isMultiSelectMode) {
                controller.disableMultiSelectMode();
              } else {
                showBottoms();
              }
            },
            child: controller.isMultiSelectMode
                ? Text(
                    ChatUIKitLocal.bottomSheetCancel.localString(context),
                    textScaler: TextScaler.noScaling,
                    style: TextStyle(
                      color: theme.color.isDark
                          ? theme.color.primaryColor6
                          : theme.color.primaryColor5,
                      fontWeight: theme.font.labelMedium.fontWeight,
                      fontSize: theme.font.labelMedium.fontSize,
                    ),
                  )
                : Icon(
                    Icons.more_vert,
                    color: theme.color.isDark
                        ? theme.color.neutralColor9
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
      bottomLine: widget.appBarModel?.bottomLine,
      bottomLineColor: widget.appBarModel?.bottomLineColor,
    );
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    updateAppBarModel();
    Widget content = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: widget.enableAppBar ? ChatUIKitAppBar.model(appBarModel!) : null,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  clearAllType();
                  inputController.switchPanel(
                    ChatUIKitKeyboardPanelType.none,
                    duration: _keyboardPanelSwitchDuration,
                  );
                },
                child: ThreadMessageListView(
                  scrollController: _scrollController,
                  header: originMsgWidget(),
                  controller: controller,
                  forceLeft: widget.forceLeft,
                  bubbleContentBuilder: widget.bubbleContentBuilder,
                  bubbleBuilder: widget.bubbleBuilder,
                  quoteBuilder: widget.quoteBuilder,
                  showAvatar: widget.showMessageItemAvatar,
                  showNickname: widget.showMessageItemNickname,
                  onItemTap: (ctx, msg, rect) {
                    stopVoice();
                    bool? ret = widget.onItemTap?.call(context, msg, rect);
                    if (ret != true) {
                      bubbleTab(msg, rect);
                    }
                    return ret;
                  },
                  onItemLongPress: (context, model, rect) {
                    bool? ret =
                        widget.onItemLongPress?.call(context, model, rect);
                    stopVoice();
                    if (ret != true) {
                      onItemLongPress(model, rect);
                    }
                    return ret;
                  },
                  onItemDoubleTap: (context, model, rect) {
                    bool? ret = widget.onDoubleTap?.call(context, model, rect);
                    stopVoice();
                    return ret;
                  },
                  onAvatarTap: (context, model) {
                    bool? ret = widget.onAvatarTap?.call(context, model);
                    stopVoice();
                    if (ret != true) {
                      avatarTap(model);
                    }
                    return ret;
                  },
                  onAvatarLongPressed: (context, model) {
                    bool? ret = widget.onAvatarLongPress?.call(context, model);
                    stopVoice();
                    if (ret != true) {}
                    return ret;
                  },
                  onNicknameTap: (context, msg) {
                    bool? ret = widget.onNicknameTap?.call(context, msg);
                    stopVoice();
                    if (ret != true) {}
                    return ret;
                  },
                  itemBuilder: widget.itemBuilder ?? itemBuilder,
                  alertItemBuilder: widget.alertItemBuilder ?? alertItem,
                  onErrorBtnTap: (model) {
                    bool ret =
                        widget.onErrorBtnTapHandler?.call(context, model) ??
                            false;
                    if (ret == false) {
                      controller.resendMessage(model.message);
                    }
                  },
                  onReactionItemTap: (model, reaction) {
                    bool? ret = widget.onReactionItemTap
                            ?.call(context, model, reaction) ??
                        false;
                    if (ret == false) {
                      controller.updateReaction(
                        model.message.msgId,
                        reaction.reaction,
                        !reaction.isAddedBySelf,
                      );
                    }
                  },
                  onReactionInfoTap: (context, model) {
                    bool ret =
                        widget.onReactionInfoTap?.call(context, model) ?? false;
                    if (ret == false) {
                      showReactionsInfo(context, model);
                    }

                    return ret;
                  },
                  reactionItemsBuilder: widget.reactionItemsBuilder,
                ),
              ),
            ),
            ...() {
              if (controller.isMultiSelectMode) {
                return [multiSelectBar()];
              } else {
                return [widget.inputBar ?? inputBar()];
              }
            }(),
          ],
        ),
      ),
    );

    content = Stack(
      children: [
        content,
        if (editMessage != null)
          // 背景色
          Positioned.fill(
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                editMessage = null;
                messageEditCanSend = false;
                setState(() {});
              },
              child: Opacity(
                opacity: 0.5,
                child: Container(color: Colors.black),
              ),
            ),
          ),
        if (editMessage != null)
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SafeArea(
                  child: ChatUIKitEditBar(
                    text: editMessage!.textContent,
                    onInputTextChanged: (text) {
                      controller.editMessage(editMessage!, text);
                      editMessage = null;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          )
      ],
    );

    content = ShareUserData(
      data: controller.userMap,
      child: content,
    );

    content = ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: content,
    );

    if (ChatUIKitSettings.messageLongPressMenuStyle ==
        ChatUIKitMessageLongPressMenuStyle.popupMenu) {
      content = ChatUIKitPopupMenu(
        controller: popupMenuController!,
        style: ChatUIKitPopupMenuStyle(
          backgroundColor: theme.color.isDark
              ? theme.color.neutralColor2
              : theme.color.neutralColor98,
          foregroundColor: theme.color.isDark
              ? theme.color.neutralColor9
              : theme.color.neutralColor1,
          dividerColor: theme.color.isDark
              ? theme.color.neutralColor3
              : theme.color.neutralColor9,
          radiusCircular: ChatUIKitSettings.messageBubbleStyle ==
                  ChatUIKitMessageListViewBubbleStyle.arrow
              ? 4
              : 16,
        ),
        child: content,
      );
    }

    content = PopScope(
      onPopInvoked: (didPop) {
        popupMenuController?.hideMenu();
      },
      child: content,
    );

    return content;
  }

  Widget? itemBuilder(BuildContext context, MessageModel model) {
    if (model.message.bodyType != MessageType.VOICE) return null;

    Widget content = ChatUIKitMessageListViewMessageItem(
      enableVoiceUnreadIcon: false,
      isPlaying: _playingMessage?.msgId == model.message.msgId,
      onErrorBtnTap: () {
        if (widget.onErrorBtnTapHandler == null) {
          controller.resendMessage(model.message);
        } else {
          widget.onErrorBtnTapHandler!.call(context, model);
        }
      },
      key: ValueKey(model.message.localTime),
      showAvatar: widget.showMessageItemAvatar,
      quoteBuilder: widget.quoteBuilder,
      showNickname: widget.showMessageItemNickname,
      onAvatarTap: () {
        if (widget.onAvatarTap == null) {
          avatarTap(model);
        } else {
          widget.onAvatarTap!.call(context, model);
        }
      },
      onAvatarLongPressed: () {
        widget.onAvatarLongPress?.call(context, model);
      },
      onBubbleDoubleTap: (rect) {
        widget.onDoubleTap?.call(context, model, rect);
      },
      onBubbleLongPressed: (rect) {
        bool? ret = widget.onItemLongPress?.call(context, model, rect);
        if (ret != true) {
          onItemLongPress(model, rect);
        }
      },
      onItemTap: () {
        if (controller.isMultiSelectMode) {
          if (controller.selectedMessages
              .map((e) => e.msgId)
              .toList()
              .contains(model.message.msgId)) {
            controller.selectedMessages
                .removeWhere((e) => model.message.msgId == e.msgId);
          } else {
            controller.selectedMessages.add(model.message);
          }
          setState(() {});
        }
      },
      onBubbleTap: (rect) {
        if (controller.isMultiSelectMode) {
          if (controller.selectedMessages
              .map((e) => e.msgId)
              .toList()
              .contains(model.message.msgId)) {
            controller.selectedMessages
                .removeWhere((e) => model.message.msgId == e.msgId);
          } else {
            controller.selectedMessages.add(model.message);
          }
          setState(() {});
        } else {
          bool? ret = widget.onItemTap?.call(context, model, rect);
          if (ret != true) {
            bubbleTab(model, rect);
          }
        }
      },
      onNicknameTap: () {
        widget.onNicknameTap?.call(context, model);
      },
      model: model,
    );

    double zoom = 0.8;
    if (MediaQuery.of(context).size.width >
        MediaQuery.of(context).size.height) {
      zoom = 0.5;
    }

    content = SizedBox(
      width: MediaQuery.of(context).size.width * zoom,
      child: content,
    );

    content = Align(
      alignment: model.message.direction == MessageDirection.SEND
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: content,
    );

    return content;
  }

  Widget originMsgWidget() {
    MessageModel? model = controller.model;
    if (model == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          ChatUIKitAvatar(
            avatarUrl: model.message.fromProfile.avatarUrl,
            size: 28,
            onTap: () {
              pushNextPage(model.message.fromProfile);
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        () {
                          ChatUIKitProfile? profile = ChatUIKitProvider.instance
                              .getProfileById(model.message.from!);
                          profile ??= model.message.fromProfile;
                          return profile.contactShowName;
                        }(),
                        style: TextStyle(
                          fontWeight: theme.font.titleSmall.fontWeight,
                          fontSize: theme.font.titleSmall.fontSize,
                          color: theme.color.isDark
                              ? theme.color.neutralSpecialColor6
                              : theme.color.neutralSpecialColor5,
                        ),
                        textScaler: TextScaler.noScaling,
                      ),
                      Text(
                        ChatUIKitTimeFormatter.instance.formatterHandler?.call(
                                context,
                                ChatUIKitTimeType.message,
                                model.message.serverTime) ??
                            ChatUIKitTimeTool.getChatTimeStr(
                              model.message.serverTime,
                              needTime: true,
                            ),
                        style: TextStyle(
                          fontWeight: theme.font.bodySmall.fontWeight,
                          fontSize: theme.font.bodySmall.fontSize,
                          color: theme.color.isDark
                              ? theme.color.neutralColor6
                              : theme.color.neutralColor5,
                        ),
                        textScaler: TextScaler.noScaling,
                      )
                    ],
                  ),
                  Row(children: [Expanded(child: subWidget(model))]),
                  const SizedBox(height: 8),
                  Divider(
                    height: 0.5,
                    thickness: 0.5,
                    color: theme.color.isDark
                        ? theme.color.neutralColor2
                        : theme.color.neutralColor98,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget subWidget(MessageModel model) {
    Widget? msgWidget;
    if (model.message.bodyType == MessageType.TXT) {
      msgWidget = ChatUIKitTextBubbleWidget(
        model: model,
        style: TextStyle(
          fontWeight: theme.font.bodyMedium.fontWeight,
          fontSize: theme.font.bodyMedium.fontSize,
          color: theme.color.isDark
              ? theme.color.neutralColor98
              : theme.color.neutralColor2,
        ),
      );
    } else if (model.message.bodyType == MessageType.IMAGE) {
      msgWidget = ChatUIKitImageBubbleWidget(model: model);
    } else if (model.message.bodyType == MessageType.VOICE) {
      msgWidget = ChatUIKitVoiceBubbleWidget(model: model, playing: false);
    } else if (model.message.bodyType == MessageType.VIDEO) {
      msgWidget = ChatUIKitVideoBubbleWidget(model: model);
    } else if (model.message.bodyType == MessageType.FILE) {
      msgWidget = ChatUIKitFileBubbleWidget(model: model);
    } else if (model.message.bodyType == MessageType.COMBINE) {
      msgWidget = ChatUIKitCombineBubbleWidget(model: model);
    } else if (model.message.bodyType == MessageType.CUSTOM) {
      if (model.message.isCardMessage) {
        msgWidget = Container(
          decoration: BoxDecoration(
            color: theme.color.isDark
                ? theme.color.primaryColor95
                : theme.color.primaryColor5,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: ChatUIKitCardBubbleWidget(model: model),
        );
      }
    }
    msgWidget ??= ChatUIKitNonsupportMessageWidget(model: model);
    return msgWidget;
  }

  void showBottoms() {
    List<ChatUIKitEventAction> items = [];
    if (controller.hasPermission) {
      items.add(
        ChatUIKitEventAction.normal(
          actionType: ChatUIKitActionType.edit,
          label: ChatUIKitLocal.threadsMessageEdit.localString(context),
          onTap: () async {
            if (controller.thread == null) return;
            Navigator.of(context).pop();
            ChatUIKitRoute.pushOrPushNamed(
              context,
              ChatUIKitRouteNames.changeInfoView,
              ChangeInfoViewArguments(
                appBarModel: ChatUIKitAppBarModel(
                    title: ChatUIKitLocal.threadEditName.localString(context)),
                hint: ChatUIKitLocal.threadNewName.localString(context),
                maxLength: 128,
                attributes: widget.attributes,
                inputTextCallback: () async {
                  return controller.thread!.threadName!;
                },
              ),
            ).then((value) {
              if (value is String) {
                controller.changeThreadName(value);
              }
            });
          },
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor2,
            fontSize: theme.font.labelLarge.fontSize,
            fontWeight: theme.font.labelLarge.fontWeight,
          ),
          icon: ChatUIKitImageLoader.messageEdit(
              color: theme.color.isDark
                  ? theme.color.neutralColor98
                  : theme.color.neutralColor2),
        ),
      );
    }
    items.add(
      ChatUIKitEventAction.normal(
        actionType: ChatUIKitActionType.members,
        label: ChatUIKitLocal.threadsMessageMembers.localString(context),
        onTap: () async {
          Navigator.of(context).pop();
          if (controller.thread == null) return;
          ChatUIKitRoute.pushOrPushNamed(
            context,
            ChatUIKitRouteNames.threadMembersView,
            ThreadMembersViewArguments(
              thread: controller.thread!,
              attributes: widget.attributes,
            ),
          );
        },
        style: TextStyle(
          color: theme.color.isDark
              ? theme.color.neutralColor98
              : theme.color.neutralColor1,
          fontSize: theme.font.labelLarge.fontSize,
          fontWeight: theme.font.labelLarge.fontWeight,
        ),
        icon: ChatUIKitImageLoader.contacts(
            color: theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor1),
      ),
    );
    items.add(
      ChatUIKitEventAction.destructive(
        actionType: ChatUIKitActionType.leave,
        label: ChatUIKitLocal.threadsMessageLeave.localString(context),
        onTap: () async {
          Navigator.of(context).pop();
          if (controller.thread == null) return;
          controller.leaveChatThread().then((value) {
            if (mounted) {
              Navigator.of(context).pop();
            }
          }).catchError((e) {
            chatPrint('leaveChatThread: $e');
          });
        },
        style: TextStyle(
          color: theme.color.isDark
              ? theme.color.neutralColor98
              : theme.color.neutralColor1,
          fontSize: theme.font.labelLarge.fontSize,
          fontWeight: theme.font.labelLarge.fontWeight,
        ),
        icon: ChatUIKitImageLoader.leaveThread(
          color: theme.color.isDark
              ? theme.color.errorColor6
              : theme.color.errorColor5,
        ),
      ),
    );
    if (controller.hasPermission) {
      items.add(
        ChatUIKitEventAction.destructive(
          actionType: ChatUIKitActionType.destroy,
          label: ChatUIKitLocal.threadsMessageDestroy.localString(context),
          onTap: () async {
            Navigator.of(context).pop();
            if (controller.thread == null) return;
            controller.destroyChatThread().catchError((e) {
              chatPrint('destroyChatThread: $e');
            });
          },
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.errorColor6
                : theme.color.errorColor5,
            fontSize: theme.font.labelLarge.fontSize,
            fontWeight: theme.font.labelLarge.fontWeight,
          ),
          icon: ChatUIKitImageLoader.voiceDelete(
            color: theme.color.isDark
                ? theme.color.errorColor6
                : theme.color.errorColor5,
          ),
        ),
      );
    }

    items = widget.rightTopMoreActionsBuilder?.call(context, items) ?? items;

    showChatUIKitBottomSheet(
      context: context,
      items: items,
    );
  }

  Widget replyMessageBar() {
    if (replyMessage == null) return const SizedBox();
    Widget content = widget.replyBarBuilder?.call(context, replyMessage!) ??
        ChatUIKitReplyBar(
          messageModel: replyMessage!,
          onCancelTap: () {
            replyMessage = null;
            setState(() {});
          },
        );

    return content;
  }

  Widget inputBar() {
    if (editMessage != null) {
      return const SafeArea(child: SizedBox(height: 54));
    }

    Widget? topWidget = replyMessage == null
        ? const SizedBox.shrink()
        : widget.replyBarBuilder?.call(context, replyMessage!) ??
            ChatUIKitReplyBar(
              messageModel: replyMessage!,
              onCancelTap: () {
                setState(() {
                  replyMessage = null;
                  popupMenuController?.hideMenu();
                });
              },
            );
    Widget content = ChatUIKitInputBar(
      keyboardPanelController: inputController,
      maintainBottomViewPadding: true,
      bottomPanels: bottomPanels(),
      leftItems: [voicePanel()],
      rightItems: [emojiPanel(), morePanel()],
      onPanelChanged: (panelType) {
        currentPanelType.value = panelType;
      },
    );

    content = Column(
      children: [
        topWidget,
        content,
      ],
    );

    return content;
  }

  void clearAllType() {
    bool needUpdate = false;

    popupMenuController?.hideMenu();

    if (_player.state == PlayerState.playing) {
      stopVoice();
      needUpdate = true;
    }

    if (needUpdate) {
      setState(() {});
    }
  }

  void textMessageEdit(Message message) {
    clearAllType();
    if (message.bodyType != MessageType.TXT) return;
    editMessage = message;
    inputController.switchPanel(
      ChatUIKitKeyboardPanelType.keyboard,
      duration: _keyboardPanelSwitchDuration,
    );
    setState(() {});
  }

  void replyMessaged(MessageModel model) {
    replyMessage = model;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      inputController.switchPanel(
        ChatUIKitKeyboardPanelType.keyboard,
        duration: _keyboardPanelSwitchDuration,
      );
    });
  }

  Future<bool> selectImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        controller.sendImageMessage(image.path, name: image.name);
        return true;
      }
    } catch (e) {
      ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.noStoragePermission);
    }
    return false;
  }

  Future<bool> selectVideo() async {
    try {
      XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        controller.sendVideoMessage(video.path, name: video.name);
        return true;
      }
    } catch (e) {
      ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.noStoragePermission);
    }
    return false;
  }

  Future<bool> selectCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        controller.sendImageMessage(photo.path, name: photo.name);
        return true;
      }
    } catch (e) {
      ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.noStoragePermission);
    }
    return false;
  }

  Future<bool> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.single;
      if (file.path?.isNotEmpty == true) {
        controller.sendFileMessage(
          file.path!,
          name: file.name,
          fileSize: file.size,
        );
        return true;
      }
    }
    return false;
  }

  void selectCard() async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.95,
          child: SelectContactView(
            appBarModel: ChatUIKitAppBarModel(
                title: ChatUIKitLocal.messagesViewSelectContactTitle
                    .localString(context)),
            onTap: (context, model) {
              showChatUIKitDialog(
                title: ChatUIKitLocal.messagesViewShareContactAlertTitle
                    .localString(context),
                content: ChatUIKitLocal.messagesViewShareContactAlertSubTitle
                    .localString(context),
                context: context,
                actionItems: [
                  ChatUIKitDialogAction.cancel(
                    label: ChatUIKitLocal
                        .messagesViewShareContactAlertButtonCancel
                        .localString(context),
                    onTap: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                  ChatUIKitDialogAction.confirm(
                    label: ChatUIKitLocal
                        .messagesViewShareContactAlertButtonConfirm
                        .localString(context),
                    onTap: () async {
                      Navigator.of(context).pop(model);
                    },
                  )
                ],
              ).then((value) {
                if (value != null) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                  if (value is ContactItemModel) {
                    controller.sendCardMessage(value.profile);
                  }
                }
              });
            },
          ),
        );
      },
    );
  }

  Widget multiSelectBar() {
    Widget content = widget.multiSelectBottomBar ??
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                forwardMessage(
                  controller.selectedMessages,
                  isMultiSelect: true,
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                child: ChatUIKitImageLoader.messageLongPressForward(
                  color: theme.color.isDark
                      ? theme.color.primaryColor6
                      : theme.color.primaryColor5,
                ),
              ),
            ),
          ],
        );
    return content;
  }

  Future<void> playVoiceMessage(Message message) async {
    if (_playingMessage?.msgId == message.msgId) {
      _playingMessage = null;
      await stopVoice();
    } else {
      await stopVoice();
      File file = File(message.localPath!);
      if (!file.existsSync()) {
        await controller.downloadMessage(message);
        ChatUIKit.instance
            .sendChatUIKitEvent(ChatUIKitEvent.messageDownloading);
      } else {
        try {
          await playVoice(message.localPath!);
          _playingMessage = message;
          // ignore: empty_catches
        } catch (e) {
          chatPrint('playVoice: $e');
        }
      }
    }
    setState(() {});
  }

  Future<void> previewVoice(bool play, {String? path}) async {
    if (play) {
      await playVoice(path!);
    } else {
      await stopVoice();
    }
  }

  Future<void> playVoice(String path) async {
    if (_player.state == PlayerState.playing) {
      await _player.stop();
    }

    await _player.play(DeviceFileSource(path));
    _player.onPlayerComplete.first.whenComplete(() async {
      _playingMessage = null;
      setState(() {});
    }).onError((error, stackTrace) {
      chatPrint('playVoice: $error');
    });
  }

  Future<void> stopVoice() async {
    if (_player.state == PlayerState.playing) {
      await _player.stop();
      _playingMessage = null;
      setState(() {});
    }
  }

  void reportMessage(MessageModel model) async {
    List<String> reasonKeys = ChatUIKitSettings.reportMessageTags;
    List<String> reasons =
        reasonKeys.map((e) => e.localString(context)).toList();

    final reportReason = await ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.reportMessageView,
      ReportMessageViewArguments(
        messageId: model.message.msgId,
        reportReasons: reasons,
        attributes: widget.attributes,
      ),
    );

    if (reportReason != null && reportReason is String) {
      int index = reasons.indexOf(reportReason);
      String tag = reasonKeys[index];
      controller.reportMessage(
        message: model.message,
        tag: tag,
        reason: reportReason,
      );
    }
  }

// 处理点击自己头像和点击自己名片
  void pushToCurrentUser(ChatUIKitProfile profile) async {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.currentUserInfoView,
      CurrentUserInfoViewArguments(
        profile: profile,
        attributes: widget.attributes,
      ),
    );
  }

// 处理好友信息
  void pushContactDetail(ChatUIKitProfile profile) {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.contactDetailsView,
      ContactDetailsViewArguments(
        profile: profile,
        attributes: widget.attributes,
        onContactDeleted: () {
          ChatUIKitRoute.pop(context);
        },
      ),
    ).then((value) {
      controller.refresh();
    });
  }

  // 处理名片信息非好友
  void pushRequestDetail(ChatUIKitProfile profile) {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.newRequestDetailsView,
      NewRequestDetailsViewArguments(
        profile: profile,
        attributes: widget.attributes,
      ),
    );
  }

  void onItemLongPress(MessageModel model, Rect rect) async {
    clearAllType();
    List<ChatUIKitEventAction>? items = widget.longPressActions;
    items ??= defaultItemLongPressed(model);

    if (widget.onItemLongPressHandler != null) {
      items = widget.onItemLongPressHandler!.call(
        context,
        model,
        rect,
        items,
      );
    }
    if (items != null) {
      if (ChatUIKitSettings.messageLongPressMenuStyle ==
          ChatUIKitMessageLongPressMenuStyle.popupMenu) {
        popupMenuController?.showMenu(
            bottomSheetReactionsTitle(model), rect, items);
      } else {
        showChatUIKitBottomSheet(
          titleWidget: bottomSheetReactionsTitle(model),
          context: context,
          items: items,
          showCancel: false,
        );
      }
    }
  }

  List<ChatUIKitEventAction> defaultItemLongPressed(MessageModel model) {
    void closeMenu() {
      if (ChatUIKitSettings.messageLongPressMenuStyle ==
          ChatUIKitMessageLongPressMenuStyle.bottomSheet) {
        Navigator.of(context).pop();
      }
    }

    List<ChatUIKitEventAction> items = [];
    for (var element in ChatUIKitSettings.msgItemLongPressActions) {
      // 复制
      if (model.message.bodyType == MessageType.TXT &&
          element == ChatUIKitActionType.copy) {
        items.add(ChatUIKitEventAction.normal(
          actionType: ChatUIKitActionType.copy,
          label: ChatUIKitLocal.messagesViewLongPressActionsTitleCopy
              .localString(context),
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          icon: ChatUIKitImageLoader.messageLongPressCopy(
            color: theme.color.isDark
                ? theme.color.neutralColor7
                : theme.color.neutralColor3,
          ),
          onTap: () async {
            closeMenu();
            Clipboard.setData(ClipboardData(text: model.message.textContent));
            ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.messageCopied);
          },
        ));
      }

      // 回复
      if (model.message.status == MessageStatus.SUCCESS &&
          element == ChatUIKitActionType.reply &&
          ChatUIKitSettings.enableMessageReply) {
        items.add(ChatUIKitEventAction.normal(
          actionType: ChatUIKitActionType.reply,
          icon: ChatUIKitImageLoader.messageLongPressReply(
            color: theme.color.isDark
                ? theme.color.neutralColor7
                : theme.color.neutralColor3,
          ),
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          label: ChatUIKitLocal.messagesViewLongPressActionsTitleReply
              .localString(context),
          onTap: () async {
            replyMessaged(model);
            closeMenu();
          },
        ));
      }
      // 转发
      if (model.message.status == MessageStatus.SUCCESS &&
          element == ChatUIKitActionType.forward &&
          ChatUIKitSettings.enableMessageForward) {
        items.add(ChatUIKitEventAction.normal(
          actionType: ChatUIKitActionType.forward,
          icon: ChatUIKitImageLoader.messageLongPressForward(
            color: theme.color.isDark
                ? theme.color.neutralColor7
                : theme.color.neutralColor3,
          ),
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          label: ChatUIKitLocal.forwardMessage.localString(context),
          onTap: () async {
            forwardMessage(
              [model.message],
              isMultiSelect: false,
            );
            closeMenu();
          },
        ));
      }

      // 多选
      if (model.message.status == MessageStatus.SUCCESS &&
          element == ChatUIKitActionType.multiSelect &&
          ChatUIKitSettings.enableMessageMultiSelect) {
        items.add(ChatUIKitEventAction.normal(
          actionType: ChatUIKitActionType.multiSelect,
          icon: ChatUIKitImageLoader.messageLongPressMultiSelected(
            color: theme.color.isDark
                ? theme.color.neutralColor7
                : theme.color.neutralColor3,
          ),
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          label:
              ChatUIKitLocal.messageListLongPressMenuMulti.localString(context),
          onTap: () async {
            controller.enableMultiSelectMode();
            closeMenu();
          },
        ));
      }

      // 翻译
      if (model.message.status == MessageStatus.SUCCESS &&
          model.message.bodyType == MessageType.TXT &&
          element == ChatUIKitActionType.translate &&
          ChatUIKitSettings.enableMessageTranslation) {
        items.add(ChatUIKitEventAction.normal(
          actionType: ChatUIKitActionType.translate,
          icon: ChatUIKitImageLoader.messageLongPressTranslate(
            color: theme.color.isDark
                ? theme.color.neutralColor7
                : theme.color.neutralColor3,
          ),
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          label: model.message.hasTranslate
              ? ChatUIKitLocal.messageListLongPressMenuTranslateOrigin
                  .localString(context)
              : ChatUIKitLocal.messageListLongPressMenuTranslate
                  .localString(context),
          onTap: () async {
            controller.translateMessage(
              model.message,
              showTranslate: !model.message.hasTranslate,
            );
            closeMenu();
          },
        ));
      }

      // 编辑
      if (model.message.status == MessageStatus.SUCCESS &&
          model.message.bodyType == MessageType.TXT &&
          model.message.direction == MessageDirection.SEND &&
          element == ChatUIKitActionType.edit &&
          ChatUIKitSettings.enableMessageEdit) {
        items.add(ChatUIKitEventAction.normal(
          actionType: ChatUIKitActionType.edit,
          label: ChatUIKitLocal.messagesViewLongPressActionsTitleEdit
              .localString(context),
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          icon: ChatUIKitImageLoader.messageLongPressEdit(
            color: theme.color.isDark
                ? theme.color.neutralColor7
                : theme.color.neutralColor3,
          ),
          onTap: () async {
            textMessageEdit(model.message);
            closeMenu();
          },
        ));
      }

      if (model.message.status == MessageStatus.SUCCESS &&
          element == ChatUIKitActionType.report &&
          ChatUIKitSettings.enableMessageReport) {
        // 举报
        items.add(ChatUIKitEventAction.normal(
          actionType: ChatUIKitActionType.report,
          label: ChatUIKitLocal.messagesViewLongPressActionsTitleReport
              .localString(context),
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          icon: ChatUIKitImageLoader.messageLongPressReport(
            color: theme.color.isDark
                ? theme.color.neutralColor7
                : theme.color.neutralColor3,
          ),
          onTap: () async {
            reportMessage(model);
            closeMenu();
          },
        ));
      }
    }

    return items;
  }

  void forwardMessage(List<Message> message, {bool isMultiSelect = false}) {
    clearAllType();
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.forwardMessageSelectView,
      ForwardMessageSelectViewArguments(
        messages: message,
        isMulti: isMultiSelect,
        attributes: widget.attributes,
      ),
    ).then((value) {
      if (value == true) {
        controller.disableMultiSelectMode();
      }
    });
  }

  Widget? bottomSheetReactionsTitle(MessageModel model) {
    if (ChatUIKitSettings.msgItemLongPressActions
                .contains(ChatUIKitActionType.reaction) ==
            false ||
        ChatUIKitSettings.enableMessageReaction == false) return null;

    void closeMenu() {
      if (ChatUIKitSettings.messageLongPressMenuStyle ==
          ChatUIKitMessageLongPressMenuStyle.bottomSheet) {
        Navigator.of(context).pop();
      }
    }

    List<MessageReaction>? reactions = model.reactions;
    return Padding(
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth - kMenuHorizontalPadding * 2;
          int maxCount = width ~/ (36 + 12) - 1;
          List<Widget> items = [];
          for (var i = 0;
              i < min(ChatUIKitSettings.favoriteReaction.length, maxCount);
              i++) {
            String emoji = ChatUIKitSettings.favoriteReaction[i];
            bool highlight = reactions?.any((element) {
                  return element.reaction == emoji && element.isAddedBySelf;
                }) ??
                false;

            items.add(
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  closeMenu();
                  onReactionTap(model, emoji, !highlight);
                  popupMenuController?.hideMenu();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: highlight
                        ? (theme.color.isDark
                            ? theme.color.primaryColor6
                            : theme.color.primaryColor5)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(3.6),
                  width: 36,
                  height: 36,
                  child: Image.asset(
                    ChatUIKitEmojiData.getEmojiImagePath(emoji)!,
                    package: ChatUIKitEmojiData.packageName,
                  ),
                ),
              ),
            );
          }

          items.add(
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                popupMenuController?.hideMenu();
                showAllReactionEmojis(model);
              },
              child: ChatUIKitImageLoader.moreReactions(width: 36, height: 36),
            ),
          );
          bool full = ChatUIKitSettings.favoriteReaction.length + 1 < maxCount;
          return Row(
            mainAxisAlignment:
                full ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
            children: full
                ? items
                    .map((e) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: e,
                        ))
                    .toList()
                : items.toList(),
          );
        },
      ),
    );
  }

  Future onReactionTap(MessageModel model, String emoji, bool isAdd) async {
    await controller.updateReaction(model.message.msgId, emoji, isAdd);
  }

  void showAllReactionEmojis(MessageModel model) {
    showChatUIKitBottomSheet(
      context: context,
      showCancel: false,
      body: ChatUIKitEmojiPanel(
        selectedEmojis: model.reactions
            ?.where((e) => e.isAddedBySelf == true)
            .map((e) => e.reaction)
            .toList(),
        selectedColor: theme.color.isDark
            ? theme.color.primaryColor6
            : theme.color.primaryColor5,
        emojiClicked: (emojiPath) async {
          var emoji = ChatUIKitEmojiData.getEmoji(emojiPath);
          bool needAdd = false;
          if (model.reactions == null) {
            needAdd = true;
          } else {
            needAdd = model.reactions?.indexWhere((element) =>
                    element.reaction == emoji && element.isAddedBySelf) ==
                -1;
          }

          Navigator.of(context).pop();
          await controller.updateReaction(model.message.msgId,
              ChatUIKitEmojiData.emojiMap[emojiPath]!, needAdd);
        },
      ),
    );
  }

  void showReactionsInfo(BuildContext context, MessageModel model) {
    showChatUIKitBottomSheet(
      context: context,
      showCancel: false,
      body: ChatUIKitMessageReactionInfo(model),
    );
  }

  void bubbleTab(MessageModel model, Rect rect) async {
    if (model.message.bodyType == MessageType.IMAGE) {
      ChatUIKitRoute.pushOrPushNamed(
        context,
        ChatUIKitRouteNames.showImageView,
        ShowImageViewArguments(
          message: model.message,
          attributes: widget.attributes,
        ),
      );
    } else if (model.message.bodyType == MessageType.VIDEO) {
      ChatUIKitRoute.pushOrPushNamed(
        context,
        ChatUIKitRouteNames.showVideoView,
        ShowVideoViewArguments(
          message: model.message,
          attributes: widget.attributes,
        ),
      );
    }

    if (model.message.bodyType == MessageType.VOICE) {
      playVoiceMessage(model.message);
    }

    if (model.message.bodyType == MessageType.COMBINE) {
      ChatUIKitRoute.pushOrPushNamed(
        context,
        ChatUIKitRouteNames.forwardMessagesView,
        ForwardMessagesViewArguments(
          message: model.message,
          attributes: widget.attributes,
        ),
      );
    }

    if (model.message.bodyType == MessageType.CUSTOM &&
        model.message.isCardMessage) {
      String? userId =
          (model.message.body as CustomMessageBody).params?[cardUserIdKey];
      String avatar =
          (model.message.body as CustomMessageBody).params?[cardAvatarKey] ??
              '';
      String name =
          (model.message.body as CustomMessageBody).params?[cardNicknameKey] ??
              '';
      if (userId?.isNotEmpty == true) {
        ChatUIKitProfile profile = ChatUIKitProfile.contact(
            id: userId!, avatarUrl: avatar, nickname: name);
        pushNextPage(profile, isCard: true);
      }
    }
  }

  void avatarTap(MessageModel model) async {
    ChatUIKitProfile profile = ChatUIKitProvider.instance.getProfile(
      ChatUIKitProfile.contact(id: model.message.from!),
    );

    pushNextPage(profile);
  }

  Widget alertItem(
    BuildContext context,
    MessageModel model,
  ) {
    Widget? content = widget.alertItemBuilder?.call(context, model);
    if (content != null) return content;

    if (model.message.isTimeMessageAlert) {
      content ??= ChatUIKitMessageListViewAlertItem(
        actions: [
          MessageAlertAction(
            text: ChatUIKitTimeFormatter.instance.formatterHandler?.call(
                    context,
                    ChatUIKitTimeType.message,
                    model.message.serverTime) ??
                ChatUIKitTimeTool.getChatTimeStr(model.message.serverTime,
                    needTime: true),
          )
        ],
      );
      return content;
    }

    if (model.message.isCreateThreadAlert) {
      Map<String, String>? map =
          (model.message.body as CustomMessageBody).params;

      String? operator = map![alertOperatorIdKey]!;
      String showName;
      if (ChatUIKit.instance.currentUserId == operator) {
        showName = ChatUIKitLocal.alertYou.localString(context);
      } else {
        ChatUIKitProfile profile = ChatUIKitProvider.instance.getProfile(
          ChatUIKitProfile.contact(id: operator),
        );
        showName = profile.contactShowName;
      }
      content ??= ChatUIKitMessageListViewAlertItem(
        actions: [
          MessageAlertAction(
            text: showName,
            onTap: () {
              ChatUIKitProfile profile = ChatUIKitProvider.instance.getProfile(
                ChatUIKitProfile.contact(
                  id: map[alertOperatorIdKey]!,
                ),
              );
              pushNextPage(profile);
            },
          ),
          MessageAlertAction(
              text: ChatUIKitLocal.messagesViewAlertThreadInfoTitle
                  .localString(context)),
        ],
      );
      return content;
    }

    return const SizedBox();
  }

  void pushNextPage(ChatUIKitProfile profile, {bool isCard = false}) async {
    clearAllType();

    // 如果点击的是自己头像
    if (profile.id == ChatUIKit.instance.currentUserId) {
      pushToCurrentUser(profile);
    } else {
      List<String> contacts = await ChatUIKit.instance.getAllContactIds();
      // 是好友，不是当前聊天对象，跳转到好友页面，并可以发消息
      if (contacts.contains(profile.id)) {
        ChatUIKitProfile? tmpProfile =
            ChatUIKitProvider.instance.getProfileById(profile.id);
        pushContactDetail(tmpProfile ?? profile);
      }
      // 不是好友，跳转到添加好友页面
      else {
        pushRequestDetail(profile);
      }
    }
  }

  @override
  void onChatThreadCreate(ChatThreadEvent event) {}
  @override
  void onChatThreadDestroy(ChatThreadEvent event) async {
    if (event.chatThread?.threadId == controller.thread?.threadId) {
      Navigator.of(context).pop();
    }
  }

  @override
  void onUserKickOutOfChatThread(ChatThreadEvent event) {}

  Widget voicePanel() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () async {
          inputController.switchPanel(
            ChatUIKitKeyboardPanelType.voice,
            duration: _keyboardPanelSwitchDuration,
          );
          RecordResultData? data = await showChatUIKitRecordBar(
            context: context,
            backgroundColor: theme.color.isDark
                ? theme.color.neutralColor1
                : theme.color.neutralColor98,
            onRecordTypeChanged: (type) {},
          );

          inputController.switchPanel(
            ChatUIKitKeyboardPanelType.none,
            duration: _keyboardPanelSwitchDuration,
          );
          if (data?.path != null) {
            controller.sendVoiceMessage(
              data!.path!,
              data.duration ?? 0,
              data.fileName ?? '',
            );
          }
        },
        child: ChatUIKitImageLoader.voiceKeyboard(
          color: theme.color.isDark
              ? theme.color.neutralColor5
              : theme.color.neutralColor3,
        ),
      ),
    );
  }

  List<ChatUIKitEventAction> moreActions() {
    void closeMenu([close = true]) {
      if (ChatUIKitSettings.messageAttachmentMenuStyle ==
          ChatUIKitMessageAttachmentMenuStyle.bottomSheet) {
        Navigator.of(context).pop();
      } else {
        if (close) {
          inputController.switchPanel(
            ChatUIKitKeyboardPanelType.none,
            duration: _keyboardPanelSwitchDuration,
          );
        }
      }
    }

    final style = ChatUIKitSettings.messageAttachmentMenuStyle ==
            ChatUIKitMessageAttachmentMenuStyle.bottomSheet
        ? TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor7
                : theme.color.neutralColor3,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          )
        : TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor7
                : theme.color.neutralColor3,
            fontWeight: theme.font.bodySmall.fontWeight,
            fontSize: theme.font.bodySmall.fontSize,
          );

    List<ChatUIKitEventAction>? items = widget.morePressActions;
    if (items == null) {
      items = [];
      items.add(ChatUIKitEventAction.normal(
        actionType: ChatUIKitActionType.photos,
        label: ChatUIKitLocal.messagesViewMoreActionsTitleAlbum
            .localString(context),
        style: style,
        icon: ChatUIKitImageLoader.messageViewMoreAlbum(
          color: theme.color.isDark
              ? theme.color.neutralColor9
              : theme.color.neutralColor3,
        ),
        onTap: () async {
          closeMenu(await selectImage());
        },
      ));
      items.add(ChatUIKitEventAction.normal(
        actionType: ChatUIKitActionType.video,
        label: ChatUIKitLocal.messagesViewMoreActionsTitleVideo
            .localString(context),
        style: style,
        icon: ChatUIKitImageLoader.messageViewMoreVideo(
          color: theme.color.isDark
              ? theme.color.neutralColor9
              : theme.color.neutralColor3,
        ),
        onTap: () async {
          closeMenu(await selectVideo());
        },
      ));
      items.add(ChatUIKitEventAction.normal(
        actionType: ChatUIKitActionType.camera,
        label: ChatUIKitLocal.messagesViewMoreActionsTitleCamera
            .localString(context),
        style: style,
        icon: ChatUIKitImageLoader.messageViewMoreCamera(
          color: theme.color.isDark
              ? theme.color.neutralColor9
              : theme.color.neutralColor3,
        ),
        onTap: () async {
          closeMenu(await selectCamera());
        },
      ));
      items.add(ChatUIKitEventAction.normal(
        actionType: ChatUIKitActionType.file,
        label: ChatUIKitLocal.messagesViewMoreActionsTitleFile
            .localString(context),
        style: style,
        icon: ChatUIKitImageLoader.messageViewMoreFile(
          color: theme.color.isDark
              ? theme.color.neutralColor9
              : theme.color.neutralColor3,
        ),
        onTap: () async {
          closeMenu(await selectFile());
        },
      ));
      items.add(ChatUIKitEventAction.normal(
        actionType: ChatUIKitActionType.contactCard,
        label: ChatUIKitLocal.messagesViewMoreActionsTitleContact
            .localString(context),
        style: style,
        icon: ChatUIKitImageLoader.messageViewMoreCard(
          color: theme.color.isDark
              ? theme.color.neutralColor9
              : theme.color.neutralColor3,
        ),
        onTap: () async {
          closeMenu();
          selectCard();
        },
      ));
    }

    if (widget.onMoreActionsItemsHandler != null) {
      items = widget.onMoreActionsItemsHandler!.call(
        context,
        items,
      );
    }
    return items!;
  }

  Widget emojiPanel() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          final type =
              currentPanelType.value == ChatUIKitKeyboardPanelType.emoji
                  ? ChatUIKitKeyboardPanelType.keyboard
                  : ChatUIKitKeyboardPanelType.emoji;
          if (type == ChatUIKitKeyboardPanelType.emoji) {
            setState(() {
              inputController.readOnly = true;
            });
          }

          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            inputController.switchPanel(
              type,
              duration: _keyboardPanelSwitchDuration,
            );
          });
        },
        child: ChatUIKitImageLoader.faceKeyboard(
          color: theme.color.isDark
              ? theme.color.neutralColor5
              : theme.color.neutralColor3,
        ),
      ),
    );
  }

  Widget morePanel() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ValueListenableBuilder(
        valueListenable: inputController.inputTextEditingController,
        builder: (context, value, child) {
          if (inputController.text.isEmpty) {
            return InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                ChatUIKitKeyboardPanelType panel =
                    ChatUIKitKeyboardPanelType.none;
                if (ChatUIKitSettings.messageAttachmentMenuStyle ==
                    ChatUIKitMessageAttachmentMenuStyle.bottomSheet) {
                  panel = ChatUIKitKeyboardPanelType.none;
                  inputController.switchPanel(
                    panel,
                    duration: _keyboardPanelSwitchDuration,
                  );
                  List<ChatUIKitEventAction> items = moreActions();
                  if (items.isNotEmpty) {
                    showChatUIKitBottomSheet(
                      context: context,
                      items: items,
                      cancelLabelStyle: TextStyle(
                        color: theme.color.isDark
                            ? theme.color.neutralColor7
                            : theme.color.neutralColor3,
                        fontWeight: theme.font.bodyLarge.fontWeight,
                        fontSize: theme.font.bodyLarge.fontSize,
                      ),
                    );
                  }
                } else {
                  panel =
                      currentPanelType.value == ChatUIKitKeyboardPanelType.more
                          ? ChatUIKitKeyboardPanelType.keyboard
                          : ChatUIKitKeyboardPanelType.more;

                  inputController.switchPanel(
                    panel,
                    duration: _keyboardPanelSwitchDuration,
                  );
                }
              },
              child: ValueListenableBuilder(
                valueListenable: currentPanelType,
                builder: (context, value, child) {
                  return AnimatedRotation(
                    turns: value == ChatUIKitKeyboardPanelType.more ? 0.125 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: ChatUIKitImageLoader.moreKeyboard(
                      color: theme.color.isDark
                          ? theme.color.neutralColor5
                          : theme.color.neutralColor3,
                    ),
                  );
                },
              ),
            );
          } else {
            return InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                controller.sendTextMessage(
                  inputController.text,
                  replay: replyMessage?.message,
                );
                replyMessage = null;
                inputController.clearText();
              },
              child: ChatUIKitImageLoader.sendKeyboard(
                color: theme.color.isDark
                    ? theme.color.primaryColor6
                    : theme.color.primaryColor5,
              ),
            );
          }
        },
      ),
    );
  }

  List<ChatUIKitBottomPanelData> bottomPanels() {
    return [
      //  keyboard
      const ChatUIKitBottomPanelData(
        height: 0,
        panelType: ChatUIKitKeyboardPanelType.keyboard,
      ),
      // voice
      const ChatUIKitBottomPanelData(
        height: 0,
        panelType: ChatUIKitKeyboardPanelType.voice,
      ),
      // emoji
      ChatUIKitBottomPanelData(
        height: 230,
        showCursor: true,
        panelType: ChatUIKitKeyboardPanelType.emoji,
        child: widget.emojiWidget ??
            ChatUIKitEmojiPanel(
              deleteOnTap: () {
                editController?.deleteTextOnCursor();
              },
              emojiClicked: (emoji) {
                editController?.addText(
                  ChatUIKitEmojiData.emojiMap[emoji] ?? emoji,
                );
              },
            ),
      ),
      ChatUIKitBottomPanelData(
        height: 254,
        panelType: ChatUIKitKeyboardPanelType.more,
        child: ChatUIKitSettings.messageAttachmentMenuStyle ==
                ChatUIKitMessageAttachmentMenuStyle.menu
            ? ChatUIKitMessageViewBottomMenu(
                eventActionsHandler: () => moreActions(),
              )
            : null,
      )
    ];
  }
}
