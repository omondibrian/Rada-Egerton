import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/data/repository/chat_repository.dart';
import 'package:rada_egerton/presentation/features/chat/forum_chat/bloc/bloc.dart';
import 'package:rada_egerton/presentation/features/chat/forum_chat/view/widgets/chat_item.dart';
import 'package:rada_egerton/presentation/features/chat/forum_chat/view/widgets/forum_appbar.dart';
import 'package:rada_egerton/presentation/features/chat/forum_chat/view/widgets/forum_chat_input.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class ForumChatPage extends StatelessWidget {
  final String forumId;
  const ForumChatPage(this.forumId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForumBloc(
        chatRepo: context.read<ChatRepository>(),
        forumId: forumId,
        appProvider: context.read<RadaApplicationProvider>(),
      )..add(
          ForumChatStarted(),
        ),
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: ForumAppBar(),
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
                child: _ForumChatView(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ForumChatInput(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ForumChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForumBloc, ForumState>(
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
      },
      buildWhen: (previous, current) => current.chats != previous.chats,
      builder: (context, state) => ListView.builder(
        itemCount: state.chats.length,
        itemBuilder: (BuildContext ctx, index) => ForumChatItem(
          chat: state.chats.elementAt(index),
        ),
      ),
    );
  }
}
