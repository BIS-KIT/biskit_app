abstract class UserModelBase {}

class UserModelError extends UserModelBase {
  final String message;
  UserModelError({
    required this.message,
  });
}

class UserModelLoading extends UserModelBase {}

class UserModel extends UserModelBase {}
