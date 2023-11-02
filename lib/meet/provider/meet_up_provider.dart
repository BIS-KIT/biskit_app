import 'package:biskit_app/common/model/cursor_pagination_model.dart';
import 'package:biskit_app/common/provider/pagination_provider.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/meet/repository/meet_up_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final meetUpProvider =
    StateNotifierProvider<MeetUpStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(meetUpRepositoryProvider);

  final notifier = MeetUpStateNotifier(
    ref: ref,
    repository: repository,
  );
  return notifier;
});

class MeetUpStateNotifier
    extends PaginationProvider<MeetUpModel, MeetUpRepository> {
  final Ref ref;

  MeetUpStateNotifier({
    required this.ref,
    required super.repository,
  });
}
