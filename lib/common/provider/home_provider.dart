import 'package:biskit_app/common/repository/util_repository.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/meet/model/tag_model.dart';
import 'package:biskit_app/meet/model/topic_model.dart';
import 'package:biskit_app/meet/repository/meet_up_repository.dart';
import 'package:biskit_app/profile/repository/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeProvider = StateNotifierProvider<HomeStateNotifier, HomeState>(
  (ref) => HomeStateNotifier(
    ref: ref,
    utilRepository: ref.watch(utilRepositoryProvider),
    meetUpRepository: ref.watch(meetUpRepositoryProvider),
    profileRepository: ref.watch(profileRepositoryProvider),
  ),
);

class HomeStateNotifier extends StateNotifier<HomeState> {
  final Ref ref;
  final UtilRepository utilRepository;
  final MeetUpRepository meetUpRepository;
  final ProfileRepository profileRepository;

  HomeStateNotifier({
    required this.ref,
    required this.utilRepository,
    required this.meetUpRepository,
    required this.profileRepository,
  }) : super(
          HomeState(
            fixTopics: [],
            tags: [],
            meetings: [],
            approveMeetings: [],
          ),
        ) {
    init();
  }

  init() async {
    List<MeetUpModel>? approveMeetings =
        await profileRepository.getMyApproveMeetings(
      skip: 0,
      limit: 5,
    );

    List<MeetUpModel> sortedApproveMeetings =
        List<MeetUpModel>.from(approveMeetings!);
    sortedApproveMeetings
        .sort((a, b) => a.meeting_time.compareTo(b.meeting_time));

    state = state.copyWith(
      fixTopics: await utilRepository.getTopics(
        isCustom: false,
      ),
      tags: await utilRepository.getTags(isCustom: false, isHome: true),
      meetings: await meetUpRepository.getMeetings(
        skip: 0,
        limit: 5,
      ),
      approveMeetings: sortedApproveMeetings,
    );
    if (state.approveMeetings.isNotEmpty) {
      // ref.read(rootProvider.notifier).setScaffoldColor(Colors);
    }
  }
}

class HomeState {
  final List<TopicModel> fixTopics;
  final List<TagModel> tags;

  // 참여예정 및 개설된 모임 2
  final List<MeetUpModel> approveMeetings;

  // 우리 학교에서 개설된 모임 5개
  final List<MeetUpModel> meetings;
  HomeState({
    required this.fixTopics,
    required this.tags,
    required this.approveMeetings,
    required this.meetings,
  });

  HomeState copyWith({
    List<TopicModel>? fixTopics,
    List<TagModel>? tags,
    List<MeetUpModel>? approveMeetings,
    List<MeetUpModel>? meetings,
  }) {
    return HomeState(
      fixTopics: fixTopics ?? this.fixTopics,
      tags: tags ?? this.tags,
      approveMeetings: approveMeetings ?? this.approveMeetings,
      meetings: meetings ?? this.meetings,
    );
  }
}
