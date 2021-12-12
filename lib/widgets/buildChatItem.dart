
import 'package:flutter/material.dart';
import 'package:rada_egerton/screens/chat/chat.model.dart';
import 'package:swipeable_tile/swipeable_tile.dart';

import '../theme.dart';
import 'ChatCard.dart';
import '../screens/chat/chat.model.dart' as Model;

Widget buildChatItem(String currentUserId, Model.Chat chatModel,
    void Function(Chat onreply) onReply, Model.Chat? replyTo) {
  var chat = chatModel;
  return SwipeableTile.swipeToTigger(
    behavior: HitTestBehavior.translucent,
    isEelevated: false,
    color: Colors.transparent,
    swipeThreshold: 0.2,
    direction: chat.authorId == currentUserId
        ? SwipeDirection.endToStart
        : SwipeDirection.startToEnd,
    onSwiped: (_) {
      onReply(chat);
    },
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
    child: GestureDetector(
      onLongPress: () {
        onReply(chat);
      },
      child: Row(
        mainAxisAlignment: chat.authorId == currentUserId
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: chat.authorId == currentUserId
                  ? ChatCard(chat, Palette.sendMessage, CrossAxisAlignment.end,
                      replyTo)
                  : ChatCard(chat, Palette.receivedMessage,
                      CrossAxisAlignment.start, replyTo)),
        ],
      ),
    ),
  );
}
