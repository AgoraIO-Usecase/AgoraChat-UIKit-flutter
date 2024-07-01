import 'package:agora_chat_uikit/chat_uikit.dart';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String languageKey = 'languageKey';
const String threadKey = 'threadKey';
const String translationKey = 'translationKey';
const String reactionKey = 'reactionKey';
const String targetLanguageKey = 'targetLanguageKey';

class SettingsDataStore {
  static SettingsDataStore? _instance;
  SharedPreferences? _sharedPreferences;

  List<String> unNotifyGroupIds = [];

  factory SettingsDataStore() {
    _instance ??= SettingsDataStore._();
    return _instance!;
  }

  SettingsDataStore._();

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _sharedPreferences ??= await SharedPreferences.getInstance();
    ChatUIKitLocalizations().translate(currentLanguage);
    ChatUIKitSettings.enableMessageThread = enableThread;
    ChatUIKitSettings.enableMessageTranslation = enableTranslation;
    ChatUIKitSettings.enableMessageReaction = enableReaction;
    ChatUIKitSettings.translateTargetLanguage = translateTargetLanguage;
  }

  String get currentLanguage {
    return _sharedPreferences?.getString(languageKey) ?? 'en';
  }

  Future<void> saveLanguage(String language) async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    _sharedPreferences?.setString(languageKey, language);
    ChatUIKitLocalizations().translate(language);
  }

  String get translateTargetLanguage {
    return _sharedPreferences?.getString(targetLanguageKey) ?? 'zh-Hans';
  }

  Future<void> saveTranslateTargetLanguage(String language) async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    _sharedPreferences?.setString(targetLanguageKey, language);
    ChatUIKitSettings.translateTargetLanguage = language;
  }

  bool get enableThread {
    return _sharedPreferences?.getBool(threadKey) ??
        ChatUIKitSettings.enableMessageThread;
  }

  Future<void> saveThread(bool enable) async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    _sharedPreferences?.setBool(threadKey, enable);
    ChatUIKitSettings.enableMessageThread = enable;
  }

  bool get enableTranslation {
    return _sharedPreferences?.getBool(translationKey) ??
        ChatUIKitSettings.enableMessageTranslation;
  }

  Future<void> saveTranslation(bool enable) async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    _sharedPreferences?.setBool(translationKey, enable);
    ChatUIKitSettings.enableMessageTranslation = enable;
  }

  bool get enableReaction {
    return _sharedPreferences?.getBool(reactionKey) ??
        ChatUIKitSettings.enableMessageReaction;
  }

  Future<void> saveReaction(bool enable) async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    _sharedPreferences?.setBool(reactionKey, enable);
    ChatUIKitSettings.enableMessageReaction = enable;
  }
}
