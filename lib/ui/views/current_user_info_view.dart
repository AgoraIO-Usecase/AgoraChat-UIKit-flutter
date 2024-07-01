import '../../chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrentUserInfoView extends StatefulWidget {
  CurrentUserInfoView.arguments(CurrentUserInfoViewArguments arguments,
      {super.key})
      : profile = arguments.profile,
        appBarModel = arguments.appBarModel,
        viewObserver = arguments.viewObserver,
        enableAppBar = arguments.enableAppBar,
        attributes = arguments.attributes;

  const CurrentUserInfoView({
    required this.profile,
    this.appBarModel,
    this.attributes,
    this.enableAppBar = true,
    this.viewObserver,
    super.key,
  });
  final ChatUIKitProfile profile;
  final ChatUIKitAppBarModel? appBarModel;
  final String? attributes;
  final bool enableAppBar;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;

  @override
  State<CurrentUserInfoView> createState() => _CurrentUserInfoViewState();
}

class _CurrentUserInfoViewState extends State<CurrentUserInfoView>
    with ChatUIKitProviderObserver {
  ChatUIKitProfile? profile;

  ChatUIKitAppBarModel? appBarModel;

  @override
  void initState() {
    super.initState();
    profile = widget.profile;
    ChatUIKitProvider.instance.addObserver(this);
    ChatUIKitProvider.instance.getProfile(profile!, force: true);
    widget.viewObserver?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    ChatUIKitProvider.instance.removeObserver(this);
    widget.viewObserver?.dispose();
    super.dispose();
  }

  @override
  void onProfilesUpdate(
    Map<String, ChatUIKitProfile> map,
  ) {
    if (map.keys.contains(profile?.id)) {
      setState(() {
        profile = map[profile?.id];
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
    Widget avatar = ChatUIKitAvatar(
      avatarUrl: ChatUIKitProvider.instance.currentUserProfile?.avatarUrl,
      size: 100,
    );

    Widget name = Text(
      ChatUIKitProvider.instance.currentUserProfile?.showName ??
          ChatUIKit.instance.currentUserId ??
          '',
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
      'ID: ${widget.profile.id}',
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
            Clipboard.setData(ClipboardData(text: widget.profile.id));
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

    Widget content = Column(
      children: [
        const SizedBox(height: 20),
        avatar,
        const SizedBox(height: 12),
        name,
        const SizedBox(height: 4),
        row,
        const SizedBox(height: 20),
      ],
    );

    return content;
  }
}
