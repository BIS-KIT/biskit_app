import 'package:biskit_app/common/const/enums.dart';

String getLevelTitle(int level) {
  switch (level) {
    case 5:
      return '능숙';
    case 4:
      return '고급';
    case 3:
      return '중급';
    case 2:
      return '기초';
    case 1:
      return '초보';
    default:
      return '레벨';
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
      return '대부분의 것들을 편히 이해할 수 있어요';
    case 4:
      return '대부분의 것들을 편히 이해할 수 있어요';
    case 3:
      return '대부분의 것들을 편히 이해할 수 있어요';
    case 2:
      return '대부분의 것들을 편히 이해할 수 있어요';
    case 1:
      return '대부분의 것들을 편히 이해할 수 있어요';
    default:
      return '대부분의 것들을 편히 이해할 수 있어요';
  }
}

String getSnsTypeString(String? snsType) {
  if (snsType == null) {
    return '이메일';
  } else if (snsType == SnsType.apple.name) {
    return '애플';
  } else if (snsType == SnsType.kakao.name) {
    return '카카오';
  } else {
    return '구글';
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
