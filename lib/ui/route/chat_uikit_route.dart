import '../../chat_uikit.dart';
import '../../universal/inner_headers.dart';

import 'package:flutter/material.dart';

typedef ChatUIKitWidgetBuilder = Widget Function(
  BuildContext context,
  Object? arguments,
);

/// 用于标记路由 [ChatUIKitRouteBackModel] 类型。
enum ChatUIKitRouteBackType { add, remove, update }

/// 路由返回信息，用于标记路由返回到上一页时的变更类型和 profileId
class ChatUIKitRouteBackModel {
  /// profileId对应信息更新。
  ChatUIKitRouteBackModel.update(this.profileId)
      : type = ChatUIKitRouteBackType.update;

  /// 信息添加。
  ChatUIKitRouteBackModel.add(this.profileId)
      : type = ChatUIKitRouteBackType.add;

  /// 信息删除。
  ChatUIKitRouteBackModel.remove(this.profileId)
      : type = ChatUIKitRouteBackType.remove;

  const ChatUIKitRouteBackModel({
    required this.type,
    required this.profileId,
  });

  /// 用于复制当前对象。 [ChatUIKitRouteBackModel] 为不可变对象，当需要修改时，需要复制一份新的对象。
  ChatUIKitRouteBackModel copy() {
    return ChatUIKitRouteBackModel(
      type: type,
      profileId: profileId,
    );
  }

  /// 信息变更类型。
  final ChatUIKitRouteBackType type;

  /// profileId。
  final String profileId;
}

/// 路由
class ChatUIKitRoute {
  static ChatUIKitRoute? _instance;
  static bool hasInit = false;
  static ChatUIKitRouteBackModel? _lastBackModel;

  /// 路由初始化，如果使用路由，需要先调用此方法。`ChatUIKitRoute.instance;`
  static ChatUIKitRoute get instance => _instance ??= ChatUIKitRoute._();

  factory ChatUIKitRoute() => _instance ??= ChatUIKitRoute._();

  ChatUIKitRoute._() {
    hasInit = true;
  }

  final Map<String, ChatUIKitWidgetBuilder> uikitRoutes =
      <String, ChatUIKitWidgetBuilder>{
    ChatUIKitRouteNames.changeInfoView: (context, arguments) {
      return ChangeInfoView.arguments(
        arguments as ChangeInfoViewArguments,
      );
    },
    ChatUIKitRouteNames.contactDetailsView: (context, arguments) {
      return ContactDetailsView.arguments(
        arguments as ContactDetailsViewArguments,
      );
    },
    ChatUIKitRouteNames.contactsView: (context, arguments) {
      return ContactsView.arguments(
        arguments as ContactsViewArguments,
      );
    },
    ChatUIKitRouteNames.groupChangeOwnerView: (context, arguments) {
      return GroupChangeOwnerView.arguments(
        arguments as GroupChangeOwnerViewArguments,
      );
    },
    ChatUIKitRouteNames.groupDetailsView: (context, arguments) {
      return GroupDetailsView.arguments(
        arguments as GroupDetailsViewArguments,
      );
    },
    ChatUIKitRouteNames.newRequestsView: (context, arguments) {
      return NewRequestsView.arguments(
        arguments as NewRequestsViewArguments,
      );
    },
    ChatUIKitRouteNames.groupsView: (context, arguments) {
      return GroupsView.arguments(
        arguments as GroupsViewArguments,
      );
    },
    ChatUIKitRouteNames.selectContactsView: (context, arguments) {
      return SelectContactView.arguments(
        arguments as SelectContactViewArguments,
      );
    },
    ChatUIKitRouteNames.newRequestDetailsView: (context, arguments) {
      return NewRequestDetailsView.arguments(
        arguments as NewRequestDetailsViewArguments,
      );
    },
    ChatUIKitRouteNames.searchUsersView: (context, arguments) {
      return SearchView.arguments(
        arguments as SearchViewArguments,
      );
    },
    ChatUIKitRouteNames.groupMembersView: (context, arguments) {
      return GroupMembersView.arguments(
        arguments as GroupMembersViewArguments,
      );
    },
    ChatUIKitRouteNames.groupAddMembersView: (context, arguments) {
      return GroupAddMembersView.arguments(
        arguments as GroupAddMembersViewArguments,
      );
    },
    ChatUIKitRouteNames.groupDeleteMembersView: (context, arguments) {
      return GroupDeleteMembersView.arguments(
        arguments as GroupDeleteMembersViewArguments,
      );
    },
    ChatUIKitRouteNames.searchGroupMembersView: (context, arguments) {
      return SearchGroupMembersView.arguments(
        arguments as SearchGroupMembersViewArguments,
      );
    },
    ChatUIKitRouteNames.messagesView: (context, arguments) {
      return MessagesView.arguments(
        arguments as MessagesViewArguments,
      );
    },
    ChatUIKitRouteNames.conversationsView: (context, arguments) {
      return ConversationsView.arguments(
        arguments as ConversationsViewArguments,
      );
    },
    ChatUIKitRouteNames.showImageView: (context, arguments) {
      return ShowImageView.arguments(
        arguments as ShowImageViewArguments,
      );
    },
    ChatUIKitRouteNames.showVideoView: (context, arguments) {
      return ShowVideoView.arguments(
        arguments as ShowVideoViewArguments,
      );
    },
    ChatUIKitRouteNames.currentUserInfoView: (context, arguments) {
      return CurrentUserInfoView.arguments(
        arguments as CurrentUserInfoViewArguments,
      );
    },
    ChatUIKitRouteNames.createGroupView: (context, arguments) {
      return CreateGroupView.arguments(
        arguments as CreateGroupViewArguments,
      );
    },
    ChatUIKitRouteNames.groupMentionView: (context, arguments) {
      return GroupMentionView.arguments(
        arguments as GroupMentionViewArguments,
      );
    },
    ChatUIKitRouteNames.reportMessageView: ((context, arguments) {
      return ReportMessageView.arguments(
        arguments as ReportMessageViewArguments,
      );
    }),
    ChatUIKitRouteNames.forwardMessageSelectView: (context, arguments) {
      return ForwardMessageSelectView.arguments(
        arguments as ForwardMessageSelectViewArguments,
      );
    },
    ChatUIKitRouteNames.forwardMessagesView: (context, arguments) {
      return ForwardMessagesView.arguments(
        arguments as ForwardMessagesViewArguments,
      );
    },
    ChatUIKitRouteNames.threadMessagesView: (context, arguments) {
      return ThreadMessagesView.arguments(
        arguments as ThreadMessagesViewArguments,
      );
    },
    ChatUIKitRouteNames.threadMembersView: (context, arguments) {
      return ThreadMembersView.arguments(
        arguments as ThreadMembersViewArguments,
      );
    },
    ChatUIKitRouteNames.threadsView: (context, arguments) {
      return ThreadsView.arguments(
        arguments as ThreadsViewArguments,
      );
    },
    ChatUIKitRouteNames.searchHistoryView: (context, arguments) {
      return SearchHistoryView.arguments(
        arguments as SearchHistoryViewArguments,
      );
    }
  };

