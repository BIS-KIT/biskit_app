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
            ));

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

  void init() async {
    List<TopicModel> topicList =
        await ref.read(createMeetUpProvider.notifier).getTopics();
    List<TagModel> tagList =
        await ref.read(createMeetUpProvider.notifier).getTags();
    state = state.copyWith(
      filterGroupList: [
        MeetUpFilterGroup(
          groupText: '날짜',
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
          groupText: '모임 주제',
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
      ],
    );

    state = state.copyWith(
      totalCount: await getMeetingsCount(),
    );
  }

  Future<int?> getMeetingsCount() async {
    int? totalCount;
    List<MeetUpFilterModel> filterList = [];
    for (var element in state.filterGroupList) {
      filterList.addAll(element.filterList.where((e) => e.isSeleted).toList());
    }
    totalCount =
        await ref.watch(meetUpRepositoryProvider).paginateCount(filterList);
    return totalCount;
  }

  selectedFilter(MeetUpFilterGroup group, MeetUpFilterModel model) async {
    state = state.copyWith(
      filterGroupList: state.filterGroupList.map((e) {
        if (e == group) {
          return e.copyWith(
            filterList: e.filterList.map((m) {
              if (m == model) {
                return m.copyWith(
                  isSeleted: !m.isSeleted,
                );
              } else {
                return m;
              }
            }).toList(),
          );
        } else {
          return e;
        }
      }).toList(),
    );

    // filter selected check
    bool isSeleted = false;
    for (var element in state.filterGroupList) {
      if (element.filterList.where((f) => f.isSeleted).isNotEmpty) {
        isSeleted = true;
        break;
      }
    }

    // total count
    state = state.copyWith(
      isFilterSelected: isSeleted,
      totalCount: await getMeetingsCount(),
    );
  }

  paginate() async {
    List<MeetUpFilterModel> list = [];
    for (var element in state.filterGroupList) {
      list.addAll(element.filterList.where((f) => f.isSeleted).toList());
    }
    await ref.read(meetUpProvider.notifier).paginate(
          filter: list,
          forceRefetch: true,
        );
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

class MeetUpFilterGroup {
  final String groupText;
  final List<MeetUpFilterModel> filterList;
  MeetUpFilterGroup({
    required this.groupText,
    required this.filterList,
  });

  MeetUpFilterGroup copyWith({
    String? groupText,
    List<MeetUpFilterModel>? filterList,
  }) {
    return MeetUpFilterGroup(
      groupText: groupText ?? this.groupText,
      filterList: filterList ?? this.filterList,
    );
  }
}
