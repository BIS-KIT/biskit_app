import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref: ref,
  );
});

class AuthRepository {
  final Ref ref;
  AuthRepository({
    required this.ref,
  });
}
