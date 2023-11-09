import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:biskit_app/meet/components/meet_up_card_widget.dart';
import 'package:biskit_app/meet/model/meet_up_creator_model.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/meet/model/tag_model.dart';
import 'package:biskit_app/review/view/review_write_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyMeetUpListScreen extends StatefulWidget {
  const MyMeetUpListScreen({super.key});

  @override
  State<MyMeetUpListScreen> createState() => _MyMeetUpListScreenState();
}

class _MyMeetUpListScreenState extends State<MyMeetUpListScreen> {
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
  onTapMeetUpCard(MeetUpModel model) async {
    final List<PhotoModel> result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PhotoManagerScreen(
          isCamera: true,
          maxCnt: 1,
        ),
      ),
    );
    if (!mounted) return;
    if (result.isNotEmpty) {
      // 후기 작성 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReviewWriteScreen(
            photoModel: result[0],
            meetUpModel: model,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBgElevation2,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 2,
                    left: 10,
                    bottom: 2,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset(
                          'assets/icons/ic_arrow_back_ios_line_24.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            kColorContentDefault,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                    left: 20,
                    bottom: 8,
                    right: 20,
                  ),
                  child: Text(
                    '어떤 모임의\n인증샷을 남길까요?',
                    style: getTsHeading20(context).copyWith(
                      color: kColorContentDefault,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                itemBuilder: (context, index) => MeetUpCardWidget(
                  model: testModel,
                  onTapMeetUp: () {
                    onTapMeetUpCard(testModel);
                  },
                ),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 12,
                ),
                itemCount: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
