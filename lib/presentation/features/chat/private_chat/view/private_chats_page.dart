import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
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
        appProvider: context.read<RadaApplicationProvider>(),
        chatRepo: context.read<ChatRepository>(),
        recepientId: recepientId,
      )
        ..add(
          PrivateChatStarted(),
        )
        ..add(
          RecepientDataRequested(),
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
              _PrivateChatView(),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
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
    final ScrollController controller =
        context.read<PrivateChatBloc>().controller;
    return BlocConsumer<PrivateChatBloc, PrivateChatState>(
      listener: (context, state) {
        if (state.infoMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 10),
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
      builder: (context, state) => RefreshIndicator(
        onRefresh: () async =>
            context.read<PrivateChatBloc>().add(PrivateChatRefresh()),
        child: ListView.builder(
          controller: controller,
          itemCount: state.chats.length + 1,
          //SizedBox provide extra space at the bottom
          itemBuilder: (BuildContext ctx, index) => index == state.chats.length
              ? const SizedBox(
                  height: 80,
                )
              : PrivateChatItem(
                  chat: state.chats.elementAt(index),
                ),
        ),
      ),
    );
  }
}
