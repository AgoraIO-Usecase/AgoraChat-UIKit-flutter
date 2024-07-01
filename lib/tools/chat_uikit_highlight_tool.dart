import '../chat_uikit.dart';
import 'package:flutter/widgets.dart';

class HighlightTool {
  static Widget highlightWidget(
    BuildContext context,
    String text, {
    String? searchKey,
    TextStyle? textStyle,
    TextStyle? highlightStyle,
  }) {
    final theme = ChatUIKitTheme.of(context);
    TextStyle normalStyle = textStyle ??
        TextStyle(
          color: theme.color.isDark
              ? theme.color.neutralColor98
              : theme.color.neutralColor1,
          fontSize: theme.font.titleMedium.fontSize,
          fontWeight: theme.font.titleMedium.fontWeight,
        );

    TextStyle highStyle = highlightStyle ??
        TextStyle(
          color: theme.color.isDark
              ? theme.color.primaryColor6
              : theme.color.primaryColor5,
          fontWeight: theme.font.titleMedium.fontWeight,
          fontSize: theme.font.titleMedium.fontSize,
        );

    String searchText = text.toLowerCase();
    String keyword = searchKey?.toLowerCase() ?? '';

    Widget? name;
    List<Match> matchList = keyword.allMatches(searchText).toList();
    int lastIndex = 0;

    List<InlineSpan> tmp = [];
    for (var i = 0; i < matchList.length; i++) {
      Match match = matchList[i];
      String str = text.substring(lastIndex, match.start);
      if (str.isNotEmpty) {
        tmp.add(TextSpan(
          text: str,
          style: normalStyle,
        ));
      }

      tmp.add(
        TextSpan(
            text: text.substring(match.start, match.end), style: highStyle),
      );
      lastIndex = match.end;
    }

    if (lastIndex != text.length) {
      tmp.add(TextSpan(
        text: text.substring(lastIndex),
        style: normalStyle,
      ));
    }

    name = RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: tmp,
        // style: normalStyle,
      ),
      textScaler: TextScaler.noScaling,
      maxLines: 1,
    );

    return name;
  }
}
