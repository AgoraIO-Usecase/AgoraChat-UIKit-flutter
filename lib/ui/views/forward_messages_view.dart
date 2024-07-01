import '../../chat_uikit.dart';
import '../../universal/inner_headers.dart';

import 'package:flutter/material.dart';

class ForwardMessagesView extends StatefulWidget {
  ForwardMessagesView.arguments(
    ForwardMessagesViewArguments arguments, {
    super.key,
  })  : message = arguments.message,
        enableAppBar = arguments.enableAppBar,
        appBarModel = arguments.appBarModel,
        viewObserver = arguments.viewObserver,
        summaryBuilder = arguments.summaryBuilder,
        attributes = arguments.attributes;

  const ForwardMessagesView({
    required this.message,
    required this.enableAppBar,
    this.appBarModel,
    this.attributes,
    this.summaryBuilder,
    this.viewObserver,
    super.key,
  });

  final Message message;
  final bool enableAppBar;
  final ChatUIKitAppBarModel? appBarModel;
  final String? attributes;
  final String? Function(BuildContext context, Message message)? summaryBuilder;
  final ChatUIKitViewObserver? viewObserver;

  @override
  State<ForwardMessagesView> createState() => _ForwardMessagesViewState();
}

class _ForwardMessagesViewState extends State<ForwardMessagesView>
    with ChatObserver {
  late final Message message;
  bool downloading = false;
  ChatUIKitAppBarModel? appBarModel;
  List<MessageModel> models = [];
  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    widget.viewObserver?.addListener(() => setState(() {}));
    message = widget.message;
    fetchCombineList();
  }

  @override
  void dispose() {
    widget.viewObserver?.dispose();
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  void fetchCombineList() async {
    try {
      downloading = true;
      List<Message> fetchedMsgs =
          await ChatUIKit.instance.fetchCombineMessageDetail(message: message);
      models.addAll(fetchedMsgs.map((e) => MessageModel(message: e)));
    } on ChatError catch (e) {
      chatPrint('download error: $e');
    } finally {
      downloading = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void updateAppBarModel(ChatUIKitTheme theme) {
    appBarModel = ChatUIKitAppBarModel(
      title: widget.appBarModel?.title ??
          ChatUIKitLocal.historyMessages.localString(context),
      centerWidget: widget.appBarModel?.centerWidget,
      titleTextStyle: widget.appBarModel?.titleTextStyle,
      subtitle: widget.appBarModel?.subtitle,
      subTitleTextStyle: widget.appBarModel?.subTitleTextStyle,
      leadingActions: widget.appBarModel?.leadingActions ??
          widget.appBarModel?.leadingActionsBuilder?.call(context, null),
      trailingActions: widget.appBarModel?.trailingActions ??
          widget.appBarModel?.trailingActionsBuilder?.call(context, null),
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
    Widget? content;
    if (downloading == true) {
      content = Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: theme.color.isDark
                ? theme.color.neutralColor4
                : theme.color.neutralColor7,
          ),
        ),
      );
    } else if (models.isNotEmpty) {
      content = historyWidget(theme);
    } else {
      content = Center(
        child: Text(
            ChatUIKitLocal.forwardedMessageDownloadError.localString(context)),
      );
    }

    content = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: widget.enableAppBar ? ChatUIKitAppBar.model(appBarModel!) : null,
      body: SafeArea(child: content),
    );

    return content;
  }

  Widget historyWidget(ChatUIKitTheme theme) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return item(models[index], theme);
      },
      separatorBuilder: (context, index) {
        return Divider(
          indent: 58,
          endIndent: 0,
          height: .5,
          thickness: .5,
          color: theme.color.isDark
              ? theme.color.neutralColor3
              : theme.color.neutralColor9,
        );
      },
      itemCount: models.length,
    );
  }

  Widget item(MessageModel model, ChatUIKitTheme theme) {
    Widget content;
    switch (model.message.body.type) {
      case MessageType.TXT:
        content = textWidget(model, theme);
        break;
      case MessageType.IMAGE:
        content = imageWidget(model, theme);
        break;
      case MessageType.VIDEO:
        content = videoWidget(model, theme);
        break;
      case MessageType.VOICE:
        content = voiceWidget(model, theme);
        break;
      case MessageType.LOCATION:
        content = locationWidget(model, theme);
        break;
      case MessageType.COMBINE:
        content = combineWidget(model, theme);
        break;
      case MessageType.FILE:
        content = fileWidget(model, theme);
        break;
      case MessageType.CUSTOM:
        if (model.message.isCardMessage) {
          content = cardWidget(model, theme);
        } else {
          content = const SizedBox();
        }
        break;
      default:
        content = const SizedBox();
    }

    ChatUIKitProfile? profile =
        ChatUIKitProvider.instance.profilesCache[model.message.from!];

    Widget titleRow = Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            profile?.showName ?? model.message.nickname ?? model.message.from!,
            textScaler: TextScaler.noScaling,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: theme.color.isDark
                  ? theme.color.neutralSpecialColor6
                  : theme.color.neutralSpecialColor5,
              fontSize: theme.font.titleSmall.fontSize,
              fontWeight: theme.font.titleSmall.fontWeight,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          ChatUIKitTimeFormatter.instance.formatterHandler?.call(context,
                  ChatUIKitTimeType.conversation, model.message.serverTime) ??
              ChatUIKitTimeTool.getChatTimeStr(model.message.serverTime),
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor6
                : theme.color.neutralColor5,
            fontSize: theme.font.bodySmall.fontSize,
            fontWeight: theme.font.bodySmall.fontWeight,
          ),
        ),
      ],
    );

    content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        ChatUIKitAvatar(
            avatarUrl: profile?.avatarUrl ?? model.message.avatarUrl),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleRow,
              content,
            ],
          ),
        )
      ],
    );

    content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: content,
    );

    return content;
  }

  Widget textWidget(MessageModel model, ChatUIKitTheme theme) {
    final body = model.message.body as TextMessageBody;
    return ChatUIKitEmojiRichText(
      emojiSize: const Size(16, 16),
      text: body.content,
      selectable: true,
      style: TextStyle(
        fontWeight: theme.font.bodyMedium.fontWeight,
        fontSize: theme.font.bodyMedium.fontSize,
        color: theme.color.isDark
            ? theme.color.neutralColor98
            : theme.color.neutralColor1,
      ),
    );
  }

  Widget imageWidget(MessageModel model, ChatUIKitTheme theme) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        ChatUIKitRoute.pushOrPushNamed(
            context,
            ChatUIKitRouteNames.showImageView,
            ShowImageViewArguments(
              message: model.message,
              attributes: widget.attributes,
              isCombine: true,
            ));
      },
      child: ChatUIKitImageBubbleWidget(
        model: model,
        isCombine: true,
      ),
    );
  }

  Widget voiceWidget(MessageModel model, ChatUIKitTheme theme) {
    final body = message.body as VoiceMessageBody;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "${[ChatUIKitLocal.messageCellCombineVoice.localString(context)]}",
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            textBaseline: TextBaseline.alphabetic,
            fontWeight: theme.font.bodyMedium.fontWeight,
            fontSize: theme.font.bodyMedium.fontSize,
          ),
        ),
        Text(
          " ${body.duration}'",
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            textBaseline: TextBaseline.alphabetic,
            fontWeight: theme.font.bodyMedium.fontWeight,
            fontSize: theme.font.bodyMedium.fontSize,
          ),
        )
      ],
    );
  }

  Widget videoWidget(MessageModel model, ChatUIKitTheme theme) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        ChatUIKitRoute.pushOrPushNamed(
            context,
            ChatUIKitRouteNames.showVideoView,
            ShowVideoViewArguments(
              message: model.message,
              attributes: widget.attributes,
              isCombine: true,
            ));
      },
      child: ChatUIKitVideoBubbleWidget(model: model, isCombine: true),
    );
  }

  Widget locationWidget(MessageModel model, ChatUIKitTheme theme) {
    final body = message.body as LocationMessageBody;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "${[ChatUIKitLocal.messageCellCombineLocation.localString(context)]}",
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            textBaseline: TextBaseline.alphabetic,
            fontWeight: theme.font.bodyMedium.fontWeight,
            fontSize: theme.font.bodyMedium.fontSize,
          ),
        ),
        Text(
          " ${body.address ?? ''}'",
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            textBaseline: TextBaseline.alphabetic,
            fontWeight: theme.font.bodyMedium.fontWeight,
            fontSize: theme.font.bodyMedium.fontSize,
          ),
        )
      ],
    );
  }

  Widget cardWidget(MessageModel model, ChatUIKitTheme theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "${[ChatUIKitLocal.messageCellCombineContact.localString(context)]}",
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            textBaseline: TextBaseline.alphabetic,
            fontWeight: theme.font.bodyMedium.fontWeight,
            fontSize: theme.font.bodyMedium.fontSize,
          ),
        ),
        Text(
          " ${model.message.cardUserNickname ?? model.message.cardUserId ?? ''}",
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            textBaseline: TextBaseline.alphabetic,
            fontWeight: theme.font.bodyMedium.fontWeight,
            fontSize: theme.font.bodyMedium.fontSize,
          ),
        )
      ],
    );
  }

  Widget combineWidget(MessageModel model, ChatUIKitTheme theme) {
    return Text(
      "${[ChatUIKitLocal.messageCellCombineCombine.localString(context)]}",
      textScaler: TextScaler.noScaling,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        textBaseline: TextBaseline.alphabetic,
        fontWeight: theme.font.bodyMedium.fontWeight,
        fontSize: theme.font.bodyMedium.fontSize,
      ),
    );
  }

  Widget fileWidget(MessageModel model, ChatUIKitTheme theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "${[ChatUIKitLocal.messageCellCombineFile.localString(context)]}",
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            textBaseline: TextBaseline.alphabetic,
            fontWeight: theme.font.bodyMedium.fontWeight,
            fontSize: theme.font.bodyMedium.fontSize,
          ),
        ),
        Text(
          " ${model.message.displayName}",
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            textBaseline: TextBaseline.alphabetic,
            fontWeight: theme.font.bodyMedium.fontWeight,
            fontSize: theme.font.bodyMedium.fontSize,
          ),
        )
      ],
    );
  }
}
