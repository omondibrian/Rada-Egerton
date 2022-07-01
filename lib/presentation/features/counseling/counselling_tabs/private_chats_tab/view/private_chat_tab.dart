import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/data/entities/user_dto.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/data/repository/chat_repository.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/presentation/features/counseling/counselling_tabs/peer_counselors_tab.dart';
import 'package:rada_egerton/presentation/features/counseling/counselling_tabs/private_chats_tab/bloc/bloc.dart';
import 'package:rada_egerton/presentation/loading_effect/shimmer.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/constants.dart';

import 'package:flutter/material.dart';
import 'package:rada_egerton/resources/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class PrivateSessionsTab extends StatelessWidget {
  const PrivateSessionsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrivateChatBloc(
        chatRepo: context.read<ChatRepository>(),
      )..add(
          PrivateChatTabStarted(),
        ),
      child: _PrivateChatTabView(),
    );
  }
}

class _PrivateChatTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrivateChatBloc, PrivateChatTabState>(
      buildWhen: (previous, current) =>
          current.conversations != current.conversations,
      builder: (context, state) {
        if (state.status == ServiceStatus.loading) {
          return Shimmer(
            child: ListView(
              children: List.generate(
                4,
                (index) => const TileLoader(),
              ),
            ),
          );
        }
        if (state.status == ServiceStatus.loadingFailure) {
          return Center(
            child: Row(
              children: [
                const Text("Ann error occured"),
                TextButton(
                  onPressed: () => context.read<PrivateChatBloc>().add(
                        PrivateChatTabStarted(),
                      ),
                  child: const Text("RETRY"),
                )
              ],
            ),
          );
        }
        if (state.conversations.isEmpty) {
          return Center(
            child: Image.asset(
              "assets/message.png",
              width: 250,
            ),
          );
        }
        return ListView.builder(
          itemBuilder: (_, index) => _ChatItem(
            state.conversations[index],
          ),
          itemCount: state.conversations.length,
        );
      },
      listener: (_, state) {
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
    );
  }
}

class _ChatItem extends StatefulWidget {
  final ChatPayload chat;
  const _ChatItem(this.chat, {Key? key}) : super(key: key);

  @override
  State<_ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<_ChatItem> {
  User? user;
  @override
  Widget build(BuildContext context) {
    String recipientId = widget.chat.reciepient!;
    //initialized recepient profile
    context
        .read<RadaApplicationProvider>()
        .getUser(
          userId: int.parse(
            widget.chat.reciepient!,
          ),
        )
        .then(
          (res) => res.fold(
            (user) => setState(
              () {
                this.user = user;
              },
            ),
            (r) => null,
          ),
        );

    void _openChat() {
      if (GlobalConfig.instance.user.id.toString() == recipientId) return;
      context.pushNamed(
        AppRoutes.privateChat,
        params: {
          "recepientId": recipientId,
        },
      );
    }

    return GestureDetector(
      onTap: _openChat,
      child: ListTile(
        leading: CircleAvatar(
          child: ClipOval(
            child: CachedNetworkImage(
              color: Colors.white,
              imageUrl: user?.profilePic ?? GlobalConfig.userAvi,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Text('${user?.name}'),
        subtitle: Text(
          "say something",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: SizeConfig.isTabletWidth ? 16 : 14,
          ),
        ),
      ),
    );
  }
}
