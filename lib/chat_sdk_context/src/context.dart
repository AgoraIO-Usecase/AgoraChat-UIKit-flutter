import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ChatSDKContext {
  late SharedPreferences sharedPreferences;
  String? _currentUserId;

  Map<String, dynamic> cachedMap = {};

  static ChatSDKContext? _instance;
  static ChatSDKContext get instance {
    return _instance ??= ChatSDKContext._internal();
  }

  void setUserId(String? userId) {
    if (_currentUserId != userId) {
      cachedMap.clear();
    }
    _currentUserId = userId;
    if (_currentUserId?.isNotEmpty == true) {
      String? cache = sharedPreferences.getString(_currentUserId!);
      if (cache != null) {
        cachedMap = json.decode(cache);
      }
    }
  }

  ChatSDKContext._internal() {
    _init();
  }

  void _init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  void save() {
    sharedPreferences.setString(_currentUserId!, json.encode(cachedMap));
  }

  void clear() {
    if (_currentUserId?.isNotEmpty == true) {
      sharedPreferences.remove(_currentUserId!);
    }
    cachedMap.clear();
  }
}
