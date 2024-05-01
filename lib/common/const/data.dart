// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';

const kACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const kREFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

// const kServerIp = kDebugMode ? '13.209.4.21' : '13.209.4.21';
const kServerIp = kDebugMode ? '13.125.249.201' : '13.125.249.201';
const kServerPort = kDebugMode ? '8000' : '8000';
const kServerVersion = kDebugMode ? 'v1' : 'v1';

const kS3Url = 'https://biskit-bucket.s3.ap-northeast-2.amazonaws.com';
const kS3HttpUrl = 'http://biskit-bucket.s3.ap-northeast-2.amazonaws.com';
const kS3Flag11Path = '/flag/1-1';
const kS3Flag43Path = '/flag/4-3';

const String kReviewTagName = 'review';

const String kCategoryDefaultPath =
    'https://biskit-bucket.s3.ap-northeast-2.amazonaws.com/default_icon/ic_talk_fill_48.svg';

bool criticalNotification = false;
bool generalNotification = false;

// 이용가이드
const String kUseGuideUrl =
    'https://wisyeons.notion.site/BISKIT-9f623ff795874ab69445aafaff1d735c';

// 서비스 이용약관
const String kTermsConditionsServiceUseUrl =
    'https://wisyeons.notion.site/BISKIT-c664d0d64e1a43bc96e33e6294aa7273';

// 개인정보 처리방침
const String kPrivacyPolicyUrl =
    'https://wisyeons.notion.site/BISKIT-2563785000624e2e8e65a4f87d0adf75';

// 위치기반 서비스 이용약관
const String kLocationServiceTermsConditionsUrl =
    'https://wisyeons.notion.site/346b7773b89d44289ec74fc5ac780479?pvs=4';
