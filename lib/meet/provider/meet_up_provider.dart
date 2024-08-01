import 'package:biskit_app/common/model/cursor_pagination_model.dart';
import 'package:biskit_app/common/provider/pagination_provider.dart';
import 'package:biskit_app/common/provider/root_provider.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/meet/provider/meet_up_filter_provider.dart';
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
  bool isLoading = false;

  MeetUpStateNotifier({
    required this.ref,
    required super.repository,
  });

  @override
  Future<void> paginate({
    int fetchCount = 20,
    bool fetchMore = false,
    bool forceRefetch = false,
    Object? orderBy,
    Object? filter,
    bool? isPublic,
  }) async {
    final rootState = ref.watch(rootProvider);

    isLoading = true;
    orderBy = orderBy ?? ref.read(meetUpFilterProvider).meetUpOrderState;
    filter = ref.read(meetUpFilterProvider).filterGroupList;
    logger.d('isPublic-paginate: ${rootState.isPublic}');
    filter = super.paginate(
      fetchCount: fetchCount,
      fetchMore: fetchMore,
      forceRefetch: forceRefetch,
      orderBy: orderBy,
      filter: filter,
      isPublic: rootState.isPublic ?? false,
    );
    isLoading = false;
  }
}
