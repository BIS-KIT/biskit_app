import 'package:biskit_app/chat/view/chat_screen.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/utils/GlobalVariable.dart';
import 'package:biskit_app/meet/view/meet_up_detail_screen.dart';
import 'package:biskit_app/setting/view/notice_detail_screen.dart';
import 'package:biskit_app/setting/view/warning_history_screen.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

void handlePageRouting(Map payload, final Ref ref) async {
  if (payload['obj_name'] == 'Meeting') {
    Navigator.of(GlobalVariable.navState.currentContext!).push(
      MaterialPageRoute(
        builder: (context) => MeetUpDetailScreen(
          meetupId: int.parse(payload['obj_id']),
          userModel: ref.read(userMeProvider),
        ),
      ),
    );
  } else if (payload['obj_name'] == 'Notice') {
    Navigator.of(GlobalVariable.navState.currentContext!).push(
      MaterialPageRoute(
        builder: (context) => NoticeDetailScreen(noticeId: payload['obj_id']),
      ),
    );
  } else if (payload['obj_name'] == 'Report') {
    Navigator.of(GlobalVariable.navState.currentContext!).push(
      MaterialPageRoute(
        builder: (context) => const WarningHistoryScreen(),
      ),
    );
  } else if (payload['obj_name'] == 'Chat') {
    Navigator.of(GlobalVariable.navState.currentContext!).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(chatRoomUid: payload['obj_id']),
      ),
    );
  }
}

localNotification(Map payload, final Ref ref, final String ground) async {
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

  if (ground == 'background') {
    handlePageRouting(payload, ref);
    logger.d('payload(background): $payload');
  } else {
    await notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        logger.d('payload(foreground): $payload');
        handlePageRouting(payload, ref);
      },
      onDidReceiveBackgroundNotificationResponse: (details) {
        logger.d('backgroundPayload: $payload');
        handlePageRouting(
            payload, ref); // Call handlePageRouting for background handling
      },
    );
  }
}

foregroundFcm(final Ref ref) async {
  // foreground
  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) {
      logger.d('Got a message whilst in the foreground!');
      logger.d('Message data: ${message.data}');

      if (message.notification != null) {
        Map payLoad = message.data;
        bool isMainAlarm = (payLoad['is_main_alarm'] ?? '') == 'True';
        bool isSubAlarm = (payLoad['is_sub_alarm'] ?? '') == 'True';

        if (isMainAlarm && criticalNotification) {
          logger.d('criticalNotification $criticalNotification');
          showNotification(message.notification!);
          localNotification(message.data, ref, 'foreground');
          return;
        }

        if (isSubAlarm && generalNotification) {
          logger.d('generalNotification $generalNotification');
          showNotification(message.notification!);
          localNotification(message.data, ref, 'foreground');
          return;
        }
      }
    },
  );
}

// FIXME: background 알림의 경우 클릭했을 때 한 번, 진입했을 때 한 번 더. 총 두 번 실행됨
backgroundFcm(final Ref ref) async {
  FirebaseMessaging.onMessageOpenedApp.listen(
    (RemoteMessage message) {
      logger.d('Got a message whilst in the background!');
      logger.d('Message data: ${message.data}');

      if (message.notification != null) {
        Map payLoad = message.data;
        bool isMainAlarm = (payLoad['is_main_alarm'] ?? '') == 'True';
        bool isSubAlarm = (payLoad['is_sub_alarm'] ?? '') == 'True';

        if (isMainAlarm && criticalNotification) {
          showNotification(message.notification!);
          localNotification(message.data, ref, 'background');
          return;
        }

        if (isSubAlarm && generalNotification) {
          showNotification(message.notification!);
          localNotification(message.data, ref, 'background');
          return;
        }
      }
    },
  );

  // FirebaseMessaging.onMessageOpenedApp.listen(
  //   (RemoteMessage message) {
  //     logger.d('Got a message whilst in the background!');
  //     logger.d('Message data: ${message.data}');

  //     if (message.notification != null) {
  //       Map payLoad = message.data;
  //       bool isMainAlarm = (payLoad['is_main_alarm'] ?? '') == 'True';
  //       bool isSubAlarm = (payLoad['is_sub_alarm'] ?? '') == 'True';

  //       if (isMainAlarm && criticalNotification) {
  //         showNotification(message.notification!);
  //         localNotification(message.data, ref, 'background');
  //         return;
  //       }

  //       if (isSubAlarm && generalNotification) {
  //         showNotification(message.notification!);
  //         localNotification(message.data, ref, 'background');
  //         return;
  //       }
  //     }
  //   },
  // );
}
