import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/presentation/features/chat/private_chat/bloc/bloc.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/theme.dart';

class PrivateChatInput extends StatelessWidget {
  final FocusNode inputNode = FocusNode();
  final TextEditingController _chatController = TextEditingController();

  PrivateChatInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrivateChatBloc, PrivateChatState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == ServiceStatus.submissionSucess) {
          _chatController.clear();
        }
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
                        Row(
                          children: <Widget>[
                            const SizedBox(width: 8.0),
                            // Icon(Icons.insert_emoticon,
                            //     size: 30.0, color: Theme.of(context).hintColor),
                            // SizedBox(width: 8.0),
                            Expanded(
                              child: TextField(
                                maxLines: 10,
                                minLines: 1,
                                controller: _chatController,
                                focusNode: inputNode,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  hintText: 'Type a message',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
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
                          ChatPayload(
                            message: _chatController.text,
                            reciepient:
                                context.read<PrivateChatBloc>().recepientId,
                            senderId: GlobalConfig.instance.user.id.toString(),
                          ),
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
      builder: (context, state) {
        if (state.selectedChat != null) {
          Container(
            margin: const EdgeInsets.only(left: 3),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(width: 5.0, color: Palette.accent),
              ),
              color: Colors.white,
            ),
            // margin: EdgeInsets.only(bottom: 2),
            child: Row(
              children: [
                const Icon(
                  Icons.reply,
                ),
                Expanded(child: Text(state.selectedChat!.message)),
                IconButton(
                  onPressed: () => context.read<PrivateChatBloc>().add(
                        PrivateChatUnselected(),
                      ),
                  icon: const Icon(Icons.close),
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
