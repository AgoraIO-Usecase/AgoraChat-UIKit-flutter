// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:agora_chat_uikit/chat_uikit.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:example/demo/demo_localizations.dart';
import 'package:example/demo/pages/help/download_page.dart';
import 'package:example/demo/tool/user_data_store.dart';

class ChatRouteFilter {
  static RouteSettings chatRouteSettings(RouteSettings settings) {
    // 拦截 ChatUIKitRouteNames.messagesView, 之后对要跳转的页面的 `RouteSettings` 进行自定义，之后返回。
    if (settings.name == ChatUIKitRouteNames.messagesView) {
      return messagesView(settings);
    } else if (settings.name == ChatUIKitRouteNames.createGroupView) {
      return createGroupView(settings);
    } else if (settings.name == ChatUIKitRouteNames.contactDetailsView) {
      return contactDetails(settings);
    } else if (settings.name == ChatUIKitRouteNames.groupDetailsView) {
      return groupDetails(settings);
    }
    return settings;
  }

  static RouteSettings groupDetails(RouteSettings settings) {
    ChatUIKitViewObserver? viewObserver = ChatUIKitViewObserver();
    GroupDetailsViewArguments arguments =
        settings.arguments as GroupDetailsViewArguments;

    arguments = arguments.copyWith(viewObserver: viewObserver);
    Future(() async {
      Group group = await ChatUIKit.instance.fetchGroupInfo(
        groupId: arguments.profile.id,
      );
      ChatUIKitProfile profile = arguments.profile.copyWith(
        showName: group.name,
        avatarUrl: group.extension,
      );
      ChatUIKitProvider.instance.addProfiles([profile]);
      UserDataStore().saveUserData(profile);
    }).then((value) {
      // 刷新ui
      viewObserver.refresh();
    }).catchError((e) {
      debugPrint('fetch group info error');
    });
    return RouteSettings(name: settings.name, arguments: arguments);
  }

  // 自定义 contact detail view
  static RouteSettings contactDetails(RouteSettings settings) {
    return settings;
    // ChatUIKitViewObserver? viewObserver = ChatUIKitViewObserver();
    // ContactDetailsViewArguments arguments =
    //     settings.arguments as ContactDetailsViewArguments;

    // arguments = arguments.copyWith(
    //   viewObserver: viewObserver,

    //   // 添加 remark 实现
    //   itemsBuilder: (context, profile, models) {
    //     return [
    //       ChatUIKitDetailsListViewItemModel(
    //         title: DemoLocalizations.contactRemark.localString(context),
    //         trailing: Text(
    //           ChatUIKitProvider.instance.getProfile(arguments.profile).remark ??
    //               '',
    //           textScaler: TextScaler.noScaling,
    //         ),
    //         onTap: () async {
    //           String errStr =
    //               DemoLocalizations.contactRemarkFailed.localString(context);
    //           String? remark = await showChatUIKitDialog(
    //             context: context,
    //             title: DemoLocalizations.contactRemark.localString(context),
    //             inputItems: [
    //               ChatUIKitDialogInputContentItem(
    //                 hintText: DemoLocalizations.contactRemarkDesc
    //                     .localString(context),
    //                 maxLength: 32,
    //               )
    //             ],
    //             actionItems: [
    //               ChatUIKitDialogAction.inputsConfirm(
    //                 label: DemoLocalizations.contactRemarkConfirm
    //                     .localString(context),
    //                 onInputsTap: (inputs) async {
    //                   Navigator.of(context).pop(inputs.first);
    //                 },
    //               ),
    //               ChatUIKitDialogAction.cancel(
    //                   label: DemoLocalizations.contactRemarkCancel
    //                       .localString(context)),
    //             ],
    //           );

    //           if (remark?.isNotEmpty == true) {
    //             ChatUIKit.instance
    //                 .updateContactRemark(arguments.profile.id, remark!)
    //                 .then((value) {
    //               ChatUIKitProfile profile =
    //                   arguments.profile.copyWith(remark: remark);
    //               // 更新数据，并设置到provider中
    //               UserDataStore().saveUserData(profile);
    //               ChatUIKitProvider.instance.addProfiles([profile]);
    //             }).catchError((e) {
    //               EasyLoading.showError(errStr);
    //             });
    //           }
    //         },
    //       ),
    //       ...models,
    //     ];
    //   },
    // );

    // // 异步更新用户信息
    // Future(() async {
    //   String userId = arguments.profile.id;
    //   try {
    //     Map<String, UserInfo> map =
    //         await ChatUIKit.instance.fetchUserInfoByIds([userId]);
    //     UserInfo? userInfo = map[userId];
    //     Contact? contact = await ChatUIKit.instance.getContact(userId);
    //     if (contact != null) {
    //       ChatUIKitProfile profile = ChatUIKitProfile.contact(
    //         id: contact.userId,
    //         nickname: userInfo?.nickName,
    //         avatarUrl: userInfo?.avatarUrl,
    //         remark: contact.remark,
    //       );
    //       // 更新数据，并设置到provider中
    //       UserDataStore().saveUserData(profile);
    //       ChatUIKitProvider.instance.addProfiles([profile]);
    //     }
    //   } catch (e) {
    //     debugPrint('fetch user info error');
    //   }
    // }).then((value) {
    //   viewObserver.refresh();
    // }).catchError((e) {});

    // return RouteSettings(name: settings.name, arguments: arguments);
  }

