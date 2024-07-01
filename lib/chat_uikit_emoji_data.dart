class ChatUIKitEmojiData {
  static int get listSize => emojiList.length;

  /// 图片所在包名
  static String packageName = 'agora_chat_uikit';

  /// 图片资源文件, 需要与emoji表情列表[emojiList]一一对应。
  static final emojiImagePaths = [
    'assets/images/emojis/U+1F600.png',
    'assets/images/emojis/U+1F604.png',
    'assets/images/emojis/U+1F609.png',
    'assets/images/emojis/U+1F62E.png',
    'assets/images/emojis/U+1F92A.png',
    'assets/images/emojis/U+1F60E.png',
    'assets/images/emojis/U+1F971.png',
    'assets/images/emojis/U+1F974.png',
    'assets/images/emojis/U+263A.png',
    'assets/images/emojis/U+1F641.png',
    'assets/images/emojis/U+1F62D.png',
    'assets/images/emojis/U+1F610.png',
    'assets/images/emojis/U+1F607.png',
    'assets/images/emojis/U+1F62C.png',
    'assets/images/emojis/U+1F913.png',
    'assets/images/emojis/U+1F633.png',
    'assets/images/emojis/U+1F973.png',
    'assets/images/emojis/U+1F620.png',
    'assets/images/emojis/U+1F644.png',
    'assets/images/emojis/U+1F910.png',
    'assets/images/emojis/U+1F97A.png',
    'assets/images/emojis/U+1F928.png',
    'assets/images/emojis/U+1F62B.png',
    'assets/images/emojis/U+1F637.png',
    'assets/images/emojis/U+1F912.png',
    'assets/images/emojis/U+1F631.png',
    'assets/images/emojis/U+1F618.png',
    'assets/images/emojis/U+1F60D.png',
    'assets/images/emojis/U+1F922.png',
    'assets/images/emojis/U+1F47F.png',
    'assets/images/emojis/U+1F92C.png',
    'assets/images/emojis/U+1F621.png',
    'assets/images/emojis/U+1F44D.png',
    'assets/images/emojis/U+1F44E.png',
    'assets/images/emojis/U+1F44F.png',
    'assets/images/emojis/U+1F64C.png',
    'assets/images/emojis/U+1F91D.png',
    'assets/images/emojis/U+1F64F.png',
    'assets/images/emojis/U+2764.png',
    'assets/images/emojis/U+1F494.png',
    'assets/images/emojis/U+1F495.png',
    'assets/images/emojis/U+1F4A9.png',
    'assets/images/emojis/U+1F48B.png',
    'assets/images/emojis/U+2600.png',
    'assets/images/emojis/U+1F31C.png',
    'assets/images/emojis/U+1F308.png',
    'assets/images/emojis/U+2B50.png',
    'assets/images/emojis/U+1F31F.png',
    'assets/images/emojis/U+1F389.png',
    'assets/images/emojis/U+1F490.png',
    'assets/images/emojis/U+1F382.png',
    'assets/images/emojis/U+1F381.png',
  ];

  static getEmojiImagePath(String emoji) {
    return emojiMapReversed[emoji];
  }

  static getEmoji(String emojiImagePath) {
    return emojiMap[emojiImagePath];
  }

  /// 表情列表, 需要与[emojiImagePaths]一一对应。
  static List<String> emojiList = [
    "\u{1F600}",
    "\u{1F604}",
    "\u{1F609}",
    "\u{1F62E}",
    "\u{1F92A}",
    "\u{1F60E}",
    "\u{1F971}",
    "\u{1F974}",
    "\u{263A}",
    "\u{1F641}",
    "\u{1F62D}",
    "\u{1F610}",
    "\u{1F607}",
    "\u{1F62C}",
    "\u{1F913}",
    "\u{1F633}",
    "\u{1F973}",
    "\u{1F620}",
    "\u{1F644}",
    "\u{1F910}",
    "\u{1F97A}",
    "\u{1F928}",
    "\u{1F62B}",
    "\u{1F637}",
    "\u{1F912}",
    "\u{1F631}",
    "\u{1F618}",
    "\u{1F60D}",
    "\u{1F922}",
    "\u{1F47F}",
    "\u{1F92C}",
    "\u{1F621}",
    "\u{1F44D}",
    "\u{1F44E}",
    "\u{1F44F}",
    "\u{1F64C}",
    "\u{1F91D}",
    "\u{1F64F}",
    "\u{2764}",
    "\u{1F494}",
    "\u{1F495}",
    "\u{1F4A9}",
    "\u{1F48B}",
    "\u{2600}",
    "\u{1F31C}",
    "\u{1F308}",
    "\u{2B50}",
    "\u{1F31F}",
    "\u{1F389}",
    "\u{1F490}",
    "\u{1F382}",
    "\u{1F381}"
  ];

  static final emojiMap = Map.fromIterables(emojiImagePaths, emojiList);
  static final emojiMapReversed = Map.fromIterables(emojiList, emojiImagePaths);
}
