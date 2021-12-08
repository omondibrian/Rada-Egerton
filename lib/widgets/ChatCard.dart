import 'package:flutter/material.dart';
import 'package:rada_egerton/theme.dart';
import '../screens/chat/chat.model.dart';
import 'package:rada_egerton/constants.dart';
import '../screens/chat/chat.model.dart' as Model;

class ChatCard extends StatelessWidget {
  final Chat chat;
  final Color chatCardColor;
  Model.Chat? replyTo;
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
          children: [
            if (replyTo != null)
              Container(
                child: Text(replyTo!.content),
                padding: EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 5.0, color: Palette.accent),
                  ),
                  color: Colors.white,
                ),
              ),
            chat.media!.isEmpty
                // Text
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      chat.content,
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
                          "$BASE_URL/api/v1/uploads/${chat.media!}",
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
                          chat.content,
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  )
          ],
        ));
  }
}
