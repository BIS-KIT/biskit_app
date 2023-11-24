import 'package:firebase_messaging/firebase_messaging.dart';

import 'local_notification_util.dart';
import 'logger_util.dart';

/// FCM 권한 요청
Future requestPermission() async {
  final messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  logger.d('User granted permission: ${settings.authorizationStatus}');
}

foregroundFcm() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    logger.d('Got a message whilst in the foreground!');
    logger.d('Message data: ${message.data}');

    if (message.notification != null) {
      showNotification(message.notification!);
      logger
          .d('Message also contained a notification: ${message.notification}');
    }
  });
}
