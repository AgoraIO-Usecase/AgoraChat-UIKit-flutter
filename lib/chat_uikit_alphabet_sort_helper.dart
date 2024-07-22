typedef AlphabetSortHandler = String? Function(
    String? groupId, String userId, String showName);

/// Contact alphabet sorting, if there is Chinese, you can redefine the first letter using [ChatUIKitAlphabetSortHelper], for example:
/// ```dart
/// ChatUIKitAlphabetSortHelper.instance.sortHandler = (String? groupId, String userId, String showName) {
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
