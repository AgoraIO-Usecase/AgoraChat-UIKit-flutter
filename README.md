# Get Started with Chat UIKit for Flutter

## Overview

Instant messaging connects people wherever they are and allows them to communicate with others in real time. With built-in user interfaces (UI) for the message list, the [Chat UIKit](https://github.com/AgoraIO-Usecase/AgoraChat-UIKit-flutter) enables you to quickly embed real-time messaging into your app without requiring extra effort on the UI.

Agora offers an open-source agora_chat_uikit project on GitHub. You can clone and run the project or refer to the logic in it to create projects integrating agora_chat_uikit.

Source code URL of agora_chat_uikit for Flutter:

https://github.com/AgoraIO-Usecase/AgoraChat-UIKit-flutter


## Important features

- Conversation List;
- Chatting in a conversation;
- Voice message;
- Text message;
- File message;
- Delivery receipt;

## Function

The `agora_chat_uikit` library provides the following functions:

- Sends and receives messages, displays messages, shows the unread message count, and clears messages. The text, image, emoji, file, and audio messages are supported.
- Deletes conversations and messages.
- Customizes the UI.

<table>
  <tr>
    <td>Widget</td>
    <td>Function</td>
    <td>Description</td>
  </tr>
  <tr>
    <td> ChatUIKit </td>
    <td></td>
    <td> The root of all widgets in ChatUIKit. </td>
  </tr>
    <td rowspan="2"> ChatConversationsView </td>
    <td> Conversation list </td>
    <td> Presents the conversation information, including the user's avatar and nickname, content of the last message, unread message count, and the time when the last message is sent or received.</td>
  <tr>
    <td>Delete conversation</td>
    <td>Deletes the conversation from the conversation list.</td>
  </tr>
  <tr>
    <td rowspan="6">ChatMessagesView</td>
    <td>Message sender</td>
    <td>Sends text, emoji, image, file, and voice messages.</td>
  </tr>
  <tr>
    <td>Delete messages</td>
    <td>Deletes messages.</td>
  </tr>
  <tr>
    <td>Recall message</td>
    <td>Recalls message that are sent within 120 seconds.</td>
  </tr>  
  <tr>
    <td>Read mark</td>
    <td>You will receive a read receipt after retrieving your message.</td>
  </tr>
  <tr>
    <td>Message sent state</td>
    <td>Display the status after the message is sent.</td>
  </tr>
  <tr>
    <td>Display message</td>
    <td>Displays one-to-one messages and group messages, including the user's avatar and nickname and the message's content, sending time or reception time, sending status, and read status. The text, image, emoji, file, voice, and video messages can be displayed.</td> 
  </tr>
  
</table>


## Dependencies

The following third-party UI libraries are used in Agora_chat_uikit:

```dart
dependencies:
  intl: ^0.18.0
  image_picker: ^1.0.4
  file_picker: ^5.5.0
  record: ^4.4.4
  audioplayers: ^5.2.0
  agora_chat_sdk: ^1.1.1
```

## Permissions

### Android

```dart
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
```

### iOS

In `Info.plist`， add the following permissions:

| Key | Type | Value |
| :------------ | :----- | :------- | 
| `Privacy - Microphone Usage Description` | String | For microphone access |
| `Privacy - Camera Usage Description` | String | For camera access |
| `Privacy - Photo Library Usage Description` | String | For photo library access |

## Prevent code obfuscation

In the `example/android/app/proguard-rules.pro` file, add the following lines to prevent code obfuscation:

```gradle
-keep class com.hyphenate.** {*;}
-dontwarn  com.hyphenate.**
```

## Integrate the UIKit

### Create a new project and add UIKit.

```sh
flutter create uikit_demo --platforms=ios,android -i objc -a java
```

#### pub.dev integration (Recommended)

Execute in the `uikit_demo` directory.

```sh
cd uikit_demo
```

```dart
flutter pub add agora_chat_uikit
flutter pub get
```

#### Local integration

You can download the project to your computer and execute it.

```dart
dependencies:
    agora_chat_uikit:
        path: `<#uikit path#>`
```

Replace the code in 'lib/main.dart'.

```dart
import 'package:flutter/material.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';

import 'messages_page.dart';

class ChatConfig {
  static const String appKey = "";
  static const String userId = "";
  static const String agoraToken = '';
}

void main() async {
  assert(ChatConfig.appKey.isNotEmpty,
      "You need to configure AppKey information first.");
  WidgetsFlutterBinding.ensureInitialized();
  final options = ChatOptions(
    appKey: ChatConfig.appKey,
    autoLogin: false,
  );
  await ChatClient.getInstance.init(options);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) {
        // ChatUIKit widget at the top of the widget
        return ChatUIKit(child: child!);
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MyHomePage(title: 'Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController scrollController = ScrollController();
  ChatConversation? conversation;
  String _chatId = "";
  final List<String> _logText = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10),
            const Text("login userId: ${ChatConfig.userId}"),
            const Text("agoraToken: ${ChatConfig.agoraToken}"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      _signIn();
                    },
                    child: const Text("SIGN IN"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _signOut();
                    },
                    child: const Text("SIGN OUT"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Enter recipient's userId",
                    ),
                    onChanged: (chatId) => _chatId = chatId,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    pushToChatPage(_chatId);
                  },
                  child: const Text("START CHAT"),
                ),
              ],
            ),
            Flexible(
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (_, index) {
                  return Text(_logText[index]);
                },
                itemCount: _logText.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void pushToChatPage(String userId) async {
    if (userId.isEmpty) {
      _addLogToConsole('UserId is null');
      return;
    }
    if (ChatClient.getInstance.currentUserId == null) {
      _addLogToConsole('user not login');
      return;
    }
    ChatConversation? conv =
        await ChatClient.getInstance.chatManager.getConversation(userId);
    Future(() {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return MessagesPage(conv!);
      }));
    });
  }

  void _signIn() async {
    _addLogToConsole('begin sign in...');
    try {
      bool judgmentPwdOrToken = false;
      do {
        if (ChatConfig.agoraToken.isNotEmpty) {
          await ChatClient.getInstance.login(
            ChatConfig.userId,
            ChatConfig.agoraToken,
          );
          judgmentPwdOrToken = true;
          break;
        }
      } while (false);
      if (judgmentPwdOrToken) {
        _addLogToConsole('sign in success');
      } else {
        _addLogToConsole(
            'sign in fail: The password and agoraToken cannot both be null.');
      }
    } on ChatError catch (e) {
      _addLogToConsole('sign in fail: ${e.description}');
    }
  }

  void _signOut() async {
    _addLogToConsole('begin sign out...');
    try {
      await ChatClient.getInstance.logout();
      _addLogToConsole('sign out success');
    } on ChatError catch (e) {
      _addLogToConsole('sign out fail: ${e.description}');
    }
  }

  void _addLogToConsole(String log) {
    _logText.add("$_timeString: $log");
    setState(() {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  String get _timeString {
    return DateTime.now().toString().split(".").first;
  }
}

```

Create a messages page.

```dart
import 'package:flutter/material.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage(this.conversation, {super.key});

  final ChatConversation conversation;

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversation.id),
      ),
      body: SafeArea(
        // Message page in uikit.
        child: ChatMessagesView(
          conversation: widget.conversation,
        ),
      ),
    );
  }
}

