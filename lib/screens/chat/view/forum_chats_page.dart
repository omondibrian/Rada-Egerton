import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/screens/chat/bloc/bloc.dart';
import 'package:rada_egerton/screens/chat/view/widget/chat_view.dart';

class ForumChats extends StatelessWidget {
  final String forumnId;
  const ForumChats({Key? key, required this.forumnId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) => previous.forumMsgs != current.forumMsgs,
      builder: (context, state) => ChatView(
        state.forumMsgs.where((msg) => msg.groupsId == forumnId).toList(),
      ),
    );
  }
}
