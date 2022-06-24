import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/data/repository/chat_repository.dart';
import 'package:rada_egerton/presentation/features/chat/private_chat/bloc/bloc.dart';
import 'package:rada_egerton/presentation/features/chat/private_chat/view/widgets/chat_item.dart';
import 'package:rada_egerton/presentation/features/chat/private_chat/view/widgets/private_appbar.dart';
import 'package:rada_egerton/presentation/features/chat/private_chat/view/widgets/private_chat_input.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class PrivateChatPage extends StatelessWidget {
  final String recepientId;
  const PrivateChatPage(this.recepientId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrivateChatBloc(
        chatRepo: context.read<ChatRepository>(),
        recepientId: recepientId,
      )..add(
          PrivateChatStarted(),
        ),
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: PrivateChatAppBar(),
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
                child: _PrivateChatView(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PrivateChatInput(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrivateChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrivateChatBloc, PrivateChatState>(
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
        itemBuilder: (BuildContext ctx, index) => PrivateChatItem(
          chat: state.chats.elementAt(index),
        ),
      ),
    );
  }
}