```

## Customize

You can test it quickly in [example](./example).

Configure the following information in the `example/lib/main.dart` file:

Replaces `appKey`, `userId`, and `agoraToken` and with your own App Key, user ID, and user token generated in Agora Console.

```dart
class ChatConfig {
  static const String appKey = "";
  static const String userId = "";
  static const String agoraToken = '';
}
```

### Customize colors

You can set the color when adding `ChatUIKit`. See `ChatUIKitTheme`.

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) {
        // ChatUIKit widget at the top of the widget
        return ChatUIKit(
          // ChatUIKitTheme
          theme: ChatUIKitTheme(),
          child: child!,
        );
      },
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
```

### Add an avatar

```dart
class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.conversation.id)),
      body: SafeArea(
        // Message page in uikit.
        child: ChatMessagesView(
          conversation: widget.conversation,
          avatarBuilder: (context, userId) {
            // Returns the avatar widget that you want to display.
            return Container(
              width: 30,
              height: 30,
              color: Colors.red,
            );
          },
        ),
      ),
    );
  }
}
```

### Add a nickname

```dart
class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.conversation.id)),
      body: SafeArea(
        // Message page in uikit.
        child: ChatMessagesView(
          conversation: widget.conversation,
          // Returns the nickname widget that you want to display.
          nicknameBuilder: (context, userId) {
            return Text(userId);
          },
        ),
      ),
    );
  }
}
```

