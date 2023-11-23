import 'package:biskit_app/common/model/cursor_pagination_model.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/meet/repository/meet_up_repository.dart';
import 'package:biskit_app/review/model/res_review_model.dart';
import 'package:biskit_app/review/repository/review_repository.dart';

final reviewProvider = StateNotifierProvider.family<ReviewStateNotifier,
    CursorPagination<ResReviewModel>, int?>(
  (ref, id) => ReviewStateNotifier(
    reviewRepository: ref.watch(reviewRepositoryProvider),
    meetUpRepository: ref.watch(
      meetUpRepositoryProvider,
    ),
    userId: id,
  ),
);

class _PaginationInfo {
  final int limit;
  final bool forceRefetch;
  _PaginationInfo({
    this.limit = 20,
    this.forceRefetch = false,
  });
}

class ReviewStateNotifier
    extends StateNotifier<CursorPagination<ResReviewModel>> {
  final ReviewRepository reviewRepository;
  final MeetUpRepository meetUpRepository;
  final int? userId;
  final paginationThrottle = Throttle(
    const Duration(seconds: 3),
    initialValue: _PaginationInfo(
      limit: 20,
    ),
    checkEquality: false,
  );
  ReviewStateNotifier({
    required this.reviewRepository,
    required this.meetUpRepository,
    required this.userId,
  }) : super(CursorPagination<ResReviewModel>(
          data: [],
          meta: CursorPaginationMeta(
            count: 0,
            totalCount: 0,
            hasMore: true,
          ),
        )) {
    fetchItems();
    paginationThrottle.values.listen(
      (state) {
        _throttledPagination(state);
      },
    );
  }

  fetchItems({
    int limit = 20,
    bool forceRefetch = false,
  }) async {
    paginationThrottle.setValue(_PaginationInfo(
      limit: limit,
      forceRefetch: forceRefetch,
    ));
  }

  _throttledPagination(_PaginationInfo info) async {
    if (info.forceRefetch) {
      state = CursorPagination<ResReviewModel>(
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

    final CursorPagination<ResReviewModel>? cursorPagination =
        await meetUpRepository.getMeetingAllReviews(
      skip: state.data.length,
      limit: limit,
      userId: userId!,
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

  createReview({
    required int meetingId,
    required String imageUrl,
    required String context,
    // required int creatorId,
  }) async {
    final result = await meetUpRepository.createReview(
      meetingId: meetingId,
      imageUrl: imageUrl,
      context: context,
    );
    logger.d(result);
  }

  deleteReview({required int id}) async {
    final result = await reviewRepository.deleteReview(id);
    if (result) {
      state = state.copyWith(
        data: state.data.where((element) => element.id != id).toList(),
      );
    }
  }
}