  // 为 MessagesView 添加文件点击下载
  static RouteSettings messagesView(RouteSettings settings) {
    MessagesViewArguments arguments =
        settings.arguments as MessagesViewArguments;
    ChatUIKitViewObserver viewObserver = ChatUIKitViewObserver();
    MessagesViewController controller = MessagesViewController(
      profile: arguments.profile,
    );
    bool visible = true;

    arguments = arguments.copyWith(
        controller: controller,
        viewObserver: viewObserver,
        appBarModel: ChatUIKitAppBarModel(
          title: 'test',
          trailingActions: [
            ChatUIKitAppBarAction(
              child: const Icon(Icons.add),
              onTap: (context) {
                final msg = ChatUIKitMessage.createAlertMessage(
                  arguments.profile.id,
                  arguments.profile.type == ChatUIKitProfileType.group
                      ? ChatType.GroupChat
                      : ChatType.Chat,
                  params: {
                    'alert': '自定义的提醒消息',
                  },
                );
                ChatUIKit.instance.insertMessage(
                  message: msg,
                  runMessageReceived: true,
                  needUpdateConversationList: true,
                );
              },
            ),
          ],
        ),
        alertItemBuilder: (context, child, model) {
          if (model.message.isAlertCustomMessage) {
            String? alert = model.message.customBodyParams?['warning'];
            return Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 3),
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                // decoration: BoxDecoration(
                //   color: Colors.grey,
                //   borderRadius: BorderRadius.circular(3),
                // ),
                child: Text(
                  alert ?? '演示功能，无真实数据，仅供体验',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          } else {
            return Container(
              //color: Colors.red,
              child: child,
            );
          }
        },
        showMessageItemNickname: (model) {
          // 只有群组消息并且不是自己发的消息显示昵称
          return (arguments.profile.type == ChatUIKitProfileType.group) &&
              model.message.from != ChatUIKit.instance.currentUserId;
        },
        bubbleContentBuilder: (context, model) {
          if (model.message.bodyType == MessageType.TXT) {
            return ChatUIKitTextBubbleWidget(
              model: model,
              onExpTap: (expStr) {
                debugPrint('expStr: $expStr');
              },
            );
          }
          return null;
        },
        onItemTap: (ctx, messageModel, rect) {
          if (messageModel.message.bodyType == MessageType.FILE) {
            Navigator.of(ctx).push(
              MaterialPageRoute(
                builder: (context) => DownloadFileWidget(
                  message: messageModel.message,
                  key: ValueKey(messageModel.message.localTime),
                ),
              ),
            );
            return true;
          }
          return false;
        },
        floatingWidget: (ctx) {
          if (!visible) {
            return const SizedBox.shrink();
          }
          Future.delayed(const Duration(seconds: 4), () {
            if (ctx.mounted) {
              visible = false;
              viewObserver.refresh();
            }
          });
          return IgnorePointer(
            ignoring: !visible,
            child: AnimatedOpacity(
              opacity: visible ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(top: 60, left: 8, right: 8),
                height: 78,
                decoration: BoxDecoration(
                  color: ChatUIKitTheme.instance.color.isDark
                      ? ChatUIKitTheme.instance.color.neutralColor2
                      : ChatUIKitTheme.instance.color.neutralSpecialColor9,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.error,
                      color: ChatUIKitTheme.instance.color.primaryColor5,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '请勿轻信任何关于汇款、中奖等信息，务必提高警惕，谨慎对待来自陌生号码的电话。如遇可疑情况，请及时向相关部门反馈并采取必要的防范措施。',
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: ChatUIKitTheme.instance.color.isDark
                                    ? ChatUIKitTheme
                                        .instance.color.neutralColor9
                                    : ChatUIKitTheme
                                        .instance.color.neutralColor3,
                              ),
                            ),
                            TextSpan(
                              text: '点击举报',
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color:
                                    ChatUIKitTheme.instance.color.primaryColor5,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  EasyLoading.show(status: '举报中...');
                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    () {
                                      EasyLoading.showSuccess('举报成功');
                                    },
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Icon(
                          Icons.close,
                          color: ChatUIKitTheme.instance.color.isDark
                              ? ChatUIKitTheme.instance.color.neutralColor9
                              : ChatUIKitTheme.instance.color.neutralColor3,
                          size: 16,
                        ),
                      ),
                      onTapUp: (details) {
                        visible = false;
                        viewObserver.refresh();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        backgroundWidget: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                '您使用的是',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '演示 DEMO',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '仅限体验功能',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 2),
              Text(
                '数据全部为虚拟内容',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ));

    return RouteSettings(name: settings.name, arguments: arguments);
  }

  // 添加创建群组拦截，并添加设置群名称功能
  static RouteSettings createGroupView(RouteSettings settings) {
    CreateGroupViewArguments arguments =
        settings.arguments as CreateGroupViewArguments;
    arguments = arguments.copyWith(
      createGroupHandler: (context, selectedProfiles) async {
        String? groupName = await showChatUIKitDialog(
          context: context,
          title: DemoLocalizations.createGroupName.localString(context),
          inputItems: [
            ChatUIKitDialogInputContentItem(
              hintText: DemoLocalizations.createGroupDesc.localString(context),
              maxLength: 32,
            ),
          ],
          actionItems: [
            ChatUIKitDialogAction.cancel(
              label: DemoLocalizations.createGroupCancel.localString(context),
            ),
            ChatUIKitDialogAction.inputsConfirm(
              label: DemoLocalizations.createGroupConfirm.localString(context),
              onInputsTap: (inputs) async {
                Navigator.of(context).pop(inputs.first);
              },
            ),
          ],
        );

        if (groupName != null) {
          return CreateGroupInfo(
            inviteMembers: [selectedProfiles.first],
            groupName: groupName,
            onGroupCreateCallback: (group, error) {
              if (error != null) {
                showChatUIKitDialog(
                  context: context,
                  title: DemoLocalizations.createGroupFailed.localString(
                    context,
                  ),
                  content: error.description,
                  actionItems: [
                    ChatUIKitDialogAction.confirm(
                      label: DemoLocalizations.createGroupConfirm.localString(
                        context,
                      ),
                    ),
                  ],
                );
              } else {
                Navigator.of(context).pop();

                if (group != null) {
                  ChatUIKitRoute.pushOrPushNamed(
                    context,
                    ChatUIKitRouteNames.messagesView,
                    MessagesViewArguments(
                      profile: ChatUIKitProfile.group(
                        id: group.groupId,
                        groupName: group.name,
                      ),
                    ),
                  );
                }
              }
            },
          );
        } else {
          return null;
        }
      },
    );

    return RouteSettings(name: settings.name, arguments: arguments);
  }
}
