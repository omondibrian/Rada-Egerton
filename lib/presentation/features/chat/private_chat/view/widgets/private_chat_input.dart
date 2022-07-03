import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/presentation/features/chat/private_chat/bloc/bloc.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/theme.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class PrivateChatInput extends StatefulWidget {
  const PrivateChatInput({Key? key}) : super(key: key);

  @override
  State<PrivateChatInput> createState() => _PrivateChatInputState();
}

class _PrivateChatInputState extends State<PrivateChatInput> {
  final FocusNode inputNode = FocusNode();

  final TextEditingController _chatController = TextEditingController();

  File? picture;
  File? video;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrivateChatBloc, PrivateChatState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == ServiceStatus.submissionSucess) {
          _chatController.clear();
          setState(() {
            picture = null;
            video = null;
          });
        }
        //Hide keyboard
        FocusManager.instance.primaryFocus?.unfocus();
      },
      buildWhen: (previous, current) =>
          previous.selectedChat != current.selectedChat,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 3, right: 8, top: 2),
          child: Row(
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        _PrivateChatSelectedChat(),
                        if (picture != null)
                          Stack(
                            children: [
                              Container(
                                height: 300,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: Image.file(picture!).image,
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: ClipOval(
                                  child: Container(
                                    color: Colors.black38,
                                    child: IconButton(
                                      onPressed: () => setState(() {
                                        picture = null;
                                      }),
                                      icon: const Icon(Icons.close,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        Row(
                          children: <Widget>[
                            const SizedBox(width: 5.0),
                            Expanded(
                              child: TextField(
                                maxLines: 10,
                                minLines: 1,
                                controller: _chatController,
                                focusNode: inputNode,
                                decoration: const InputDecoration(
                                  hintText: 'Type a message',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.camera_alt,
                                  color: Theme.of(context).hintColor),
                              onPressed: () async {
                                inputNode.unfocus();
                                await ServiceUtility().uploadImage().then(
                                      (file) => setState(
                                        () {
                                          picture = file;
                                        },
                                      ),
                                    );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              GestureDetector(
                onTap: () {
                  context.read<PrivateChatBloc>().add(
                        PrivateChatSend(
                          message: _chatController.text,
                          video: video,
                          picture: picture,
                        ),
                      );
                },
                child: CircleAvatar(
                  backgroundColor: Palette.accent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocBuilder<PrivateChatBloc, PrivateChatState>(
                      buildWhen: (previous, current) =>
                          current.status != previous.status,
                      builder: (context, state) {
                        if (state.status == ServiceStatus.submiting) {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        }
                        return const Icon(
                          Icons.send,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PrivateChatSelectedChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrivateChatBloc, PrivateChatState>(
      buildWhen: (previous, current) =>
          previous.selectedChat != current.selectedChat,
      builder: (context, state) {
        if (state.selectedChat != null) {
          return Container(
            constraints: const BoxConstraints(minHeight: 80),
            margin: const EdgeInsets.only(left: 3),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(width: 5.0, color: Palette.accent),
              ),
              color: Colors.white,
            ),
            // margin: EdgeInsets.only(bottom: 2),
            child: Stack(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.reply,
                    ),
                    Expanded(
                      child: Text(state.selectedChat!.message),
                    ),
                    if (state.selectedChat?.imageUrl != null)
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: Image.network(
                                    imageUrl(state.selectedChat!.imageUrl!))
                                .image,
                          ),
                        ),
                      ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: ClipOval(
                    child: Container(
                      color: Colors.black38,
                      child: IconButton(
                        onPressed: () => context.read<PrivateChatBloc>().add(
                              PrivateChatUnselected(),
                            ),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
