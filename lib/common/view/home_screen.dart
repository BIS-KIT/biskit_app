import 'package:biskit_app/common/components/btn_tag_widget.dart';
import 'package:biskit_app/common/components/category_item_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/meet/components/meet_up_card_widget.dart';
import 'package:biskit_app/meet/model/meet_up_creator_model.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/meet/model/tag_model.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  MeetUpModel testModel = MeetUpModel(
    current_participants: 1,
    korean_count: 1,
    foreign_count: 0,
    name: '모임 밋업 비스킷 채팅 우아악',
    location: '서울시청',
    description: 'asdf',
    meeting_time: '2023-11-07T01:55:05.72773',
    max_participants: 2,
    image_url: null,
    is_active: true,
    id: 60,
    created_time: '2023-11-07T01:55:05.72773',
    creator: MeetUpCreatorModel(
      id: 65,
      name: 'TATAT',
      birth: '1999-11-11',
      user_nationality: [],
      gender: 'male',
    ),
    participants_status: '외국인 모집',
    tags: [
      TagModel(
        id: 1,
        kr_name: '영어 못해도 괜찮아요',
        en_name: '',
        is_custom: false,
      ),
    ],
  );
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userMeProvider);
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Navigation bar
          _buildNavigatorBar(),
          if (userState is UserModel)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Category
                    Container(
                      color: kColorBgDefault,
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '${userState.profile!.nick_name}님\n새로운 모임을 찾아볼까요?',
                            style: getTsHeading20(context).copyWith(
                              color: kColorContentOnBgPrimary,
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Wrap(
                            alignment: WrapAlignment.center,
                            runSpacing: 16,
                            children: [
                              ...kCategoryList
                                  .map(
                                    (e) => CategoryItemWidget(
                                      iconPath: e['imgUrl']!,
                                      text: e['value']!,
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      color: kColorBgElevation1,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          // Meetup
                          SizedBox(
                            height: 230,
                            child: Column(
                              children: [
                                // Title area
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '우리학교에서 개설된 모임',
                                          style:
                                              getTsHeading18(context).copyWith(
                                            color: kColorContentDefault,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: SvgPicture.asset(
                                          'assets/icons/ic_chevron_right_line_24.svg',
                                          width: 24,
                                          height: 24,
                                          colorFilter: const ColorFilter.mode(
                                            kColorContentWeakest,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 8,
                                ),

                                SizedBox(
                                  height: 182,
                                  child: ListView.separated(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) =>
                                        MeetUpCardWidget(
                                      model: testModel,
                                      sizeType: MeetUpCardSizeType.M,
                                      onTapMeetUp: () {},
                                    ),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      width: 12,
                                    ),
                                    itemCount: 4,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 36,
                          ),

                          // Tag
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    '태그로 찾기',
                                    style: getTsHeading18(context).copyWith(
                                      color: kColorContentDefault,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    BtnTagWidget(
                                      label: '비건',
                                      emoji: '🌱',
                                    ),
                                    BtnTagWidget(
                                      label: '크리스마스에 놀아요',
                                      emoji: '🎄',
                                    ),
                                    BtnTagWidget(
                                      label: '영어 못해도 괜찮아요',
                                      emoji: '🥺',
                                    ),
                                    BtnTagWidget(
                                      label: '점심식사',
                                      emoji: '🍚',
                                    ),
                                    BtnTagWidget(
                                      label: '함께 스터디해요',
                                      emoji: '👩🏽‍💻',
                                    ),
                                    BtnTagWidget(
                                      label: '뒷풀이',
                                      emoji: '🍺',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 36,
                          ),

                          // Make meetup card
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 32,
                              horizontal: 20,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '원하는 모임이 없다면 직접 만들어볼까요?',
                                  style: getTsBody14Sb(context).copyWith(
                                    color: kColorContentWeaker,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const OutlinedButtonWidget(
                                  text: '모임 만들기',
                                  isEnable: true,
                                  height: 44,
                                  leftIconPath:
                                      'assets/icons/ic_plus_line_24.svg',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildNavigatorBar() {
    return Container(
      color: kColorBgDefault,
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
            ),
            child: SvgPicture.asset(
              'assets/icons/biskit_signature_mono.svg',
              width: 57,
              height: 26,
              colorFilter: const ColorFilter.mode(
                kColorContentWeaker,
                BlendMode.srcIn,
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  'assets/icons/ic_notifications_line_24.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    kColorContentDefault,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Padding(
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
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
