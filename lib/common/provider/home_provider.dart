import 'package:biskit_app/common/repository/util_repository.dart';
import 'package:biskit_app/meet/repository/meet_up_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/meet/model/tag_model.dart';
import 'package:biskit_app/meet/model/topic_model.dart';

final homeProvider = StateNotifierProvider<HomeStateNotifier, HomeState>(
  (ref) => HomeStateNotifier(
    utilRepository: ref.watch(utilRepositoryProvider),
    meetUpRepository: ref.watch(meetUpRepositoryProvider),
  ),
);

class HomeStateNotifier extends StateNotifier<HomeState> {
  final UtilRepository utilRepository;
  final MeetUpRepository meetUpRepository;

  HomeStateNotifier({
    required this.utilRepository,
    required this.meetUpRepository,
  }) : super(
          HomeState(
            fixTopics: [],
            tags: [],
            meetings: [],
          ),
        ) {
    init();
  }

  init() async {
    state = state.copyWith(
      fixTopics: await utilRepository.getTopics(
        isCustom: false,
      ),
      tags: await utilRepository.getTags(),
      meetings: await meetUpRepository.getMeetings(
        skip: 0,
        limit: 5,
      ),
    );
  }
}

class HomeState {
  final List<TopicModel> fixTopics;
  final List<TagModel> tags;
  final List<MeetUpModel> meetings;
  HomeState({
    required this.fixTopics,
    required this.tags,
    required this.meetings,
  });

  HomeState copyWith({
    List<TopicModel>? fixTopics,
    List<TagModel>? tags,
    List<MeetUpModel>? meetings,
  }) {
    return HomeState(
      fixTopics: fixTopics ?? this.fixTopics,
      tags: tags ?? this.tags,
      meetings: meetings ?? this.meetings,
    );
  }
}
