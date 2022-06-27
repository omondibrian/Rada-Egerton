import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/presentation/features/chat/private_chat/bloc/bloc.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/constants.dart';

class PrivateChatAppBar extends StatelessWidget {
  const PrivateChatAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrivateChatBloc, PrivateChatState>(
      listener: (context, state) {
        if (state.recepientProfileStatus == ServiceStatus.loadingFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 5),
              content: const Text(
                "An error occured",
                style: TextStyle(color: Colors.red),
              ),
              action: SnackBarAction(
                label: "RETRY",
                onPressed: () => context.read<PrivateChatBloc>().add(
                      RecepientDataRequested(),
                    ),
              ),
            ),
          );
        }
      },
      buildWhen: (previous, current) => current.recepient != previous.recepient,
      builder: (context, state) {
        return AppBar(
          title: Row(
            children: [
              CircleAvatar(
                child: ClipOval(
                  child: CachedNetworkImage(
                    color: Colors.white,
                    imageUrl:
                        state.recepient?.profilePic ?? GlobalConfig.userAvi,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: 120,
                      height: 120,
                    ),
                    placeholder: (context, url) => Image.asset(
                      "assets/users.png",
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Text(state.recepient?.name ?? "Loading..."),
                  const Text(
                    "Say something..",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  onTap: () => {
                    context.pushNamed(AppRoutes.viewProfile, params: {
                      "userId": context.read<PrivateChatBloc>().recepientId
                    })
                  },
                  child: const Text(
                    'View Profile',
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
