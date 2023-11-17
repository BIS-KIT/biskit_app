import 'package:biskit_app/common/components/badge_emoji_widget.dart';
import 'package:biskit_app/common/components/badge_widget.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/meet/model/meet_up_detail_model.dart';
import 'package:biskit_app/meet/repository/meet_up_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extended_wrap/extended_wrap.dart';
import 'package:flutter/material.dart';

import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MeetUpDetailScreen extends ConsumerStatefulWidget {
  final MeetUpModel meetUpModel;
  const MeetUpDetailScreen({
    Key? key,
    required this.meetUpModel,
  }) : super(key: key);

  @override
  ConsumerState<MeetUpDetailScreen> createState() => _MeetUpDetailScreenState();
}

class _MeetUpDetailScreenState extends ConsumerState<MeetUpDetailScreen> {
  final GlobalKey _mainBoxKey = GlobalKey();
  final DateFormat dateFormat1 = DateFormat('MM/dd(EEE)', 'ko');
  final DateFormat dateFormat2 = DateFormat('a h:mm', 'ko');

  MeetUpDetailModel? meetUpDetailModel;
  final ScrollController scrollController = ScrollController();
  bool isTitleView = false;

  double opacity = 0;

  @override
  void initState() {
    init();
    scrollController.addListener(() {
      // logger.d(scrollController.offset);
      Size? mainBoxSize = getWidgetSize(_mainBoxKey);
      if (mainBoxSize != null && scrollController.offset < mainBoxSize.height) {
        double tempOpacity =
            scrollController.offset / (mainBoxSize.height - 100);
        if (tempOpacity >= 0.9) {
          opacity = 1;
        } else if (tempOpacity < 0.1) {
          opacity = 0;
        } else {
          opacity = tempOpacity;
        }
        setState(() {});
      }
      // if (scrollController.offset > 140 && !isTitleView) {
      //   setState(() {
      //     isTitleView = true;
      //   });
      // }

      // if (scrollController.offset < 140 && isTitleView) {
      //   setState(() {
      //     isTitleView = false;
      //   });
      // }
    });
    super.initState();
  }

