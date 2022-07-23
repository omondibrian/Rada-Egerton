part of 'main.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message ${message.messageId}');
}

AndroidNotificationChannel androidChannel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
  //TODO: configure sound
);

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
List<String> subscribedGroups = [];

void initMessaging(RadaApplicationProvider applicationProvider) async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  applicationProvider.addListener(
    () {
      //Subscribe to groups
      for (var c in applicationProvider.groups) {
        if (!subscribedGroups.contains(c.id)) {
          subscribedGroups.add(c.id);
          messaging.subscribeToTopic("radaCommsgroup${c.id}");
        }
      }

      //Incase user leaves a group then we unsubscribe from that group
      Iterable<String> ids = applicationProvider.groups.map((e) => e.id);
      for (var id in subscribedGroups) {
        if (!ids.contains(id)) {
          messaging.unsubscribeFromTopic("radaCommsgroup$id");
        }
      }
    },
  );

  if (!kIsWeb) {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }
}
