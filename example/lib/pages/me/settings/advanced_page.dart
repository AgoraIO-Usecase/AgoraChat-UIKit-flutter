import 'package:agora_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/demo_localizations.dart';
import 'package:em_chat_uikit_example/tool/settings_data_store.dart';
import 'package:em_chat_uikit_example/widgets/list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdvancedPage extends StatefulWidget {
  const AdvancedPage({super.key});

  @override
  State<AdvancedPage> createState() => _AdvancedPageState();
}

class _AdvancedPageState extends State<AdvancedPage> {
  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget content = ListView(
      children: [
        ListItem(
          title:
              DemoLocalizations.featureSettingsTranslation.localString(context),
          trailingWidget: CupertinoSwitch(
              value: SettingsDataStore().enableTranslation,
              onChanged: (value) async {
                await SettingsDataStore().saveTranslation(value);
                setState(() {});
              }),
        ),
        Container(
          padding:
              const EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 16),
          color: theme.color.isDark
              ? theme.color.neutralColor3
              : theme.color.neutralColor95,
          child: Text(
            DemoLocalizations.featureSettingsTranslationDesc
                .localString(context),
            textAlign: TextAlign.left,
            textScaler: TextScaler.noScaling,
            style: TextStyle(
              height: 0.9,
              fontSize: theme.font.bodyMedium.fontSize,
              fontWeight: theme.font.bodyMedium.fontWeight,
              color: theme.color.isDark
                  ? theme.color.neutralColor7
                  : theme.color.neutralColor5,
            ),
          ),
        ),
        ListItem(
          title: DemoLocalizations.featureSettingsThread.localString(context),
          trailingWidget: CupertinoSwitch(
              value: SettingsDataStore().enableThread,
              onChanged: (value) async {
                await SettingsDataStore().saveThread(value);
                setState(() {});
              }),
        ),
        Container(
          padding:
              const EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 16),
          color: theme.color.isDark
              ? theme.color.neutralColor3
              : theme.color.neutralColor95,
          child: Text(
            DemoLocalizations.featureSettingsThreadDesc.localString(context),
            textAlign: TextAlign.left,
            textScaler: TextScaler.noScaling,
            style: TextStyle(
              height: 0.9,
              fontSize: theme.font.bodyMedium.fontSize,
              fontWeight: theme.font.bodyMedium.fontWeight,
              color: theme.color.isDark
                  ? theme.color.neutralColor7
                  : theme.color.neutralColor5,
            ),
          ),
        ),
        ListItem(
          title: DemoLocalizations.featureSettingsReaction.localString(context),
          trailingWidget: CupertinoSwitch(
              value: SettingsDataStore().enableReaction,
              onChanged: (value) async {
                await SettingsDataStore().saveReaction(value);
                setState(() {});
              }),
        ),
        Container(
          padding:
              const EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 16),
          color: theme.color.isDark
              ? theme.color.neutralColor3
              : theme.color.neutralColor95,
          child: Text(
            DemoLocalizations.featureSettingsReactionDesc.localString(context),
            textAlign: TextAlign.left,
            textScaler: TextScaler.noScaling,
            style: TextStyle(
              height: 0.9,
              fontSize: theme.font.bodyMedium.fontSize,
              fontWeight: theme.font.bodyMedium.fontWeight,
              color: theme.color.isDark
                  ? theme.color.neutralColor7
                  : theme.color.neutralColor5,
            ),
          ),
        ),
      ],
    );
    return Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: ChatUIKitAppBar(
        backgroundColor: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
        title: DemoLocalizations.advancedSettings.localString(context),
        centerTitle: false,
      ),
      body: SafeArea(child: content),
    );
  }
}
