import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/data/entities/user_dto.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/data/providers/authentication_provider.dart';
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
import 'package:rada_egerton/resources/utils/time_ago.dart';

class PrivateSessionsTab extends StatelessWidget {
  const PrivateSessionsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrivateTabChatBloc(
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
    return BlocConsumer<PrivateTabChatBloc, PrivateChatTabState>(
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
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("An error occured"),
                TextButton(
                  onPressed: () => context.read<PrivateTabChatBloc>().add(
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
          physics: const AlwaysScrollableScrollPhysics(),
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
              behavior: SnackBarBehavior.floating,
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

class _ChatItem extends StatelessWidget {
  final ChatPayload chat;
  const _ChatItem(this.chat, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String recipientId =
        AuthenticationProvider.instance.user.id.toString() == chat.recipient
            ? chat.senderId!
            : chat.recipient!;
    void _openChat() {
      context.pushNamed(
        AppRoutes.privateChat,
        params: {
          "recepientId": recipientId,
        },
      );
    }

    ChatPayload? lastChat =
        context.read<ChatRepository>().lastPrivateChat(recipientId);
    Future<User?> initProfile() async {
      User? user;
      await context
          .read<RadaApplicationProvider>()
          .getUser(
            userId: int.parse(
              recipientId,
            ),
            retryLog: (value) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(
                  "An error occured, retying...",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          )
          .then(
            (res) => res.fold(
              (user_) => user = user_,
              (r) => null,
            ),
          );
      return user;
    }

    return GestureDetector(
      onTap: _openChat,
      child: FutureBuilder(
          future: initProfile(),
          builder: (context, snapshot) {
            User? user = snapshot.data as User?;
            return ListTile(
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
              title: Text(user?.name ?? "Loading..."),
              subtitle: Text(
                lastChat?.message ?? "say something",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: SizeConfig.isTabletWidth ? 16 : 14,
                ),
              ),
              trailing: Text(
                lastChat != null
                    ? TimeAgo.timeAgoSinceDate(lastChat.createdAt)
                    : "",
              ),
            );
          }),
    );
  }
}
