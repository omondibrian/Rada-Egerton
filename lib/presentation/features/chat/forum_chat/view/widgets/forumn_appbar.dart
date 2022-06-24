import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/presentation/features/chat/forum_chat/bloc/bloc.dart';

class ForumnAppBar extends StatelessWidget {
  const ForumnAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final counselingProvider = Provider.of<CounsellorProvider>(context);
    //TODO: add forumn name, image
    return AppBar(
      title: Row(
        children: [
          CircleAvatar(
            child: ClipOval(
              child: CachedNetworkImage(
                color: Colors.white,
                imageUrl: "formn image",
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
              onTap: () => context.read<ForumnBloc>().add(
                    ForumnUnsubscribe(),
                  ),
              child: Text(
                'Leave ',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              // onTap: _openBottomSheet
            ),
          ],
        ),
      ],
    );
  }
}
