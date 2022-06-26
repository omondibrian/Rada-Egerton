import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rada_egerton/data/repository/chat_repository.dart';
import 'package:rada_egerton/presentation/features/chat/group_chat/bloc/bloc.dart';
import 'package:rada_egerton/presentation/features/chat/group_chat/view/widgets/chat_item.dart';
import 'package:rada_egerton/presentation/features/chat/group_chat/view/widgets/group_appbar.dart';
import 'package:rada_egerton/presentation/features/chat/group_chat/view/widgets/group_chat_input.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class GroupChatPage extends StatelessWidget {
  final String groupId;
  const GroupChatPage(this.groupId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GroupBloc(
        chatRepo: context.read<ChatRepository>(),
        groupId: groupId,
      )..add(
          GroupChatStarted(),
        ),
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: GroupAppBar(),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/background_pattern.png',
              ),
              repeat: ImageRepeat.repeat,
            ),
          ),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10.0, bottom: 50),
                child: _GroupChatView(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GroupChatInput(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupBloc, GroupState>(
      listener: (context, state) {
        if (state.infoMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.infoMessage!.message,
                style: TextStyle(
                  color: state.infoMessage!.messageTypeColor,
                ),
              ),
            ),
          );
        }
        if (!state.subscribed) {
          context.pop();
        }
      },
      buildWhen: (previous, current) => current.chats != previous.chats,
      builder: (context, state) => ListView.builder(
        itemCount: state.chats.length,
        itemBuilder: (BuildContext ctx, index) => GroupChatItem(
          chat: state.chats.elementAt(index),
        ),
      ),
    );
  }
}
