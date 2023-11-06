import 'package:biskit_app/common/model/cursor_pagination_model.dart';
import 'package:biskit_app/common/provider/pagination_provider.dart';
import 'package:biskit_app/meet/model/meet_up_list_order.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/meet/repository/meet_up_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final meetUpProvider =
    StateNotifierProvider<MeetUpStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(meetUpRepositoryProvider);

  final notifier = MeetUpStateNotifier(
    ref: ref,
    repository: repository,
    meetUpOrderState: MeetUpOrderState.created_time,
  );
  return notifier;
});

class MeetUpStateNotifier
    extends PaginationProvider<MeetUpModel, MeetUpRepository> {
  final Ref ref;
  MeetUpOrderState meetUpOrderState;
  bool isLoading = false;

  MeetUpStateNotifier({
    required this.ref,
    required super.repository,
    required this.meetUpOrderState,
  });

  setOrderBy(MeetUpOrderState value) {
    meetUpOrderState = value;
    paginate(
      orderBy: value,
    );
  }

  @override
  Future<void> paginate({
    int fetchCount = 20,
    bool fetchMore = false,
    bool forceRefetch = false,
    Object? orderBy,
    Object? filter,
  }) async {
    isLoading = true;
    orderBy = meetUpOrderState;

    super.paginate(
      fetchCount: fetchCount,
      fetchMore: fetchMore,
      forceRefetch: forceRefetch,
      orderBy: orderBy,
      filter: filter,
    );
    isLoading = false;
  }
}
