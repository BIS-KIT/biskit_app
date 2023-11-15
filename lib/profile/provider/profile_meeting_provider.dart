// ignore_for_file: constant_identifier_names

import 'package:biskit_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/profile/repository/profile_repository.dart';

final profileMeetingProvider =
    StateNotifierProvider<ProfileMeetingStateNotifier, ProfileMeetingState>(
  (ref) => ProfileMeetingStateNotifier(
    profileRepository: ref.watch(profileRepositoryProvider),
  ),
);

enum ProfileMeetingStatus { APPROVE, PENDING, PAST }

class ProfileMeetingStateNotifier extends StateNotifier<ProfileMeetingState> {
  final ProfileRepository profileRepository;

  ProfileMeetingStateNotifier({
    required this.profileRepository,
  }) : super(ProfileMeetingState(
          dataList: [],
          isLoading: false,
          profileMeetingStatus: ProfileMeetingStatus.APPROVE,
        )) {
    //
    fetch();
  }

  fetch() async {
    state = state.copyWith(
      isLoading: true,
      dataList: [],
    );

    CursorPagination<MeetUpModel>? cursorPagination =
        await profileRepository.getMyMeetings(
      skip: 0,
      limit: 5,
      status: state.profileMeetingStatus.name,
    );

    state = state.copyWith(
      isLoading: false,
      dataList: cursorPagination == null ? [] : cursorPagination.data,
    );
  }

  // TODO 개발용 나의 모임 가져오기
  getMyMeeting() async {
    return await profileRepository.getMyMeetings(
      status: ProfileMeetingStatus.APPROVE.name,
      skip: 0,
      limit: 5,
    );
  }

  void onTapStatus(ProfileMeetingStatus status) {
    state = state.copyWith(
      profileMeetingStatus: status,
    );
    fetch();
  }
}

class ProfileMeetingState {
  final bool isLoading;
  final ProfileMeetingStatus profileMeetingStatus;
  final List<MeetUpModel> dataList;
  ProfileMeetingState({
    required this.isLoading,
    required this.profileMeetingStatus,
    required this.dataList,
  });

  ProfileMeetingState copyWith({
    bool? isLoading,
    ProfileMeetingStatus? profileMeetingStatus,
    List<MeetUpModel>? dataList,
  }) {
    return ProfileMeetingState(
      isLoading: isLoading ?? this.isLoading,
      profileMeetingStatus: profileMeetingStatus ?? this.profileMeetingStatus,
      dataList: dataList ?? this.dataList,
    );
  }
}
