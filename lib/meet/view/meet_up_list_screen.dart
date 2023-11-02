import 'package:biskit_app/common/components/chip_widget.dart';
import 'package:biskit_app/common/components/pagination_list_view.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/meet/components/meet_up_card_widget.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/meet/provider/meet_up_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MeetUpListScreen extends StatefulWidget {
  const MeetUpListScreen({super.key});

  @override
  State<MeetUpListScreen> createState() => _MeetUpListScreenState();
}

class _MeetUpListScreenState extends State<MeetUpListScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
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
          ),

          // 필터
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              // bottom: 8,
              left: 20,
            ),
            child: Row(
              children: [
                ChipWidget(
                  text: '등록순',
                  textColor: kColorContentDefault,
                  isSelected: false,
                  onTapDelete: () {},
                  rightIcon: 'assets/icons/ic_chevron_down_line_24.svg',
                  rightIconColor: kColorContentWeaker,
                ),
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
                        return const ChipWidget(
                          text: '다음주',
                          isSelected: true,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 4,
                        );
                      },
                      itemCount: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: PaginationListView(
              provider: meetUpProvider,
              padding: const EdgeInsets.only(
                top: 8,
                left: 20,
                right: 20,
                bottom: 8,
              ),
              itemBuilder: (context, index, model) {
                MeetUpModel meetUpModel = model as MeetUpModel;
                return MeetUpCardWidget(
                  model: meetUpModel,
                );
              },
              separatorWidget: const SizedBox(
                height: 12,
              ),
              emptyDataWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/ic_person_fill_24.svg',
                    width: 56,
                    height: 56,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    '모임이 없어요',
                    style: getTsBody16Rg(context).copyWith(
                      color: kColorContentWeakest,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
