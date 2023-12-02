import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biskit_app/common/model/cursor_pagination_model.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/meet/repository/meet_up_repository.dart';

final meetUpSearchProvider = StateNotifierProvider.autoDispose<
    MeetUpSearchStateNotifier, CursorPagination<MeetUpModel>>(
  (ref) => MeetUpSearchStateNotifier(
    meetUpRepository: ref.watch(
      meetUpRepositoryProvider,
    ),
  ),
);

class MeetUpSearchStateNotifier
    extends StateNotifier<CursorPagination<MeetUpModel>> {
  final MeetUpRepository meetUpRepository;
  String searchWord = '';
  final paginationThrottle = Throttle(
    const Duration(seconds: 3),
    initialValue: _PaginationInfo(
      limit: 20,
      searchWord: '',
    ),
    checkEquality: false,
  );
  MeetUpSearchStateNotifier({
    required this.meetUpRepository,
  }) : super(CursorPagination<MeetUpModel>(
          data: [],
          meta: CursorPaginationMeta(
            count: 0,
            totalCount: 0,
            hasMore: true,
          ),
        )) {
    init();
  }

  init() {
    state = CursorPagination<MeetUpModel>(
      data: [],
      meta: CursorPaginationMeta(
        count: 0,
        totalCount: 0,
        hasMore: true,
      ),
    );
    paginationThrottle.values.listen(
      (state) {
        _throttledPagination(state);
      },
    );
  }

  initData() {
    state = CursorPagination<MeetUpModel>(
      data: [],
      meta: CursorPaginationMeta(
        count: 0,
        totalCount: 0,
        hasMore: true,
      ),
    );
  }

  fetchItems({
    int limit = 10,
    bool forceRefetch = false,
    required String searchWord,
  }) async {
    paginationThrottle.setValue(_PaginationInfo(
      limit: limit,
      forceRefetch: forceRefetch,
      searchWord: searchWord,
    ));
  }

  _throttledPagination(_PaginationInfo info) async {
    if (info.forceRefetch) {
      state = CursorPagination<MeetUpModel>(
        data: [],
        meta: CursorPaginationMeta(
          count: 0,
          totalCount: 0,
          hasMore: true,
        ),
      );
    }

    if (!state.meta.hasMore) return;
    // int skip = info.skip;
    int limit = info.limit;

    final CursorPagination<MeetUpModel>? cursorPagination =
        await meetUpRepository.getMeetingsSearch(
      skip: state.data.length,
      limit: limit,
      searchWord: info.searchWord,
    );
    if (cursorPagination != null) {
      state = state.copyWith(
        meta: cursorPagination.meta,
        data: [
          ...state.data,
          ...cursorPagination.data,
        ],
      );
    }
  }
}

class _PaginationInfo {
  final int limit;
  final bool forceRefetch;
  final String searchWord;
  _PaginationInfo({
    this.limit = 20,
    this.forceRefetch = false,
    required this.searchWord,
  });
}
