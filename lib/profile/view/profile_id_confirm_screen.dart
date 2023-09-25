import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:photo_manager/photo_manager.dart';

class ProfileIdConfirmScreen extends StatefulWidget {
  const ProfileIdConfirmScreen({super.key});

  @override
  State<ProfileIdConfirmScreen> createState() => _ProfileIdConfirmScreenState();
}

class _ProfileIdConfirmScreenState extends State<ProfileIdConfirmScreen> {
  final JustTheController tooltipController = JustTheController();

  PhotoModel? selectedPhotoModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultLayout(
      title: '',
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            padding: const EdgeInsets.only(
              right: 10,
            ),
            child: Text(
              '4 / 4',
              style: getTsBody14Rg(context).copyWith(
                color: kColorContentWeakest,
              ),
            ),
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 설명
            _buildTop(context),
            const SizedBox(
              height: 24,
            ),

            // Student ID area
            GestureDetector(
              onTap: () async {
                final List result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PhotoManagerScreen(
                          isCamera: true,
                          maxCnt: 1,
                        ),
                      ),
                    ) ??
                    [];
                logger.d(result);
                setState(() {
                  selectedPhotoModel = result[0];
                });
              },
              child: Container(
                width: size.width - 40,
                height: size.width - 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: kColorBgElevation3,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                clipBehavior: Clip.hardEdge,
                child: selectedPhotoModel == null
                    ? Column(
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              // height: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              color: kColorBgPrimary,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/ic_plus_line_24.svg',
                                    width: 40,
                                    height: 40,
                                    colorFilter: const ColorFilter.mode(
                                      kColorContentOnBgPrimary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Text(
                                    '학생증 올리기',
                                    style: getTsHeading18(context).copyWith(
                                      color: kColorContentOnBgPrimary,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    '(모바일)학생증 또는 학적증명자료',
                                    style: getTsBody14Rg(context).copyWith(
                                      color: kColorContentOnBgPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '실명, 학교, 학과, 학번',
                                  style: getTsBody14Sb(context).copyWith(
                                    color: kColorContentWeaker,
                                  ),
                                ),
                                Text(
                                  '이 정확히 나오도록 올려주세요',
                                  style: getTsBody14Rg(context).copyWith(
                                    color: kColorContentWeaker,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : AssetEntityImage(
                        selectedPhotoModel!.assetEntity,
                        fit: BoxFit.contain,
                      ),
              ),
            ),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 34,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '다음에 할게요',
                        style: getTsBody14Rg(context).copyWith(
                          color: kColorBorderStrong,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FilledButtonWidget(
                    text: '작성 완료',
                    isEnable: selectedPhotoModel != null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildTop(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 8,
        ),
        Text(
          '학생 인증을 하면\n모임에 참여할 수 있어요',
          style: getTsHeading24(context).copyWith(
            color: kColorContentDefault,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        JustTheTooltip(
          controller: tooltipController,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          backgroundColor: Colors.black.withOpacity(0.7),
          elevation: 0,
          tailBaseWidth: 20,
          tailLength: 6,
          preferredDirection: AxisDirection.down,
          content: SizedBox(
            width: 315,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              child: Text(
                '비스킷은 안전한 모임을 위해 학생 인증된 사용자 대상으로 모임참여를 허용하고 있어요. 학생인증 용도 외 다른 어떠한 용도로도 사용되지 않으며, 인증이 끝난 즉시 파기됩니다. 타인의 학생증을 도용시 서비스 이용이 제한되며 형사처벌의 대상이 될 수 있습니다.',
                style: getTsBody14Rg(context).copyWith(
                  color: kColorBgDefault,
                ),
              ),
            ),
          ),
          offset: 8,
          tailBuilder: (tip, point2, point3) {
            return Path()
              ..moveTo(tip.dx - (tip.dx * 0.5), tip.dy)
              ..lineTo(point2.dx - (point2.dx * 0.5), point2.dy)
              ..lineTo(point3.dx - (point3.dx * 0.5), point3.dy)
              ..close();
          },
          child: GestureDetector(
            onTap: () {
              tooltipController.showTooltip();
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/ic_help_fill_24.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    kColorContentWeaker,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  '학생인증이 왜 필요한가요?',
                  style: getTsBody14Rg(context).copyWith(
                    color: kColorContentWeaker,
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