### Add the bubble click event

```dart
class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.conversation.id)),
      body: SafeArea(
        // Message page in uikit.
        child: ChatMessagesView(
          conversation: widget.conversation,
          // item tap event
          onTap: (context, message) {
            bubbleClicked(message);
            return true;
          },
        ),
      ),
    );
  }

  void bubbleClicked(ChatMessage message) {
    debugPrint('bubble clicked');
  }
}
```

### Customize the message item widget

```dart
class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.conversation.id)),
      body: SafeArea(
        // Message page in uikit.
        child: ChatMessagesView(
          conversation: widget.conversation,
          itemBuilder: (context, model) {
            if (model.message.body.type == MessageType.TXT) {
              // Custom message bubble
              return CustomTextItemWidget(
                model: model,
                onTap: (context, message) {
                  bubbleClicked(message);
                  return true;
                },
              );
            }
          },
        ),
      ),
    );
  }

  void bubbleClicked(ChatMessage message) {
    debugPrint('bubble clicked');
  }
}

// Custom message bubble
class CustomTextItemWidget extends ChatMessageListItem {
  const CustomTextItemWidget({super.key, required super.model, super.onTap});

  @override
  Widget build(BuildContext context) {
    ChatTextMessageBody body = model.message.body as ChatTextMessageBody;

    Widget content = Text(
      body.content,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 50,
        fontWeight: FontWeight.w400,
      ),
    );
    return getBubbleWidget(content);
  }
}

```

### Customize the input widget

```dart
class _MessagesPageState extends State<MessagesPage> {
  late ChatMessageListController _msgController;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _msgController = ChatMessageListController(widget.conversation);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.conversation.id)),
      body: SafeArea(
        // Message page in uikit.
        child: ChatMessagesView(
          conversation: widget.conversation,
          messageListViewController: _msgController,
          inputBar: customInputWidget(),
          needDismissInputWidget: () {
            _focusNode.unfocus();
          },
        ),
      ),
    );
  }

  // custom input widget
  Widget customInputWidget() {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: _textController,
            ),
          ),
          ElevatedButton(
              onPressed: () {
                final msg = ChatMessage.createTxtSendMessage(
                    targetId: widget.conversation.id,
                    content: _textController.text);
                _textController.text = '';
                _msgController.sendMessage(msg);
              },
              child: const Text('Send'))
        ],
      ),
    );
  }
}

```

### Delete all Messages in the current conversation

```dart
class _MessagesPageState extends State<MessagesPage> {
  late ChatMessageListController _msgController;

  @override
  void initState() {
    super.initState();
    _msgController = ChatMessageListController(widget.conversation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversation.id),
        actions: [
          TextButton(
              onPressed: () {
                _msgController.deleteAllMessages();
              },
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: SafeArea(
        // Message page in uikit.
        child: ChatMessagesView(
          conversation: widget.conversation,
          messageListViewController: _msgController,
        ),
      ),
    );
  }
}
```

### Customize actions displayed upon a click of the plus symbol in the page

```dart
class _MessagesPageState extends State<MessagesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversation.id),
      ),
      body: SafeArea(
        // Message page in uikit.
        child: ChatMessagesView(
          conversation: widget.conversation,
          // Returns a list of custom events
          inputBarMoreActionsOnTap: (items) {
            ChatBottomSheetItem item = ChatBottomSheetItem(
              type: ChatBottomSheetItemType.normal,
              onTap: customMoreAction,
              label: 'more',
            );

            return items + [item];
          },
        ),
      ),
    );
  }

  Future<void> customMoreAction() async {
    debugPrint('custom action');
    Navigator.of(context).pop();
  }
}
```

## ChatUIKit introduce

