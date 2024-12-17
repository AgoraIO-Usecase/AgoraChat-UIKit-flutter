import 'universal/inner_headers.dart';
import 'package:flutter/widgets.dart';

mixin ChatUIKitLocal {
  static const String conversationsViewMenuAddContact =
      'new_chat_button_click_menu_add_contacts';
  static const String conversationsViewMenuCreateGroup =
      'new_chat_button_click_menu_create_group';
  static const String conversationsViewMenuCreateNewChat =
      'new_chat_button_click_menu_create_new_chat';
  static const String conversationsViewMenuSelectContacts =
      'new_chat_button_click_menu_select_contacts';
  static const String conversationsViewMenuCancel =
      'new_chat_button_click_menu_cancel';
  static const String conversationsViewSearchHint =
      'conversations_view_search_hint';

  static const String conversationListLongPressMenuDelete =
      'conversation_list_long_pressed_menu_delete';
  static const String conversationListLongPressMenuPin =
      'conversation_list_long_pressed_menu_pin';
  static const String conversationListLongPressMenuUnPin =
      'conversation_list_long_pressed_menu_unpin';
  static const String conversationListLongPressMenuMute =
      'conversation_list_long_pressed_menu_mute';
  static const String conversationListLongPressMenuUnmute =
      'conversation_list_long_pressed_menu_unmute';
  static const String conversationListLongPressMenuRead =
      'conversation_list_long_pressed_menu_read';
  static const String conversationListLongPressMenuCancel =
      'conversation_list_long_pressed_menu_cancel';

  static const String messageListLongPressMenuCopy =
      'message_list_long_pressed_menu_copy';
  static const String messageListLongPressMenuReply =
      'message_list_long_pressed_menu_reply';
  static const String messageListLongPressMenuEdit =
      'message_list_long_pressed_menu_edit';
  static const String messageListLongPressMenuDelete =
      'message_list_long_pressed_menu_delete';
  static const String messageListLongPressMenuRecall =
      'message_list_long_pressed_menu_recall';
  static const String messageListLongPressMenuMulti =
      'message_list_long_pressed_menu_multi';
  static const String messageListLongPressMenuPin =
      'message_list_long_pressed_menu_pin';
  static const String messageListLongPressMenuTranslate =
      'message_list_long_pressed_menu_translate';
  static const String messageListLongPressMenuTranslateOrigin =
      'message_list_long_pressed_menu_translate_origin';
  static const String messageListLongPressMenuCreateThread =
      'message_list_long_pressed_menu_create_thread';
  static const recordBarRecord = 'record_bar_record';
  static const recordBarRecording = 'record_bar_recording';
  static const recordBarPlay = 'record_bar_play';
  static const recordBarPlaying = 'record_bar_playing';
  static const recordBarAutoStop = 'record_bar_auto_stop';

  static const addContactTitle = 'add_contact_title';
  static const addContactSubTitle = 'add_contact_sub_title';
  static const addContactInputHints = 'add_contact_input_hints';
  static const addContactConfirm = 'add_contact_add';
  static const addContactCancel = 'add_contact_cancel';
  static const historyMessages = 'history_messages';
  static const createGroupViewTitle = 'create_group_view_title';
  static const createGroupViewCreate = 'create_group_view_create';
  static const createGroupViewSearchContact =
      'create_group_view_search_contact';
  static const createGroupViewCancel = 'create_group_view_cancel';

  static const contactsViewNewRequests = 'contacts_view_new_request';
  static const contactsViewGroups = 'contacts_view_groups';
  static const contactsViewSearch = 'contacts_view_search';
  static const contactsAddContactAlertTitle =
      'contacts_add_contact_alert_title';
  static const contactsAddContactAlertSubTitle =
      'contacts_add_contact_alert_sub_title';
  static const contactsAddContactAlertHintText =
      'contacts_add_contact_alert_hint_text';
  static const contactsAddContactAlertButtonConfirm =
      'contacts_add_contact_alert_button_confirm';
  static const contactsAddContactAlertButtonCancel =
      'contacts_add_contact_alert_button_cancel';

  static const contactDetailViewSend = 'contact_detail_view_send';
  static const contactDetailViewSearch = 'contact_detail_view_search';
  static const contactDetailViewRemark = 'contact_detail_view_remark';
  static const contactDetailViewPhone = 'contact_detail_view_phone';
  static const contactDetailViewDoNotDisturb =
      'contact_detail_view_do_not_disturb';
  static const contactDetailViewBlock = 'contact_detail_view_block';
  static const contactDetailViewClearChatHistory =
      'contact_detail_view_clear_chat_history';
  static const contactDetailViewClearChatHistoryAlertTitle =
      'contact_detail_view_clear_chat_history_alert_title';
  static const contactDetailViewClearChatHistoryAlertSubTitle =
      'contact_detail_view_clear_chat_history_alert_sub_title';
  static const contactDetailViewClearChatHistoryAlertButtonConfirm =
      'contact_detail_view_clear_chat_history_alert_button_confirm';
  static const contactDetailViewClearChatHistoryAlertButtonCancel =
      'contact_detail_view_clear_chat_history_alert_button_cancel';
  static const contactDetailViewDelete = 'contact_detail_view_delete';
  static const contactDetailViewCancel = 'contact_detail_view_cancel';
  static const contactDetailViewDeleteAlertTitle =
      'contact_detail_view_delete_alert_title';
  static const contactDetailViewDeleteAlertSubTitle =
      'contact_detail_view_delete_alert_sub_title';
  static const contactDetailViewDeleteAlertButtonConfirm =
      'contact_detail_view_delete_alert_button_confirm';
  static const contactDetailViewDeleteAlertButtonCancel =
      'contact_detail_view_delete_alert_button_cancel';

  static const forwardMessageViewTitle = 'forward_message_view_title';
  static const forwardMessage = 'forward_message';
  static const forwardedMessage = 'forwarded_message';
  static const forwardedMessageDownloadError =
      'forwarded_message_download_error';
  static const forwardSelectContacts = 'forward_select_contact';
  static const forwardSelectGroups = 'forward_select_group';

  static const groupDetailViewSend = 'group_detail_view_send';
  static const groupDetailViewDoNotDisturb = 'group_detail_view_do_not_disturb';
  static const groupDetailViewClearChatHistory =
      'group_detail_view_clear_chat_history';
  static const groupDetailViewClearChatHistoryAlertButtonConfirm =
      'group_detail_view_clear_chat_history_alert_button_confirm';
  static const groupDetailViewClearChatHistoryAlertButtonCancel =
      'group_detail_view_clear_chat_history_alert_button_cancel';
  static const groupDetailViewCancel = 'group_detail_view_cancel';
  static const groupDetailViewMember = 'group_detail_view_group_member';
  static const groupDetailViewGroupName = 'group_detail_view_group_name';
  static const groupDetailViewDescription = 'group_detail_view_description';
  static const groupDetailViewSwitchPublic = 'group_detail_view_switch_public';
  static const groupDetailViewTransferGroup =
      'group_detail_view_transfer_group';
  static const groupDetailViewDisbandGroup = 'group_detail_view_disband_group';
  static const groupDetailViewDisbandAlertTitle =
      'group_detail_view_disband_alert_title';
  static const groupDetailViewDisbandAlertSubTitle =
      'group_detail_view_disband_alert_sub_title';
  static const groupDetailViewDisbandAlertButtonConfirm =
      'group_detail_view_disband_alert_button_confirm';
  static const groupDetailViewDisbandAlertButtonCancel =
      'group_detail_view_disband_alert_button_cancel';
  static const groupDetailViewLeaveGroup = 'group_detail_view_leave_group';
  static const groupDetailViewLeaveAlertTitle =
      'group_detail_view_leave_alert_title';
  static const groupDetailViewLeaveAlertSubTitle =
      'group_detail_view_leave_alert_sub_title';
  static const groupDetailViewLeaveAlertButtonConfirm =
      'group_detail_view_leave_alert_button_confirm';
  static const groupDetailViewLeaveAlertButtonCancel =
      'group_detail_view_leave_alert_button_cancel';
  static const groupDetailChangeGroupName = 'group_detail_change_group_name';
  static const groupDetailChangeGroupDescription =
      'group_detail_change_group_description';

  static const groupMentionViewMentionAll = 'group_mention_view_mention_all';
  static const groupMentionViewTitle = 'group_mention_view_title';
  static const groupMentionViewSearchHint = 'group_mention_view_search_hint';

  static const groupAddMembersViewTitle = 'group_add_member_view_title';
  static const groupAddMembersViewSearchContact =
      'group_add_member_view_search_contact';
  static const groupAddMembersViewAdd = 'group_add_member_view_add';

  static const groupDeleteMembersViewTitle = 'group_delete_member_view_title';
  static const groupDeleteMembersViewSearchMember =
      'group_delete_member_view_search_member';
  static const groupDeleteMembersViewDelete = 'group_delete_member_view_delete';

  static const groupDeleteMembersViewAlertTitle =
      'group_delete_member_view_alert_title';
  static const groupDeleteMembersViewAlertSubTitle =
      'group_delete_member_view_alert_sub_title';
  static const groupDeleteMembersViewAlertButtonConfirm =
      'group_delete_member_view_alert_button_confirm';
  static const groupDeleteMembersViewAlertButtonCancel =
      'group_delete_member_view_alert_button_cancel';
  static const groupMembersViewTitle = 'group_members_view_title';
  static const groupMembersSearch = 'group_members_view_search';
  static const groupMembersMentionViewTitle =
      'group_members_mention_view_title';
  static const groupChangeOwnerViewTitle = 'group_change_owner_view_title';
  static const groupChangeOwnerViewAlertTitle =
      'group_change_owner_view_alert_title';
  static const groupChangeOwnerViewAlertSubTitle =
      'group_change_owner_view_alert_sub_title';
  static const groupChangeOwnerViewAlertButtonConfirm =
      'group_change_owner_view_alert_button_confirm';
  static const groupChangeOwnerViewAlertButtonCancel =
      'group_change_owner_view_alert_button_cancel';

  static const groupsViewTitle = 'groups_view_title';

  static const changInfoViewSave = 'change_info_view_save';
  static const changInfoViewInputHint = 'change_info_view_input_hint';
  static const alertDestroy = 'messages_view_group_destroy_info';
  static const alertLeave = 'messages_view_group_leave_info';
  static const alertKickedInfo = 'messages_view_group_kicked_info';
  static const alertRecallInfo = 'messages_view_recall_info';
  static const alertYou = 'messages_view_recall_info_you';
  static const alertAlreadyAdd = 'message_view_already_add';
  static const alertAsContact = 'message_view_as_contact';
  static const alertPinTitle = 'messages_view_alert_pin_title';
  static const alertUnpinTitle = 'messages_view_alert_unpin_title';

  static const messagesViewAlertGroupInfoTitle =
      'messages_view_alert_group_info_title';
  static const messagesViewAlertThreadInfoTitle =
      'messages_view_alert_thread_info_title';
  static const messageViewAlertShowDetail = 'message_view_alert_show_detail';

  static const messagesViewEditMessageTitle =
      'messages_view_edit_message_title';
  static const messagesViewMoreActionsTitleAlbum =
      'messages_view_more_actions_title_album';
  static const messagesViewMoreActionsTitleCamera =
      'messages_view_more_actions_title_camera';
  static const messagesViewMoreActionsTitleFile =
      'messages_view_more_actions_title_file';
  static const messagesViewMoreActionsTitleLocation =
      'messages_view_more_actions_title_location';
  static const messagesViewMoreActionsTitleVideo =
      'messages_view_more_actions_title_video';
  static const messagesViewMoreActionsTitleVoice =
      'messages_view_more_actions_title_voice';
  static const messagesViewMoreActionsTitleContact =
      'messages_view_more_actions_title_contact';
  static const messagesViewLongPressActionsTitleCopy =
      'messages_view_long_press_actions_title_copy';
  static const messagesViewLongPressActionsTitleRecall =
      'messages_view_long_press_actions_title_recall';
  static const messagesViewLongPressActionsTitleDelete =
      'messages_view_long_press_actions_title_delete';
  static const messagesViewLongPressActionsTitleReply =
      'messages_view_long_press_actions_title_reply';
  static const messagesViewLongPressActionsTitleEdit =
      'messages_view_long_press_actions_title_edit';
  static const messagesViewLongPressActionsTitleReport =
      'messages_view_long_press_actions_title_report';
  static const messagesViewDeleteMessageAlertTitle =
      'messages_view_delete_message_alert_title';
  static const messagesViewDeleteMessageAlertSubTitle =
      'messages_view_delete_message_alert_sub_title';
  static const messagesViewDeleteMessageAlertButtonConfirm =
      'messages_view_delete_message_alert_confirm';
  static const messagesViewDeleteMessageAlertButtonCancel =
      'messages_view_delete_message_alert_cancel';
  static const messagesViewRecallMessageAlertTitle =
      'messages_view_recall_message_alert_title';
  static const messagesViewRecallMessageAlertSubTitle =
      'messages_view_recall_message_alert_sub_title';
  static const messagesViewRecallMessageAlertButtonConfirm =
      'messages_view_recall_message_alert_confirm';
  static const messagesViewRecallMessageAlertButtonCancel =
      'messages_view_recall_message_alert_cancel';
  static const messagesViewSelectContactTitle =
      'messages_view_select_contact_title';
  static const messagesViewSelectContactCancel =
      'messages_view_select_contact_cancel';
  static const messagesViewShareContactAlertTitle =
      'messages_view_share_contact_alert_title';
  static const messagesViewShareContactAlertSubTitle =
      'messages_view_share_contact_alert_sub_title';
  static const messagesViewShareContactAlertSubTitleTo =
      'messages_view_share_contact_alert_sub_title_to';
  static const messagesViewShareContactAlertButtonConfirm =
      'messages_view_share_contact_alert_confirm';
  static const messagesViewShareContactAlertButtonCancel =
      'messages_view_share_contact_alert_cancel';
  static const messagesViewTyping = 'messages_view_typing';

  static const messageCellCombineText = 'message_cell_combine_text';
  static const messageCellCombineImage = 'message_cell_combine_image';
  static const messageCellCombineVoice = 'message_cell_combine_voice';
  static const messageCellCombineVideo = 'message_cell_combine_video';
  static const messageCellCombineFile = 'message_cell_combine_file';
  static const messageCellCombineContact = 'message_cell_combine_contact';
  static const messageCellCombineLocation = 'message_cell_combine_location';
  static const messageCellCombineCombine = 'message_cell_combine_combine';

  static const newRequestDetailsViewAddContact =
      'new_request_details_view_add_contact';
  static const newRequestsViewTitle = 'new_requests_view_title';

  static const reportMessageViewTitle = 'report_message_view_title';
  static const reportMessageViewReportReasons =
      'report_message_view_report_reasons';
  static const reportMessageViewConfirm = 'report_message_view_confirm';
  static const reportMessageViewCancel = 'report_message_view_cancel';

  static const reportTarget1 = 'tag1';
  static const reportTarget2 = 'tag2';
  static const reportTarget3 = 'tag3';
  static const reportTarget4 = 'tag4';
  static const reportTarget5 = 'tag5';
  static const reportTarget6 = 'tag6';
  static const reportTarget7 = 'tag7';
  static const reportTarget8 = 'tag8';
  static const reportTarget9 = 'tag9';

  static const selectContactViewSearchHint = 'select_contact_view_search_hint';

  static const nonSupportMessage = 'non_support_message';

  static const conversationListItemMention = 'conversation_list_item_mention';

  static const listViewLoadFailed = 'list_view_load_failed';
  static const listViewReload = 'list_view_reload';
  static const messageTextWidgetURLPreviewParsing =
      'message_text_widget_url_preview_parsing';
  static const quoteWidgetTitleImage = 'quote_widget_title_image';
  static const quoteWidgetTitleVideo = 'quote_widget_title_video';
  static const quoteWidgetTitleVoice = 'quote_widget_title_voice';
  static const quoteWidgetTitleFile = 'quote_widget_title_file';
  static const quoteWidgetTitleCombine = 'quote_widget_title_combine';
  static const quoteWidgetTitleContact = 'quote_widget_title_contact';
  static const quoteWidgetTitleUnFind = 'quote_widget_title_un_find';

  static const messageTranslated = 'message_translated';
  static const messageEdited = 'message_edited';

  static const messageListItemContactCard = 'message_list_item_contact_card';
  static const newRequestItemAdd = 'new_request_item_title';
  static const newRequestItemAddReason = 'new_request_item_add_reason';
  static const searchWidgetCancel = 'search_widget_cancel';

  static const replayBarTitleContact = 'replay_bar_title_contact';
  static const replayBarTitleFile = 'replay_bar_title_file';
  static const replayBarTitleCombine = 'replay_bar_title_combine';
  static const replayBarTitleVoice = 'replay_bar_title_voice';
  static const replayBarTitleVideo = 'replay_bar_title_video';
  static const replayBarTitleImage = 'replay_bar_title_image';
  static const replayBarTitle = 'replay_bar_title';

  static const confirm = 'confirm';
  static const cancel = 'cancel';

  static const bottomSheetCancel = 'bottom_sheet_cancel';

  static const threadsViewTitle = 'threads_view_title';
  static const threadNoLastMessage = 'thread_no_last_message';
  static const threadsMessageLeave = 'threads_message_leave';
  static const threadsMessageMembers = 'threads_message_members';
  static const threadsMessageEdit = 'threads_message_edit';
  static const threadsMessageDestroy = 'threads_message_destroy';
  static const threadEditName = 'thread_edit_name';
  static const threadNewName = 'thread_new_name';
  static const threadMembers = 'thread_members';

  static const searchHistory = 'search_history';

  static const pinMessages = 'pinMessages';
  static const hasPined = 'has_pined';
  static const byPined = 'by_pined';
  static const unPinInquire = 'un_pin_confirm';
  static const unPinConfirmed = 'un_pin_confirmed';

  static const floatingUnreadMessage = 'floating_unread_message';
  static const deleteSomeMessages = 'delete_some_messages';

  static const Map<String, String> zh = {
    conversationsViewMenuAddContact: '添加联系人',
    conversationsViewMenuCreateGroup: '创建群组',
    conversationsViewMenuSelectContacts: '选择联系人',
    conversationsViewMenuCreateNewChat: '新会话',
    conversationsViewMenuCancel: '取消',
    conversationsViewSearchHint: '搜索',
    conversationListLongPressMenuDelete: '删除',
    conversationListLongPressMenuPin: '置顶',
    conversationListLongPressMenuUnPin: '取消置顶',
    conversationListLongPressMenuMute: '免打扰',
    conversationListLongPressMenuUnmute: '取消免打扰',
    conversationListLongPressMenuRead: '标记为已读',
    conversationListLongPressMenuCancel: '取消',
    messageListLongPressMenuCopy: '复制',
    messageListLongPressMenuReply: '回复',
    messageListLongPressMenuEdit: '编辑',
    messageListLongPressMenuDelete: '删除',
    messageListLongPressMenuRecall: '撤回',
    messageListLongPressMenuMulti: '多选',
    messageListLongPressMenuPin: '置顶',
    messageListLongPressMenuTranslate: '翻译',
    messageListLongPressMenuTranslateOrigin: '隐藏译文',
    messageListLongPressMenuCreateThread: '创建话题',
    recordBarRecord: '点击录音',
    recordBarRecording: '正在录音',
    recordBarPlay: '点击播放',
    recordBarPlaying: '播放中',
    recordBarAutoStop: '%a秒后自动停止',
    addContactTitle: '添加联系人',
    addContactSubTitle: '通过用户ID添加联系人',
    addContactInputHints: '用户ID',
    addContactConfirm: '添加',
    addContactCancel: '取消',
    historyMessages: '聊天消息',
    createGroupViewTitle: '创建群组',
    createGroupViewCreate: '创建',
    createGroupViewSearchContact: '搜索联系人',
    createGroupViewCancel: '取消',
    contactsViewNewRequests: '新请求',
    contactsViewGroups: '群组',
    contactsViewSearch: '搜索联系人',
    contactsAddContactAlertTitle: '添加联系人',
    contactsAddContactAlertSubTitle: '通过用户ID添加联系人',
    contactsAddContactAlertHintText: '输入用户ID',
    contactsAddContactAlertButtonConfirm: '添加',
    contactsAddContactAlertButtonCancel: '取消',
    contactDetailViewSend: '发消息',
    contactDetailViewSearch: '搜索消息',
    contactDetailViewRemark: '备注',
    contactDetailViewPhone: '电话',
    contactDetailViewDoNotDisturb: '消息免打扰',
    contactDetailViewBlock: '加入黑名单',
    contactDetailViewClearChatHistory: '清空聊天记录',
    contactDetailViewClearChatHistoryAlertTitle: '清空聊天记录？',
    contactDetailViewClearChatHistoryAlertSubTitle: '清空聊天记录后，你将无法查看与该联系人的聊天记录。',
    contactDetailViewClearChatHistoryAlertButtonConfirm: '确认',
    contactDetailViewClearChatHistoryAlertButtonCancel: '取消',
    contactDetailViewDelete: '删除联系人',
    contactDetailViewCancel: '取消',
    contactDetailViewDeleteAlertTitle: '删除联系人？',
    contactDetailViewDeleteAlertSubTitle: '删除联系人将清空与该联系人的聊天记录。',
    contactDetailViewDeleteAlertButtonConfirm: '确认',
    contactDetailViewDeleteAlertButtonCancel: '取消',
    forwardMessageViewTitle: '转发给',
    forwardMessage: '转发',
    forwardedMessage: '已转发',
    forwardedMessageDownloadError: '下载失败',
    forwardSelectContacts: '联系人',
    forwardSelectGroups: '群组',
    groupDetailViewSend: '发消息',
    groupDetailViewDoNotDisturb: '消息免打扰',
    groupDetailViewClearChatHistory: '清空聊天记录',
    groupDetailViewClearChatHistoryAlertButtonConfirm: '确认',
    groupDetailViewClearChatHistoryAlertButtonCancel: '取消',
    groupDetailViewCancel: '取消',
    groupDetailViewMember: '群成员',
    groupDetailViewGroupName: '群名称',
    groupDetailViewDescription: '群描述',
    groupDetailViewSwitchPublic: '公开群组',
    groupDetailViewTransferGroup: '转移群主',
    groupDetailViewDisbandGroup: '解散群组',
    groupDetailViewDisbandAlertTitle: '确认解散群聊？',
    groupDetailViewDisbandAlertSubTitle: '解散群组将清空该群组的聊天记录。',
    groupDetailViewDisbandAlertButtonConfirm: '确认',
    groupDetailViewDisbandAlertButtonCancel: '取消',
    groupDetailViewLeaveGroup: '退出群组',
    groupDetailViewLeaveAlertTitle: '确认退出群组？',
    groupDetailViewLeaveAlertSubTitle: '确定退出群组，同时删除与该群的聊天记录。',
    groupDetailViewLeaveAlertButtonConfirm: '退出',
    groupDetailViewLeaveAlertButtonCancel: '取消',
    groupDetailChangeGroupName: '修改群名称',
    groupDetailChangeGroupDescription: '修改群描述',
    groupMentionViewMentionAll: '所有人',
    groupMentionViewTitle: '提及',
    groupMentionViewSearchHint: '搜索',
    groupAddMembersViewTitle: '添加群成员',
    groupAddMembersViewSearchContact: '搜索联系人',
    groupAddMembersViewAdd: '添加',
    groupDeleteMembersViewTitle: '移除群成员',
    groupDeleteMembersViewSearchMember: '搜索',
    groupDeleteMembersViewDelete: '删除',
    groupDeleteMembersViewAlertTitle: '移除选中的%a位群成员？',
    groupDeleteMembersViewAlertSubTitle: '你确定要移除该群成员吗？',
    groupDeleteMembersViewAlertButtonConfirm: '移除',
    groupDeleteMembersViewAlertButtonCancel: '取消',
    groupMembersViewTitle: '群成员',
    groupMembersSearch: '搜索群成员',
    groupMembersMentionViewTitle: '提及',
    groupChangeOwnerViewTitle: '转移群主',
    groupChangeOwnerViewAlertTitle: '转让群主身份给',
    groupChangeOwnerViewAlertSubTitle: '转让后，对方将变为群主。',
    groupChangeOwnerViewAlertButtonConfirm: '确认',
    groupChangeOwnerViewAlertButtonCancel: '取消',
    groupsViewTitle: '群组',
    changInfoViewSave: '完成',
    changInfoViewInputHint: '请输入',
    alertDestroy: '本群组已被解散',
    alertLeave: '已退出本群组',
    alertKickedInfo: '已被移出本群组',
    alertRecallInfo: '撤回了一条消息',
    alertYou: '你',
    alertAlreadyAdd: '已添加',
    alertAsContact: '为联系人',
    messagesViewAlertGroupInfoTitle: '创建群组',
    messagesViewAlertThreadInfoTitle: '创建了话题',
    messageViewAlertShowDetail: '查看详情',
    alertPinTitle: '置顶了一条消息',
    alertUnpinTitle: '移除了一条置顶消息',
    messagesViewEditMessageTitle: '正在编辑',
    messagesViewMoreActionsTitleAlbum: '相册',
    messagesViewMoreActionsTitleCamera: '相机',
    messagesViewMoreActionsTitleFile: '文件',
    messagesViewMoreActionsTitleLocation: '位置',
    messagesViewMoreActionsTitleVideo: '视频',
    messagesViewMoreActionsTitleVoice: '语音',
    messagesViewMoreActionsTitleContact: '名片',
    messagesViewLongPressActionsTitleCopy: '复制',
    messagesViewLongPressActionsTitleRecall: '撤回',
    messagesViewLongPressActionsTitleDelete: '删除',
    messagesViewLongPressActionsTitleReply: '回复',
    messagesViewLongPressActionsTitleEdit: '编辑',
    messagesViewLongPressActionsTitleReport: '举报',
    messagesViewDeleteMessageAlertTitle: '删除这条消息？',
    messagesViewDeleteMessageAlertSubTitle: '删除本地消息后，对方仍可以看到这条消息。',
    messagesViewDeleteMessageAlertButtonConfirm: '确认',
    messagesViewDeleteMessageAlertButtonCancel: '取消',
    messagesViewRecallMessageAlertTitle: '撤回这条消息？',
    messagesViewRecallMessageAlertSubTitle: '撤回后消息将被删除。',
    messagesViewRecallMessageAlertButtonConfirm: '确认',
    messagesViewRecallMessageAlertButtonCancel: '取消',
    messagesViewSelectContactTitle: '选择联系人',
    messagesViewSelectContactCancel: '取消',
    messagesViewShareContactAlertTitle: '分享联系人？',
    messagesViewShareContactAlertSubTitle: '分享联系人',
    messagesViewShareContactAlertSubTitleTo: '给',
    messagesViewShareContactAlertButtonConfirm: '确认',
    messagesViewShareContactAlertButtonCancel: '取消',
    messagesViewTyping: '正在输入...',
    messageCellCombineText: '文本',
    messageCellCombineImage: '图片',
    messageCellCombineVoice: '语音',
    messageCellCombineVideo: '视频',
    messageCellCombineFile: '文件',
    messageCellCombineContact: '联系人',
    messageCellCombineLocation: '位置',
    messageCellCombineCombine: '聊天记录',
    newRequestDetailsViewAddContact: '添加联系人',
    newRequestsViewTitle: '新请求',
    reportMessageViewTitle: '消息举报',
    reportMessageViewReportReasons: '举报原因',
    reportMessageViewConfirm: '举报',
    reportMessageViewCancel: '取消',
    // report reason
    reportTarget1: '不受欢迎的商业内容或垃圾内容',
    reportTarget2: '色情或露骨内容',
    reportTarget3: '虐待儿童',
    reportTarget4: '仇恨言论或过于写实的暴力内容',
    reportTarget5: '宣扬恐怖主义',
    reportTarget6: '骚扰或欺凌',
    reportTarget7: '自杀或自残',
    reportTarget8: '虚假信息',
    reportTarget9: '其他',
    selectContactViewSearchHint: '搜索联系人',
    nonSupportMessage: '不支持的消息类型',
    conversationListItemMention: '有人@我',
    listViewLoadFailed: '加载失败',
    listViewReload: '重新加载',
    messageTextWidgetURLPreviewParsing: '解析中...',
    quoteWidgetTitleImage: '图片',
    quoteWidgetTitleVideo: '视频',
    quoteWidgetTitleVoice: '语音 ',
    quoteWidgetTitleFile: '文件 ',
    quoteWidgetTitleCombine: '聊天记录',
    quoteWidgetTitleContact: '联系人 ',
    quoteWidgetTitleUnFind: '未找到原消息',
    messageTranslated: '已翻译',
    messageEdited: '已编辑',
    messageListItemContactCard: '联系人',
    newRequestItemAdd: '添加',
    newRequestItemAddReason: '请求添加您为好友',
    searchWidgetCancel: '取消',
    replayBarTitleContact: '联系人 ',
    replayBarTitleFile: '附件 ',
    replayBarTitleCombine: '聊天记录 ',
    replayBarTitleVoice: '语音 ',
    replayBarTitleVideo: '视频',
    replayBarTitleImage: '图片',
    replayBarTitle: '正在回复 ',
    confirm: '确认',
    cancel: '取消',
    bottomSheetCancel: '取消',
    threadsViewTitle: '所有话题',
    threadNoLastMessage: '暂无消息',
    threadsMessageLeave: '离开话题',
    threadsMessageMembers: '话题成员',
    threadsMessageEdit: '编辑话题',
    threadsMessageDestroy: '删除话题',
    threadEditName: '修改话题名称',
    threadNewName: '新话题名称',
    threadMembers: '话题成员',
    searchHistory: '搜索历史',
    pinMessages: '条置顶消息',
    hasPined: ' 置顶了 ',
    byPined: ' 的消息',
    unPinInquire: '移除',
    unPinConfirmed: '确认移除',
    floatingUnreadMessage: '条未读消息',
    deleteSomeMessages: '删除%a条消息?',
  };

  static const Map<String, String> en = {
    conversationsViewMenuAddContact: 'Add Contacts',
    conversationsViewMenuCreateGroup: 'New Group',
    conversationsViewMenuSelectContacts: 'Select Contacts',
    conversationsViewMenuCreateNewChat: 'New Chat',
    conversationsViewMenuCancel: 'Cancel',
    conversationsViewSearchHint: 'Search',
    conversationListLongPressMenuDelete: 'Delete',
    conversationListLongPressMenuPin: 'Pin',
    conversationListLongPressMenuUnPin: 'Unpin',
    conversationListLongPressMenuMute: 'Mute',
    conversationListLongPressMenuUnmute: 'Unmute',
    conversationListLongPressMenuRead: 'Read',
    conversationListLongPressMenuCancel: 'Cancel',
    messageListLongPressMenuCopy: 'Copy',
    messageListLongPressMenuReply: 'Reply',
    messageListLongPressMenuEdit: 'Edit',
    messageListLongPressMenuDelete: 'Delete',
    messageListLongPressMenuRecall: 'Recall',
    messageListLongPressMenuMulti: 'Select',
    messageListLongPressMenuPin: 'Pin',
    messageListLongPressMenuTranslate: 'Trans',
    messageListLongPressMenuTranslateOrigin: 'Hide',
    messageListLongPressMenuCreateThread: 'Thread',
    recordBarRecord: 'Tap to Record',
    recordBarRecording: 'Recording',
    recordBarPlay: 'Tap to Play',
    recordBarPlaying: 'Playing',
    recordBarAutoStop: 'It stops after %a seconds',
    addContactTitle: 'Add Contacts',
    addContactSubTitle: 'Search by ID',
    addContactInputHints: 'User ID',
    addContactConfirm: 'Add',
    addContactCancel: 'Cancel',
    historyMessages: 'Chat History',
    createGroupViewTitle: 'New Group',
    createGroupViewCreate: 'Create',
    createGroupViewSearchContact: 'Search Contacts',
    createGroupViewCancel: 'Cancel',
    contactsViewNewRequests: 'New Requests',
    contactsViewGroups: 'Groups',
    contactsViewSearch: 'Search Contacts',
    contactsAddContactAlertTitle: 'Add Contacts',
    contactsAddContactAlertSubTitle: 'Add Contacts by ID',
    contactsAddContactAlertHintText: 'Input ID',
    contactsAddContactAlertButtonConfirm: 'Add',
    contactsAddContactAlertButtonCancel: 'Cancel',
    contactDetailViewSend: 'Chat',
    contactDetailViewSearch: 'Search',
    contactDetailViewRemark: 'Remark',
    contactDetailViewPhone: 'Phone',
    contactDetailViewDoNotDisturb: 'Mute Notifications',
    contactDetailViewBlock: 'Block',
    contactDetailViewClearChatHistory: 'Clear Chat History',
    contactDetailViewClearChatHistoryAlertTitle: 'Clear Chat History?',
    contactDetailViewClearChatHistoryAlertSubTitle:
        'After clearing the chat history, you will not be able to view the chat history with this contact.',
    contactDetailViewClearChatHistoryAlertButtonConfirm: 'Confirm',
    contactDetailViewClearChatHistoryAlertButtonCancel: 'Cancel',
    contactDetailViewDelete: 'Delete Contact',
    contactDetailViewCancel: 'Cancel',
    contactDetailViewDeleteAlertTitle: 'Delete this contact?',
    contactDetailViewDeleteAlertSubTitle:
        'Deleting the contact will clear the chat history.',
    contactDetailViewDeleteAlertButtonConfirm: 'Confirm',
    contactDetailViewDeleteAlertButtonCancel: 'Cancel',
    forwardMessageViewTitle: 'Forward to',
    forwardMessage: 'Forward',
    forwardedMessage: 'Forwarded',
    forwardedMessageDownloadError: 'Download failed',
    forwardSelectContacts: 'Contacts',
    forwardSelectGroups: 'Groups',
    groupDetailViewSend: 'Chat',
    groupDetailViewDoNotDisturb: 'Mute Notifications',
    groupDetailViewClearChatHistory: 'Clear Chat History',
    groupDetailViewClearChatHistoryAlertButtonConfirm: 'Confirm',
    groupDetailViewClearChatHistoryAlertButtonCancel: 'Cancel',
    groupDetailViewCancel: 'Cancel',
    groupDetailViewMember: 'Group Members',
    groupDetailViewGroupName: 'Group Name',
    groupDetailViewDescription: 'Group Description',
    groupDetailViewSwitchPublic: 'Set public',
    groupDetailViewTransferGroup: 'Transfer Ownership',
    groupDetailViewDisbandGroup: 'Disband Group',
    groupDetailViewDisbandAlertTitle: 'Disband this group?',
    groupDetailViewDisbandAlertSubTitle:
        'Disbanding the group will clear the chat history.',
    groupDetailViewDisbandAlertButtonConfirm: 'Confirm',
    groupDetailViewDisbandAlertButtonCancel: 'Cancel',
    groupDetailViewLeaveGroup: 'Leave Group',
    groupDetailViewLeaveAlertTitle: 'Leave Group',
    groupDetailViewLeaveAlertSubTitle:
        'Leaving a group will also delete the chat history.',
    groupDetailViewLeaveAlertButtonConfirm: 'Confirm',
    groupDetailViewLeaveAlertButtonCancel: 'Cancel',
    groupDetailChangeGroupName: 'Change Group Name',
    groupDetailChangeGroupDescription: 'Change Group Description',
    groupMentionViewMentionAll: 'All',
    groupMentionViewTitle: 'Group Mention',
    groupMentionViewSearchHint: 'Search',
    groupAddMembersViewTitle: 'Add Group Members',
    groupAddMembersViewSearchContact: 'Search Contacts',
    groupAddMembersViewAdd: 'Add',
    groupDeleteMembersViewTitle: 'Remove Group Members',
    groupDeleteMembersViewSearchMember: 'Search Members',
    groupDeleteMembersViewDelete: 'Delete',
    groupDeleteMembersViewAlertTitle: 'Remove these %a members?',
    groupDeleteMembersViewAlertSubTitle:
        'Are you sure you want to remove this group member(s)?',
    groupDeleteMembersViewAlertButtonConfirm: 'Confirm',
    groupDeleteMembersViewAlertButtonCancel: 'Cancel',
    groupMembersViewTitle: 'Group Members',
    groupMembersSearch: 'Search Members',
    groupMembersMentionViewTitle: 'Mentions',
    groupChangeOwnerViewTitle: 'Transfer Ownership',
    groupChangeOwnerViewAlertTitle: 'Transfer group ownership to ',
    groupChangeOwnerViewAlertSubTitle:
        'After the transfer, the other party will become the owner.',
    groupChangeOwnerViewAlertButtonConfirm: 'Confirm',
    groupChangeOwnerViewAlertButtonCancel: 'Cancel',
    groupsViewTitle: 'Groups',
    changInfoViewSave: 'Done',
    changInfoViewInputHint: 'input',
    alertDestroy: 'The group has been disbanded.',
    alertLeave: ' have left the group.',
    alertKickedInfo: ' have been removed from the group.',
    alertRecallInfo: ' recalled a message',
    alertYou: 'You',
    alertAlreadyAdd: ' have added ',
    alertAsContact: ' as a contact',
    messagesViewAlertGroupInfoTitle: ' created a group ',
    messagesViewAlertThreadInfoTitle: ' created a thread ',
    messageViewAlertShowDetail: 'show details',
    alertPinTitle: ' pinned a message',
    alertUnpinTitle: ' unpinned a message',
    messagesViewEditMessageTitle: 'Editing',
    messagesViewMoreActionsTitleAlbum: 'Album',
    messagesViewMoreActionsTitleCamera: 'Camera',
    messagesViewMoreActionsTitleFile: 'File',
    messagesViewMoreActionsTitleLocation: 'Location',
    messagesViewMoreActionsTitleVideo: 'Video',
    messagesViewMoreActionsTitleVoice: 'Voice',
    messagesViewMoreActionsTitleContact: 'Contact Card',
    messagesViewLongPressActionsTitleCopy: 'Copy',
    messagesViewLongPressActionsTitleRecall: 'Recall',
    messagesViewLongPressActionsTitleDelete: 'Delete',
    messagesViewLongPressActionsTitleReply: 'Reply',
    messagesViewLongPressActionsTitleEdit: 'Edit',
    messagesViewLongPressActionsTitleReport: 'Report',
    messagesViewDeleteMessageAlertTitle: 'Delete this message?',
    messagesViewDeleteMessageAlertSubTitle:
        'You are deleting this locally and your contacts can still see this message.',
    messagesViewDeleteMessageAlertButtonConfirm: 'Confirm',
    messagesViewDeleteMessageAlertButtonCancel: 'Cancel',
    messagesViewRecallMessageAlertTitle: 'Recall this message?',
    messagesViewRecallMessageAlertSubTitle:
        'After the recall, the message will be deleted.',
    messagesViewRecallMessageAlertButtonConfirm: 'Recall',
    messagesViewRecallMessageAlertButtonCancel: 'Cancel',
    messagesViewSelectContactTitle: 'Select Contact',
    messagesViewSelectContactCancel: 'Cancel',
    messagesViewShareContactAlertTitle: 'Share Contact',
    messagesViewShareContactAlertSubTitle: 'Share Contact ',
    messagesViewShareContactAlertSubTitleTo: ' to ',
    messagesViewShareContactAlertButtonConfirm: 'Share',
    messagesViewShareContactAlertButtonCancel: 'Cancel',
    messagesViewTyping: 'Typing...',
    messageCellCombineText: 'Text',
    messageCellCombineImage: 'Image',
    messageCellCombineVoice: 'Voice',
    messageCellCombineVideo: 'Video',
    messageCellCombineFile: 'File',
    messageCellCombineContact: 'Card',
    messageCellCombineLocation: 'Location',
    messageCellCombineCombine: 'Chat History',
    newRequestDetailsViewAddContact: 'Add Contact',
    newRequestsViewTitle: 'New Requests',
    reportMessageViewTitle: 'Report Message',
    reportMessageViewReportReasons: 'Report Reasons',
    reportMessageViewConfirm: 'Report',
    reportMessageViewCancel: 'Cancel',
    // report reason
    reportTarget1: 'Unwelcome commercial content or spam',
    reportTarget2: 'Pornographic or explicit content',
    reportTarget3: 'Child abuse',
    reportTarget4: 'Hate speech or graphic violence',
    reportTarget5: 'Promote terrorism',
    reportTarget6: 'Harassment or bullying',
    reportTarget7: 'Suicide or self harm',
    reportTarget8: 'False information',
    reportTarget9: 'Others',

    selectContactViewSearchHint: 'Search Contacts',
    nonSupportMessage: 'Unsupported message type',
    conversationListItemMention: 'Mentioned',
    listViewLoadFailed: 'Load Failed',
    listViewReload: 'Reload',
    messageTextWidgetURLPreviewParsing: 'Parsing...',
    quoteWidgetTitleImage: 'Image',
    quoteWidgetTitleVideo: 'Video',
    quoteWidgetTitleVoice: 'Voice ',
    quoteWidgetTitleFile: 'File ',
    quoteWidgetTitleCombine: 'Chat History',
    quoteWidgetTitleContact: 'Contact ',
    quoteWidgetTitleUnFind: 'Not found original message',
    messageTranslated: 'Translated',
    messageEdited: 'Edited',
    messageListItemContactCard: 'Contact card',
    newRequestItemAdd: 'Add',
    newRequestItemAddReason: 'Request to add you as a friend',
    searchWidgetCancel: 'Cancel',
    replayBarTitleContact: 'Contact ',
    replayBarTitleFile: 'File ',
    replayBarTitleCombine: 'Chat History ',
    replayBarTitleVoice: 'Voice ',
    replayBarTitleVideo: 'Video',
    replayBarTitleImage: 'Image',
    replayBarTitle: 'Replying ',
    confirm: 'Confirm',
    cancel: 'Cancel',
    bottomSheetCancel: 'Cancel',
    threadsViewTitle: 'All topics',
    threadNoLastMessage: 'No message',
    threadsMessageLeave: 'Leave Topic',
    threadsMessageMembers: 'Topic Members',
    threadsMessageEdit: 'Edit Topic',
    threadsMessageDestroy: 'Delete Topic',
    threadEditName: 'Topic Name',
    threadNewName: 'New Topic Name',
    threadMembers: 'Topic Members',
    searchHistory: 'Search History',
    pinMessages: ' Pin message',
    hasPined: ' pinned ',
    byPined: " 's message",
    unPinInquire: 'Remove',
    unPinConfirmed: 'Confirm',
    floatingUnreadMessage: 'unread messages',
    deleteSomeMessages: 'Delete %a messages?',
  };
}

