import '../../chat_uikit.dart';

class GroupItemModel with ChatUIKitListItemModelBase, NeedSearch {
  @override
  ChatUIKitProfile profile;

  GroupItemModel({
    required this.profile,
  }) {
    profile = profile;
  }

  GroupItemModel copyWith({
    ChatUIKitProfile? profile,
  }) {
    return GroupItemModel(
      profile: profile ?? this.profile,
    );
  }

  @override
  String get showName {
    return profile.showName;
  }

  String? get avatarUrl {
    return profile.avatarUrl;
  }

  static GroupItemModel fromProfile(ChatUIKitProfile profile) {
    return GroupItemModel(profile: profile);
  }
}
