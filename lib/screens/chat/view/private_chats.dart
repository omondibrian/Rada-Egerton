import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/screens/chat/bloc/bloc.dart';
import 'package:rada_egerton/screens/chat/view/widget/chat_view.dart';

class PrivateChats extends StatelessWidget {
  final String receipientId;
  const PrivateChats({Key? key, required this.receipientId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) => previous.peerMsgs != current.peerMsgs,
      builder: (context, state) => ChatView(
        state.peerMsgs.where((msg) => msg.reciepient == receipientId).toList(),
      ),
    );
  }
}