  init() async {
    meetUpDetailModel = await ref
        .read(meetUpRepositoryProvider)
        .getMeetUpDetail(widget.meetUpModel.id);
    setState(() {});
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final paddig = MediaQuery.of(context).padding;
    return Scaffold(
      backgroundColor: kColorBgDefault,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Opacity(
                            opacity: 1,
                            child: Container(
                              key: _mainBoxKey,
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                top: 24,
                                left: 20,
                                right: 20,
                                bottom: 32,
                              ),
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'assets/images/bg_food.png',
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 48,
                                  ),
                                  if (meetUpDetailModel != null)
                                    ExtendedWrap(
                                      spacing: 4,
                                      maxLines: 1,
                                      children: [
                                        ...meetUpDetailModel!.topics.map(
                                          (topic) => BadgeWidget(
                                            text: topic.kr_name,
                                            backgroundColor:
                                                kColorBgInverseWeak,
                                            textColor: kColorContentInverse,
                                          ),
                                        ),
                                      ],
                                    ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    widget.meetUpModel.name,
                                    style: getTsHeading20(context)
                                        .copyWith(color: kColorContentDefault),
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),

                                  // infoBox
                                  _buildInfoBox(context),

                                  const SizedBox(
                                    height: 12,
                                  ),

                                  // location
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      decoration: ShapeDecoration(
                                        color: kColorBgDefault,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        shadows: const [
                                          BoxShadow(
                                            color: Color(0x11495B7D),
                                            blurRadius: 20,
                                            offset: Offset(0, 4),
                                            spreadRadius: 0,
                                          ),
                                          BoxShadow(
                                            color: Color(0x07495B7D),
                                            blurRadius: 1,
                                            offset: Offset(0, 0),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16,
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/ic_pin_fill_24.svg',
                                            width: 20,
                                            height: 20,
                                            colorFilter: const ColorFilter.mode(
                                              kColorContentWeaker,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              widget.meetUpModel.location,
                                              maxLines: 1,
                                              style: getTsBody14Rg(context)
                                                  .copyWith(
                                                color: kColorContentWeak,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          SvgPicture.asset(
                                            'assets/icons/ic_chevron_right_line_24.svg',
                                            width: 24,
                                            height: 24,
                                            colorFilter: const ColorFilter.mode(
                                              kColorContentWeakest,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 24,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: kColorBgDefault,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 20,
                          bottom: 20,
                          right: 20,
                        ),
                        color: kColorBgDefault,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "모임 소개",
                              style: getTsHeading18(context)
                                  .copyWith(color: kColorContentDefault),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            if (meetUpDetailModel != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  meetUpDetailModel!.description,
                                  style: getTsBody16Rg(context)
                                      .copyWith(color: kColorContentWeaker),
                                ),
                              ),
                            Wrap(
                              spacing: 6,
                              runSpacing: 8,
                              children: [
                                ...widget.meetUpModel.tags.map(
                                  (tag) => BadgeEmojiWidget(
                                    label: tag.kr_name,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 20,
                  bottom: 20,
                  right: 20,
                ),
                child: const FilledButtonWidget(
                  text: '참여신청',
                  isEnable: true,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(
              top: 2 + paddig.top,
              bottom: 2,
              left: 10,
              right: 10,
            ),
            decoration: BoxDecoration(
              color: kColorBgDefault.withOpacity(opacity),
              border: opacity < 0.2
                  ? null
                  : Border(
                      bottom: BorderSide(
                        width: opacity,
                        color: kColorBorderDefalut,
                      ),
                    ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    constraints: const BoxConstraints(),
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
                ),
                const SizedBox(
                  width: 44,
                ),
                Expanded(
                  child: Opacity(
                    // duration: const Duration(seconds: 1),
                    opacity: opacity,
                    child: Text(
                      'asdf asdfasfasdfasdfasf s fasfasf asf sdf sdf sd fsdfsd',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: getTsBody16Sb(context).copyWith(
                        color: kColorContentDefault,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 44,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      'assets/icons/ic_more_horiz_line_24.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        kColorContentDefault,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildInfoBox(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 24,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        child: SvgPicture.asset(
                          'assets/icons/ic_calendar.svg',
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            kColorContentWeaker,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                dateFormat1.format(
                                  DateTime.parse(
                                      widget.meetUpModel.meeting_time),
                                ),
                                textAlign: TextAlign.center,
                                style: getTsBody14Rg(context).copyWith(
                                  color: kColorContentWeak,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '·',
                                textAlign: TextAlign.center,
                                style: getTsBody14Rg(context).copyWith(
                                  color: kColorContentWeak,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                dateFormat2.format(
                                  DateTime.parse(
                                      widget.meetUpModel.meeting_time),
                                ),
                                textAlign: TextAlign.center,
                                style: getTsBody14Rg(context).copyWith(
                                  color: kColorContentWeak,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        child: SvgPicture.asset(
                          'assets/icons/ic_person_fill_24.svg',
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            kColorContentWeaker,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${widget.meetUpModel.current_participants}/${widget.meetUpModel.max_participants}명',
                                textAlign: TextAlign.center,
                                style: getTsBody14Rg(context).copyWith(
                                  color: kColorContentWeak,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (widget.meetUpModel.participants_status != '')
                                BadgeWidget(
                                  text: widget.meetUpModel.participants_status,
                                  textColor: kColorContentSecondary,
                                  backgroundColor: kColorBgSecondaryWeak,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        child: SvgPicture.asset(
                          'assets/icons/ic_lang.svg',
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            kColorContentWeaker,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (meetUpDetailModel != null)
                        Expanded(
                          child: ExtendedWrap(
                            spacing: 8,
                            runSpacing: 6,
                            maxLines: 2,
                            children: [
                              ...meetUpDetailModel!.languages.map(
                                (lang) => Text(
                                  lang.kr_name,
                                  style: getTsBody14Rg(context).copyWith(
                                    color: kColorContentWeak,
                                  ),
                                ),
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
        ],
      ),
    );
  }
}
