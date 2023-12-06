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

String getDateTimeToString(DateTime dateTime) {
  final DateFormat dayFormat1 = DateFormat('MM월 dd일', 'ko');
  final DateFormat dayFormat2 = DateFormat('a hh:mm', 'ko');
  int dayDiff = getDayDifference(dateTime, DateTime.now());
  if (dayDiff == 0) {
    // 오늘이면 시간으로 반환
    return dayFormat2.format(dateTime);
  } else if (dayDiff.abs() == 1) {
    return '어제';
  } else {
    // 오늘이 아니면 날짜로 반환
    return dayFormat1.format(dateTime);
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

  if (now.day - meetupDate.day == 0) {
    return '오늘';
  } else if (now.day - meetupDate.day == -1) {
    return '내일';
  } else {
    return dateFormat.format(meetupDate);
  }
}
