import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/data/providers/authentication_provider.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/presentation/features/profile/bloc/bloc.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/size_config.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => previous.user != current.user,
      builder: (context, state) {
        return Stack(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              maxRadius: SizeConfig.isTabletWidth ? 100 : 70,
              child: CircleAvatar(
                maxRadius: SizeConfig.isTabletWidth ? 97 : 67,
                backgroundImage: CachedNetworkImageProvider(
                  state.user?.profilePic ?? GlobalConfig.userAvi,
                ),
              ),
            ),
            if (state.user?.id == AuthenticationProvider.instance.user.id)
              Positioned(
                left: 100,
                top: 90,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: _UploadImage(),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _UploadImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status == ServiceStatus.submiting) {
          return const CircularProgressIndicator(
            color: Colors.black,
          );
        }
        return IconButton(
          icon: const Icon(Icons.camera_alt, color: Colors.black),
          onPressed: context.read<ProfileCubit>().updateProfileImage,
        );
      },
    );
  }
}
