import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/presentation/features/profile/bloc/bloc.dart';
import 'package:rada_egerton/presentation/features/profile/view/widget/avatar.dart';
import 'package:rada_egerton/resources/config.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => previous.user != current.user,
      builder: (context, state) {
        return Stack(
          children: <Widget>[
            Ink(
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                image: const DecorationImage(
                    image: AssetImage('assets/android-icon-192x192.png'),
                    fit: BoxFit.cover),
              ),
            ),
            Ink(
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.black38,
              ),
            ),
            if (state.user?.id == GlobalConfig.instance.user.id)
              Container(
                width: double.infinity,
                height: 200,
                padding: const EdgeInsets.only(bottom: 0.0, right: 0.0),
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MaterialButton(
                      color: Colors.white,
                      shape: const CircleBorder(side: BorderSide.none),
                      elevation: 0,
                      child: Icon(
                        Icons.edit,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () =>
                          context.read<ProfileCubit>().readOnlyToggle(),
                    )
                  ],
                ),
              ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 160),
              child: Column(
                children: <Widget>[
                  const Avatar(),
                  Text(
                    state.user?.name ?? "Loading...",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
