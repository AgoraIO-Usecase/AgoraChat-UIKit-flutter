import 'package:agora_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/demo_localizations.dart';
import 'package:em_chat_uikit_example/widgets/list_item.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final String website = 'https://www.easemob.com';
  final String contact = '400-622-1776';
  final String business = 'bd@easemob.com';
  final String channel = 'qudao@easemob.com';
  final String feedback = 'issues@easemob.com';

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: ChatUIKitAppBar(
        backgroundColor: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
        centerTitle: false,
        title: DemoLocalizations.about.localString(context),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: SizedBox(
              width: 60,
              height: 60,
              child: Image.asset('assets/images/icon.png'),
            ),
          ),
          ListItem(
            title: DemoLocalizations.visitWebsite.localString(context),
            subtitle: website,
            enableArrow: true,
            onTap: toWebsite,
          ),
          ListItem(
            title: DemoLocalizations.contactUs.localString(context),
            subtitle: contact,
            enableArrow: true,
            onTap: toContactUS,
          ),
          ListItem(
            title: DemoLocalizations.businessCooperation.localString(context),
            subtitle: business,
            enableArrow: true,
            onTap: toBusinessCooperation,
          ),
          ListItem(
            title: DemoLocalizations.channelCooperation.localString(context),
            subtitle: channel,
            enableArrow: true,
            onTap: toChannelCooperation,
          ),
          ListItem(
            title: DemoLocalizations.feedback.localString(context),
            subtitle: feedback,
            enableArrow: true,
            onTap: toFeedback,
          ),
        ],
      ),
    );
  }

  void toWebsite() async {
    if (!await launchUrl(Uri.parse(website))) {
      throw Exception('Could not launch $website');
    }
  }

  void toContactUS() async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: contact,
    );
    if (!await launchUrl(phoneLaunchUri)) {
      throw Exception('Could not launch $contact');
    }
  }

  void toBusinessCooperation() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: business,
    );
    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch $business');
    }
  }

  void toChannelCooperation() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: channel,
    );
    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch $channel');
    }
  }

  void toFeedback() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: feedback,
    );
    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch $feedback');
    }
  }
}
