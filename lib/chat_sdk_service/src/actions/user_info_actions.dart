import '../../chat_sdk_service.dart';

mixin UserInfoActions on UserInfoWrapper {
  Future<void> updateUserInfo({
    String? nickname,
    String? avatarUrl,
    String? mail,
    String? phone,
    int? gender,
    String? sign,
    String? birth,
    String? ext,
  }) async {
    return checkResult(ChatSDKEvent.updateUserInfo, () {
      return Client.getInstance.userInfoManager.updateUserInfo(
        nickname: nickname,
        avatarUrl: avatarUrl,
        mail: mail,
        phone: phone,
        gender: gender,
        sign: sign,
        birth: birth,
        ext: ext,
      );
    });
  }

  Future<UserInfo?> fetchOwnInfo({int expireTime = 0}) async {
    return checkResult(ChatSDKEvent.fetchOwnInfo, () {
      return Client.getInstance.userInfoManager
          .fetchOwnInfo(expireTime: expireTime);
    });
  }

  Future<Map<String, UserInfo>> fetchUserInfoByIds(
    List<String> userIds, {
    int expireTime = 0,
  }) async {
    return checkResult(ChatSDKEvent.fetchUserInfoByIds, () {
      return Client.getInstance.userInfoManager.fetchUserInfoById(
        userIds,
        expireTime: expireTime,
      );
    });
  }

  void clearUserInfoCache() {
    Client.getInstance.userInfoManager.clearUserInfoCache();
  }
}
