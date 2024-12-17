import '../../chat_uikit.dart';

class ContactItemModel
    with ChatUIKitListItemModelBase, NeedSearch, NeedAlphabetical {
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
  double get itemHeight => ChatUIKitSettings.contactItemListItemHeight;

  @override
  String get showName {
    return profile.contactShowName;
  }

  String? get avatarUrl {
    return profile.avatarUrl;
  }

  static ContactItemModel fromProfile(ChatUIKitProfile profile) {
    return ContactItemModel(profile: profile);
  }
}
