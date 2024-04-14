import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/setting/model/notice_list_model.dart';
import 'package:biskit_app/setting/model/notice_model.dart';
import 'package:biskit_app/setting/repository/setting_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationProvider =
    StateNotifierProvider<NoticeListStateNotifier, NoticeListModelBase?>((ref) {
  return NoticeListStateNotifier(ref: ref);
});

class NoticeListStateNotifier extends StateNotifier<NoticeListModelBase?> {
  final Ref ref;
  NoticeListStateNotifier({
    required this.ref,
  }) : super(NoticeListModelLoading()) {
    getNoticeList();
  }

  Future<void> getNoticeList() async {
    try {
      NoticeListModel? res =
          await ref.read(settingRepositoryProvider).getNoticeList();
      state = res;
    } catch (e) {
      state = NoticeListModelError(message: e.toString());
    }
  }

  Future<void> createNotice({
    required String title,
    required String content,
    required int userId,
  }) async {
    try {
      NoticeModel? notice = await ref
          .read(settingRepositoryProvider)
          .createNotice(title: title, content: content, user_id: userId);

      if (state is NoticeListModel && notice != null) {
        final currentState = state as NoticeListModel;
        final updatedNotices = currentState.notices..add(notice);
        state = currentState.copyWith(notices: updatedNotices);
      }
    } catch (e) {
      state = NoticeListModelError(message: e.toString());
    }
  }

  Future<void> updateNotice({
    required int noticeId,
    required int userId,
    required String title,
    required String content,
  }) async {
    try {
      NoticeModel? updatedNotice = await ref
          .read(settingRepositoryProvider)
          .updateNotice(
              notice_id: noticeId,
              user_id: userId,
              title: title,
              content: content);

      if (state is NoticeListModel && updatedNotice != null) {
        final currentState = state as NoticeListModel;
        final updatedNotices = currentState.notices.map((notice) {
          // ID가 일치하는 공지사항을 찾아 업데이트
          if (notice.id == noticeId) {
            return updatedNotice;
          }
          return notice;
        }).toList();
        state = currentState.copyWith(notices: updatedNotices);
      }
    } catch (e) {
      state = NoticeListModelError(message: e.toString());
    }
  }

  Future<void> deleteNotice({
    required int noticeId,
    required int userId,
  }) async {
    try {
      logger.d('notice_id api ${noticeId}');
      int? deletedNoticeId = await ref
          .read(settingRepositoryProvider)
          .deleteNotice(notice_id: noticeId, user_id: userId);

      if (state is NoticeListModel && deletedNoticeId != null) {
        final currentState = state as NoticeListModel;
        // ID가 일치하는 공지사항을 찾아 삭제
        final updatedNotices = currentState.notices
            .where((notice) => notice.id != deletedNoticeId)
            .toList();
        state = currentState.copyWith(notices: updatedNotices);
      }
    } catch (e) {
      state = NoticeListModelError(message: e.toString());
    }
  }
}
