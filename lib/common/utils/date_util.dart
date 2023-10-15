import 'package:cloud_firestore/cloud_firestore.dart';

int getDayDifference(DateTime d1, DateTime d2) {
  return DateTime(d1.year, d1.month, d1.day)
      .difference(DateTime(d2.year, d2.month, d2.day))
      .inDays;
}

int getTimestampDifferenceMin(Timestamp t1, Timestamp t2) {
  return t1.toDate().minute - t2.toDate().minute;
}
