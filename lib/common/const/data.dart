// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';

const kACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const kREFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

const kServerIp = kDebugMode ? '13.209.4.21' : '13.209.4.21';
const kServerPort = kDebugMode ? '8000' : '8000';
const kServerVersion = kDebugMode ? 'v1' : 'v1';

const kS3Url = 'https://biskit-bucket.s3.ap-northeast-2.amazonaws.com';
const kS3Flag11Path = '/flag/1-1';
const kS3Flag43Path = '/flag/4-3';

const String kReviewTagName = 'review';

const String kCategoryDefaultPath =
    'https://biskit-bucket.s3.ap-northeast-2.amazonaws.com/default_icon/ic_talk_fill_48.png';
const List<Map<String, String>> kCategoryList = [
  {'value': '식사', 'imgUrl': 'assets/icons/ic_food_fill_48.svg'},
  {'value': '언어교환', 'imgUrl': 'assets/icons/ic_language_exchange_fill_48.svg'},
  {'value': '액티비티', 'imgUrl': 'assets/icons/ic_activity_fill_48.svg'},
  {'value': '스포츠', 'imgUrl': 'assets/icons/ic_sports_fill_48.svg'},
  {'value': '스터디', 'imgUrl': 'assets/icons/ic_study_fill_48.svg'},
  {'value': '문화·예술', 'imgUrl': 'assets/icons/ic_culture_fill_48.svg'},
  {'value': '취미', 'imgUrl': 'assets/icons/ic_hobby_fill_48.svg'},
  {'value': '기타', 'imgUrl': 'assets/icons/ic_talk_fill_48.svg'},
];
