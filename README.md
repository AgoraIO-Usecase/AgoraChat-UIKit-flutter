# chat_uikit for Flutter

This guide gives a comprehensive overview into chat_uikit. The new chat_uikit is intended to provide developers with an efficient, plug-and-play, and highly customizable UI component library, helping you build complete and elegant IM applications that can easily satisfy most instant messaging scenarios. Please download the demo to try it out.

# chat_uikit Guide

## Introduction

This guide provides an overview and usage examples of the chat_uikit framework in Flutter development, and presents various components and functions of this UIKit, giving developers a good understanding of how chat_uikit works and how to use it efficiently.

## Table of contents

- [chat\_uikit for Flutter](#chat_uikit-for-flutter)
- [chat\_uikit Guide](#chat_uikit-guide)
  - [Introduction](#introduction)
  - [Table of contents](#table-of-contents)
- [Development Environment](#development-environment)
- [Installation](#installation)
- [Structure](#structure)
- [Quick Start](#quick-start)
- [Advanced usage](#advanced-usage)
  - [Provider](#provider)
    - [Example](#example)
    - [Usage](#usage)
  - [Configuration items](#configuration-items)
  - [Internationalization](#internationalization)
  - [Theme](#theme)
  - [Route interception and customization](#route-interception-and-customization)
  - [Event interception and error handling](#event-interception-and-error-handling)
  - [Connection status change and login token expiration callback](#connection-status-change-and-login-token-expiration-callback)
  - [Message time formatting](#message-time-formatting)
  - [Correction of the alphabetical order of contacts](#correction-of-the-alphabetical-order-of-contacts)
- [Design guide](#design-guide)

# Development Environment

```yaml
environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: '>=3.19.0'
```

- ios 12+
- android minSDKVersion 23

# Installation

```bash
flutter pub add agora_chat_uikit
```

# Structure

```bash
.
├── chat_uikit.dart                                             // library
├── chat_uikit_alphabet_sort_helper.dart                        // Tool to correct the alphabetical order of contacts
├── chat_uikit_defines.dart                                     // UIKit handler definition class
├── chat_uikit_emoji_data.dart                                  // Message emoji data class
├── chat_uikit_localizations.dart                               // Internationalization tool class
├── chat_uikit_service                                          // Secondary wrapping for the chat SDK wrapper class, used to adapt incompliant functions in the wrapping class to UIKit functions.
├── chat_uikit_settings.dart                                    // Class to set functions, used to turn on or off or configure certain functions
├── chat_uikit_time_formatter.dart                              // Tool to set the displayed time format
├── provider                                                    // User attribute tool
│   ├── chat_uikit_profile.dart                                 // User attribute object, including the user's avatar, nickname, and remarks.
│   └── chat_uikit_provider.dart                                // User attribute provider, used to provide user attribute data in the UIKit. 
├── sdk_service                                                 // Wrapping for the chat SDK, used to wrap APIs in the chat SDK that are available to developers. The UIKit interacts with the wrapping class, instead of calling APIs in the chat SDK.
├── tools                                                       // Internal tool class
│   ├── chat_uikit_context.dart                                 // Data context to store certain states.
│   ├── chat_uikit_conversation_extension.dart                  // Processed class of the conversation list to pre-process certain properties.
│   ├── chat_uikit_file_size_tool.dart                          // Tool to calculate the displayed file size.
│   ├── chat_uikit_helper.dart                                  // Internal class to calculate the border radius
│   ├── chat_uikit_highlight_tool.dart                          // Tool class to calculate the component highlight value
│   ├── chat_uikit_image_loader.dart                            // Image loading tool class
│   ├── chat_uikit_message_extension.dart                       // Message processing class that pre-processes certain properties
│   ├── chat_uikit_time_tool.dart                               // Default time format class
│   ├── chat_uikit_url_helper.dart                              // Tool class for URL preview
│   └── safe_disposed.dart                                      // Internal processing class for ChangeNotifier
├── ui                                                          // UI components
│   ├── components                                              // Components
│   ├── controllers                                             // View/widget controllers
│   ├── custom                                                  // UI customization
│   ├── models                                                  // models
│   ├── route                                                   // Route component in the UIKit
│   ├── views                                                   // Views
│   └── widgets                                                 // Widgets
└── universal                                                   // Internal class
```

# Quick Start

1. Create a project.

```bash
flutter create uikit_quick_start --platforms=android,ios
```

2. Add dependencies.

```bash
cd uikit_quick_start
flutter pub add agora_chat_uikit
flutter pub get
```

3. Add permissions.

- iOS: Add permissions in `<project root>/ios/Runner/Info.plist`.

```xml
NSPhotoLibraryUsageDescription
NSCameraUsageDescription
NSMicrophoneUsageDescription
```

4. Initialize the UIKit.

```dart
import 'package:agora_chat_uikit/chat_uikit.dart';
...

void main() {
  ChatUIKit.instance
      .init(options: Options(appKey: <!--Your AppKey-->, autoLogin: false))
      .then((value) {
    runApp(const MyApp());
  });
}

```

5. Log in to the UIKit.

```dart
Future<void> login() async {
  try {
    await ChatUIKit.instance.loginWithToken(
        userId: '<!--user id-->',
        token: '<!--user token-->');
  } catch (e) {
    debugPrint('login error: $e');
  }
}
```

6. Create the chat page.

```dart
class ChatPage extends StatefulWidget {
  const ChatPage({required this.chatterId, super.key});
  final String chatterId;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return MessagesView(
      profile: ChatUIKitProfile.contact(
        id: widget.chatterId,
      ),
    );
  }
}
```

Complete code:

```dart
import 'package:flutter/material.dart';
import 'package:agora_chat_uikit/chat_uikit.dart';

const String appKey = '';
const String userId = '';
const String token = '';

const String chatterId = '';

void main() {
  ChatUIKit.instance
      .init(options: Options(appKey: appKey, autoLogin: false))
      .then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final ChatUIKitLocalizations _localization = ChatUIKitLocalizations();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: _localization.supportedLocales,
      localizationsDelegates: _localization.localizationsDelegates,
      localeResolutionCallback: _localization.localeResolutionCallback,
      locale: _localization.currentLocale,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: login,
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: chat,
              child: const Text('Chat'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    try {
      await ChatUIKit.instance.loginWithToken(
        userId: userId,
        token: token,
      );
    } catch (e) {
      debugPrint('login error: $e');
    }
  }

  void chat() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChatPage(
          chatterId: chatterId,
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({required this.chatterId, super.key});
  final String chatterId;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return MessagesView(
      profile: ChatUIKitProfile.contact(
        id: widget.chatterId,
      ),
    );
  }
}
```


# Advanced usage

## Provider

Provider is a data provider. If user data or group data needs to be displayed, the UIKit will request data via the Provider and you need to return data to the Provider. The UIKit, once getting your data, will refresh the UI to show your data. Following is an example of Provider (`example/lib/tool/user_provider_widget.dart`).

### Example

```dart

class UserProviderWidget extends StatefulWidget {
  const UserProviderWidget({required this.child, super.key});

  final Widget child;

  @override
  State<UserProviderWidget> createState() => _UserProviderWidgetState();
}

class _UserProviderWidgetState extends State<UserProviderWidget>
    with GroupObserver {
  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    // Open DB
    UserDataStore().init(onOpened: onOpened);
    // Set Provider Handler
    ChatUIKitProvider.instance.profilesHandler = onProfilesRequest;
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void onOpened() async {
    // 1. Fill all stored data into uikit.
    await addAllUserInfoToProvider();
    // 2. Load group information, and check if it has been filled into uikit. If not, fetch data from the server and then fill it into uikit.
    await loadGroupInfos();
    // 2. Load user information, and check if it has been filled into uikit. If not, fetch data from the server and then fill it into uikit.
    await loadUserInfos();
    // 3. Fetch current user information, then fill it into uikit.
    await fetchCurrentUserInfo();
  }

  Future<void> fetchCurrentUserInfo() async {
    try {
      // Do not retrieve your own user data from the db, always fetch the latest data from the server. 
      Map<String, UserInfo> map = await ChatUIKit.instance
          .fetchUserInfoByIds([ChatUIKit.instance.currentUserId!]);
      ChatUIKitProfile profile = ChatUIKitProfile.contact(
        id: map.values.first.userId,
        nickname: map.values.first.nickName,
        avatarUrl: map.values.first.avatarUrl,
      );
      UserDataStore().saveUserData(profile);
      ChatUIKitProvider.instance.addProfiles([profile]);
    } catch (e) {
      debugPrint('fetchCurrentUserInfo error: $e');
    }
  }

  // This method is called when uikit needs to display user information and the cache does not exist;
  // it requires fetching and storing the information in the db based on user attributes.
  List<ChatUIKitProfile>? onProfilesRequest(List<ChatUIKitProfile> profiles) {
    List<String> userIds = profiles
        .where((e) => e.type == ChatUIKitProfileType.contact)
        .map((e) => e.id)
        .toList();
    if (userIds.isNotEmpty) {
      fetchUserInfos(userIds);
    }

    List<String> groupIds = profiles
        .where((e) => e.type == ChatUIKitProfileType.group)
        .map((e) => e.id)
        .toList();
    updateGroupsProfile(groupIds);
    return profiles;
  }

  // When a group is created by yourself, it is necessary to fill the group information into uikit. 
  @override
  void onGroupCreatedByMyself(Group group) async {
    ChatUIKitProfile profile =
        ChatUIKitProfile.group(id: group.groupId, groupName: group.name);

    ChatUIKitProvider.instance.addProfiles([profile]);
    // save to db
    UserDataStore().saveUserData(profile);
  }

  // When the group name is changed by yourself, it is necessary to update the group information in uikit. 
  @override
  void onGroupNameChangedByMeSelf(Group group) {
    ChatUIKitProfile? profile =
        ChatUIKitProvider.instance.getProfileById(group.groupId);

    profile = profile?.copyWith(name: group.name) ??
        ChatUIKitProfile.group(
          id: group.groupId,
          groupName: group.name,
        );

    ChatUIKitProvider.instance.addProfiles([profile]);
    // save to db
    UserDataStore().saveUserData(profile);
  }

  // Fill all stored data into uikit.
  Future<void> addAllUserInfoToProvider() async {
    List<ChatUIKitProfile> list = await UserDataStore().loadAllProfiles();
    ChatUIKitProvider.instance.addProfiles(list);
  }

  // Load group information, and check if it has been filled into uikit. If not, fetch data from the server and then fill it into uikit.
  Future<void> loadGroupInfos() async {
    List<Group> groups = await ChatUIKit.instance.getJoinedGroups();
    List<ChatUIKitProfile> profiles = groups
        .map((e) => ChatUIKitProfile.group(id: e.groupId, groupName: e.name))
        .toList();

    if (profiles.isNotEmpty) {
      UserDataStore().saveUserDatas(profiles);
      ChatUIKitProvider.instance.addProfiles(profiles);
    }
  }

  Future<void> updateGroupsProfile(List<String> groupIds) async {
    List<ChatUIKitProfile> list = [];
    for (var groupId in groupIds) {
      try {
        Group group = await ChatUIKit.instance.fetchGroupInfo(groupId: groupId);
        ChatUIKitProfile profile = ChatUIKitProfile.group(
          id: group.groupId,
          groupName: group.name,
          avatarUrl: group.extension,
        );
        list.add(profile);
      } on ChatError catch (e) {
        if (e.code == 600) {
          // 600 indicates the group does not exist, unable to fetch data, providing default data.
          ChatUIKitProfile profile = ChatUIKitProfile.group(id: groupId);
          list.add(profile);
        }
        debugPrint('loadGroupInfo error: $e');
      }
    }
    UserDataStore().saveUserDatas(list);
    ChatUIKitProvider.instance.addProfiles(list);
  }

  // Load user information, and check if it has been filled into uikit. If not, fetch data from the server and then fill it into uikit.
  Future<void> loadUserInfos() async {
    try {
      Map<String, ChatUIKitProfile> map =
          ChatUIKitProvider.instance.profilesCache;
      List<Contact> contacts = await ChatUIKit.instance.getAllContacts();
      contacts.removeWhere((element) => map.keys.contains(element.userId));
      if (contacts.isNotEmpty) {
        List<String> userIds = contacts.map((e) => e.userId).toList();
        fetchUserInfos(userIds);
      }
    } catch (e) {
      debugPrint('loadUserInfos error: $e');
    }
  }

  void fetchUserInfos(List<String> userIds) async {
    try {
      Map<String, UserInfo> map =
          await ChatUIKit.instance.fetchUserInfoByIds(userIds);
      List<ChatUIKitProfile> list = map.values
          .map((e) => ChatUIKitProfile.contact(
              id: e.userId, nickname: e.nickName, avatarUrl: e.avatarUrl))
          .toList();

      if (list.isNotEmpty) {
        UserDataStore().saveUserDatas(list);
        ChatUIKitProvider.instance.addProfiles(list);
      }
    } catch (e) {
      debugPrint('fetchUserInfos error: $e');
    }
  }
}

```

### Usage

A hanlder `profilesHandler` is required before the use of `ChatUIKitProvider`. After that, when related information needs to be displayed, UIKit will return you a default `ChatUIKitProfile` object via the handler and you need to return a `ChatUIKitProfile` object. In this case, you are advised to return a `ChatUIKitProfile` object for the placeholding purpose. When you have obtained the correct `ChatUIKitProfile` object from your server or database, pass it to the UIKit using the `ChatUIKitProvider.instance.addProfiles(list)` method. Receiving the object, the UIKit refreshes the UI and caches it for subsequent displaying. Take the following steps to use ChatUIKitProvider:

1. Set `profilesHandler` upon the app start and login.

```dart
    ChatUIKitProvider.instance.profilesHandler = onProfilesRequest;
```

2. Set the user data and group data in the database to the UIKit via `ChatUIKitProvider`.

```dart
    List<ChatUIKitProfile> list = await UserDataStore().loadAllProfiles();
    ChatUIKitProvider.instance.addProfiles(list);
```

3. When `profilesHandler` is executed, you can first return `ChatUIKitProfile` for the placeholding purpose, get data from the server, and then save the data to the database and pass it to the UIKit. 

```dart
  List<ChatUIKitProfile>? onProfilesRequest(List<ChatUIKitProfile> profiles) {
    List<String> userIds = profiles
        .where((e) => e.type == ChatUIKitProfileType.contact)
        .map((e) => e.id)
        .toList();
    if (userIds.isNotEmpty) {
      fetchUserInfos(userIds);
    }

    List<String> groupIds = profiles
        .where((e) => e.type == ChatUIKitProfileType.group)
        .map((e) => e.id)
        .toList();
    updateGroupsProfile(groupIds);
    return profiles;
  }
```

## Configuration items

ChatUIKit allows easy style customization via ChatUIKitSettings.

```dart
import 'chat_uikit.dart';

import 'package:flutter/material.dart';

enum CornerRadius { extraSmall, small, medium, large }

class ChatUIKitSettings {
  /// Specifies the corner radius for the avatars in the uikit.
  static CornerRadius avatarRadius = CornerRadius.medium;

  /// Specifies the corner radius of the search box.
  static CornerRadius searchBarRadius = CornerRadius.small;

  /// Specifies the corner radius of the input box.
  static CornerRadius inputBarRadius = CornerRadius.medium;

  /// Default avatar placeholder image.
  static ImageProvider? avatarPlaceholder;

  /// The corner radius for the dialog.
  static ChatUIKitDialogRectangleType dialogRectangleType =
      ChatUIKitDialogRectangleType.filletCorner;

  /// Default display style of message bubbles.
  static ChatUIKitMessageListViewBubbleStyle messageBubbleStyle =
      ChatUIKitMessageListViewBubbleStyle.arrow;

  /// Whether to show avatars in the conversation list.
  static bool showConversationListAvatar = true;

  /// Whether to show unread message count in the conversation list.
  static bool showConversationListUnreadCount = true;

  // Mute icon displayed in the conversation list.
  static ImageProvider? conversationListMuteImage;

  /// Message long press menu.
  static List<ChatUIKitActionType> msgItemLongPressActions = [
    ChatUIKitActionType.reaction,
    ChatUIKitActionType.copy, // only text message.
    ChatUIKitActionType.forward,
    ChatUIKitActionType.thread, // only group message.
    ChatUIKitActionType.reply,
    ChatUIKitActionType.recall,
    ChatUIKitActionType.edit, // only text message.
    ChatUIKitActionType.multiSelect,
    ChatUIKitActionType.pinMessage,
    ChatUIKitActionType.translate, // only text message.
    ChatUIKitActionType.report,
    ChatUIKitActionType.delete,
  ];

  /// Whether to enable the functionality of input status for one-on-one chat messages.
  static bool enableTypingIndicator = true;

  /// Whether to enable the thread feature.
  static bool enableMessageThread = true;

  /// Whether to enable message translation feature.
  static bool enableMessageTranslation = true;

  /// Message translation target language.
  static String translateTargetLanguage = 'zh-Hans';

  /// Whether to enable message reaction feature.
  static bool enableMessageReaction = true;

  /// Message reaction emojis in the bottom sheet title. These emojis need to be included in the emoji list [ChatUIKitEmojiData.emojiList].
  static List<String> favoriteReaction = [   
    '\u{1F44D}',
    '\u{2764}',
    '\u{1F609}',
    '\u{1F928}',
    '\u{1F62D}',
    '\u{1F389}',
  ];

  /// Regular expression for the default message URL  
  static RegExp defaultUrlRegExp = RegExp(
    r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+',
    caseSensitive: false,
  );

  /// Whether to enable the message pinning feature
  static bool enablePinMsg = true;

  /// Whether to enable message quoting feature
  static bool enableMessageReply = true;

  /// Whether to enable message recall feature
  static bool enableMessageRecall = true;

  /// Time limit for message recall, in seconds
  static int recallExpandTime = 120;

  /// Whether to enable message editing feature
  static bool enableMessageEdit = true;

  /// Whether to enable message reporting feature
  static bool enableMessageReport = true;

  /// Message report tags, can be customized. The reasons for reporting should be written in the localization file, and the key for the reason in the localization file should be consistent with the tag. For example, [ChatUIKitLocal.reportTarget1]
  static List<String> reportMessageTags = [
    'tag1',
    'tag2',
    'tag3',
    'tag4',
    'tag5',
    'tag6',
    'tag7',
    'tag8',
    'tag9',
  ];

  /// Whether to enable message multi-selection feature  
  static bool enableMessageMultiSelect = true;

  /// Whether to enable message forwarding feature
  static bool enableMessageForward = true;

  /// Alphabetical order of `showName` of contacts. If there are Chinese characters, you can redefine the initials using [ChatUIKitAlphabetSortHelper].
  static String sortAlphabetical = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ#';
}

```

## Internationalization

UIKit provides the internationalization function. You need to set internationalization information in `MaterialApp` when integrating the UIKit.

```dart
final ChatUIKitLocalizations _localization = ChatUIKitLocalizations();

...

@override
Widget build(BuildContext context) {
  return MaterialApp(
    supportedLocales: _localization.supportedLocales,
    localizationsDelegates: _localization.localizationsDelegates,
    localeResolutionCallback: _localization.localeResolutionCallback,
    locale: _localization.currentLocale,
    ...
  );
}

```

To add the supported languages, you can first use `ChatUIKitLocalizations.addLocales`, and then call `ChatUIKitLocalizations.resetLocales`.

Following is an example of adding French.

```dart
_localization.addLocales(locales: const [
  ChatLocal('fr', {
    ChatUIKitLocal.conversationsViewSearchHint: 'Recherche',
  })
]);

_localization.resetLocales();
```

## Theme

UIKit comes with two themes: light and dark, with the former as the default. When setting the theme, you are advised to add `ChatUIKitTheme` component as root node of the UIKit. 

```dart
return MaterialApp(
  title: 'Flutter Demo',
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
  ),
  builder: (context, child) {
    /// add theme support
    return ChatUIKitTheme(
      font: ChatUIKitFont(),
      color: ChatUIKitColor.light(), // ChatUIKitColor.dark()
      child: child!,
    );
  },
  home: const MyHomePage(title: 'Flutter Demo Home Page'),
);
```

`ChatUIKitColor` can be customized by adjusting `hue`. For example, adjust the `hue` value in light mode.

```dart
return MaterialApp(
  title: 'Flutter Demo',
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
  ),
  builder: (context, child) {
    return ChatUIKitTheme(
      color: ChatUIKitColor.light(
        primaryHue: 203,
        secondaryHue: 155,
        errorHue: 350,
        neutralHue: 203,
        neutralSpecialHue: 220,
      ),
      child: child!,
    );
  },
  home: const MyHomePage(title: 'Flutter Demo Home Page'),
); 
```

`ChatUIKitFont` allows you to set the font size. For example, you can pass different types of `ChatUIKitFontSize` to `ChatUIKitFont.fontSize(fontSize: ChatUIKitFontSize.normal)` to change the font size of the UIKit.

## Route interception and customization

The UIKit uses `pushNamed` to implement redirection, with the `ChatUIKitViewArguments` object of the target redirection page passed. You can intercept `onGenerateRoute(RouteSettings settings)` and parse `settings.name` to get the target page for redirection. Then, you can reset the `ChatUIKitViewArguments` parameter for redirection interception and page customization. The name of the target redirection page is specified in `chat_uikit_route_names.dart`. 

For details on route interception, you can refer to `example/lib/custom/chat_route_filter.dart`. 


## Event interception and error handling

When the UIKit starts to call the chat SDK, `ChatSDKEventsObserver.onChatSDKEventBegin` is triggered. When the call ends, `ChatSDKEventsObserver.onChatSDKEventEnd` is triggered. If an error occurs, `ChatError` is reported.

```dart
class SDKEventHandlerPage extends StatefulWidget {
  const SDKEventHandlerPage({super.key});

  @override
  State<SDKEventHandlerPage> createState() => _SDKEventHandlerPageState();
}

class _SDKEventHandlerPageState extends State<SDKEventHandlerPage>
    with ChatSDKEventsObserver {
  @override
  void initState() {
    ChatUIKit.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  /// When the call to an SDK method starts, you can display different prompt windows based on different events.
  @override
  void onChatSDKEventBegin(ChatSDKEvent event) {}

  /// When the call to an SDK method call ends, you can end the prompt window display at this time. If there is an error, you can display the corresponding prompt message.
  @override
  void onChatSDKEventEnd(ChatSDKEvent event, ChatError? error) {}

  ...
}
```

For more information, you can refer to `example/lib/tool/toast_page.dart`.

For other events than those of the chat SDK, `ChatUIKitEventsObservers.onChatUIKitEventsReceived` is triggered.

```dart
class UIKitEventHandlePage extends StatefulWidget {
  const UIKitEventHandlePage({super.key});

  @override
  State<UIKitEventHandlePage> createState() => _UIKitEventHandlePageState();
}

class _UIKitEventHandlePageState extends State<UIKitEventHandlePage>
    with ChatUIKitEventsObservers {
  @override
  void initState() {
    ChatUIKit.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  /// This method is used to pass events from ChatUIKit to developers.
  @override
  void onChatUIKitEventsReceived(ChatUIKitEvent event) {}

  ...
}

```

For more information, see `example/lib/tool/toast_page.dart`.

## Connection status change and login token expiration callback 

When the connection status or login status changes, the corresponding event in `ChatUIKit.instance.connectHandler` is triggered.

```dart
ChatUIKit.instance.connectHandler(
  onUserAuthenticationFailed: () {},
  onUserDidChangePassword: () {},
  onUserDidForbidByServer: () {},
  onUserDidLoginFromOtherDevice: (deviceName) {},
  onUserDidLoginTooManyDevice: () {},
  onUserDidRemoveFromServer: () {},
  onUserKickedByOtherDevice: () {},
  onConnected: () {},
  onDisconnected: () {},
  onTokenWillExpire: () {},
  onTokenDidExpire: () {},
  onAppActiveNumberReachLimit: () {},
);
```

For more information, you can refer to `example/lib/tool/token_status_handler_widget.dart`.

## Message time formatting

UIKit presents time in the default format. You can call `ChatUIKitTimeFormatter` to alter the way the time is formatted.

```dart
ChatUIKitTimeFormatter.instance.formatterHandler = (context, type, time) {
  return 'formatter time'; // return formatted time, e.g. 12:00 PM
};
```

## Correction of the alphabetical order of contacts

For example, if a contact name contains other characters than English letters, you can use `ChatUIKitAlphabetSortHelper` to sort contacts in the alphabetical order. 

```dart
ChatUIKitAlphabetSortHelper.instance.sortHandler = (String? groupId, String userId, String showName) {
  // Return the first letter of the showName for sorting, especially useful for sorting Chinese characters
  return PinyinHelper.getFirstWordPinyin(showName);
};
```

# Design guide

For any questions about design guidelines and details, you can add comments to the Figma design draft and mention our designer Stevie Jiang.

- [Design sketch](https://www.figma.com/community/file/1327193019424263350/chat-uikit-for-mobile)

- [UI design guide](https://github.com/StevieJiang/Chat-UIkit-Design-Guide/blob/main/README.md)