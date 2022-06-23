import 'package:flutter/material.dart';
import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/theme.dart';

class ChatCard extends StatelessWidget {
  final ChatPayload chat;
  final Color chatCardColor;
  final ChatPayload? replyTo;
  final CrossAxisAlignment crossAxisAlignment;
  ChatCard(
      this.chat, this.chatCardColor, this.crossAxisAlignment, this.replyTo);
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .7),
        padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        decoration: BoxDecoration(
            color: chatCardColor, borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (replyTo != null)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 5.0, color: Palette.accent),
                  ),
                ),
                child: Text(replyTo!.message),
              ),
            chat.picture == null
                // Text
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      chat.message,
                      style: const TextStyle(color: Colors.black),
                    ),
                  )
                :
                // Image
                Column(
                    crossAxisAlignment: crossAxisAlignment,
                    children: [
                      Material(
                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                        clipBehavior: Clip.hardEdge,
                        child: Image.network(
                          imageUrl(chat.imageUrl!),
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              decoration: BoxDecoration(
                                color: chatCardColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                              width: 200.0,
                              height: 200.0,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.green,
                                  value: loadingProgress.expectedTotalBytes !=
                                              null &&
                                          loadingProgress.expectedTotalBytes !=
                                              null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },

                          // width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        child: Text(
                          chat.message,
                          style: const TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  )
          ],
        ));
  }
}
