import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biskit_app/meet/model/meet_up_filter_model.dart';
import 'package:biskit_app/meet/model/tag_model.dart';
import 'package:biskit_app/meet/model/topic_model.dart';
import 'package:biskit_app/meet/provider/create_meet_up_provider.dart';
import 'package:biskit_app/meet/provider/meet_up_provider.dart';
import 'package:biskit_app/meet/repository/meet_up_repository.dart';

final meetUpFilterProvider =
    StateNotifierProvider<MeetUpFilterStateNotifiar, MeetUpState>(
  (ref) => MeetUpFilterStateNotifiar(
    ref: ref,
  ),
);

class MeetUpFilterStateNotifiar extends StateNotifier<MeetUpState> {
  final Ref ref;
  MeetUpFilterStateNotifiar({
    required this.ref,
  }) : super(
          MeetUpState(
            isFilterSelected: false,
            filterGroupList: [],
            totalCount: 0,
          ),
        ) {
    init();
  }

  init() async {
    state = state.copyWith(
      filterGroupList: await getInitFixFilterGroupList(),
    );
  }

  Future<List<MeetUpFilterGroup>> getInitFixFilterGroupList() async {
    List<TopicModel> topicList =
        await ref.read(createMeetUpProvider.notifier).getTopics();
    List<TagModel> tagList =
        await ref.read(createMeetUpProvider.notifier).getTags();
    return [
      MeetUpFilterGroup(
        groupText: '날짜',
        filterType: MeetUpFilterType.time,
        filterList: [
          MeetUpFilterModel(
            text: '오늘',
            isSeleted: false,
            value: 'TODAY',
          ),
          MeetUpFilterModel(
            text: '내일',
            isSeleted: false,
            value: 'TOMORROW',
          ),
          MeetUpFilterModel(
            text: '이번주',
            isSeleted: false,
            value: 'THIS_WEEK',
          ),
          MeetUpFilterModel(
            text: '다음주',
            isSeleted: false,
            value: 'NEXT_WEEK',
          ),
        ],
      ),
      MeetUpFilterGroup(
        groupText: '요일',
        filterType: MeetUpFilterType.time,
        filterList: [
          MeetUpFilterModel(
            text: '월',
            isSeleted: false,
            value: 'MONDAY',
          ),
          MeetUpFilterModel(
            text: '화',
            isSeleted: false,
            value: 'TUESDAY',
          ),
          MeetUpFilterModel(
            text: '수',
            isSeleted: false,
            value: 'WEDNESDAY',
          ),
          MeetUpFilterModel(
            text: '목',
            isSeleted: false,
            value: 'THURSDAY',
          ),
          MeetUpFilterModel(
            text: '금',
            isSeleted: false,
            value: 'FRIDAY',
          ),
          MeetUpFilterModel(
            text: '토',
            isSeleted: false,
            value: 'SATURDAY',
          ),
          MeetUpFilterModel(
            text: '일',
            isSeleted: false,
            value: 'SUNDAY',
          ),
        ],
      ),
      MeetUpFilterGroup(
        groupText: '시간',
        filterType: MeetUpFilterType.time,
        filterList: [
          MeetUpFilterModel(
            text: '오전',
            isSeleted: false,
            value: 'MORNING',
          ),
          MeetUpFilterModel(
            text: '오후',
            isSeleted: false,
            value: 'AFTERNOON',
          ),
          MeetUpFilterModel(
            text: '저녁',
            isSeleted: false,
            value: 'EVENING',
          ),
        ],
      ),
      MeetUpFilterGroup(
        groupText: '주최자 국적',
        filterType: MeetUpFilterType.national,
        filterList: [
          MeetUpFilterModel(text: '한국인', isSeleted: false, value: 'KOREAN'),
          MeetUpFilterModel(text: '외국인', isSeleted: false, value: 'FOREIGNER'),
        ],
      ),
      MeetUpFilterGroup(
        groupText: '모임 주제',
        filterType: MeetUpFilterType.topic,
        filterList: topicList
            .map(
              (e) => MeetUpFilterModel(
                text: e.kr_name,
                isSeleted: false,
                value: e.id.toString(),
              ),
            )
            .toList(),
      ),
      MeetUpFilterGroup(
        groupText: '태그',
        filterType: MeetUpFilterType.tag,
        filterList: tagList
            .map(
              (e) => MeetUpFilterModel(
                text: e.kr_name,
                isSeleted: false,
                value: e.id.toString(),
              ),
            )
            .toList(),
      ),
    ];
  }

  Future<int?> getMeetingsCount(List<MeetUpFilterGroup> filterGroupList) async {
    int? totalCount;
    totalCount = await ref
        .watch(meetUpRepositoryProvider)
        .paginateCount(filterGroupList);
    return totalCount;
  }

  paginate() async {
    await ref.read(meetUpProvider.notifier).paginate(
          filter: state.filterGroupList,
          forceRefetch: true,
        );
  }

  saveFilter({
    int? totalCount,
    required List<MeetUpFilterGroup> filterGroupList,
    required bool isSelected,
  }) async {
    state = state.copyWith(
      totalCount: totalCount,
      filterGroupList: filterGroupList,
      isFilterSelected: isSelected,
    );

    await paginate();
  }
}

class MeetUpState {
  final bool isFilterSelected;
  final List<MeetUpFilterGroup> filterGroupList;
  final int? totalCount;
  MeetUpState({
    required this.isFilterSelected,
    required this.filterGroupList,
    required this.totalCount,
  });

  MeetUpState copyWith({
    bool? isFilterSelected,
    List<MeetUpFilterGroup>? filterGroupList,
    int? totalCount,
  }) {
    return MeetUpState(
      isFilterSelected: isFilterSelected ?? this.isFilterSelected,
      filterGroupList: filterGroupList ?? this.filterGroupList,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

enum MeetUpFilterType { tag, topic, time, national }

class MeetUpFilterGroup {
  final String groupText;
  final MeetUpFilterType filterType;
  final List<MeetUpFilterModel> filterList;
  MeetUpFilterGroup({
    required this.groupText,
    required this.filterType,
    required this.filterList,
  });

  MeetUpFilterGroup copyWith({
    String? groupText,
    MeetUpFilterType? filterType,
    List<MeetUpFilterModel>? filterList,
  }) {
    return MeetUpFilterGroup(
      groupText: groupText ?? this.groupText,
      filterType: filterType ?? this.filterType,
      filterList: filterList ?? this.filterList,
    );
  }
}
