// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../chat_uikit.dart';
import '../../universal/inner_headers.dart';

/// 消息页面
class MessagesView extends StatefulWidget {
  /// 构造函数, 通过 [MessagesViewArguments] 传入参数。详细参考 [MessagesViewArguments]。
  MessagesView.arguments(MessagesViewArguments arguments, {super.key})
      : profile = arguments.profile,
        controller = arguments.controller,
        inputBar = arguments.inputBar,
        appBarModel = arguments.appBarModel,
        showMessageItemAvatar = arguments.showMessageItemAvatar,
        showMessageItemNickname = arguments.showMessageItemNickname,
        onItemTap = arguments.onItemTap,
        onDoubleTap = arguments.onDoubleTap,
        onAvatarTap = arguments.onAvatarTap,
        onNicknameTap = arguments.onNicknameTap,
        emojiWidget = arguments.emojiWidget,
        itemBuilder = arguments.itemBuilder,
        alertItemBuilder = arguments.alertItemBuilder,
        onAvatarLongPress = arguments.onAvatarLongPress,
        morePressActions = arguments.morePressActions,
        replyBarBuilder = arguments.replyBarBuilder,
        quoteBuilder = arguments.quoteBuilder,
        onErrorBtnTapHandler = arguments.onErrorBtnTapHandler,
        bubbleBuilder = arguments.bubbleBuilder,
        enableAppBar = arguments.enableAppBar,
        onMoreActionsItemsHandler = arguments.onMoreActionsItemsHandler,
        onItemLongPressHandler = arguments.onItemLongPressHandler,
        bubbleContentBuilder = arguments.bubbleContentBuilder,
        inputController = arguments.inputController,
        forceLeft = arguments.forceLeft,
        multiSelectBottomBar = arguments.multiSelectBottomBar,
        viewObserver = arguments.viewObserver,
        attributes = arguments.attributes,
        onReactionItemTap = arguments.onReactionItemTap,
        onReactionInfoTap = arguments.onReactionInfoTap,
        reactionItemsBuilder = arguments.reactionItemsBuilder,
        onThreadItemTap = arguments.onThreadItemTap,
        threadItemBuilder = arguments.threadItemBuilder,
        backgroundWidget = arguments.backgroundWidget;

  /// 构造函数。
  const MessagesView({
    required this.profile,
    this.appBarModel,
    this.enableAppBar = true,
    this.inputBar,
    this.controller,
    this.showMessageItemAvatar,
    this.showMessageItemNickname,
    this.onItemTap,
    this.onItemLongPressHandler,
    this.onDoubleTap,
    this.onAvatarTap,
    this.onAvatarLongPress,
    this.onNicknameTap,
    this.emojiWidget,
    this.itemBuilder,
    this.alertItemBuilder,
    this.morePressActions,
    this.onMoreActionsItemsHandler,
    this.replyBarBuilder,
    this.quoteBuilder,
    this.onErrorBtnTapHandler,
    this.bubbleBuilder,
    this.bubbleContentBuilder,
    this.forceLeft,
    this.inputController,
    this.multiSelectBottomBar,
    this.viewObserver,
    this.attributes,
    this.onReactionItemTap,
    this.onReactionInfoTap,
    this.reactionItemsBuilder,
    this.onThreadItemTap,
    this.threadItemBuilder,
    this.backgroundWidget,
    super.key,
  });

  /// 用户信息对象，用于设置对方信息。详细参考 [ChatUIKitProfile]。
  final ChatUIKitProfile profile;

  /// 消息列表控制器，用于控制消息列表和收发消息等，如果不设置将会自动创建。详细参考 [MessagesViewController]。
  final MessagesViewController? controller;

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

  /// 消息长按事件回调， 如果设置后将会替换默认的消息长按事件回调。
  final MessagesViewItemLongPressPositionHandler? onItemLongPressHandler;

  /// 强制消息靠左，默认为 `false`， 设置后自己发的消息也会在左侧显示。
  final bool? forceLeft;

  /// 表情控件，如果设置后将会替换默认的表情控件。详细参考 [ChatUIKitEmojiPanel]。
  final Widget? emojiWidget;

  /// 回复消息提示组件构建器，如果设置后将会替换默认的回复消息提示组件。详细参考 [ChatUIKitReplyBar]。
  final Widget? Function(BuildContext context, MessageModel replyMessage)?
      replyBarBuilder;

  /// 引用消息构建器，如果设置后将会替换默认的引用消息样式。
  final Widget Function(BuildContext context, QuoteModel model)? quoteBuilder;

  /// 错误消息点击事件，如果设置后将会替换默认的错误消息点击事件。如果不处理可以返回 `false`。默认行为为重新发送消息。
  final MessageItemTapHandler? onErrorBtnTapHandler;

  /// 气泡构建器，如果设置后将会替换默认的气泡构建器。详细参考 [MessageItemBubbleBuilder]。
  final MessageItemBubbleBuilder? bubbleBuilder;

  /// 气泡内容构建器，如果设置后将会替换默认的气泡内容构建器。详细参考 [MessageItemBuilder]。
  final MessageItemBuilder? bubbleContentBuilder;

  /// 输入框控制器，如果设置后将会替换默认的输入框控制器。详细参考 [ChatUIKitKeyboardPanelController]。
  final ChatUIKitKeyboardPanelController? inputController;

  /// View 附加属性，设置后的内容将会带入到下一个页面。
  final String? attributes;

  /// 多选时显示的 bottom bar
  final Widget? multiSelectBottomBar;

  /// reaction 点击事件，如果设置后将会替换默认的反应点击事件。详细参考 [MessageReactionItemTapHandler]。
  final MessageReactionItemTapHandler? onReactionItemTap;

  /// reaction 点击事件，如果设置后将会替换默认的反应信息点击事件。详细参考 [MessageItemTapHandler]。
  final MessageItemTapHandler? onReactionInfoTap;

