import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/data/repository/chat_repository.dart';
import 'package:rada_egerton/presentation/features/chat/forum_chat/bloc/bloc.dart';
import 'package:rada_egerton/presentation/features/chat/forum_chat/view/widgets/chat_item.dart';
import 'package:rada_egerton/presentation/features/chat/forum_chat/view/widgets/forumn_appbar.dart';
import 'package:rada_egerton/presentation/features/chat/forum_chat/view/widgets/forumn_chat_input.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class ForumnChatPage extends StatelessWidget {
  final String forumnId;
  const ForumnChatPage(this.forumnId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForumnBloc(
        chatRepo: context.read<ChatRepository>(),
        forumnId: forumnId,
      )..add(
          ForumnChatStarted(),
        ),
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: ForumnAppBar(),
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
                child: _ForumnChatView(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ForumnChatInput(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ForumnChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForumnBloc, ForumnState>(
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
        itemBuilder: (BuildContext ctx, index) => ForumnChatItem(
          chat: state.chats.elementAt(index),
        ),
      ),
    );
  }
}
