
import 'package:flutter/material.dart';

import '../theme.dart';
import '../screens/chat/chat.model.dart';

Widget chatCard(Chat chat, Color chatCardColor, MainAxisAlignment alignment,
    CrossAxisAlignment crossAxisAlignment) {
  return Row(
    children: <Widget>[
      chat.media == null
          // Text
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: Text(
                chat.content,
                style: TextStyle(color: Colors.black),
              ),
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              width: 200.0,
              decoration: BoxDecoration(
                  //color: Palette.sendCardColor,
                  color: chatCardColor,
                  borderRadius: BorderRadius.circular(8.0)),
            )
          :
          // Image
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              // padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              padding: EdgeInsets.all(5.0),
              width: 200.0,
              decoration: BoxDecoration(
                  color: Palette.sendMessage,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                crossAxisAlignment: crossAxisAlignment,
                children: [
                  Material(
                    child: Image.network(
                      chat.media!,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 15.0,
                          ),
                          decoration: BoxDecoration(
                            color: Palette.sendMessage,
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
                                      loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                    child: Text(
                      chat.content,
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
              // margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
            ),
      // Sticker
    ],
    mainAxisAlignment: alignment,
  );
}
