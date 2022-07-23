import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/data/providers/authentication_provider.dart';
import 'package:rada_egerton/data/providers/counseling_provider.dart';
import 'package:rada_egerton/data/providers/information_content.dart';
import 'package:rada_egerton/data/repository/chat_repository.dart';
import 'package:rada_egerton/firebase_options.dart';
import 'presentation/app/app.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
part 'firebase_messaging.dart';

void main() async {
  RadaApplicationProvider appProvider = RadaApplicationProvider();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initMessaging(appProvider);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(
    RepositoryProvider(
      create: (context) => ChatRepository(),
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
