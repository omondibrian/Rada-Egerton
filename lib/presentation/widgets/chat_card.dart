import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/theme.dart';

class ChatCard extends StatelessWidget {
  final ChatPayload chat;
  final Color chatCardColor;
  final ChatPayload? replyTo;
  final CrossAxisAlignment crossAxisAlignment;
  const ChatCard(
    this.chat,
    this.chatCardColor,
    this.crossAxisAlignment,
    this.replyTo, {
    Key? key,
  }) : super(key: key);
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
          chat.imageUrl == null
              // Text
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(
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
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                      child: GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => _ImageView(
                            url: imageUrl(chat.imageUrl!),
                          ),
                        ),
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
                              constraints: const BoxConstraints(
                                  minHeight: 200, minWidth: 200),
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
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SelectableText(
                      chat.message,
                      style: const TextStyle(color: Colors.black),
                    )
                  ],
                ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(chat.date),
          )
        ],
      ),
    );
  }
}

class _ImageView extends StatelessWidget {
  final String url;
  const _ImageView({required this.url});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black38,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CachedNetworkImage(
            imageUrl: url,
            width: double.infinity,
            placeholder: (context, _) => Center(
              child: Container(
                constraints:
                    const BoxConstraints(maxHeight: 300, maxWidth: 300),
                child: const CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
