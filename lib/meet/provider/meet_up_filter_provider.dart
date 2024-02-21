import 'package:biskit_app/meet/model/meet_up_filter_model.dart';
import 'package:biskit_app/meet/model/meet_up_list_order.dart';
import 'package:biskit_app/meet/model/tag_model.dart';
import 'package:biskit_app/meet/model/topic_model.dart';
import 'package:biskit_app/meet/provider/create_meet_up_provider.dart';
import 'package:biskit_app/meet/provider/meet_up_provider.dart';
import 'package:biskit_app/meet/repository/meet_up_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            meetUpOrderState: MeetUpOrderState.created_time,
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
        await ref.read(createMeetUpProvider.notifier).getTopics(
              isCustom: false,
            );
    List<TagModel> tagList =
        await ref.read(createMeetUpProvider.notifier).getTags(isCustom: false);
    return [
      MeetUpFilterGroup(
        groupText: 'exploreFilterBottomSheet.date.title'.tr(),
        filterType: MeetUpFilterType.time,
        filterViewType: MeetUpFilterViewType.days,
        filterList: [
          MeetUpFilterModel(
            text: 'exploreFilterBottomSheet.date.today'.tr(),
            isSeleted: false,
            value: 'TODAY',
          ),
          MeetUpFilterModel(
            text: 'exploreFilterBottomSheet.date.tomorrow'.tr(),
            isSeleted: false,
            value: 'TOMORROW',
          ),
          MeetUpFilterModel(
            text: 'exploreFilterBottomSheet.date.thisWeek'.tr(),
            isSeleted: false,
            value: 'THIS_WEEK',
          ),
          MeetUpFilterModel(
            text: 'exploreFilterBottomSheet.date.nextWeek'.tr(),
            isSeleted: false,
            value: 'NEXT_WEEK',
          ),
        ],
      ),
      MeetUpFilterGroup(
        groupText: 'exploreFilterBottomSheet.day.title'.tr(),
        filterType: MeetUpFilterType.time,
        filterViewType: MeetUpFilterViewType.week,
        filterList: [
          MeetUpFilterModel(
            text: 'exploreFilterBottomSheet.day.mon'.tr(),
            isSeleted: false,
            value: 'MONDAY',
          ),
          MeetUpFilterModel(
            text: 'exploreFilterBottomSheet.day.tue'.tr(),
            isSeleted: false,
            value: 'TUESDAY',
          ),
          MeetUpFilterModel(
            text: 'exploreFilterBottomSheet.day.wed'.tr(),
            isSeleted: false,
            value: 'WEDNESDAY',
          ),
          MeetUpFilterModel(
            text: 'exploreFilterBottomSheet.day.thu'.tr(),
            isSeleted: false,
            value: 'THURSDAY',
          ),
          MeetUpFilterModel(
            text: 'exploreFilterBottomSheet.day.fri'.tr(),
            isSeleted: false,
            value: 'FRIDAY',
          ),
          MeetUpFilterModel(
            text: 'exploreFilterBottomSheet.day.sat'.tr(),
            isSeleted: false,
            value: 'SATURDAY',
          ),
          MeetUpFilterModel(
            text: 'exploreFilterBottomSheet.day.sun'.tr(),
            isSeleted: false,
            value: 'SUNDAY',
          ),
        ],
      ),
      MeetUpFilterGroup(
        groupText: 'exploreFilterBottomSheet.time.title'.tr(),
        filterType: MeetUpFilterType.time,
        filterViewType: MeetUpFilterViewType.time,
        filterList: [
          MeetUpFilterModel(
            text: 'exploreFilterBottomSheet.time.morning'.tr(),
            isSeleted: false,
            value: 'MORNING',
          ),
          MeetUpFilterModel(
            text: 'exploreFilterBottomSheet.time.afternoon'.tr(),
            isSeleted: false,
            value: 'AFTERNOON',
          ),
          MeetUpFilterModel(
            text: 'exploreFilterBottomSheet.time.dinner'.tr(),
            isSeleted: false,
            value: 'EVENING',
          ),
        ],
      ),
      MeetUpFilterGroup(
        groupText: 'exploreFilterBottomSheet.hostNationality.title'.tr(),
        filterType: MeetUpFilterType.national,
        filterViewType: MeetUpFilterViewType.national,
        filterList: [
          MeetUpFilterModel(
              text: 'exploreFilterBottomSheet.hostNationality.korean'.tr(),
              isSeleted: false,
              value: 'KOREAN'),
          MeetUpFilterModel(
              text: 'exploreFilterBottomSheet.hostNationality.foreigner'.tr(),
              isSeleted: false,
              value: 'FOREIGNER'),
        ],
      ),
      MeetUpFilterGroup(
        groupText: 'exploreFilterBottomSheet.category.title'.tr(),
        filterType: MeetUpFilterType.topic,
        filterViewType: MeetUpFilterViewType.topic,
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
        groupText: 'exploreFilterBottomSheet.tag.title'.tr(),
        filterType: MeetUpFilterType.tag,
        filterViewType: MeetUpFilterViewType.tag,
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
          orderBy: state.meetUpOrderState,
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

  setOrderBy(MeetUpOrderState meetUpOrderState) async {
    state = state.copyWith(
      meetUpOrderState: meetUpOrderState,
    );
    await paginate();
  }

  void onTapTopicAndTag({
    required MeetUpFilterType type,
    required int id,
  }) async {
    List<MeetUpFilterGroup> filterGroupList = await getInitFixFilterGroupList();
    filterGroupList = filterGroupList.map(
      (e) {
        if (e.filterType == type) {
          return e.copyWith(
            filterList: e.filterList.map((f) {
              if (f.value == '$id') {
                return f.copyWith(
                  isSeleted: true,
                );
              }
              return f;
            }).toList(),
          );
        } else {
          return e;
        }
      },
    ).toList();

    await saveFilter(
      filterGroupList: filterGroupList,
      isSelected: true,
      totalCount: await getMeetingsCount(filterGroupList),
    );
  }
}

class MeetUpState {
  final MeetUpOrderState meetUpOrderState;
  final bool isFilterSelected;
  final List<MeetUpFilterGroup> filterGroupList;
  final int? totalCount;
  MeetUpState({
    required this.meetUpOrderState,
    required this.isFilterSelected,
    required this.filterGroupList,
    required this.totalCount,
  });

  MeetUpState copyWith({
    MeetUpOrderState? meetUpOrderState,
    bool? isFilterSelected,
    List<MeetUpFilterGroup>? filterGroupList,
    int? totalCount,
  }) {
    return MeetUpState(
      meetUpOrderState: meetUpOrderState ?? this.meetUpOrderState,
      isFilterSelected: isFilterSelected ?? this.isFilterSelected,
      filterGroupList: filterGroupList ?? this.filterGroupList,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

enum MeetUpFilterType { tag, topic, time, national }

enum MeetUpFilterViewType { tag, topic, time, days, week, national }

class MeetUpFilterGroup {
  final String groupText;
  final MeetUpFilterType filterType;
  final MeetUpFilterViewType filterViewType;
  final List<MeetUpFilterModel> filterList;
  MeetUpFilterGroup({
    required this.groupText,
    required this.filterType,
    required this.filterViewType,
    required this.filterList,
  });

  MeetUpFilterGroup copyWith({
    String? groupText,
    MeetUpFilterType? filterType,
    MeetUpFilterViewType? filterViewType,
    List<MeetUpFilterModel>? filterList,
  }) {
    return MeetUpFilterGroup(
      groupText: groupText ?? this.groupText,
      filterType: filterType ?? this.filterType,
      filterViewType: filterViewType ?? this.filterViewType,
      filterList: filterList ?? this.filterList,
    );
  }
}
