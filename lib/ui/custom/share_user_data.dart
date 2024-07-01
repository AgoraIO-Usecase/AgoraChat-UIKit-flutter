import '../../chat_uikit.dart';
import 'package:flutter/widgets.dart';

class ShareUserData extends InheritedWidget {
  const ShareUserData({
    super.key,
    required super.child,
    required this.data,
  });

  final Map<String, ChatUIKitProfile> data;

  static ShareUserData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShareUserData>();
  }

  String? showName(String userId) {
    return data[userId]?.showName;
  }

  String? showAvatar(String userId) {
    return data[userId]?.avatarUrl;
  }

  @override
  bool updateShouldNotify(covariant ShareUserData oldWidget) {
    return oldWidget.data != data;
  }
}

class UserData {
  UserData({
    this.nickname,
    this.avatarUrl,
    this.time = 0,
  });

  final String? nickname;
  final String? avatarUrl;
  final int time;

  UserData copyWith({String? nickname, String? avatarUrl}) {
    return UserData(
      nickname: nickname ?? this.nickname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