You need have a `ChatUIKit` widget at the top of you widget tree. It will help you refresh `ChatConversationsView` when you return from `ChatMessagesView`. It also provides the theme Settings.

| Prop | Description |
| :-------------- | :----- |
| theme | Chat UIKit theme for setting component styles. If this prop is not set, the default style will be used.|

For more information, see `ChatUIKit`.

```dart
ChatUIKit({
    super.key,
    this.child,
    ChatUIKitTheme? theme,
});
```

### ChatMessagesView

`ChatMessagesView` is used to manage text, image, emoji, file, and voice messages:

- Sends and receives messages.
- Deletes messages.
- Recalls messages.

| Prop | Prop Description |
| :-------------- | :----- |
| conversation | The ChatConversation to which the messages belong. |
| inputBarTextEditingController | Text input widget text editing controller. |
| background | The background widget.|
| inputBar | Text input component. If you don't pass in this prop, `ChatInputBar` will be used by default.|
| onTap | Message bubble click callback.|
| onBubbleLongPress | Callback for holding a message bubble.|
| onBubbleDoubleTap| Callback for double-clicking a message bubble.|
| avatarBuilder | Avatar component builder.|
| nicknameBuilder | Nickname component builder.|
| itemBuilder| Message bubble. If you don't set this prop, the default bubble will be used. |
| moreItems | Action items displayed after a message bubble is held down. If you return `null` in `onBubbleLongPress`, `moreItems` will be used. This prop involves three default actions: copy, delete, and recall. |
| messageListViewController | Message list controller. You are advised to use the default value. For details, see `ChatMessageListController`.  |
| willSendMessage | Text message pre-sending callback. This callback needs to return a `ChatMessage` object.  |
| onError| Error callbacks, such as no permissions.  |
| enableScrollBar | Whether to enable the scroll bar. The scroll bar is enabled by default.  |
| needDismissInputWidget | Callback for dismissing the input widget. If you use a custom input widget, dismiss the input widget when you receive this callback, for example, by calling `FocusNode.unfocus`. See `ChatInputBar`. |
| inputBarMoreActionsOnTap | The callback for clicking the plus symbol next to the input box. You need to return the `ChatBottomSheetItems` list.   |

For more information, see `ChatMessagesView`.

```dart
ChatMessagesView({
  required this.conversation,
  this.inputBarTextEditingController,
  this.background,
  this.inputBar,
  this.onTap,
  this.onBubbleLongPress,
  this.onBubbleDoubleTap,
  this.avatarBuilder,
  this.nicknameBuilder,
  this.itemBuilder,
  this.moreItems,
  ChatMessageListController? messageListViewController,
  this.willSendMessage,
  this.onError,
  this.enableScrollBar = true,
  this.needDismissInputWidget,
  this.inputBarMoreActionsOnTap,
  super.key,
});
```

### ChatConversationsView

The 'ChatConversationsView' allows you to quickly display and manage the current conversations.

| Prop| Description |
| :-------------- | :----- |
| controller | The ChatConversationsView controller. |
| itemBuilder | Conversation list item builder. Return a widget if you need to customize it. |
| avatarBuilder | Avatar builder. If this prop is not implemented or you return `null`, the default avatar will be used.|
| nicknameBuilder | Nickname builder. If you don't set this prop or return `null`, the conversation ID is displayed. |
| onItemTap | The callback of the click event of the conversation list item. |
| backgroundWidgetWhenListEmpty | Background widget when list is empty. |
| enablePullReload | Whether to enable drop-down refresh. |

For more information, see `ChatConversationsView`.

```dart
ChatConversationsView({
  super.key,
  this.onItemTap,
  ChatConversationsViewController? controller,
  this.itemBuilder,
  this.avatarBuilder,
  this.nicknameBuilder,
  this.backgroundWidgetWhenListEmpty,
  this.enablePullReload = false,
  this.scrollController,
  this.reverse = false,
  this.primary,
  this.physics,
  this.shrinkWrap = false,
  this.cacheExtent,
  this.dragStartBehavior = DragStartBehavior.down,
  this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  this.restorationId,
  this.clipBehavior = Clip.hardEdge,
});
```

## License

The sample projects are under the MIT license.
