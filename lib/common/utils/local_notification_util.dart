import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notifications = FlutterLocalNotificationsPlugin();

localNotificationInit() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await notifications.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      logger.d(details);
    },
  );
}

showNotification(
  RemoteNotification notification,
) async {
  var androidDetails = const AndroidNotificationDetails(
    '채널 ID',
    '채널 이름',
    priority: Priority.high,
    importance: Importance.max,
    styleInformation: BigTextStyleInformation(
      '',
    ),
  );

  var iosDetails = const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  // 알림 id, 제목, 내용 맘대로 채우기
  notifications.show(
    notification.hashCode,
    notification.title,
    notification.body,
    NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    ),
  );
}
