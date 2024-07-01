import 'package:agora_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/demo_localizations.dart';
import 'package:em_chat_uikit_example/notifications/app_settings_notification.dart';
import 'package:em_chat_uikit_example/tool/settings_data_store.dart';
import 'package:em_chat_uikit_example/widgets/list_item.dart';
import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  ValueNotifier<String> language =
      ValueNotifier<String>(SettingsDataStore().currentLanguage);

  @override
  void initState() {
    super.initState();

    language.addListener(() {
      SettingsDataStore().saveLanguage(language.value);
      ChatUIKitLocalizations().translate(language.value);
      AppSettingsNotification().dispatch(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = ListView(
      children: [
        ListItem(
          title: '中文',
          trailingWidget: language.value == 'zh'
              ? Icon(
                  Icons.check_box,
                  size: 28,
                  color: theme.color.isDark
                      ? theme.color.primaryColor6
                      : theme.color.primaryColor5,
                )
              : Icon(
                  Icons.check_box_outline_blank,
                  size: 28,
                  color: theme.color.isDark
                      ? theme.color.neutralColor4
                      : theme.color.neutralColor7,
                ),
          onTap: () {
            language.value = 'zh';
          },
        ),
        ListItem(
          title: 'English',
          trailingWidget: language.value == 'en'
              ? Icon(
                  Icons.check_box,
                  size: 28,
                  color: theme.color.isDark
                      ? theme.color.primaryColor6
                      : theme.color.primaryColor5,
                )
              : Icon(
                  Icons.check_box_outline_blank,
                  size: 28,
                  color: theme.color.isDark
                      ? theme.color.neutralColor4
                      : theme.color.neutralColor7,
                ),
          onTap: () {
            language.value = 'en';
          },
        ),
      ],
    );

    content = Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: ChatUIKitAppBar(
        backgroundColor: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
        title: DemoLocalizations.languageSettings.localString(context),
        centerTitle: false,
      ),
      body: SafeArea(child: content),
    );

    return content;
  }
}
