# agora_chat_uikit_example

## Understand the tech

The following figure shows the workflow of how clients send and receive peer-to-peer messages:

![agora_chat](https://docs.agora.io/en/assets/images/get-started-sdk-understand-009486abec0cc276183ab535456cf889.png)

1. Clients retrieve a token from your app server.
2. Client A and Client B log in to Agora Chat.
3. Client A sends a message to Client B. The message is sent to the Agora Chat server and the server delivers the message to Client B. When Client B receives the message, the SDK triggers an event. Client B listens for the event and gets the message.

## Prerequisites

For the iOS platform, your development environment must meet the following requirements:

- Flutter 2.10 or later
- Dart 2.16 or later
- macOS
- Xcode 12.4 or later with Xcode Command Line Tools
- CocoaPods
- An iOS simulator or a real iOS device running iOS 10.0 or later

For the Android platform, your development environment must meet the following requirements:

- Flutter 2.10 or later
- Dart 2.16 or later
- macOS or Windows
- Android Studio 4.0 or later with JDK 1.8 or later
- An Android simulator or a real Android device running Android SDK API level 21 or later

<div class="alert note">You need to run the <code>flutter doctor</code> command to check whether both the development environment and the deployment environment are correct.</div>

## Token generation

This section describes how to register a user at Agora Console and generate a temporary token.

### Register a user

To generate a user ID, do the following:

1. On the **Project Management** page, click **Config** for the project you want to use.

![](https://web-cdn.agora.io/docs-files/1664531061644)

2. On the **Edit Project** page, click **Config** next to **Chat** below **Features**.

![](https://web-cdn.agora.io/docs-files/1664531091562)

3. In the left-navigation pane, select **Operation Management** > **User** and click **Create User**.

![](https://web-cdn.agora.io/docs-files/1664531141100)

4. In the **Create User** dialog box, fill in the **User ID**, **Nickname**, and **Password**, and click **Save** to create a user.

![](https://web-cdn.agora.io/docs-files/1664531162872)

### Generate a user token

To ensure communication security, Agora recommends using tokens to authenticate users logging in to an Agora Chat system.

For testing purposes, Agora Console supports generating Agora chat tokens. To generate an Agora chat token, do the following:

1. On the **Project Management** page, click **Config** for the project you want to use.

![](https://web-cdn.agora.io/docs-files/1664531061644)

2. On the **Edit Project** page, click **Config** next to **Chat** below **Features**.

![](https://web-cdn.agora.io/docs-files/1664531091562)

3. In the **Data Center** section of the **Application Information** page, enter the user ID in the **Chat User Temp Token** box and click **Generate** to generate a token with user privileges.

![](https://web-cdn.agora.io/docs-files/1664531214169)


### Steps to run


Used to demonstrate agora_chat_uikit, contains chat, session list page.

1. Set up ChatConfig, fill in your appkey and login account and agoraToken information.
2. Clone this project to local.
3. open `example`.
4. run `flutter pub get`;
5. If you want to use your own App Key for the experience, you can edit the `example/lib/main.dart` file.

Replaces `appKey`, `userId`, and `agoraToken` and with your own App Key, user ID, and user token generated in Agora Console.

```dart
class ChatConfig {
  static const String appKey = "";
  static const String userId = "";
  static const String agoraToken = '';
}
```

   > See [Enable and Configure Agora Chat Service](https://docs.agora.io/cn/agora-chat/enable_agora_chat?platform=flutter) to learn how to enable and configure Agora Chat Service.

   > Refer to the source code [Chat App Server](https://github.com/AgoraIO/Agora-Chat-API-Examples/tree/main/chat-app-server) to learn how to quickly build an App Server.

6. Make the project and run the app in the simulator or connected physical Android or iOS device.

You are all set! Feel free to play with this sample project and explore features of the Agora Chat UIKit.

## License

The sample projects are under the MIT license.