import 'package:biskit_app/common/components/chip_widget.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/meet/model/meet_up_filter_model.dart';
import 'package:biskit_app/meet/provider/meet_up_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeetUpFilterSheetWidget extends ConsumerStatefulWidget {
  const MeetUpFilterSheetWidget({super.key});

  @override
  ConsumerState<MeetUpFilterSheetWidget> createState() =>
      _MeetUpFilterSheetWidgetState();
}

class _MeetUpFilterSheetWidgetState
    extends ConsumerState<MeetUpFilterSheetWidget> {
  List<MeetUpFilterGroup> filterGroupList = [];
  int? totalCount = 0;

  @override
  void initState() {
    init();
    super.initState();
  }

  // 초기값 셋팅
  init() async {
    setState(() {
      filterGroupList = ref.read(meetUpFilterProvider).filterGroupList;
      totalCount = ref.read(meetUpFilterProvider).totalCount;
    });
    await setTotalCount();
  }

  // 초기화
  zeroInit() async {
    filterGroupList = await ref
        .read(meetUpFilterProvider.notifier)
        .getInitFixFilterGroupList();
    await setTotalCount();
  }

  // 검색필터 선택
  void selectFilter(
    MeetUpFilterType filterType,
    MeetUpFilterModel model,
  ) async {
    setState(() {
      filterGroupList = filterGroupList.map((group) {
        if (group.filterType == filterType) {
          return group.copyWith(
            filterList: group.filterList
                .map((e) => e == model
                    ? e.copyWith(
                        isSeleted: !e.isSeleted,
                      )
                    : e)
                .toList(),
          );
        } else {
          return group;
        }
      }).toList();
    });

    // 모임 수 값 셋팅
    await setTotalCount();
  }

  // 모임 수 값 셋팅
  setTotalCount() async {
    int? count = await ref
        .read(meetUpFilterProvider.notifier)
        .getMeetingsCount(filterGroupList);
    // logger.d('count>>>$count');
    setState(() {
      totalCount = count ?? 0;
    });
  }

  // 필터 저장
  saveMeetUpFilter() async {
    bool isSelected = false;
    for (var element in filterGroupList) {
      if (element.filterList.where((f) => f.isSeleted).isNotEmpty) {
        isSelected = true;
        break;
      }
    }
    ref.read(meetUpFilterProvider.notifier).saveFilter(
          totalCount: totalCount,
          filterGroupList: filterGroupList,
          isSelected: isSelected,
        );
  }

  @override
  Widget build(BuildContext context) {
    // final filterState = ref.watch(meetUpFilterProvider);

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Filter
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 32,
                    ),
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            filterGroupList[index].groupText,
                            style: getTsBody14Sb(context).copyWith(
                              color: kColorContentWeak,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: filterGroupList[index]
                                .filterList
                                .map((e) => ChipWidget(
                                      text: e.text,
                                      isSelected: e.isSeleted,
                                      onClickSelect: () {
                                        selectFilter(
                                          filterGroupList[index].filterType,
                                          e,
                                        );
                                      },
                                    ))
                                .toList(),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: kColorBorderDefalut,
                        ),
                      );
                    },
                    itemCount: filterGroupList.length,
                  ),
                ),
                // bottom button
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 34,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          zeroInit();
                        },
                        child: const OutlinedButtonWidget(
                          text: '초기화',
                          isEnable: true,
                          leftIconPath: 'assets/icons/ic_reset_line_24.svg',
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            saveMeetUpFilter();
                            if (!mounted) return;
                            Navigator.of(context).pop();
                          },
                          child: FilledButtonWidget(
                            text: '${totalCount ?? 0}개 모임보기',
                            isEnable: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
