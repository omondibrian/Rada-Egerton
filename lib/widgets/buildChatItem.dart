import 'package:flutter/material.dart';
import 'package:swipeable_tile/swipeable_tile.dart';

import '../theme.dart';
import '../widgets/ChartCard.dart';
import '../screens/chat/chat.model.dart' as Model;

Widget buildItem(String currentUserName, Model.Chat chatModel) {
  var chat = chatModel;
  if (chat.authorName == currentUserName) {
    // Right (my message)
    return Column(
      children: [
        chatCard(chat, Palette.sendMessage, MainAxisAlignment.end,
            CrossAxisAlignment.end),
      ],
    );
  } else {
    // Left (peer message)
    return SwipeableTile.swipeToTigger(
      behavior: HitTestBehavior.translucent,
      isEelevated: false,
      color: Colors.transparent,
      swipeThreshold: 0.2,
      direction: SwipeDirection.endToStart,
      onSwiped: (_) {},
      key: UniqueKey(),
      backgroundBuilder: (context, direction, progress) {
        bool vibrated = false;
        return AnimatedBuilder(
          animation: progress,
          builder: (context, child) {
            if (progress.value > 0.9999 && !vibrated) {
              vibrated = true;
            } else if (progress.value < 0.9999) {
              vibrated = false;
            }

            return AnimatedContainer(
              alignment: Alignment.centerRight,
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Transform.scale(
                  scale: Tween<double>(
                    begin: 0.0,
                    end: 1.2,
                  )
                      .animate(
                        CurvedAnimation(
                          parent: progress,
                          curve: Interval(0.4, 1.0, curve: Curves.elasticOut),
                        ),
                      )
                      .value,
                  child: Icon(
                    Icons.reply,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                chatCard(chat, Palette.receivedMessage, MainAxisAlignment.start,
                    CrossAxisAlignment.start),
              ])),
    );
  }
}
