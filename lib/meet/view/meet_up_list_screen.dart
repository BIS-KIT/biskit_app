import 'package:biskit_app/common/components/chip_widget.dart';
import 'package:biskit_app/common/components/pagination_list_view.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/meet/components/meet_up_card_widget.dart';
import 'package:biskit_app/meet/components/meet_up_filter_sheet_widget.dart';
import 'package:biskit_app/meet/model/meet_up_list_order.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/meet/provider/meet_up_filter_provider.dart';
import 'package:biskit_app/meet/provider/meet_up_provider.dart';
import 'package:biskit_app/meet/view/meet_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MeetUpListScreen extends ConsumerStatefulWidget {
  const MeetUpListScreen({super.key});

  @override
  ConsumerState<MeetUpListScreen> createState() => _MeetUpListScreenState();
}

class _MeetUpListScreenState extends ConsumerState<MeetUpListScreen> {
  bool isTopVisible = true;
  bool isPopupMenuVisible = false;
  late MeetUpListOrder selectedOrder;
  final List<MeetUpListOrder> meetUpListOrder = [
    MeetUpListOrder(
      state: MeetUpOrderState.created_time,
      text: '등록순',
    ),
    MeetUpListOrder(
      state: MeetUpOrderState.meeting_time,
      text: '일시순',
    ),
    MeetUpListOrder(
      state: MeetUpOrderState.deadline_soon,
      text: '마감임박순',
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedOrder = meetUpListOrder[0];
  }

  void onTapFilter() {
    // ref.read(meetUpFilterProvider.notifier).tempSave();
    showBiskitBottomSheet(
      context: context,
      title: '필터',
      rightIcon: 'assets/icons/ic_cancel_line_24.svg',
      onRightTap: () {
        Navigator.pop(context);
      },
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          48,
      contentWidget: const Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: MeetUpFilterSheetWidget(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(meetUpFilterProvider);
    return GestureDetector(
      onTap: () {
        if (isPopupMenuVisible) {
          setState(() {
            isPopupMenuVisible = false;
          });
        }
      },
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                // Top
                if (isTopVisible) _buildTop(context, filterState),

                // 필터
                _buildFilter(),

                // List
                _buildList(context, filterState),
              ],
            ),
            _buildPopUpMenu(context),

            // 로딩
            // if (meetUpState.)
            //   const Center(
            //     child: CustomLoading(),
            //   ),
          ],
        ),
      ),
    );
  }

  Positioned _buildPopUpMenu(BuildContext context) {
    return Positioned(
      top: 100,
      left: 20,
      child: Container(
        height: isPopupMenuVisible ? null : 0,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x2D495B7D),
              blurRadius: 40,
              offset: Offset(0, 16),
              spreadRadius: 0,
            )
          ],
        ),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...meetUpListOrder
                  .map(
                    (e) => GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        ref
                            .read(meetUpFilterProvider.notifier)
                            .setOrderBy(e.state);
                        setState(() {
                          selectedOrder = e;
                          isPopupMenuVisible = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        child: Text(
                          e.text,
                          style: e == selectedOrder
                              ? getTsBody16Sb(context).copyWith(
                                  color: kColorContentSecondary,
                                )
                              : getTsBody16Rg(context).copyWith(
                                  color: kColorContentWeakest,
                                ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildFilter() {
    final filterState = ref.watch(meetUpFilterProvider);
    final List<MeetUpFilterGroup> groupList = [];

    for (var element in filterState.filterGroupList
        .where((g) => g.filterList.where((f) => f.isSeleted).isNotEmpty)) {
      groupList.add(element);
    }
    for (var element in filterState.filterGroupList
        .where((g) => g.filterList.where((f) => f.isSeleted).isEmpty)) {
      groupList.add(element);
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        // bottom: 8,
        left: 20,
      ),
      child: Row(
        children: [
          ChipWidget(
            text: selectedOrder.text,
            textColor: kColorContentDefault,
            isSelected: false,
            onTapDelete: () {
              setState(() {
                isPopupMenuVisible = !isPopupMenuVisible;
              });
            },
            onClickSelect: () {
              setState(() {
                isPopupMenuVisible = !isPopupMenuVisible;
              });
            },
            rightIcon: 'assets/icons/ic_chevron_down_line_24.svg',
            rightIconColor: kColorContentWeaker,
          ),
          // if (filterState.isFilterSelected)
          Expanded(
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                padding: const EdgeInsets.only(
                  left: 4,
                  right: 20,
                ),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ChipWidget(
                    text: groupList[index]
                            .filterList
                            .where((element) => element.isSeleted)
                            .isEmpty
                        ? groupList[index].groupText
                        : groupList[index]
                            .filterList
                            .where((element) => element.isSeleted)
                            .map((e) => e.text)
                            .join(', '),
                    isSelected: groupList[index]
                        .filterList
                        .where((element) => element.isSeleted)
                        .isNotEmpty,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: 4,
                  );
                },
                itemCount: groupList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildList(BuildContext context, MeetUpState filterState) {
    return Expanded(
      child: PaginationListView(
        provider: meetUpProvider,
        scrollUp: () {
          setState(() {
            isTopVisible = true;
          });
        },
        scrollDown: () {
          setState(() {
            isTopVisible = false;
          });
        },
        padding: const EdgeInsets.only(
          top: 16,
          left: 20,
          right: 20,
          bottom: 8,
        ),
        itemBuilder: (context, index, model) {
          MeetUpModel meetUpModel = model as MeetUpModel;
          return MeetUpCardWidget(
            model: meetUpModel,
            onTapMeetUp: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeetUpScreen(
                    meetUpId: meetUpModel.id,
                  ),
                ),
              );
            },
          );
        },
        separatorWidget: const SizedBox(
          height: 12,
        ),
        emptyDataWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/img_empty_states.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              filterState.isFilterSelected ? '조건에 맞는 모임이 없어요' : '모임이 없어요',
              style: getTsBody16Sb(context).copyWith(
                color: kColorContentPlaceholder,
              ),
            ),
            const SizedBox(
              height: 180,
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildTop(BuildContext context, MeetUpState filterState) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 2,
        bottom: 2,
        left: 20,
        right: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '탐색',
            style: getTsHeading20(context).copyWith(
              color: kColorContentDefault,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: onTapFilter,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        'assets/icons/ic_filter_line_24.svg',
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          kColorContentDefault,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    if (filterState.isFilterSelected)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: kColorBgNotification,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  'assets/icons/ic_search_line_24.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    kColorContentDefault,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
