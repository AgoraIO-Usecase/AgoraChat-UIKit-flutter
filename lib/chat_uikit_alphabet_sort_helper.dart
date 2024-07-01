typedef AlphabetSortHandler = String Function(String showName);

/// 联系人字母排序, 如果有中文，可以用过 [ChatUIKitAlphabetSortHelper] 首字母重新定义, 如:
/// ```dart
/// ChatUIKitAlphabetSortHelper.instance.sortHandler = (showName) {
///   /// 获取中文首字母
///   return PinyinHelper.getPinyinE(showName, defPinyin: '#', format: PinyinFormat.WITHOUT_TONE).substring(0, 1);
/// }
/// ```
class ChatUIKitAlphabetSortHelper {
  static ChatUIKitAlphabetSortHelper? _instance;
  static ChatUIKitAlphabetSortHelper get instance {
    _instance ??= ChatUIKitAlphabetSortHelper._internal();
    return _instance!;
  }

  AlphabetSortHandler? sortHandler;

  ChatUIKitAlphabetSortHelper._internal();
}
