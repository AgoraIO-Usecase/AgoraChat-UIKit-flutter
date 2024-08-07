import 'package:agora_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/demo_localizations.dart';
import 'package:em_chat_uikit_example/widgets/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with ChatUIKitProviderObserver {
  ChatUIKitProfile? _userProfile;
  bool isLight = true;
  @override
  void initState() {
    super.initState();
    ChatUIKitProvider.instance.addObserver(this);
    _userProfile = ChatUIKitProvider.instance.currentUserProfile;
  }

  @override
  void dispose() {
    ChatUIKitProvider.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onProfilesUpdate(Map<String, ChatUIKitProfile> map) {
    if (map.keys.contains(ChatUIKit.instance.currentUserId)) {
      setState(() {
        _userProfile = map[ChatUIKit.instance.currentUserId];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: ChatUIKitAppBar(
        showBackButton: false,
        backgroundColor: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: _buildContent(),
      ),
    );

    return content;
  }

  Widget _buildContent() {
    final theme = ChatUIKitTheme.of(context);

    Widget name = Text(
      _userProfile?.showName ?? ChatUIKit.instance.currentUserId ?? '',
      textScaler: TextScaler.noScaling,
      overflow: TextOverflow.ellipsis,
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
      'ID: ${ChatUIKit.instance.currentUserId}',
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
          onTap: () {
            Clipboard.setData(
                ClipboardData(text: ChatUIKit.instance.currentUserId ?? ''));
            ChatUIKit.instance.sendChatUIKitEvent(
              ChatUIKitEvent.userIdCopied,
            );
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
        const SizedBox(height: 12),
        name,
        const SizedBox(height: 4),
        row,
      ],
    );

    content = ListView(
      children: [
        content,
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Text(DemoLocalizations.settings.localString(context),
              textScaler: TextScaler.noScaling),
        ),
        ListItem(
          imageWidget: Image.asset('assets/images/settings.png'),
          title: DemoLocalizations.general.localString(context),
          enableArrow: true,
          onTap: generalSettings,
        ),
        ListItem(
          imageWidget: Image.asset('assets/images/notifications.png'),
          title: DemoLocalizations.notification.localString(context),
          onTap: nonsupport,
        ),
        ListItem(
          imageWidget: Image.asset('assets/images/info.png'),
          title: DemoLocalizations.about.localString(context),
          enableArrow: true,
          onTap: about,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: InkWell(
            onTap: () {
              logout();
            },
            child: Text(
              DemoLocalizations.logout.localString(context),
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                fontWeight: theme.font.titleMedium.fontWeight,
                fontSize: theme.font.titleMedium.fontSize,
                color: theme.color.isDark
                    ? theme.color.primaryColor6
                    : theme.color.primaryColor5,
              ),
            ),
          ),
        ),
      ],
    );

    return content;
  }

  void generalSettings() {
    Navigator.of(context).pushNamed('/general_page').then(
      (value) {
        setState(() {});
      },
    );
  }

  void about() {
    Navigator.of(context).pushNamed('/about_page').then(
      (value) {
        setState(() {});
      },
    );
  }

  void nonsupport() {
    showChatUIKitDialog(
      title: '暂不支持',
      context: context,
      actionItems: [
        ChatUIKitDialogAction.confirm(
          label: '确定',
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void logout() {
    showChatUIKitDialog(
      title: DemoLocalizations.logoutTitle.localString(context),
      context: context,
      actionItems: [
        ChatUIKitDialogAction.cancel(
          label: DemoLocalizations.logoutCancel.localString(context),
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogAction.confirm(
          label: DemoLocalizations.logoutConfirm.localString(context),
          onTap: () async {
            Navigator.of(context).pop();
            ChatUIKit.instance.logout().then((value) {
              toLoginPage();
            });
          },
        ),
      ],
    );
  }

  void toLoginPage() {
    Navigator.of(context).popAndPushNamed('/login');
  }
}
