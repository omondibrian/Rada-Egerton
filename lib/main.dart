import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/data/providers/authentication_provider.dart';
import 'package:rada_egerton/data/providers/counseling_provider.dart';
import 'package:rada_egerton/data/providers/information_content.dart';
import 'package:rada_egerton/data/repository/chat_repository.dart';
import 'presentation/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  RadaApplicationProvider appProvider = RadaApplicationProvider();
  runApp(
    RepositoryProvider(
      create: (context) => ChatRepository(applicationProvider: appProvider),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthenticationProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => CounsellingProvider(),
          ),
          ChangeNotifierProvider.value(
            value: appProvider,
          ),
          ChangeNotifierProvider(
            create: (_) => InformationProvider(),
          )
        ],
        child: const RadaApp(),
      ),
    ),
  );
}
