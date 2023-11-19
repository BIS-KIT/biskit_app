import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/const/enums.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/meet/model/meet_up_request_model.dart';
import 'package:biskit_app/meet/repository/meet_up_repository.dart';
import 'package:biskit_app/profile/components/profile_card_widget.dart';
import 'package:biskit_app/profile/components/profile_card_with_subtext_widget.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/meet/model/meet_up_detail_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MeetUpMemberManagementScreen extends ConsumerStatefulWidget {
  final MeetUpDetailModel meetUpDetailModel;
  const MeetUpMemberManagementScreen({
    Key? key,
    required this.meetUpDetailModel,
  }) : super(key: key);

  @override
  ConsumerState<MeetUpMemberManagementScreen> createState() =>
      _MeetUpMemberManagementScreenState();
}

class _MeetUpMemberManagementScreenState
    extends ConsumerState<MeetUpMemberManagementScreen> {
  List<MeetUpRequestModel> requests = [];
  List<UserModel> users = [];
  @override
  void initState() {
    super.initState();
    fetchRequest();
  }

  fetchRequest() async {
    users = widget.meetUpDetailModel.participants;
    requests = await ref
        .read(meetUpRepositoryProvider)
        .getMeetingRequests(widget.meetUpDetailModel.id);
    requests = requests
        .where((e) => e.status == VerificationStatus.PENDING.name)
        .toList();
    setState(() {});
  }

  void onTapReject(MeetUpRequestModel model) async {
    showConfirmModal(
      context: context,
      title: '${model.user.profile!.nick_name}님의 참여를 거절하시겠어요?',
      leftCall: () {
        Navigator.of(context).pop();
      },
      rightCall: () async {
        bool isOk =
            await ref.read(meetUpRepositoryProvider).postJoinReject(model.id);
        if (isOk) {
          setState(() {
            requests.remove(model);
          });
        }
        if (!mounted) return;
        Navigator.of(context).pop();
      },
      leftButton: '취소',
      leftTextColor: kColorContentWeak,
      rightButton: '거절',
      rightBackgroundColor: kColorBgError,
      rightTextColor: kColorContentError,
    );
  }

  void onTapApprove(MeetUpRequestModel model) async {
    showConfirmModal(
      context: context,
      title: '${model.user.profile!.nick_name}님의 참여를 수락하시겠어요?',
      leftCall: () {
        Navigator.of(context).pop();
      },
      rightCall: () async {
        bool isOk = await ref.read(meetUpRepositoryProvider).postJoinApprove(
              id: model.id,
              chatRoomUid: widget.meetUpDetailModel.chat_id,
              userId: model.user.id,
            );
        if (isOk) {
          setState(() {
            requests.remove(model);
            users.add(model.user);
          });
        }
        if (!mounted) return;
        Navigator.of(context).pop();
      },
      leftButton: '취소',
      leftTextColor: kColorContentWeak,
      rightButton: '수락',
      rightBackgroundColor: kColorBgPrimary,
      rightTextColor: kColorContentOnBgPrimary,
    );
  }

  void onTapProfile(UserModel userModel) {
    showMoreBottomSheet(
      context: context,
      list: [
        MoreButton(
          text: '내보내기',
          color: kColorContentError,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: kColorBgDefault,
      title: '모임원 관리',
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 16,
          left: 20,
          right: 20,
        ),
        child: Column(
          children: [
            // 참여 대기자
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '참여 대기자',
                  style: getTsHeading18(context).copyWith(
                    color: kColorContentDefault,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                if (requests.isEmpty) _buildEmptyCard(context),
                if (requests.isNotEmpty)
                  ...requests
                      .mapIndexed((index, model) => Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  left: 16,
                                  bottom: 16,
                                  right: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: kColorBgDefault,
                                  border: Border.all(
                                    width: 1,
                                    color: kColorBorderDefalut,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: ProfileCardWithSubtextWidget(
                                            userNationalityModel:
                                                model.user.user_nationality[0],
                                            name: model.user.profile!.nick_name,
                                            profilePath: model
                                                .user.profile!.profile_photo,
                                            isCreator: false,
                                            // TODO 모임 참가 신청 일자 해야함
                                            subText: '10.22(일) 오전 10:23 신청',
                                            introductions: const [],
                                            onTap: () {},
                                          ),
                                        ),
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
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              onTapReject(model);
                                            },
                                            child: const OutlinedButtonWidget(
                                              text: '거절',
                                              isEnable: true,
                                              height: 44,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              onTapApprove(model);
                                            },
                                            child: const FilledButtonWidget(
                                              text: '수락',
                                              isEnable: true,
                                              height: 44,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (index != requests.length - 1)
                                const SizedBox(
                                  height: 12,
                                ),
                            ],
                          ))
                      .toList()
              ],
            ),

            const SizedBox(
              height: 40,
            ),

            // 참여자
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '참여자',
                  style: getTsHeading18(context).copyWith(
                    color: kColorContentDefault,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                ...users.map(
                  (e) => ProfileCardWidget(
                    userNationalityModel: e.user_nationality[0],
                    name: e.profile!.nick_name,
                    profilePath: e.profile!.profile_photo,
                    isCreator: widget.meetUpDetailModel.creator.id == e.id,
                    onTap: () {
                      onTapProfile(e);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _buildEmptyCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 16,
        left: 16,
        bottom: 24,
        right: 16,
      ),
      decoration: const BoxDecoration(
        color: kColorBgElevation2,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/icons/ic_person_empty.svg',
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            '참여 대기자가 없어요',
            style: getTsBody16Sb(context).copyWith(
              color: kColorContentPlaceholder,
            ),
          ),
        ],
      ),
    );
  }
}
