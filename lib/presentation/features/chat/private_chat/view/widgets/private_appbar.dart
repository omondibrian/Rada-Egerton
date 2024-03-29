import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rada_egerton/data/providers/authentication_provider.dart';
import 'package:rada_egerton/data/providers/counseling_provider.dart';
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
              behavior: SnackBarBehavior.floating,
              content: const Text(
                "An error occured while loading recipient profile",
                style: TextStyle(color: Colors.red),
              ),
              action: SnackBarAction(
                label: "RETRY",
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  context.read<PrivateChatBloc>().add(
                        RecepientDataRequested(),
                      );
                },
              ),
              duration: const Duration(seconds: 60),
            ),
          );
        }
      },
      buildWhen: (previous, current) => current.recepient != previous.recepient,
      builder: (context, state) {
        bool currentIsCounsellor =
            context.read<CounsellingProvider>().isCounsellor(
                  userId: AuthenticationProvider.instance.user.id,
                );
        bool recepientIsCounsellor = context
            .read<CounsellingProvider>()
            .isCounsellor(
              userId: int.parse(context.read<PrivateChatBloc>().recepientId),
            );
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
                if (currentIsCounsellor)
                  PopupMenuItem(
                    onTap: () => {
                      context.pushNamed(AppRoutes.viewProfile, params: {
                        "userId": context.read<PrivateChatBloc>().recepientId
                      })
                    },
                    child: const Text(
                      'profile',
                    ),
                  ),
                if (recepientIsCounsellor)
                  PopupMenuItem(
                    onTap: () => {
                      context.pushNamed(AppRoutes.schedule, params: {
                        "userId": context.read<PrivateChatBloc>().recepientId
                      })
                    },
                    child: const Text(
                      'schedule',
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
