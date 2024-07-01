import 'package:agora_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/demo_localizations.dart';
import 'package:em_chat_uikit_example/pages/contact/contact_page.dart';
import 'package:em_chat_uikit_example/pages/conversation/conversation_page.dart';
import 'package:em_chat_uikit_example/pages/me/my_page.dart';
import 'package:em_chat_uikit_example/tool/toast_page.dart';
import 'package:em_chat_uikit_example/widgets/user_provider_widget.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with
        AutomaticKeepAliveClientMixin,
        ChatObserver,
        ContactObserver,
        ChatUIKitEventsObservers,
        ChatSDKEventsObserver {
  int _currentIndex = 0;

  ValueNotifier<int> unreadMessageCount = ValueNotifier(0);
  ValueNotifier<int> contactRequestCount = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    ChatUIKit.instance.addObserver(this);
    // 更新未读消息
    onConversationsUpdate();
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  List<Widget> _pages(BuildContext context) {
    return const [ConversationPage(), ContactPage(), MyPage()];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = ChatUIKitTheme.of(context);

    Widget content = Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages(context),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        selectedLabelStyle: TextStyle(
          fontSize: theme.font.labelExtraSmall.fontSize,
          fontWeight: theme.font.labelExtraSmall.fontWeight,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: theme.font.labelExtraSmall.fontSize,
          fontWeight: theme.font.labelExtraSmall.fontWeight,
        ),
        backgroundColor: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
        selectedItemColor: theme.color.isDark
            ? theme.color.primaryColor6
            : theme.color.primaryColor5,
        unselectedItemColor: theme.color.isDark
            ? theme.color.neutralColor3
            : theme.color.neutralColor5,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        currentIndex: _currentIndex,
        items: [
          CustomBottomNavigationBarItem(
            label: DemoLocalizations.chat.localString(context),
            image: 'assets/images/chat.png',
            unreadCountWidget: ValueListenableBuilder(
              valueListenable: unreadMessageCount,
              builder: (context, value, child) {
                return ChatUIKitBadge(
                  value,
                  textColor: theme.color.neutralColor98,
                  backgroundColor: theme.color.isDark
                      ? theme.color.errorColor6
                      : theme.color.errorColor5,
                );
              },
            ),
            borderColor: theme.color.isDark
                ? theme.color.neutralColor1
                : theme.color.neutralColor98,
            isSelect: _currentIndex == 0,
            imageSelectColor: theme.color.primaryColor5,
            imageUnSelectColor: theme.color.neutralColor5,
          ),
          CustomBottomNavigationBarItem(
            label: DemoLocalizations.contacts.localString(context),
            image: 'assets/images/contact.png',
            unreadCountWidget: ValueListenableBuilder(
              valueListenable: contactRequestCount,
              builder: (context, value, child) {
                return ChatUIKitBadge(
                  value,
                  textColor: theme.color.neutralColor98,
                  backgroundColor: theme.color.isDark
                      ? theme.color.errorColor6
                      : theme.color.errorColor5,
                );
              },
            ),
            isSelect: _currentIndex == 1,
            borderColor: theme.color.isDark
                ? theme.color.neutralColor1
                : theme.color.neutralColor98,
            imageSelectColor: theme.color.primaryColor5,
            imageUnSelectColor: theme.color.neutralColor5,
          ),
          CustomBottomNavigationBarItem(
            label: DemoLocalizations.me.localString(context),
            image: 'assets/images/me.png',
            isSelect: _currentIndex == 2,
            imageSelectColor: theme.color.primaryColor5,
            imageUnSelectColor: theme.color.neutralColor5,
          )
        ],
      ),
    );

    content = ToastPage(child: content);

    content = UserProviderWidget(child: content);

    return content;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  // 用于刷新消息未读数
  void onMessagesReceived(List<Message> messages) {
    ChatUIKit.instance.getUnreadMessageCount().then((value) {
      unreadMessageCount.value = value;
    });
  }

  @override
  void onConversationsUpdate() {
    ChatUIKit.instance.getUnreadMessageCount().then((value) {
      unreadMessageCount.value = value;
    });
  }

  // 用于更新好友请求未读数
  @override
  void onFriendRequestCountChanged(int count) {
    contactRequestCount.value = count;
  }

  @override
  // 用于刷新消息和联系人未读数
  void onChatSDKEventEnd(ChatSDKEvent event, ChatError? error) {
    if (event == ChatSDKEvent.acceptContactRequest ||
        event == ChatSDKEvent.declineContactRequest ||
        event == ChatSDKEvent.markConversationAsRead ||
        event == ChatSDKEvent.setSilentMode ||
        event == ChatSDKEvent.clearSilentMode) {
      setState(() {});
    }
  }
}

class CustomBottomNavigationBarItem extends BottomNavigationBarItem {
  CustomBottomNavigationBarItem({
    required this.image,
    required super.label,
    this.imageUnSelectColor,
    this.imageSelectColor,
    this.unreadCountWidget,
    this.isSelect = false,
    this.borderColor,
  }) : super(
          icon: Stack(
            children: [
              SizedBox(
                width: 76,
                height: 34,
                child: Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4, top: 10),
                    child: Image.asset(
                      image,
                      fit: BoxFit.contain,
                      color: isSelect ? imageSelectColor : imageUnSelectColor,
                    )),
              ),
              Positioned(
                  top: 0,
                  left: 36,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: borderColor ?? Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: unreadCountWidget ?? const SizedBox(),
                  ))
            ],
          ),
        );

  final String image;
  final Widget? unreadCountWidget;
  final Color? imageUnSelectColor;
  final Color? imageSelectColor;
  final Color? borderColor;
  final bool isSelect;
}