  /// reaction 构建器，如果设置后将会替换默认的反应构建器。详细参考 [MessageItemBuilder]。
  final MessageItemBuilder? reactionItemsBuilder;

  /// thread 点击事件，如果设置后将会替换默认的线程点击事件。详细参考 [MessageItemTapHandler]。
  final MessageItemTapHandler? onThreadItemTap;

  /// thread 构建器，如果设置后将会替换默认的线程构建器。详细参考 [MessageItemBuilder]。
  final MessageItemBuilder? threadItemBuilder;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;

  /// 背景组件，如果设置后将会替换默认的背景组件。
  final Widget? backgroundWidget;

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView>
    with ChatObserver, ChatUIKitThemeMixin {
  late final MessagesViewController controller;
  late final ImagePicker _picker;
  late final AudioPlayer _player;
  late final AutoScrollController _scrollController;

  ChatUIKitPopupMenuController? popupMenuController;

  final Duration _keyboardPanelSwitchDuration =
      const Duration(milliseconds: 150);

  Message? editMessage;
  MessageModel? replyMessage;
  ChatUIKitProfile? profile;
  Message? _playingMessage;
  final ValueNotifier<bool> _remoteTyping = ValueNotifier(false);
  Timer? _typingTimer;
  ChatUIKitAppBarModel? appBarModel;

  PinMessageListViewController? pinMessageController;

  late ChatUIKitKeyboardPanelController inputController;

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

    profile = widget.profile;
    setup();
  }

  void setup() {
    inputController = widget.inputController ??
        ChatUIKitKeyboardPanelController(
            inputTextEditingController: CustomTextEditingController());

    ChatUIKit.instance.addObserver(this);
    _scrollController = AutoScrollController();
    widget.viewObserver?.addListener(() {
      updateView();
    });

    controller = widget.controller ?? MessagesViewController(profile: profile!);
    controller.addListener(
      () {
        updateView();
        if (controller.lastActionType == MessageLastActionType.topPosition) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            jumpToMessage(controller.searchedMsg?.msgId);
          });
        }

