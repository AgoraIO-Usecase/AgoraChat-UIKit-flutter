# flutter_chat_uikit_example

Used to demonstrate agora_chat_uikit, contains chat, session list page.

### Steps to run

1. Set up ChatConfig, fill in your appkey and login account and agoraToken information.
2. Clone this project to local.
3. open `example`.
4. run `flutter pub get`;
5. If you want to use your own App Key for the experience, you can edit the `example/lib/main.dart` file.
   - Replace `ChatConfig.appKey` with your App KEY.
   - Replace `ChatConfig.userId` with your registered user id.
   - Replace `ChatConfig.agoraToken` agoraToken corresponds to the user id

   > See [Enable and Configure Agora Chat Service](https://docs.agora.io/cn/agora-chat/enable_agora_chat?platform=flutter) to learn how to enable and configure Agora Chat Service.

   > Refer to the source code [Chat App Server](https://github.com/AgoraIO/Agora-Chat-API-Examples/tree/main/chat-app-server) to learn how to quickly build an App Server.

6. Make the project and run the app in the simulator or connected physical Android or iOS device.

You are all set! Feel free to play with this sample project and explore features of the Agora Chat UIKit.

### Next

More documentation can be found on the [Agora](https://docs.agora.io/en/agora-chat/get-started/get-started-sdk?platform=flutter#understand-the-tech)

## License

The sample projects are under the MIT license.