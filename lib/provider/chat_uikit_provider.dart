import '../chat_uikit.dart';

/// 用户信息更新观察者，当用户信息更新时，会通知所有的观察者。
abstract mixin class ChatUIKitProviderObserver {
  void onProfilesUpdate(
    Map<String, ChatUIKitProfile> map,
  ) {}
}

/// 用户信息回调，入参为需要提供信息的 profile 列表，返回值为提供信息后的 profile 列表，如果返回值为空，当再次需要展示是仍会回调。
typedef ChatUIKitProviderProfileHandler = List<ChatUIKitProfile>? Function(
  List<ChatUIKitProfile> profiles,
);

/// 用户信息提供类，用于设置用户/群组展示的名称和头像信息
class ChatUIKitProvider {
  static ChatUIKitProvider? _instance;
  static ChatUIKitProvider get instance {
    _instance ??= ChatUIKitProvider._internal();
    return _instance!;
  }

  ChatUIKitProvider._internal();

  /// 用户信息回调, 详细参考 [ChatUIKitProviderProfileHandler]
  ChatUIKitProviderProfileHandler? profilesHandler;

  /// 缓存的 profiles, key 为id，value 为 profile，具体参考 [ChatUIKitProfile]。
  final Map<String, ChatUIKitProfile> profilesCache = {};

  final List<ChatUIKitProviderObserver> _observers = [];

  ChatUIKitProfile? get currentUserProfile {
    return profilesCache[ChatUIKit.instance.currentUserId];
  }

  /// 添加观察者，当用户信息更新时，会通知所有的观察者。
  void addObserver(ChatUIKitProviderObserver observer) {
    _observers.add(observer);
  }

  /// 移除观察者。
  void removeObserver(ChatUIKitProviderObserver observer) {
    _observers.remove(observer);
  }

  /// 清空所有观察者。
  void clearAllObservers() {
    _observers.clear();
  }

  /// 清空所有缓存。
  void clearAllCache() {
    profilesCache.clear();
  }

  /// 获取用户信息，如果缓存中存在，则直接返回，如果不存在，则调用 [profilesHandler] 获取用户信息。
  Map<String, ChatUIKitProfile> getProfiles(List<ChatUIKitProfile> profiles,
      {bool force = false}) {
    List<ChatUIKitProfile> ret = [];
    List<ChatUIKitProfile> needProviders = [];

    for (var profile in profiles) {
      ChatUIKitProfile? cachedProfile = profilesCache[profile.id];
      if (cachedProfile == null || force == true) {
        needProviders.add(profile);
      } else {
        ret.add(cachedProfile);
      }
    }

    if (needProviders.isNotEmpty) {
      List<ChatUIKitProfile>? tmp = profilesHandler?.call(needProviders);
      if (tmp?.isNotEmpty == true) {
        // 将返回数据加入到缓存中
        Future(() => addProfiles(tmp!));
        // 将 tmp 添加到需要返回的数据中
        ret.addAll(tmp!);
        // 将已经添加的数据从 need Providers中移出
        needProviders.removeWhere(
            (element) => tmp.map((e) => e.id).contains(element.id));
      }
      // 将 needProviders 添加到返回的数据中
      ret.addAll(needProviders);
    }

    return {for (var element in ret) element.id: element};
  }

  /// 获取用户信息，如果缓存中存在，则直接返回，如果不存在，则调用 [profilesHandler] 获取用户信息。
  ChatUIKitProfile getProfile(ChatUIKitProfile profile, {bool force = false}) {
    return getProfiles([profile], force: force)[profile.id]!;
  }

  ChatUIKitProfile? getProfileById(String id) {
    return profilesCache[id];
  }

  /// 添加用户信息，用户信息更新时会通知所有的观察者信息更新。
  void addProfiles(List<ChatUIKitProfile> list) {
    if (list.isEmpty) return;
    var result = {for (var element in list) element.id: element};
    profilesCache.addAll(result);
    for (var observer in _observers) {
      Future(() {
        observer.onProfilesUpdate(result);
      });
    }
  }
}
