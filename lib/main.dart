import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/data/providers/authentication_provider.dart';
import 'package:rada_egerton/data/providers/chat.provider.dart';
import 'package:rada_egerton/data/providers/counselling.provider.dart';
import 'package:rada_egerton/data/providers/information.content.dart';
import 'package:rada_egerton/presentation/features/chat/bloc/bloc.dart';

import 'presentation/app/app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthenticationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CounsellorProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RadaApplicationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => InformationProvider(),
        )
      ],
      child: BlocProvider(
        create: (_) => ChatBloc(),
        child: RadaApp(),
      ),
    ),
  );
}
