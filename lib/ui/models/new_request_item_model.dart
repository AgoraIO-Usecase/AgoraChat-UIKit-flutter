import '../../chat_uikit.dart';

class NewRequestItemModel with ChatUIKitListItemModelBase, NeedSearch {
  @override
  ChatUIKitProfile profile;

  final String? reason;

  NewRequestItemModel({
    required this.profile,
    this.reason,
  }) {
    profile = profile;
  }

  @override
  String get showName {
    return profile.showName;
  }

  String? get avatarUrl {
    return profile.avatarUrl;
  }

  NewRequestItemModel copyWith({
    ChatUIKitProfile? profile,
    String? reason,
  }) {
    return NewRequestItemModel(
      profile: profile ?? this.profile,
      reason: reason ?? this.reason,
    );
  }

  static NewRequestItemModel fromUserId(String userId, [String? reason]) {
    ChatUIKitProfile profile = ChatUIKitProvider.instance.getProfile(
      ChatUIKitProfile.contact(id: userId),
    );
    return NewRequestItemModel(profile: profile, reason: reason);
  }

  static NewRequestItemModel fromProfile(ChatUIKitProfile profile) {
    return NewRequestItemModel(profile: profile);
  }
}
