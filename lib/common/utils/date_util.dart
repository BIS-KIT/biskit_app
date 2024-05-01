import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

int getDayDifference(DateTime d1, DateTime d2) {
  return DateTime(d1.year, d1.month, d1.day)
      .difference(DateTime(d2.year, d2.month, d2.day))
      .inDays;
}

DateTime getDateTimeByTimestamp(dynamic timestamp) {
  return timestamp.toDate().toLocal();
}

int getTimestampDifferenceMin(Timestamp t1, Timestamp t2) {
  return t1.toDate().minute - t2.toDate().minute;
}

String getDateTimeToString(DateTime dateTime, String? langCode) {
  final DateFormat dateFormatUS = DateFormat('MM/dd (EEE)', 'en_US');
  final DateFormat dateFormatKO = DateFormat('MM월 dd일 (EEE)', 'ko_KR');
  final DateFormat timeFormatUS = DateFormat('a h:mm', 'en_US');
  final DateFormat timeFormatKO = DateFormat('a h:mm', 'ko_KR');

  int dayDiff = getDayDifference(dateTime, DateTime.now());
  if (dayDiff == 0) {
    // 오늘이면 시간으로 반환
    return ((langCode == 'en' ? timeFormatUS : timeFormatKO)).format(dateTime);
  } else if (dayDiff.abs() == 1) {
    return '어제';
  } else {
    // 오늘이 아니면 날짜로 반환
    return ((langCode == 'en' ? dateFormatUS : dateFormatKO)).format(dateTime);
  }
}

DateTime getDateTimeIntervalMin5() {
  final now = DateTime.now();

  int minute = 0;
  if (now.minute % 5 == 1) {
    minute = 4;
  } else if (now.minute % 5 == 2) {
    minute = 3;
  }
  if (now.minute % 5 == 3) {
    minute = 2;
  }
  if (now.minute % 5 == 4) {
    minute = 1;
  }
  return now.add(Duration(minutes: minute));
}

getMeetUpDateStr({
  required String? meetUpDateStr,
  required DateFormat dateFormat,
}) {
  if (meetUpDateStr == null || meetUpDateStr.isEmpty) {
    return '';
  }

  final DateTime now = DateTime.now();
  final DateTime meetupDate = DateTime.parse(meetUpDateStr);

  if (now.year == meetupDate.year &&
      now.month == meetupDate.month &&
      now.day == meetupDate.day) {
    return 'homeScreen.date.today'.tr();
  } else {
    final DateTime tomorrow = now.add(const Duration(days: 1));
    if (tomorrow.year == meetupDate.year &&
        tomorrow.month == meetupDate.month &&
        tomorrow.day == meetupDate.day) {
      return 'homeScreen.date.tomorrow'.tr();
    } else {
      return dateFormat.format(meetupDate);
    }
  }
}
