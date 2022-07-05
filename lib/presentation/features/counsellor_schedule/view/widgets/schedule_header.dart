import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/presentation/features/counsellor_schedule/bloc/bloc.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/size_config.dart';

class CounsellorScheduleHeader extends StatelessWidget {
  const CounsellorScheduleHeader({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounsellorScheduleCubit, ScheduleState>(
      buildWhen: (previous, current) =>
          previous.counsellor?.user != current.counsellor?.user,
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
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 160),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    maxRadius: SizeConfig.isTabletWidth ? 100 : 70,
                    child: CircleAvatar(
                      maxRadius: SizeConfig.isTabletWidth ? 97 : 67,
                      backgroundImage: CachedNetworkImageProvider(
                        state.counsellor?.user.profilePic ??
                            GlobalConfig.userAvi,
                      ),
                    ),
                  ),
                  Text(
                    state.counsellor?.user.name ?? "Loading...",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text(
                    state.counsellor?.expertise ?? "Loading...",
                    style: Theme.of(context).textTheme.subtitle1,
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
