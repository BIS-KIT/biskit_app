import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/meet/repository/meet_up_repository.dart';
import 'package:biskit_app/review/model/res_review_model.dart';
import 'package:biskit_app/review/repository/review_repository.dart';

final reviewProvider =
    StateNotifierProvider<ReviewStateNotifier, List<ResReviewModel>>(
  (ref) => ReviewStateNotifier(
    reviewRepository: ref.watch(reviewRepositoryProvider),
    meetUpRepository: ref.watch(
      meetUpRepositoryProvider,
    ),
  ),
);

class _PaginationInfo {
  final int skip;
  final int limit;
  _PaginationInfo({
    this.skip = 0,
    this.limit = 20,
  });
}

class ReviewStateNotifier extends StateNotifier<List<ResReviewModel>> {
  final ReviewRepository reviewRepository;
  final MeetUpRepository meetUpRepository;
  final paginationThrottle = Throttle(
    const Duration(seconds: 3),
    initialValue: _PaginationInfo(
      limit: 20,
      skip: 0,
    ),
    checkEquality: false,
  );
  ReviewStateNotifier({
    required this.reviewRepository,
    required this.meetUpRepository,
  }) : super([]) {
    fetchItems();
    paginationThrottle.values.listen(
      (state) {
        _throttledPagination(state);
      },
    );
  }

  _throttledPagination(_PaginationInfo info) async {
    logger.d(info);
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

  fetchItems({
    int skip = 0,
    int limit = 20,
  }) async {
    paginationThrottle.setValue(_PaginationInfo(
      skip: skip,
      limit: limit,
    ));
  }
}
