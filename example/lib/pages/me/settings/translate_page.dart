import 'package:agora_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/demo_localizations.dart';
import 'package:em_chat_uikit_example/tool/settings_data_store.dart';
import 'package:em_chat_uikit_example/widgets/list_item.dart';
import 'package:flutter/material.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({super.key});

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  String? translate;

  @override
  void initState() {
    super.initState();
    translate = SettingsDataStore().translateTargetLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = ListView(
      children: [
        ListItem(
          title: DemoLocalizations.translateTargetLanguageChinese
              .localString(context),
          trailingWidget: translate == 'zh-Hans'
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
          onTap: () async {
            await SettingsDataStore().saveTranslateTargetLanguage('zh-Hans');
            translate = 'zh-Hans';
            setState(() {});
          },
        ),
        ListItem(
          title: DemoLocalizations.translateTargetLanguageEnglish
              .localString(context),
          trailingWidget: translate == 'en'
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
          onTap: () async {
            await SettingsDataStore().saveTranslateTargetLanguage('en');
            translate = 'en';
            setState(() {});
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
        title: DemoLocalizations.translateTargetLanguage.localString(context),
        centerTitle: false,
      ),
      body: SafeArea(child: content),
    );

    return content;
  }
}
