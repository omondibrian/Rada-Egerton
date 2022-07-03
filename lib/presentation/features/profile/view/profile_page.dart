import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/presentation/features/profile/bloc/bloc.dart';
import 'package:rada_egerton/presentation/features/profile/view/widget/profile_details.dart';
import 'package:rada_egerton/presentation/features/profile/view/widget/profile_header.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class ProfileScreen extends StatelessWidget {
  final int? userId;
  const ProfileScreen({Key? key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => ProfileCubit(
            userId: userId,
            provider: context.read<RadaApplicationProvider>(),
          ),
          child: _ProfileView(),
        ),
      ),
    );
  }
}

class _ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) => previous.message != current.message,
      listener: (context, state) {
        if (state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar( behavior: SnackBarBehavior.floating, 

              content: Text(
                state.message!.message,
                style: TextStyle(
                  color: state.message!.messageTypeColor,
                ),
              ),
            ),
          );
        }
      },
      child: Column(
        children: <Widget>[
          const ProfileHeader(),
          const SizedBox(height: 10.0),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                  ),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Profile Information",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                ProfileDetails(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
