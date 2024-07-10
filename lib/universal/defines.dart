const String userGroupName = 'chatUIKit_group_member_nick_name';
const String msgUserInfoKey = "ease_chat_uikit_user_info";
const String msgPreviewKey = "ease_chat_uikit_text_url_preview";
const String userAvatarKey = "avatarURL";
const String userNicknameKey = "nickname";
const String cardMessageKey = "userCard";
const String cardNicknameKey = "nickname";
const String cardUserIdKey = "uid";
const String cardAvatarKey = "avatar";

const String quoteKey = 'msgQuote';
const String quoteMsgIdKey = 'msgID';
const String quoteMsgTypeKey = 'msgType';
const String quoteMsgPreviewKey = 'msgPreview';
const String quoteMsgSenderKey = 'msgSender';

const String alertTimeKey = 'timeMessageKey';

const String alertRecalledKey = 'alertRecalledKey';
const String alertCreateThreadKey = 'createThreadKey';
const String alertUpdateThreadKey = 'updateThreadKey';
const String alertDeleteThreadKey = 'deleteThreadKey';
// 操作人id
const String alertOperatorIdKey = 'alertOperatorIdKey';
// 操作人名称
const String alertOperatorNameKey = 'alertOperatorNameKey';
// 被操作id
const String alertTargetIdKey = 'alertTargetIdKey';
// 被操作名称
const String alertTargetNameKey = 'alertTargetNameKey';
// 被操作所属，主要用于thread的所属msgId
const String alertTargetParentIdKey = 'alertTargetParentIdKey';

const String alertGroupCreateKey = 'createGroupKey';
const String alertGroupDestroyKey = 'alertGroupDestroyKey';
const String alertGroupLeaveKey = 'alertGroupLeaveKey';
const String alertGroupKickedKey = 'alertGroupKickedKey';
const String alertContactAddKey = 'alertContactAddKey';

const String mentionKey = 'em_at_list';
const String mentionAllValue = 'ALL';
const String hasMentionKey = 'mention';
const String hasMentionValue = 'mention';

const String voiceHasReadKey = 'voiceHasRead';
const String hasTranslatedKey = 'hasTranslatedKey';

enum ChatUIKitActionType {
  avatar,
  reaction,
  copy, // only text message
  reply,
  forward,
  multiSelect,
  translate, // only text message
  thread,
  edit, // only text message
  report,
  delete,
  recall,
  photos,
  video,
  camera,
  file,
  contactCard,
  pinMessage,
  members,
  destroy,
  leave,
  create,
  transferOwner,
  disbandGroup,
  mute,
  pin,
  read,
  addContact,
  newChat,
  cancel,
  add,
  remove,
  more,
  save,
  custom,
}
