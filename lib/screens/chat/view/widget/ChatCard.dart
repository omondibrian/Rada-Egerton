import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
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
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        decoration: BoxDecoration(
            color: chatCardColor, borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (replyTo != null)
              Container(
                child: Text(replyTo!.message),
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 5.0, color: Palette.accent),
                  ),
                ),
              ),
            chat.picture == null
                // Text
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      chat.message,
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                :
                // Image
                Column(
                    crossAxisAlignment: crossAxisAlignment,
                    children: [
                      Material(
                        child: Image.network(
                          GlobalConfig.imageUrl(chat.imageUrl!),
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              decoration: BoxDecoration(
                                color: chatCardColor,
                                borderRadius: BorderRadius.all(
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
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      Container(
                        child: Text(
                          chat.message,
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  )
          ],
        ));
  }
}