class ChatLocal {
  /// Constructor of the model.
  const ChatLocal(
    this.languageCode,
    this.mapData, {
    this.countryCode,
    this.fontFamily,
    this.scriptCode,
  }) : assert(languageCode != '');

  /// Language code. This will use to check with the supported language codes
  /// and find the data for localization.
  final String languageCode;

  /// This is the map of data that will use for localization.
  final Map<String, String> mapData;

  /// Country code is the region sub tag for the locale.
  final String? countryCode;

  /// Font family for the language
  final String? fontFamily;

  /// The script sub tag for the locale.
  final String? scriptCode;
}

class ChatUIKitLocalizations {
  List<ChatLocal> defaultLocale = [
    const ChatLocal('zh', ChatUIKitLocal.zh),
    const ChatLocal('en', ChatUIKitLocal.en),
  ];

  static final ChatUIKitLocalizations _instance = ChatUIKitLocalizations._();
  factory ChatUIKitLocalizations() => _instance;
  final FlutterLocalization _localization = FlutterLocalization.instance;
  ChatUIKitLocalizations._() {
    WidgetsFlutterBinding.ensureInitialized();
    _localization.init(
      mapLocales: defaultLocale.map((e) {
        return MapLocale(
          e.languageCode,
          e.mapData,
          countryCode: e.countryCode,
          fontFamily: e.fontFamily,
          scriptCode: e.scriptCode,
        );
      }).toList(),
      initLanguageCode: 'en',
    );
  }

  void translate(String languageCode) {
    _localization.translate(languageCode);
  }

  Locale? get currentLocale => _localization.currentLocale;

  Iterable<Locale> get supportedLocales => _localization.supportedLocales;

  Iterable<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      _localization.localizationsDelegates;

  void addLocales({required List<ChatLocal> locales}) {
    defaultLocale = defaultLocale + locales;
  }

  void resetLocales() {
    _localization.init(
      mapLocales: defaultLocale.map((e) {
        return MapLocale(
          e.languageCode,
          e.mapData,
          countryCode: e.countryCode,
          fontFamily: e.fontFamily,
          scriptCode: e.scriptCode,
        );
      }).toList(),
      initLanguageCode: 'en',
    );
  }

  Locale displayLanguageWhenNotSupported = const Locale('en');

  Locale? localeResolutionCallback(
    Locale? locale,
    Iterable<Locale> supportedLocales,
  ) {
    Locale? ret;
    int index = supportedLocales.toList().lastIndexWhere(
        (element) => element.languageCode == locale?.languageCode);
    if (index == -1) {
      ret = displayLanguageWhenNotSupported;
    } else {
      ret = supportedLocales.elementAt(index);
    }

    return ret;
  }
}
