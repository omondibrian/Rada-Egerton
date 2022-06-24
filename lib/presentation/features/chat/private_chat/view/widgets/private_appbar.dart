import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/data/entities/UserDTO.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/presentation/features/chat/private_chat/bloc/bloc.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class PrivateChatAppBar extends StatefulWidget {
  const PrivateChatAppBar({
    Key? key,
  }) : super(key: key);

  @override
  State<PrivateChatAppBar> createState() => _PrivateChatAppBarState();
}

class _PrivateChatAppBarState extends State<PrivateChatAppBar> {
  User? recepient;
  void initRecepient() async {}
  @override
  Widget build(BuildContext context) {
    Future<void> initRecepient() async {
      int id = int.parse(context.read<PrivateChatBloc>().recepientId);
      await context
          .read<RadaApplicationProvider>()
          .getUser(
            userId: id,
          )
          .then(
            (res) => res.fold(
              (user) => setState(
                () {
                  recepient = user;
                },
              ),
              (info) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    info.message,
                    style: TextStyle(
                      color: info.messageTypeColor,
                    ),
                  ),
                  action: SnackBarAction(
                    onPressed: () => initRecepient(),
                    label: "Try again",
                  ),
                  duration: const Duration(minutes: 5),
                ),
              ),
            ),
          );
    }

    return FutureBuilder(
      future: initRecepient(),
      builder: (context, _) {
        return AppBar(
          title: Row(
            children: [
              CircleAvatar(
                child: ClipOval(
                  child: CachedNetworkImage(
                    color: Colors.white,
                    imageUrl: recepient?.profilePic ?? "",
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
            ],
          ),
          actions: [
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  onTap: () => {},
                  child: Text(
                    'Leave ',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