  static ChatUIKitRouteBackModel? get lastModel {
    ChatUIKitRouteBackModel? ret = _lastBackModel?.copy();
    _lastBackModel = null;
    return ret;
  }

  static pop(BuildContext context, {int sceneCount = 1}) {
    int popScene = sceneCount;
    Navigator.popUntil(context, (route) {
      return popScene-- <= 0;
    });
  }

  /// 返回到根页面
  static popToRoot(
    BuildContext context, {
    ChatUIKitRouteBackModel? model,
  }) {
    _lastBackModel = model;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  /// 返回到群组列表页面，如果没找到，则返回根页面
  static popToGroupsView(
    BuildContext context, {
    ChatUIKitRouteBackModel? model,
  }) {
    _lastBackModel = model;
    Navigator.of(context).popUntil((route) {
      return route.settings.name == ChatUIKitRouteNames.groupsView ||
          route.isFirst;
    });
  }

  /// 返回到联系人列表页面，如果没找到，则返回根页面
  static popToContactsView(
    BuildContext context, {
    ChatUIKitRouteBackModel? model,
  }) {
    _lastBackModel = model;
    Navigator.of(context).popUntil((route) {
      return route.settings.name == ChatUIKitRouteNames.contactsView ||
          route.isFirst;
    });
  }

  /// 返回到联系人列表页面，如果没找到，则返回根页面
  static void popToMessagesView(
    BuildContext context, {
    ChatUIKitRouteBackModel? model,
  }) {
    _lastBackModel = model;
    Navigator.of(context).popUntil((route) {
      chatPrint('route.settings.name: ${route.settings.toString()}');
      return route.settings.name == ChatUIKitRouteNames.messagesView ||
          route.isFirst;
    });
  }

  /// ChatUIKit 路由拦截器, 可以在 `onGenerateRoute` 中进行拦截，如果拦截失败，再进行你自己的路由跳转。
  ///
  /// ```dart
  ///   onGenerateRoute: (settings) {
  ///     return ChatUIKitRoute().generateRoute(settings) ??
  ///         MaterialPageRoute(
  ///             builder: (context) {
  ///               return const HomePage();
  ///             },
  ///         );
  ///   },
  /// ```
  Route? generateRoute<T extends Object>(RouteSettings settings) {
    if (settings.arguments is ChatUIKitViewArguments) {
      ChatUIKitWidgetBuilder? builder = uikitRoutes[settings.name];
      if (builder != null) {
        final route = MaterialPageRoute(
          builder: (context) {
            return builder(context, settings.arguments);
          },
          settings: settings,
        );

        return route;
      }
      return null;
    } else {
      return null;
    }
  }

  /// 路由跳转，如果没有初始化，则使用 [MaterialPageRoute] 进行跳转。
  static Future<T?> pushOrPushNamed<T extends Object?>(
    BuildContext context,
    String pushName,
    ChatUIKitViewArguments arguments,
  ) {
    // addPushName(pushName);
    if (hasInit) {
      return Navigator.of(context).pushNamed(
        pushName,
        arguments: arguments,
      );
    } else {
      return Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return ChatUIKitRouteNames.getWidgetFromName(
              pushName,
              arguments,
            );
          },
        ),
      );
    }
  }

  // static void addPushName(String pushName) {
  //   pushedName.add(pushName);
  //   chatPrint('pushedName: $pushedName');
  // }

  // static List<String> pushedName = [];
}
