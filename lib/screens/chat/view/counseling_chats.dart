import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/screens/chat/bloc/bloc.dart';
import 'package:rada_egerton/screens/chat/view/widget/chat_view.dart';

class CounselingChats extends StatelessWidget {
  final String id;
  const CounselingChats({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) => previous.groupMsgs != current.groupMsgs,
      builder: (context, state) => ChatView(
        state.groupMsgs.where((msg) => msg.groupsId == id).toList(),
      ),
    );
  }
}
