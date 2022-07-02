import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/presentation/features/chat/private_chat/bloc/bloc.dart';
import 'package:rada_egerton/presentation/widgets/chat_card.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/theme.dart';
import 'package:swipeable_tile/swipeable_tile.dart';

class PrivateChatItem extends StatelessWidget {
  final ChatPayload chat;
  const PrivateChatItem({required this.chat, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatPayload? replyTo;
    for (var c in context.read<PrivateChatBloc>().state.chats) {
      if (c.id?.toString() == chat.reply) {
        replyTo = c;
      }
    }

    return SwipeableTile.swipeToTrigger(
      behavior: HitTestBehavior.translucent,
      color: Colors.transparent,
      swipeThreshold: 0.2,
      direction: chat.recipient == GlobalConfig.instance.user.id.toString()
          ? SwipeDirection.endToStart
          : SwipeDirection.startToEnd,
      onSwiped: (_) => context.read<PrivateChatBloc>().add(
            PrivateChatSelected(chat.copyWith()),
          ),
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
                          curve: const Interval(0.4, 1.0,
                              curve: Curves.elasticOut),
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
        onLongPress: () => context.read<PrivateChatBloc>().add(
              PrivateChatSelected(chat.copyWith()),
            ),
        child: Row(
          mainAxisAlignment: chat.senderId.toString() ==
                  GlobalConfig.instance.user.id.toString()
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: chat.senderId == GlobalConfig.instance.user.id.toString()
                  ? ChatCard(
                      chat,
                      Palette.sendMessage,
                      CrossAxisAlignment.end,
                      replyTo,
                    )
                  : ChatCard(
                      chat,
                      Palette.receivedMessage,
                      CrossAxisAlignment.start,
                      replyTo,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
