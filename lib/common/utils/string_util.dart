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