        if (controller.lastActionType == MessageLastActionType.bottomPosition) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (_scrollController.positions.isNotEmpty) {
              _scrollController.jumpTo(0);
            }
          });
        }
      },
    );

    _picker = ImagePicker();
    _player = AudioPlayer();

    controller.fetchItemList();
    controller.sendConversationsReadAck();
    controller.clearMentionIfNeed();

    pinMessageController = PinMessageListViewController(profile!);

    if (ChatUIKitSettings.messageLongPressMenuStyle ==
        ChatUIKitMessageLongPressMenuStyle.popupMenu) {
      popupMenuController = ChatUIKitPopupMenuController();
    }

    currentPanelType.addListener(() {
      popupMenuController?.hideMenu();
    });

    editController?.addListener(() {
      if (editController?.needMention == true) {
        if (profile?.type == ChatUIKitProfileType.group) {
          needMention();
        }
      }
    });
  }

  void jumpToMessage(String? messageId,
      {AutoScrollPosition position = AutoScrollPosition.end}) async {
    int index = controller.msgModelList
        .indexWhere((element) => element.message.msgId == messageId);
    if (index == -1 || messageId == null) {
      ChatUIKit.instance
          .sendChatUIKitEvent(ChatUIKitEvent.targetMessageNotFound);
      return;
    }

    _scrollController.scrollToIndex(
      index,
      preferPosition: position,
      duration: const Duration(milliseconds: 10),
    );

    await _scrollController.scrollToIndex(
      index,
      preferPosition: position,
      duration: const Duration(milliseconds: 100),
    );

    await _scrollController.highlight(
      index,
      highlightDuration: const Duration(milliseconds: 500),
    );
  }

  void updateAppBarModel() {
    appBarModel = ChatUIKitAppBarModel(
      title: widget.appBarModel?.title ??
          (controller.conversationType == ConversationType.GroupChat
              ? controller.profile.contactShowName
              : controller.userMap[controller.profile.id]?.contactShowName),
      titleTextStyle: widget.appBarModel?.titleTextStyle,
      centerWidget: widget.appBarModel?.centerWidget,
      subtitle: widget.appBarModel?.subtitle,
      subTitleTextStyle: widget.appBarModel?.subTitleTextStyle,
      centerTitle: widget.appBarModel?.centerTitle ?? false,
      showBackButton: widget.appBarModel?.showBackButton ?? true,
      leadingActions: widget.appBarModel?.leadingActions ??
          () {
            List<ChatUIKitAppBarAction> actions = [
              ChatUIKitAppBarAction(
                actionType: ChatUIKitActionType.avatar,
                onTap: (ctx) => pushNextPage(controller.profile),
                child: ChatUIKitAvatar(
                  avatarUrl: controller.profile.avatarUrl,
                ),
              ),
            ];

            actions = widget.appBarModel?.leadingActionsBuilder
                    ?.call(context, actions) ??
                actions;
            List<ChatUIKitAppBarAction> newActions = [];
            for (var action in actions) {
              newActions.add(action.copyWith(
                onTap: (context) {
                  clearAllType();
                  action.onTap?.call(context);
                },
              ));
            }
            return newActions;
          }(),
      trailingActions: widget.appBarModel?.trailingActions ??
          () {
            List<ChatUIKitAppBarAction> actions = [
              if (ChatUIKitSettings.enablePinMsg &&
                  !controller.isMultiSelectMode &&
                  controller.conversationType == ConversationType.GroupChat)
                ChatUIKitAppBarAction(
                  actionType: ChatUIKitActionType.pinMessage,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ChatUIKitImageLoader.pinMessage(
                      color: theme.color.isDark
                          ? theme.color.neutralColor9
                          : theme.color.neutralColor3,
                    ),
                  ),
                  onTap: (context) {
                    showPinMsgsView();
                  },
                ),
              if (ChatUIKitSettings.enableMessageThread &&
                  !controller.isMultiSelectMode &&
                  controller.conversationType == ConversationType.GroupChat)
                ChatUIKitAppBarAction(
                  actionType: ChatUIKitActionType.thread,
                  onTap: (context) {
                    pushThread();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ChatUIKitImageLoader.messageLongPressThread(
                      color: theme.color.isDark
                          ? theme.color.neutralColor9
                          : theme.color.neutralColor3,
                    ),
                  ),
                ),
              if (controller.isMultiSelectMode)
                ChatUIKitAppBarAction(
                  actionType: ChatUIKitActionType.cancel,
                  onTap: (context) {
                    controller.disableMultiSelectMode();
                  },
                  child: Text(
                    ChatUIKitLocal.bottomSheetCancel.localString(context),
                    textScaler: TextScaler.noScaling,
                    style: TextStyle(
                      color: theme.color.isDark
                          ? theme.color.primaryColor6
                          : theme.color.primaryColor5,
                      fontWeight: theme.font.labelMedium.fontWeight,
                      fontSize: theme.font.labelMedium.fontSize,
                    ),
                  ),
                ),
            ];

            actions = widget.appBarModel?.trailingActionsBuilder
                    ?.call(context, actions) ??
                actions;
            List<ChatUIKitAppBarAction> newActions = [];
            for (var action in actions) {
              newActions.add(action.copyWith(
                onTap: (context) {
                  clearAllType();
                  action.onTap?.call(context);
                },
              ));
            }
            return newActions;
          }(),
      backgroundColor: widget.appBarModel?.backgroundColor,
      systemOverlayStyle: widget.appBarModel?.systemOverlayStyle,
      onBackButtonPressed: widget.appBarModel?.onBackButtonPressed,
      bottomLine: widget.appBarModel?.bottomLine ?? true,
      bottomLineColor: widget.appBarModel?.bottomLineColor,
    );
  }

  void needMention() {
    if (controller.conversationType == ConversationType.GroupChat) {
      ChatUIKitRoute.pushOrPushNamed(
        context,
        ChatUIKitRouteNames.groupMentionView,
        GroupMentionViewArguments(
          groupId: controller.profile.id,
          attributes: widget.attributes,
        ),
      ).then((value) {
        if (value != null) {
          if (value == true) {
            editController?.atAll();
          } else if (value is ChatUIKitProfile) {
            editController?.at(value);
          }
        }
      });
    }
  }

  @override
  void onTyping(List<String> fromUsers) {
    if (controller.profile.type == ChatUIKitProfileType.group) return;
    if (fromUsers.contains(controller.profile.id)) {
      updateInputType();
    }
  }

  void updateInputType() {
    if (_typingTimer != null) {
      _typingTimer?.cancel();
      _typingTimer = null;
    }

    _remoteTyping.value = true;
    _typingTimer = Timer(const Duration(seconds: 6), () {
      if (mounted) {
        _remoteTyping.value = false;
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _typingTimer?.cancel();
    _typingTimer = null;
    widget.viewObserver?.dispose();
    ChatUIKit.instance.removeObserver(this);
    pinMessageController?.dispose();
    inputController.dispose();
    _player.dispose();

    super.dispose();
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    updateAppBarModel();
    Widget content = MessageListView(
      scrollController: _scrollController,
      forceLeft: widget.forceLeft,
      bubbleContentBuilder: widget.bubbleContentBuilder,
      bubbleBuilder: widget.bubbleBuilder,
      quoteBuilder: widget.quoteBuilder,
      controller: controller,
      showAvatar: widget.showMessageItemAvatar,
      showNickname: widget.showMessageItemNickname,
      onItemTap: (ctx, msg, rect) {
        stopSound();
        bool? ret = widget.onItemTap?.call(context, msg, rect);
        if (ret != true) {
          bubbleTab(msg, rect);
        }
        return ret;
      },
      onItemLongPress: (context, model, rect) {
        onItemLongPress(model, rect);
        return true;
      },
      onItemDoubleTap: (context, model, rect) {
        bool? ret = widget.onDoubleTap?.call(context, model, rect);
        stopSound();
        return ret;
      },
      onAvatarTap: (context, model) {
        bool? ret = widget.onAvatarTap?.call(context, model);
        stopSound();
        if (ret != true) {
          avatarTap(model);
        }
        return ret;
      },
      onAvatarLongPressed: (context, model) {
        bool? ret = widget.onAvatarLongPress?.call(context, model);
        stopSound();
        if (ret != true) {}
        return ret;
      },
      onNicknameTap: (context, msg) {
        bool? ret = widget.onNicknameTap?.call(context, msg);
        stopSound();
        if (ret != true) {}
        return ret;
      },
      itemBuilder: widget.itemBuilder ?? itemBuilder,
      alertItemBuilder: widget.alertItemBuilder ?? alertItem,
      onErrorBtnTap: (model) {
        bool ret = widget.onErrorBtnTapHandler?.call(context, model) ?? false;
        if (ret == false) {
          onErrorBtnTap(model);
        }
      },
      onReactionItemTap: (model, reaction) {
        bool? ret =
            widget.onReactionItemTap?.call(context, model, reaction) ?? false;
        if (ret == false) {
          controller.updateReaction(
            model.message.msgId,
            reaction.reaction,
            !reaction.isAddedBySelf,
          );
        }
      },
      onReactionInfoTap: (context, model) {
        bool ret = widget.onReactionInfoTap?.call(context, model) ?? false;
        if (ret == false) {
          showReactionsInfo(context, model);
        }

        return ret;
      },
      reactionItemsBuilder: widget.reactionItemsBuilder,
      onThreadItemTap: (context, model) {
        bool ret = widget.onThreadItemTap?.call(context, model) ?? false;
        if (ret == false) {
          showThread(context, model);
        }
        return ret;
      },
      threadItemBuilder: widget.threadItemBuilder,
    );

    content = GestureDetector(
      onTap: () {
        clearAllType();
        inputController.switchPanel(ChatUIKitKeyboardPanelType.none);
      },
      child: content,
    );

    content = Stack(
      children: [
        content,
        Positioned.fill(child: floatingUnreadWidget()),
      ],
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
    List<Widget> list = [
      Expanded(child: content),
    ];
    if (controller.isMultiSelectMode) {
      list.add(multiSelectBar());
    } else {
      list.add(widget.inputBar ?? inputBar());
    }

    content = Column(children: list);
    content = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: widget.enableAppBar ? ChatUIKitAppBar.model(appBarModel!) : null,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: ChatUIKitSettings.enablePinMsg &&
                controller.chatType == ChatType.GroupChat
            ? Stack(
                children: [
                  content,
                  PinMessageListView(
                    maxHeight: MediaQuery.of(context).size.height / 5 * 3,
                    pinMessagesController: pinMessageController!,
                    onTap: (message) => jumpToMessage(
                      message.msgId,
                      position: AutoScrollPosition.begin,
                    ),
                  ),
                ],
              )
            : content,
      ),
    );

    content = Stack(
      children: [
        Container(
          color: theme.color.isDark
              ? theme.color.neutralColor1
              : theme.color.neutralColor98,
          child: widget.backgroundWidget,
        ),
        content,
        if (editMessage != null) ...[
          Positioned.fill(
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                editMessage = null;

                updateView();
              },
              child: Opacity(
                opacity: 0.5,
                child: Container(color: Colors.black),
              ),
            ),
          ),
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
                      updateView();
                    },
                  ),
                ),
              ],
            ),
          ),
        ]
      ],
    );

    content = ShareUserData(
      data: controller.userMap,
      child: content,
    );

    content = NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          if (_scrollController.offset < 20) {
            if (controller.onBottom == false) {
              controller.onBottom = true;
              controller.addAllCacheToList();
            }
          } else {
            if (controller.onBottom == true) {
              controller.onBottom = false;
              controller.lastActionType =
                  MessageLastActionType.originalPosition;
            }
          }
          if (_scrollController.position.maxScrollExtent -
                  _scrollController.offset <
              1500) {
            controller.fetchItemList();
          }
        }

        return false;
      },
      child: content,
    );

    content = ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: content,
    );

    content = PopScope(
      child: content,
      onPopInvoked: (didPop) {
        popupMenuController?.hideMenu();
        if (didPop) {
          controller.markAllMessageAsRead();
        }
      },
    );

    return content;
  }

  Widget? itemBuilder(BuildContext context, MessageModel model) {
    controller.sendMessageReadAck(model.message);
    if (model.message.bodyType != MessageType.VOICE) return null;

    Widget content = ChatUIKitMessageListViewMessageItem(
      isPlaying: _playingMessage?.msgId == model.message.msgId,
      onThreadItemTap: () {
        bool ret = widget.onThreadItemTap?.call(context, model) ?? false;
        if (ret == false) {
          showThread(context, model);
        }
      },
      onErrorBtnTap: () {
        if (widget.onErrorBtnTapHandler == null) {
          onErrorBtnTap(model);
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
        onItemLongPress(model, rect);
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
          updateView();
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

  Widget alertItem(
    BuildContext ctx,
    MessageModel model,
  ) {
    Widget? content = widget.alertItemBuilder?.call(context, model);
    if (content != null) {
      return content;
    }

    if (model.message.isTimeMessageAlert) {
      content = ChatUIKitMessageListViewAlertItem(
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

    // 如果是撤回消息提醒
    if (model.message.isRecallAlert) {
      Map<String, String>? map =
          (model.message.body as CustomMessageBody).params;

      String? from = map?[alertOperatorIdKey];
      String? showName;
      if (ChatUIKit.instance.currentUserId == from) {
        showName = ChatUIKitLocal.alertYou.localString(context);
      } else {
        if (from?.isNotEmpty == true) {
          ChatUIKitProfile profile = ChatUIKitProvider.instance
              .getProfile(ChatUIKitProfile.contact(id: from!));
          showName = profile.contactShowName;
        }
      }

      content ??= ChatUIKitMessageListViewAlertItem(
        actions: [
          MessageAlertAction(
            text: '$showName',
            type: MessageAlertActionType.heightLight,
          ),
          MessageAlertAction(
            text: ChatUIKitLocal.alertRecallInfo.localString(context),
          ),
        ],
      );
      return content;
    }

    Map<String, String>? map = (model.message.body as CustomMessageBody).params;
    String? operator = map?[alertOperatorIdKey];
    String? targetId = map?[alertTargetIdKey];
    ChatUIKitProfile? operatorProfile;
    if (operator != null) {
      operatorProfile = ChatUIKitProvider.instance.getProfile(
        ChatUIKitProfile.contact(id: operator),
      );
    }
    String showName;
    if (ChatUIKit.instance.currentUserId == operator) {
      showName = ChatUIKitLocal.alertYou.localString(context);
    } else {
      showName = operatorProfile?.contactShowName ?? '';
    }

    // 如果是创建群组消息提醒
    if (model.message.isCreateGroupAlert) {
      ChatUIKitProfile? targetProfile;
      if (targetId != null) {
        targetProfile = ChatUIKitProvider.instance.getProfile(
          ChatUIKitProfile.group(id: targetId),
        );
      }

      content ??= ChatUIKitMessageListViewAlertItem(
        actions: [
          MessageAlertAction(
            text: showName,
            type: MessageAlertActionType.heightLight,
          ),
          MessageAlertAction(
              text: ChatUIKitLocal.messagesViewAlertGroupInfoTitle
                  .localString(context)),
          MessageAlertAction(
            text: targetProfile?.contactShowName ?? "",
            type: MessageAlertActionType.heightLight,
          ),
        ],
      );
      return content;
    }

    if (model.message.isCreateThreadAlert) {
      String? alertTargetName = map?[alertTargetNameKey];

      content ??= ChatUIKitMessageListViewAlertItem(
        actions: [
          MessageAlertAction(
            text: showName,
            type: MessageAlertActionType.heightLight,
          ),
          MessageAlertAction(
            text: ChatUIKitLocal.messagesViewAlertThreadInfoTitle
                .localString(context),
          ),
          if (alertTargetName != null)
            MessageAlertAction(
              text: ': $alertTargetName',
            ),
          MessageAlertAction(
            text:
                ChatUIKitLocal.messageViewAlertShowDetail.localString(context),
            type: MessageAlertActionType.heightLight,
            onTap: () async {
              String? msgId = map?[alertTargetParentIdKey]!;
              if (msgId == null) return;
              ChatUIKit.instance.loadMessage(messageId: msgId).then((value) {
                if (value != null) {
                  value.chatThread().then((thread) {
                    if (thread == null) return;
                    MessageModel model =
                        MessageModel(message: value, thread: thread);
                    if (mounted) {
                      inputController.switchPanel(
                        ChatUIKitKeyboardPanelType.none,
                        duration: _keyboardPanelSwitchDuration,
                      );
                      ChatUIKitRoute.pushOrPushNamed(
                        context,
                        ChatUIKitRouteNames.threadMessagesView,
                        ThreadMessagesViewArguments(
                          appBarModel: ChatUIKitAppBarModel(
                              subtitle: controller.profile.contactShowName),
                          controller:
                              ThreadMessagesViewController(model: model),
                          attributes: widget.attributes,
                        ),
                      );
                    }
                  });
                }
              });
            },
          ),
        ],
      );
      return content;
    }

    if (model.message.isDestroyGroupAlert) {
      return ChatUIKitMessageListViewAlertItem(
        actions: [
          MessageAlertAction(
            text: ChatUIKitLocal.alertDestroy.localString(context),
          ),
        ],
      );
    }

    if (model.message.isLeaveGroupAlert) {
      return ChatUIKitMessageListViewAlertItem(
        actions: [
          MessageAlertAction(
            text: showName,
            type: MessageAlertActionType.heightLight,
          ),
          MessageAlertAction(
            text: ChatUIKitLocal.alertLeave.localString(context),
          ),
        ],
      );
    }

    if (model.message.isKickedGroupAlert) {
      return ChatUIKitMessageListViewAlertItem(
        actions: [
          MessageAlertAction(
            text: showName,
            type: MessageAlertActionType.heightLight,
          ),
          MessageAlertAction(
            text: ChatUIKitLocal.alertKickedInfo.localString(context),
          ),
        ],
      );
    }

    if (model.message.isNewContactAlert) {
      ChatUIKitProfile profile = ChatUIKitProvider.instance
          .getProfile(ChatUIKitProfile.contact(id: operator!));
      return ChatUIKitMessageListViewAlertItem(
        actions: [
          MessageAlertAction(
            text: ChatUIKitLocal.alertYou.localString(context),
            type: MessageAlertActionType.heightLight,
          ),
          MessageAlertAction(
            text: ChatUIKitLocal.alertAlreadyAdd.localString(context),
          ),
          MessageAlertAction(
            text: profile.contactShowName,
            type: MessageAlertActionType.heightLight,
          ),
          MessageAlertAction(
            text: ChatUIKitLocal.alertAsContact.localString(context),
          ),
        ],
      );
    }

    if (model.message.isPinAlert) {
      return ChatUIKitMessageListViewAlertItem(
        actions: [
          MessageAlertAction(
            text: showName,
            type: MessageAlertActionType.heightLight,
          ),
          MessageAlertAction(
            text: ChatUIKitLocal.alertPinTitle.localString(context),
          ),
        ],
      );
    }

    if (model.message.isUnPinAlert) {
      return ChatUIKitMessageListViewAlertItem(
        actions: [
          MessageAlertAction(
            text: showName,
            type: MessageAlertActionType.heightLight,
          ),
          MessageAlertAction(
            text: ChatUIKitLocal.alertUnpinTitle.localString(context),
          ),
        ],
      );
    }

    return const SizedBox();
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
          closeMenu(await selectCard());
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

    content = Stack(
      children: [
        content,
        Transform.translate(
          offset: const Offset(0, -25),
          child: typingWidget(),
        ),
      ],
    );

    return content;
  }

  Widget typingWidget() {
    return ValueListenableBuilder(
      valueListenable: _remoteTyping,
      builder: (BuildContext context, bool value, Widget? child) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          curve: Curves.linearToEaseOut,
          opacity: value ? 1 : 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
            color: theme.color.isDark
                ? theme.color.neutralColor1
                : theme.color.neutralColor98,
            child: Row(children: [
              SizedBox(
                width: 16,
                height: 16,
                child: ChatUIKitAvatar(avatarUrl: profile?.avatarUrl),
              ),
              const SizedBox(width: 5),
              Text(
                ChatUIKitLocal.messagesViewTyping.localString(context),
                textScaler: TextScaler.noScaling,
                style: TextStyle(
                    fontWeight: theme.font.bodyExtraSmall.fontWeight,
                    fontSize: theme.font.bodyExtraSmall.fontSize,
                    color: theme.color.isDark
                        ? theme.color.neutralColor6
                        : theme.color.neutralColor5),
              ),
            ]),
          ),
        );
      },
    );
  }

  void updateView() {
    setState(() {});
  }

  Widget multiSelectBar() {
    Widget content = widget.multiSelectBottomBar ??
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () async {
                if (controller.selectedMessages.isEmpty) {
                  return;
                }
                bool? ret = await showChatUIKitDialog(
                  context: context,
                  actionItems: [
                    ChatUIKitDialogAction.cancel(
                        label: ChatUIKitLocal.cancel.localString(context)),
                    ChatUIKitDialogAction.confirm(
                      label: ChatUIKitLocal.confirm.localString(context),
                      onTap: () async {
                        Navigator.of(context).pop(true);
                      },
                    )
                  ],
                  title: Strings.format(
                      ChatUIKitLocal.deleteSomeMessages.localString(context),
                      [controller.selectedMessages.length]),
                );
                if (ret == true) {
                  controller.deleteSelectedMessages();
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                child: ChatUIKitImageLoader.messageTrash(
                  color: theme.color.isDark
                      ? theme.color.errorColor6
                      : theme.color.errorColor5,
                ),
              ),
            ),
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

    content = SizedBox(
      height: 54,
      child: content,
    );

    content = SafeArea(
      child: content,
    );

    return content;
  }

  void clearAllType() {
    bool needUpdate = false;

    popupMenuController?.hideMenu();

    if (_player.state == PlayerState.playing) {
      stopSound();
      needUpdate = true;
    }

    if (needUpdate) {
      updateView();
    }
  }

  void onItemLongPress(MessageModel model, Rect rect) async {
    clearAllType();
    if (currentPanelType.value != ChatUIKitKeyboardPanelType.none) {
      inputController.switchPanel(
        ChatUIKitKeyboardPanelType.none,
        duration: _keyboardPanelSwitchDuration,
      );
      return;
    }
    List<ChatUIKitEventAction>? items = defaultItemLongPressed(model);
    if (items.isEmpty) return;
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

  void avatarTap(MessageModel model) async {
    ChatUIKitProfile profile = ChatUIKitProvider.instance.getProfile(
      ChatUIKitProfile.contact(id: model.message.from!),
    );

    pushNextPage(profile);
  }

  void bubbleTab(MessageModel model, Rect rect) async {
    popupMenuController?.hideMenu();
    inputController.switchPanel(
      ChatUIKitKeyboardPanelType.none,
      duration: _keyboardPanelSwitchDuration,
    );
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
        pushNextPage(profile);
      }
    }
  }

  void onErrorBtnTap(MessageModel model) {
    controller.resendMessage(model.message);
  }

  void textMessageEdit(Message message) {
    clearAllType();
    if (message.bodyType != MessageType.TXT) return;
    editMessage = message;
    inputController.switchPanel(
      ChatUIKitKeyboardPanelType.keyboard,
      duration: _keyboardPanelSwitchDuration,
    );
    updateView();
  }

  void replyMessaged(MessageModel model) {
    replyMessage = model;
    updateView();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      inputController.switchPanel(
        ChatUIKitKeyboardPanelType.keyboard,
        duration: _keyboardPanelSwitchDuration,
      );
    });
  }

  void deleteMessage(MessageModel model) async {
    final delete = await showChatUIKitDialog(
      title: ChatUIKitLocal.messagesViewDeleteMessageAlertTitle
          .localString(context),
      content: ChatUIKitLocal.messagesViewDeleteMessageAlertSubTitle
          .localString(context),
      context: context,
      actionItems: [
        ChatUIKitDialogAction.cancel(
          label: ChatUIKitLocal.messagesViewDeleteMessageAlertButtonCancel
              .localString(context),
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogAction.confirm(
          label: ChatUIKitLocal.messagesViewDeleteMessageAlertButtonConfirm
              .localString(context),
          onTap: () async {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
    if (delete == true) {
      controller.deleteMessage(model.message.msgId);
    }
  }

  void recallMessage(MessageModel model) async {
    final recall = await showChatUIKitDialog(
      title: ChatUIKitLocal.messagesViewRecallMessageAlertTitle
          .localString(context),
      context: context,
      actionItems: [
        ChatUIKitDialogAction.cancel(
          label: ChatUIKitLocal.messagesViewRecallMessageAlertButtonCancel
              .localString(context),
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogAction.confirm(
          label: ChatUIKitLocal.messagesViewRecallMessageAlertButtonConfirm
              .localString(context),
          onTap: () async {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
    if (recall == true) {
      try {
        controller.recallMessage(model.message);
        // ignore: empty_catches
      } catch (e) {}
    }
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

  Future<bool> selectCard() async {
    bool? ret = await showModalBottomSheet<bool>(
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
                content: Strings.format(
                    '${ChatUIKitLocal.messagesViewShareContactAlertSubTitle.localString(context)}"%a"${ChatUIKitLocal.messagesViewShareContactAlertSubTitleTo.localString(context)}"%a"?',
                    [
                      model.profile.contactShowName,
                      controller.profile.contactShowName
                    ]),
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
                  if (value is ContactItemModel) {
                    controller.sendCardMessage(value.profile);
                    if (context.mounted) {
                      Navigator.of(context).pop(true);
                    }
                  } else {
                    if (context.mounted) {
                      Navigator.of(context).pop(false);
                    }
                  }
                }
              });
            },
          ),
        );
      },
    );

    ret = ret ?? false;
    return ret;
  }

  Future<void> playVoiceMessage(Message message) async {
    if (_playingMessage?.msgId == message.msgId) {
      _playingMessage = null;
      await stopSound();
    } else {
      await stopSound();
      File file = File(message.localPath!);
      if (!file.existsSync()) {
        await controller.downloadMessage(message);
        ChatUIKit.instance
            .sendChatUIKitEvent(ChatUIKitEvent.messageDownloading);
      } else {
        try {
          controller.playMessage(message);
          await playVoice(message.localPath!);
          _playingMessage = message;
          // ignore: empty_catches
        } catch (e) {
          chatPrint('playVoice: $e');
        }
      }
    }
    updateView();
  }

  Future<void> previewVoice(bool play, {String? path}) async {
    if (play) {
      await playVoice(path!);
    } else {
      await stopSound();
    }
  }

  Future<void> playVoice(String path) async {
    if (_player.state == PlayerState.playing) {
      await _player.stop();
    }

    await _player.play(DeviceFileSource(path));
    _player.onPlayerComplete.first.whenComplete(() async {
      _playingMessage = null;
      updateView();
    }).onError((error, stackTrace) {});
  }

  Future<void> stopSound() async {
    if (_player.state == PlayerState.playing) {
      await _player.stop();
      _playingMessage = null;
      updateView();
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

  void pushNextPage(ChatUIKitProfile profile) async {
    clearAllType();
    inputController.switchPanel(
      ChatUIKitKeyboardPanelType.none,
      duration: _keyboardPanelSwitchDuration,
    );
    popupMenuController?.hideMenu();
    // 如果点击的是自己头像
    if (profile.id == ChatUIKit.instance.currentUserId) {
      pushToCurrentUser(profile);
    } else if (profile.type == ChatUIKitProfileType.group) {
      // 点击的是群聊头像
      Group? group = await ChatUIKit.instance.getGroup(groupId: profile.id);
      pushToGroupInfo(profile, group);
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

  // 处理当前聊天对象是群时
  void pushToGroupInfo(ChatUIKitProfile profile, Group? group) {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.groupDetailsView,
      GroupDetailsViewArguments(
          profile: profile,
          attributes: widget.attributes,
          group: group,
          onMessageDidClear: () {
            replyMessage = null;
            controller.clearMessages();
          },
          actionsBuilder: (context, defaultList) {
            return [
              ChatUIKitDetailContentAction(
                title: ChatUIKitLocal.groupDetailViewSend.localString(context),
                icon: 'assets/images/chat.png',
                iconSize: const Size(32, 32),
                packageName: ChatUIKitImageLoader.packageName,
                onTap: (context) {
                  Navigator.of(context).pop();
                },
              ),
              ChatUIKitDetailContentAction(
                title:
                    ChatUIKitLocal.contactDetailViewSearch.localString(context),
                icon: 'assets/images/search_history.png',
                packageName: ChatUIKitImageLoader.packageName,
                iconSize: const Size(32, 32),
                onTap: (context) {
                  ChatUIKitRoute.pushOrPushNamed(
                    context,
                    ChatUIKitRouteNames.searchHistoryView,
                    SearchHistoryViewArguments(
                      profile: profile,
                      attributes: widget.attributes,
                    ),
                  ).then((value) {
                    if (value != null && value is Message) {
                      int count = 0;
                      if (context.mounted) {
                        Navigator.of(context).popUntil((route) {
                          count++;
                          if (count == 2) return true;
                          return route.settings.name ==
                                  ChatUIKitRouteNames.messagesView ||
                              route.isFirst;
                        });
                      }

                      controller.jumpToSearchedMessage(value);
                    }
                  });
                },
              ),
            ];
          }),
    ).then((value) {
      controller.refresh();
    });
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
          onMessageDidClear: () {
            replyMessage = null;
            controller.clearMessages();
          },
          actionsBuilder: (context, defaultList) {
            return [
              ChatUIKitDetailContentAction(
                title:
                    ChatUIKitLocal.contactDetailViewSend.localString(context),
                icon: 'assets/images/chat.png',
                iconSize: const Size(32, 32),
                packageName: ChatUIKitImageLoader.packageName,
                onTap: (ctx) {
                  ChatUIKitRoute.pop(context);
                },
              ),
              ChatUIKitDetailContentAction(
                title:
                    ChatUIKitLocal.contactDetailViewSearch.localString(context),
                icon: 'assets/images/search_history.png',
                packageName: ChatUIKitImageLoader.packageName,
                iconSize: const Size(32, 32),
                onTap: (context) {
                  ChatUIKitRoute.pushOrPushNamed(
                    context,
                    ChatUIKitRouteNames.searchHistoryView,
                    SearchHistoryViewArguments(
                      profile: profile,
                      attributes: widget.attributes,
                    ),
                  ).then((value) {
                    if (value != null && value is Message) {
                      int count = 0;
                      if (context.mounted) {
                        Navigator.of(context).popUntil((route) {
                          count++;
                          if (count == 2) return true;
                          return route.settings.name ==
                                  ChatUIKitRouteNames.messagesView ||
                              route.isFirst;
                        });
                      }
                      controller.jumpToSearchedMessage(value);
                    }
                  });
                },
              ),
            ];
          }),
    ).then((value) {
      controller.refresh();
    });
  }

  // 处理非好友信息
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
                ? theme.color.neutralColor9
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
                ? theme.color.neutralColor9
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
                ? theme.color.neutralColor9
                : theme.color.neutralColor3,
          ),
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor1,
            fontWeight: theme.font.labelMedium.fontWeight,
            fontSize: theme.font.labelMedium.fontSize,
          ),
          label: ChatUIKitLocal.forwardMessage.localString(context),
          onTap: () async {
            closeMenu();
            forwardMessage(
              [model.message],
              isMultiSelect: false,
            );
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
                ? theme.color.neutralColor9
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
            closeMenu();
            controller.enableMultiSelectMode();
          },
        ));
      }

      // 置顶
      if (model.message.status == MessageStatus.SUCCESS &&
          element == ChatUIKitActionType.pinMessage &&
          model.message.chatType == ChatType.GroupChat &&
          ChatUIKitSettings.enablePinMsg) {
        items.add(ChatUIKitEventAction.normal(
          actionType: ChatUIKitActionType.pinMessage,
          icon: ChatUIKitImageLoader.pinMessage(
            color: theme.color.isDark
                ? theme.color.neutralColor9
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
              ChatUIKitLocal.messageListLongPressMenuPin.localString(context),
          onTap: () async {
            closeMenu();
            pinMessageController?.pinMsg(model.message);
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
                ? theme.color.neutralColor9
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
            closeMenu();
            controller.translateMessage(
              model.message,
              showTranslate: !model.message.hasTranslate,
            );
          },
        ));
      }

      // 创建话题
      if (model.message.status == MessageStatus.SUCCESS &&
          model.message.chatType == ChatType.GroupChat &&
          element == ChatUIKitActionType.thread &&
          model.thread == null &&
          ChatUIKitSettings.enableMessageThread) {
        items.add(ChatUIKitEventAction.normal(
          actionType: ChatUIKitActionType.thread,
          label: ChatUIKitLocal.messageListLongPressMenuCreateThread
              .localString(context),
          icon: ChatUIKitImageLoader.messageLongPressThread(
            color: theme.color.isDark
                ? theme.color.neutralColor9
                : theme.color.neutralColor3,
          ),
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          onTap: () async {
            closeMenu();
            inputController.switchPanel(
              ChatUIKitKeyboardPanelType.none,
              duration: _keyboardPanelSwitchDuration,
            );
            ChatUIKitRoute.pushOrPushNamed(
              context,
              ChatUIKitRouteNames.threadMessagesView,
              ThreadMessagesViewArguments(
                controller: ThreadMessagesViewController(model: model),
                appBarModel: ChatUIKitAppBarModel(
                  title: model.message.showInfoTranslate(
                    context,
                    needShowName: false,
                  ),
                  subtitle: appBarModel?.subtitle,
                ),
                attributes: widget.attributes,
              ),
            );
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
                ? theme.color.neutralColor9
                : theme.color.neutralColor3,
          ),
          onTap: () async {
            closeMenu();
            textMessageEdit(model.message);
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
                ? theme.color.neutralColor9
                : theme.color.neutralColor3,
          ),
          onTap: () async {
            closeMenu();
            reportMessage(model);
          },
        ));
      }
      if (element == ChatUIKitActionType.delete) {
        // 删除
        items.add(ChatUIKitEventAction.normal(
          actionType: ChatUIKitActionType.delete,
          label: ChatUIKitLocal.messagesViewLongPressActionsTitleDelete
              .localString(context),
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          icon: ChatUIKitImageLoader.messageLongPressDelete(
            color: theme.color.isDark
                ? theme.color.neutralColor9
                : theme.color.neutralColor3,
          ),
          onTap: () async {
            closeMenu();
            deleteMessage(model);
          },
        ));
      }

      // 撤回
      if (model.message.status == MessageStatus.SUCCESS &&
          model.message.direction == MessageDirection.SEND &&
          model.message.serverTime >=
              DateTime.now().millisecondsSinceEpoch -
                  ChatUIKitSettings.recallExpandTime * 1000 &&
          element == ChatUIKitActionType.recall &&
          ChatUIKitSettings.enableMessageRecall) {
        items.add(ChatUIKitEventAction.normal(
          actionType: ChatUIKitActionType.recall,
          label: ChatUIKitLocal.messagesViewLongPressActionsTitleRecall
              .localString(context),
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          icon: ChatUIKitImageLoader.messageLongPressRecall(
            color: theme.color.isDark
                ? theme.color.neutralColor9
                : theme.color.neutralColor3,
          ),
          onTap: () async {
            closeMenu();
            recallMessage(model);
          },
        ));
      }
    }

    return items;
  }

  void attemptSendInputType() {
    controller.attemptSendInputType();
  }

  void forwardMessage(List<Message> messages, {bool isMultiSelect = false}) {
    clearAllType();
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.forwardMessageSelectView,
      ForwardMessageSelectViewArguments(
        messages: messages,
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
    List<MessageReaction>? reactions = model.reactions;

    void closeMenu() {
      if (ChatUIKitSettings.messageLongPressMenuStyle ==
          ChatUIKitMessageLongPressMenuStyle.bottomSheet) {
        Navigator.of(context).pop();
      }
    }

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
                showAllReactions(model);
                popupMenuController?.hideMenu();
              },
              child: ChatUIKitImageLoader.moreReactions(
                width: 36,
                height: 36,
                color: theme.color.isDark
                    ? theme.color.neutralColor9
                    : theme.color.neutralColor3,
              ),
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

  void pushThread() {
    inputController.switchPanel(
      ChatUIKitKeyboardPanelType.none,
      duration: _keyboardPanelSwitchDuration,
    );
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.threadsView,
      ThreadsViewArguments(
        profile: controller.profile,
        attributes: widget.attributes,
      ),
    );
  }

  void showPinMsgsView() async {
    await pinMessageController?.fetchPinMessages();
  }

  void showAllReactions(MessageModel model) {
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

  void showThread(BuildContext context, MessageModel model) {
    inputController.switchPanel(
      ChatUIKitKeyboardPanelType.none,
      duration: _keyboardPanelSwitchDuration,
    );
    popupMenuController?.hideMenu();
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.threadMessagesView,
      ThreadMessagesViewArguments(
        controller: ThreadMessagesViewController(model: model),
        appBarModel: ChatUIKitAppBarModel(
          title: model.thread?.threadName ??
              model.message.showInfoTranslate(
                context,
                needShowName: true,
              ),
          subtitle: appBarModel?.subtitle,
        ),
        attributes: widget.attributes,
      ),
    );
  }

  Widget floatingUnreadWidget() {
    if (controller.cacheMessages.isEmpty) return const SizedBox();
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton.icon(
          onPressed: () {
            controller.addAllCacheToList();
          },
          icon: const Icon(Icons.arrow_downward),
          label: Text(
            "${controller.cacheMessages.length} ${ChatUIKitLocal.floatingUnreadMessage.localString(context)}",
            textScaler: TextScaler.noScaling,
            style: TextStyle(
              color: theme.color.isDark
                  ? theme.color.primaryColor6
                  : theme.color.primaryColor5,
              fontWeight: theme.font.labelMedium.fontWeight,
              fontSize: theme.font.labelMedium.fontSize,
            ),
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            backgroundColor: MaterialStateProperty.all(
              theme.color.isDark
                  ? theme.color.neutralColor2
                  : theme.color.neutralColor98,
            ),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            elevation: MaterialStateProperty.all(0),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            foregroundColor: MaterialStateProperty.all(
              theme.color.isDark
                  ? theme.color.primaryColor6
                  : theme.color.primaryColor5,
            ),
            side: MaterialStateProperty.all<BorderSide>(
              BorderSide(
                color: theme.color.isDark
                    ? theme.color.neutralColor3
                    : theme.color.neutralColor9,
              ),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget voicePanel() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () async {
          stopSound();
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
                  mention: editController?.mentionList,
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
