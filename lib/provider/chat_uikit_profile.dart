/// Profile 类型，用于区分是联系人还是群组。
enum ChatUIKitProfileType {
  /// 联系人类型。
  contact,

  /// 群类型。
  group,

  /// 自定义类型。
  custom,
}

/// ChatUIKitProfile class, used to store information about contacts or groups.
class ChatUIKitProfile {
  /// id, if it is a contact, it is the user id, if it is a group, it is the group id.
  final String id;

  /// 名称,如果是联系人，则为用户名称，如果是群组，则为群组名称。
  final String? showName;

  /// 头像地址, 如果是联系人，则为用户头像地址，如果是群组，则为群组头像地址。
  final String? avatarUrl;

  /// Profile type, used to distinguish between contacts and groups.
  final ChatUIKitProfileType type;

  /// Extension field, used to store some additional information.
  final Map<String, String>? extension;

  /// Timestamp, not used internally by uikit. Developers can use this field to store some timestamp information.
  final int timestamp;

  /// Remark, if it is a contact, it is the remark information.
  final String? remark;

  /// The name used for display, if the name is empty, the id is displayed.
  String get contactShowName {
    if (remark != null &&
        remark!.isNotEmpty &&
        type == ChatUIKitProfileType.contact) {
      return remark!;
    }

    if (showName != null && showName!.isNotEmpty) {
      return showName!;
    }
    return id;
  }

  /// The nickname used for display, if the name is empty, the id is displayed.
  String get nickname {
    if (showName != null && showName!.isNotEmpty) {
      return showName!;
    }
    return id;
  }

  /// Constructor, used to create a profile object.
  /// [id] is the user id.
  /// [showName] is the show name. when type is contact, it is the user nickname, when type is group, it is the group name.
  /// [avatarUrl] is the user avatar address.
  /// [type] is the profile type.
  /// [extension] is the extension field.
  /// [remark] is the user remark information.
  /// [timestamp] is the timestamp.
  ChatUIKitProfile({
    required this.id,
    required this.type,
    this.showName,
    this.avatarUrl,
    this.extension,
    this.remark,
    this.timestamp = 0,
  });

  /// Create a contact profile object.
  /// [id] is the user id.
  /// [nickname] is the user name.
  /// [avatarUrl] is the user avatar address.
  /// [remark] is the user remark information.
  /// [extension] is the extension field.
  /// [timestamp] is the timestamp.
  ChatUIKitProfile.contact({
    required String id,
    String? nickname,
    String? avatarUrl,
    String? remark,
    Map<String, String>? extension,
    int timestamp = 0,
  }) : this(
          id: id,
          showName: nickname,
          avatarUrl: avatarUrl,
          type: ChatUIKitProfileType.contact,
          extension: extension,
          remark: remark,
          timestamp: timestamp,
        );

  /// Create a group profile object.
  /// [id] is the group id.
  /// [groupName] is the group name.
  /// [avatarUrl] is the group avatar address.
  /// [extension] is the extension field.
  /// [timestamp] is the timestamp.
  ChatUIKitProfile.group({
    required String id,
    String? groupName,
    String? avatarUrl,
    Map<String, String>? extension,
    int timestamp = 0,
  }) : this(
          id: id,
          showName: groupName,
          avatarUrl: avatarUrl,
          type: ChatUIKitProfileType.group,
          extension: extension,
          timestamp: timestamp,
        );

  /// Create a custom profile object.
  /// [id] is the id.
  /// [showName] is the show name.
  /// [avatarUrl] is the avatar address.
  /// [remark] is the remark information.
  /// [extension] is the extension field.
  /// [timestamp] is the timestamp.
  ChatUIKitProfile.custom({
    required String id,
    String? showName,
    String? avatarUrl,
    String? remark,
    Map<String, String>? extension,
    int timestamp = 0,
  }) : this(
          id: id,
          showName: showName,
          avatarUrl: avatarUrl,
          type: ChatUIKitProfileType.custom,
          extension: extension,
          remark: remark,
          timestamp: timestamp,
        );

  ///
  /// Copy the current object and modify the specified attributes.
  /// [showName] is the show name. when type is contact, it is the user nickname, when type is group, it is the group name.
  /// [avatarUrl] is the user avatar address.
  /// [extension] is the extension field.
  /// [remark] is the user remark information.
  /// [timestamp] is the timestamp.
  ChatUIKitProfile copyWith({
    String? showName,
    String? avatarUrl,
    Map<String, String>? extension,
    String? remark,
    int? timestamp,
  }) {
    return ChatUIKitProfile(
      id: id,
      showName: showName ?? this.showName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      type: type,
      extension: extension ?? this.extension,
      timestamp: timestamp ?? this.timestamp,
      remark: remark ?? this.remark,
    );
  }

  @override
  String toString() {
    return "id: $id, nickname: $showName, type: $type, avatar: $avatarUrl, remark: $remark \n";
  }
}
