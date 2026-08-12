import 'package:flutter/material.dart';

import '../../../../../chat_uikit.dart';

const double _kHorizontalPadding = 17;

class ChatUIKitMessageViewBottomMenu extends StatefulWidget {
  const ChatUIKitMessageViewBottomMenu({this.eventActionsHandler, super.key});

  final List<ChatUIKitEventAction>? Function()? eventActionsHandler;

  @override
  State<ChatUIKitMessageViewBottomMenu> createState() =>
      _ChatUIKitMessageViewBottomMenuState();
}

class _ChatUIKitMessageViewBottomMenuState
    extends State<ChatUIKitMessageViewBottomMenu> with ChatUIKitThemeMixin {
  ValueNotifier<int> pageIndexValue = ValueNotifier(0);

  @override
  void dispose() {
    pageIndexValue.dispose();
    super.dispose();
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    List<ChatUIKitEventAction> eventActions =
        widget.eventActionsHandler?.call() ?? [];

    int pageIndex = (eventActions.length ~/ 8);

    List<List<ChatUIKitEventAction>> listOfEventActions = [];

    for (int i = 0; i <= pageIndex; i++) {
      int start = i * 8;
      int end = (i + 1) * 8;
      if (end > eventActions.length) {
        end = eventActions.length;
      }
      listOfEventActions.add(eventActions.sublist(start, end));
    }

    Widget content = PageView(
      scrollDirection: Axis.horizontal,
      physics: pageIndex < 1
          ? const NeverScrollableScrollPhysics()
          : const ScrollPhysics(),
      onPageChanged: (value) {
        pageIndexValue.value = value;
      },
      children: [
        for (int i = 0; i < listOfEventActions.length; i++)
          MenuPage(eventActions: listOfEventActions[i]),
      ],
    );

    content = Container(
      color: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child: content),
          if (pageIndex > 0)
            ValueListenableBuilder(
              valueListenable: pageIndexValue,
              builder: (context, value, child) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(listOfEventActions.length, (index) {
                    return Container(
                      height: 6,
                      width: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: index == value
                            ? theme.color.isDark
                                ? theme.color.neutralColor9
                                : theme.color.neutralColor5
                            : theme.color.isDark
                                ? theme.color.neutralColor5
                                : theme.color.neutralColor9,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3)),
                      ),
                    );
                  }),
                );
              },
            )
        ],
      ),
    );
    return content;
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({required this.eventActions, super.key});
  final List<ChatUIKitEventAction> eventActions;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with ChatUIKitThemeMixin {
  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    double width = MediaQuery.of(context).size.width;
    double itemWidth = (width - _kHorizontalPadding * 2) / 4;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
          vertical: 16, horizontal: _kHorizontalPadding),
      itemCount: widget.eventActions.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: itemWidth,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                widget.eventActions[index].onTap?.call();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: theme.color.isDark
                      ? theme.color.neutralColor2
                      : theme.color.neutralColor95,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(6),
                width: 64,
                height: 64,
                child: Center(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: widget.eventActions[index].icon ??
                        const Icon(Icons.add),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                widget.eventActions[index].label,
                overflow: TextOverflow.ellipsis,
                textScaler: TextScaler.noScaling,
                style: widget.eventActions[index].style,
              ),
            )
          ],
        );
      },
    );
  }
}
