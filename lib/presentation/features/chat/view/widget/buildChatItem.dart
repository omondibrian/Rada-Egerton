import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/data/entities/ChatDto.dart';
import 'package:rada_egerton/presentation/features/chat/bloc/bloc.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/theme.dart';
import 'package:swipeable_tile/swipeable_tile.dart';

import 'ChatCard.dart';

class BuildChatItem extends StatelessWidget {
  final ChatPayload chat;
  final ChatPayload? replyTo;
  const BuildChatItem({required this.chat, required this.replyTo});

  @override
  Widget build(BuildContext context) {
    return SwipeableTile(
      behavior: HitTestBehavior.translucent,
      color: Colors.transparent,
      swipeThreshold: 0.2,
      direction: chat.reciepient == GlobalConfig.instance.user.id
          ? SwipeDirection.endToStart
          : SwipeDirection.startToEnd,
      onSwiped: (_) => context.read<ChatBloc>().add(ChatUnselected()),
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
          // onReply(chat);
        },
        child: Row(
          mainAxisAlignment: chat.senderId == GlobalConfig.instance.user.id
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: chat.senderId == GlobalConfig.instance.user.id
                  ? ChatCard(chat, Palette.sendMessage, CrossAxisAlignment.end,
                      replyTo)
                  : ChatCard(chat, Palette.receivedMessage,
                      CrossAxisAlignment.start, replyTo),
            ),
          ],
        ),
      ),
    );
  }
}
