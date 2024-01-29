import 'package:biskit_app/common/const/enums.dart';
import 'package:easy_localization/easy_localization.dart';

String getLevelTitle(int level) {
  switch (level) {
    case 5:
      return 'langLevelBottomSheet.mastery.title'.tr();
    case 4:
      return 'langLevelBottomSheet.advanced.title'.tr();
    case 3:
      return 'langLevelBottomSheet.intermediate.title'.tr();
    case 2:
      return 'langLevelBottomSheet.elementary.title'.tr();
    case 1:
      return 'langLevelBottomSheet.beginner.title'.tr();
    default:
      return 'selectLangBottomSheet.level.title'.tr();
  }
}

String getLevelServerValue(int level) {
  switch (level) {
    case 5:
      return 'PROFICIENT';
    case 4:
      return 'ADVANCED';
    case 3:
      return 'INTERMEDIATE';
    case 2:
      return 'BASIC';
    case 1:
      return 'BEGINNER';
    default:
      return '';
  }
}

int getLevelServerValueToInt(String value) {
  switch (value) {
    case 'PROFICIENT':
      return 5;
    case 'ADVANCED':
      return 4;
    case 'INTERMEDIATE':
      return 3;
    case 'BASIC':
      return 2;
    case 'BEGINNER':
      return 1;
    default:
      return 0;
  }
}

String getLevelServerValueToKrString(String value) {
  switch (value) {
    case 'PROFICIENT':
      return '능숙';
    case 'ADVANCED':
      return '고급';
    case 'INTERMEDIATE':
      return '중급';
    case 'BASIC':
      return '기초';
    case 'BEGINNER':
      return '초보';
    default:
      return '레벨';
  }
}

String getLevelSubTitle(int level) {
  switch (level) {
    case 5:
      return 'langLevelBottomSheet.mastery.description'.tr();
    case 4:
      return 'langLevelBottomSheet.advanced.description'.tr();
    case 3:
      return 'langLevelBottomSheet.intermediate.description'.tr();
    case 2:
      return 'langLevelBottomSheet.elementary.description'.tr();
    case 1:
      return 'langLevelBottomSheet.beginner.description'.tr();
    default:
      return '';
  }
}

String getLanMaxDescription(String levelStr) {
  switch (levelStr) {
    case '능숙':
      return '능숙한 사람이 가장 많아요';
    case '고급':
      return '고급인 사람이 가장 많아요';
    case '중급':
      return '중급인 사람이 가장 많아요';
    case '기초':
      return '기초인 사람이 가장 많아요';
    case '초보':
      return '초보인 사람이 가장 많아요';
    default:
      return '';
  }
}

String getSnsTypeString(String? snsType) {
  if (snsType == null) {
    return 'accountScreen.accountInfo.email'.tr();
  } else if (snsType == SnsType.apple.name) {
    return 'accountScreen.accountInfo.apple'.tr();
  } else if (snsType == SnsType.kakao.name) {
    return 'accountScreen.accountInfo.kakako'.tr();
  } else {
    return 'accountScreen.accountInfo.google'.tr();
  }
}

String getSnsTypeIconPath(String? snsType) {
  if (snsType == null) {
    return 'assets/icons/ic_login_email.svg';
  } else if (snsType == SnsType.apple.name) {
    return 'assets/icons/ic_login_apple.svg';
  } else if (snsType == SnsType.kakao.name) {
    return 'assets/icons/ic_login_kakao.svg';
  } else {
    return 'assets/icons/ic_login_google.svg';
  }
}
