import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

const kEn = 'en';
getTsHeading24(BuildContext context) {
  return context.locale.languageCode == kEn
      ? kTsEnHeading24Eb
      : kTsKrHeading24Bd;
}

getTsHeading20(BuildContext context) {
  return context.locale.languageCode == kEn
      ? kTsEnHeading20Eb
      : kTsKrHeading20Bd;
}

getTsHeading18(BuildContext context) {
  return context.locale.languageCode == kEn
      ? kTsEnHeading18Eb
      : kTsKrHeading18Bd;
}

getTsBody16Sb(BuildContext context) {
  return context.locale.languageCode == kEn ? kTsEnBody16Sb : kTsKrBody16Sb;
}

getTsBody16Rg(BuildContext context) {
  return context.locale.languageCode == kEn ? kTsEnBody16Rg : kTsKrBody16Rg;
}

getTsBody14Sb(BuildContext context) {
  return context.locale.languageCode == kEn ? kTsEnBody14Sb : kTsKrBody14Sb;
}

getTsBody14Rg(BuildContext context) {
  return context.locale.languageCode == kEn ? kTsEnBody14Rg : kTsKrBody14Rg;
}

getTsCaption12Sb(BuildContext context) {
  return context.locale.languageCode == kEn
      ? kTsEnCaption12Sb
      : kTsKrCaption12Sb;
}

getTsCaption12Rg(BuildContext context) {
  return context.locale.languageCode == kEn
      ? kTsEnCaption12Rg
      : kTsKrCaption12Rg;
}

getTsCaption11Md(BuildContext context) {
  return context.locale.languageCode == kEn
      ? kTsEnCaption11Md
      : kTsKrCaption11Md;
}

// 국문
const TextStyle kTsKrHeading24Bd = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Suite',
  fontSize: 24,
  fontWeight: FontWeight.w700,
  height: 1.4,
);

const TextStyle kTsKrHeading20Bd = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Suite',
  fontSize: 20,
  fontWeight: FontWeight.w700,
  height: 1.4,
);

const TextStyle kTsKrHeading18Bd = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Suite',
  fontSize: 18,
  fontWeight: FontWeight.w700,
  height: 1.4,
);

const TextStyle kTsKrBody16Sb = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Pretendard',
  fontSize: 16,
  fontWeight: FontWeight.w600,
  height: 1.5,
);

const TextStyle kTsKrBody16Rg = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Pretendard',
  fontSize: 16,
  fontWeight: FontWeight.w400,
  height: 1.5,
);

const TextStyle kTsKrBody14Sb = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Pretendard',
  fontSize: 14,
  fontWeight: FontWeight.w600,
  height: 1.5,
);

const TextStyle kTsKrBody14Rg = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Pretendard',
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 1.5,
);

const TextStyle kTsKrCaption12Sb = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Pretendard',
  fontSize: 12,
  fontWeight: FontWeight.w600,
  height: 1.5,
);

const TextStyle kTsKrCaption12Rg = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Pretendard',
  fontSize: 12,
  fontWeight: FontWeight.w400,
  height: 1.5,
);

const TextStyle kTsKrCaption11Md = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Pretendard',
  fontSize: 11,
  fontWeight: FontWeight.w500,
  height: 1.5,
);

// 영문
const TextStyle kTsEnHeading24Eb = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Suite',
  fontSize: 24,
  fontWeight: FontWeight.w800,
  height: 1.3,
  letterSpacing: -0.24,
);

const TextStyle kTsEnHeading20Eb = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Suite',
  fontSize: 20,
  fontWeight: FontWeight.w800,
  height: 1.3,
  letterSpacing: -0.20,
);

const TextStyle kTsEnHeading18Eb = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Suite',
  fontSize: 18,
  fontWeight: FontWeight.w800,
  height: 1.3,
  letterSpacing: -0.18,
);

const TextStyle kTsEnBody16Sb = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Pretendard',
  fontSize: 16,
  fontWeight: FontWeight.w600,
  height: 1.4,
);

const TextStyle kTsEnBody16Rg = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Pretendard',
  fontSize: 16,
  fontWeight: FontWeight.w400,
  height: 1.4,
);

const TextStyle kTsEnBody14Sb = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Pretendard',
  fontSize: 14,
  fontWeight: FontWeight.w600,
  height: 1.4,
);

const TextStyle kTsEnBody14Rg = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Pretendard',
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 1.4,
);

const TextStyle kTsEnBody12Sb = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Pretendard',
  fontSize: 12,
  fontWeight: FontWeight.w600,
  height: 1.4,
);

const TextStyle kTsEnBody12Rg = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Pretendard',
  fontSize: 12,
  fontWeight: FontWeight.w400,
  height: 1.4,
);

const TextStyle kTsEnCaption12Sb = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Pretendard',
  fontSize: 12,
  fontWeight: FontWeight.w600,
  height: 1.4,
);
const TextStyle kTsEnCaption12Rg = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Pretendard',
  fontSize: 12,
  fontWeight: FontWeight.w400,
  height: 1.4,
);
const TextStyle kTsEnCaption11Md = TextStyle(
  color: Color(0xFF292C45),
  fontFamily: 'Pretendard',
  fontSize: 11,
  fontWeight: FontWeight.w500,
  height: 1.4,
);
