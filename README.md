# 快速开始

利用环信单群聊 UIKit，你可以轻松实现单群和群聊。Flutter 单群聊 UIKit 支持 iOS 和 Android 平台。

本文介绍如何快速实现在单聊会话中发送消息。

## 前提条件

开始前，请确保你的开发环境满足以下条件：

1. Flutter 版本

```yaml
environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.3.0"
```

2. 你需要添加权限：

- iOS: 在 `<project root>/ios/Runner/Info.plist` 中添加以下权限。

```xml
NSPhotoLibraryUsageDescription
NSCameraUsageDescription
NSMicrophoneUsageDescription
```

- Android: `em_chat_uikit` 已经在 `AndroidManifest.xml` 中添加以下权限, 你不需要再重复添加。

```xml
  <uses-permission android:name="android.permission.CAMERA" />
  <uses-permission android:name="android.permission.RECORD_AUDIO" />
  <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
  <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" android:minSdkVersion="30"/>
```


## 实现发送第一条单聊消息

本节介绍如何通过单群聊 UIKit 实现发送第一条单聊消息。

### 第一步 创建项目

```bash
flutter create chat_uikit_demo --platforms=android,ios
```

### 第二步 添加依赖

进入项目目录，添加最新版 `em_chat_uikit`：

```bash
cd chat_uikit_demo
flutter pub add em_chat_uikit
flutter pub get
```

### 第三步 添加主题

打开新建的项目(此处使用的 IDE 是 `vscode`), 添加 `ChatUIKitTheme` 主题依赖。

需要确保主题 `ChatUIKitTheme` 是 `ChatUIKit` 中所有组件的父组件，建议放在 `MyApp` 中，保证始终生效。

```dart
class MyApp extends StatelessWidget {
   MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ...
      // 新添加的代码
      builder: (context, child) {
        return ChatUIKitTheme(child: child!);
      },
    );
  }
}
```

### 第四步 添加国际化

```dart
class MyApp extends StatelessWidget {
  // 新添加的代码
  final ChatUIKitLocalizations _localization = ChatUIKitLocalizations();
   MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 新添加的代码
      supportedLocales: _localization.supportedLocales,
      localizationsDelegates: _localization.localizationsDelegates,
      localeResolutionCallback: _localization.localeResolutionCallback,
      locale: _localization.currentLocale,

      ...
    );
  }
}
```


### 第五步 初始化

初始化 `ChatUIKit`，其中 `appkey` 需要替换为你自己的 App Key。

```dart

// 导入头文件
import 'package:em_chat_uikit/chat_uikit.dart';
...

void main() {
  ChatUIKit.instance
      .init(options: Options(appKey: appkey, autoLogin: false))
      .then((value) {
    runApp(MyApp());
  });
}

```

### 第六步 登录

`ChatUIKit` 提供以下两种登录方法：用户 ID 和密码以及用户 ID 和 token。

:::tip
若你已集成了 IM SDK，SDK 的所有用户 ID 均可用于登录单群聊 UIKit。
:::

- [使用用户 ID 和密码登录](/product/enable_and_configure_IM.html#创建-im-用户)：

```dart 
ChatUIKit.instance.loginWithPassword(userId: userId, password: password);
```

- 使用用户 ID 和 token 登录：

为了方便快速体验，你可以在[环信即时通讯云控制台](https://console.easemob.com/user/login)的**应用概览** > **用户认证**页面创建用户并查看用户 token。**用户认证**页面中的用户仅用于快速体验或调试目的。

在开发环境中，你需要在环信控制台[创建 IM 用户](/product/enable_and_configure_IM.html#创建-im-用户)，从你的 App Server 获取用户 token，详见[使用环信用户 token 鉴权](/product/easemob_user_token.html) 。

```dart
ChatUIKit.instance.loginWithToken(userId: userId, token: token);
```

### 第七步 添加聊天页面

登录后显示聊天页面。

`ChatUIKit` 提供了 `MessagesView`，用于登录成功后显示聊天页面。

```dart
  @override
  Widget build(BuildContext context) {
    /// userId：接收方的用户 ID
    return MessagesView(profile: ChatUIKitProfile.contact(id: userId));
  }
```

### 第七步 发送第一条消息

在聊天页面下方输入消息，然后点击**发送**按钮发送消息。

![img](@static/images/uikit/chatuikit/android/message_first.png =300x650) 

## 参考

快速开始整个流程的完整代码如下：

```dart
import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

const appkey = '';
const currentUserId = '';
const currentUserPwd = '';
const chatterId = '';
void main() {
  ChatUIKit.instance.init(options: Options(appKey: appkey, autoLogin: false)).then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final ChatUIKitLocalizations _localization = ChatUIKitLocalizations();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 设置demo国际化支持语言
      supportedLocales: _localization.supportedLocales,
      // 提供语言包内容给demo
      localizationsDelegates: _localization.localizationsDelegates,
      // 当国际化语言不支持时，提供语言默认实现
      localeResolutionCallback: _localization.localeResolutionCallback,
      locale: _localization.currentLocale,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      builder: (context, child) {
        return ChatUIKitTheme(
          color: ChatUIKitColor.light(),
          child: child!,
        );
      },
      onGenerateRoute: (settings) {
        return null;
      },
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
            TextButton(
              onPressed: () {
                if (ChatUIKit.instance.isLogged()) {
                  ChatUIKit.instance.logout().then((value) => setState(() {}));
                } else {
                  ChatUIKit.instance
                      .loginWithPassword(userId: currentUserId, password: currentUserPwd)
                      .then((value) => setState(() {}));
                }
              },
              child: ChatUIKit.instance.isLogged() ? const Text('Logout') : const Text('Login'),
            ),
            if (ChatUIKit.instance.isLogged()) const Expanded(child: ChatPage()),
          ],
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return MessagesView(profile: ChatUIKitProfile.contact(id: chatterId));
  }
}

```