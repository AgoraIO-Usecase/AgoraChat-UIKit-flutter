import '../../chat_uikit.dart';
class ContactItemModel
    with ChatUIKitListItemModelBase, NeedAlphabetical, NeedSearch {
  @override
  ChatUIKitProfile profile;

  ContactItemModel({
    required this.profile,
  }) {
    profile = profile;
  }

  ContactItemModel copyWith({
    ChatUIKitProfile? profile,
  }) {
    return ContactItemModel(
      profile: profile ?? this.profile,
    );
  }

  @override
  double get itemHeight => 60;

  @override
  String get showName {
    return profile.showName;
  }

  String? get avatarUrl {
    return profile.avatarUrl;
  }

  static ContactItemModel fromProfile(ChatUIKitProfile profile) {
    return ContactItemModel(profile: profile);
  }
}
