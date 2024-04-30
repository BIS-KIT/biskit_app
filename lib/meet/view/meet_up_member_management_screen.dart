import 'package:biskit_app/chat/repository/chat_repository.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/enums.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/meet/model/meet_up_detail_model.dart';
import 'package:biskit_app/meet/model/meet_up_request_model.dart';
import 'package:biskit_app/meet/repository/meet_up_repository.dart';
import 'package:biskit_app/profile/components/profile_list_widget.dart';
import 'package:biskit_app/profile/components/profile_list_with_subtext_widget.dart';
import 'package:biskit_app/profile/view/profile_view_screen.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/loader_overlay.dart';

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
  final DateFormat dateFormatUS = DateFormat('MM/dd(EEE) a hh:mm', 'en_US');
  final DateFormat dateFormatKO = DateFormat('MM/dd(EEE) a hh:mm', 'ko_KR');

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
        .where((e) => e.status == MyMeetingStatus.PENDING.name)
        .toList();
    setState(() {});
  }

  void onTapReject(MeetUpRequestModel model, String chatId) async {
    showConfirmModal(
      context: context,
      title:
          '${model.user.profile!.nick_name} ${'adminMemberScreen.modal.declineModal.title'.tr()}',
      leftCall: () {
        Navigator.of(context).pop();
      },
      rightCall: () async {
        context.loaderOverlay.show();

        bool isOk =
            await ref.read(meetUpRepositoryProvider).postJoinReject(model.id);
        if (isOk) {
          // 모임 퇴장 > 채팅방 나가기
          await ref.read(chatRepositoryProvider).chatExist(
                chatRoomUid: chatId,
                userId: model.user.id,
              );
          setState(() {
            requests.remove(model);
          });
        }
        if (!mounted) return;
        context.loaderOverlay.hide();
        Navigator.of(context).pop();
      },
      leftButton: 'modal.cancel'.tr(),
      leftTextColor: kColorContentWeak,
      rightButton: 'modal.reject'.tr(),
      rightBackgroundColor: kColorBgError,
      rightTextColor: kColorContentError,
    );
  }

  void onTapApprove(MeetUpRequestModel model, String chatId) async {
    showConfirmModal(
      context: context,
      title:
          '${model.user.profile!.nick_name}${'adminMemberScreen.modal.acceptModal.title'.tr()}',
      leftCall: () {
        Navigator.of(context).pop();
      },
      rightCall: () async {
        context.loaderOverlay.show();

        bool isOk = await ref.read(meetUpRepositoryProvider).postJoinApprove(
              id: model.id,
              chatRoomUid: widget.meetUpDetailModel.chat_id,
              userId: model.user.id,
            );
        if (isOk) {
          // 모임 수락 > 채팅방 입장
          await ref.read(chatRepositoryProvider).goChatRoom(
                chatRoomUid: chatId,
                user: model.user,
              );
          setState(() {
            requests.remove(model);
            users.add(model.user);
          });
        }
        if (!mounted) return;
        context.loaderOverlay.hide();
        Navigator.of(context).pop();
      },
      leftButton: 'adminMemberScreen.modal.acceptModal.cancel'.tr(),
      leftTextColor: kColorContentWeak,
      rightButton: 'adminMemberScreen.modal.acceptModal.accept'.tr(),
      rightBackgroundColor: kColorBgPrimary,
      rightTextColor: kColorContentOnBgPrimary,
    );
  }

  void onTapProfile(UserModel userModel) {
    showMoreBottomSheet(
      context: context,
      list: [
        MoreButton(
          text: 'adminMemberScreen.actionSheet.remove'.tr(),
          color: kColorContentError,
          onTap: () async {
            showConfirmModal(
              context: context,
              title:
                  '${userModel.profile!.nick_name}${'adminMemberScreen.modal.removeModal.title'.tr()}',
              leftCall: () {
                Navigator.of(context).pop();
              },
              rightCall: () async {
                context.loaderOverlay.show();

                bool isOk =
                    await ref.read(meetUpRepositoryProvider).postExitMeeting(
                          user_id: userModel.id,
                          meeting_id: widget.meetUpDetailModel.id,
                        );
                if (isOk) {
                  await ref.read(chatRepositoryProvider).chatExist(
                        chatRoomUid: widget.meetUpDetailModel.chat_id,
                        userId: userModel.id,
                      );

                  users = users
                      .where((element) => element.id != userModel.id)
                      .toList();
                  setState(() {});
                  if (!mounted) return;
                }
                if (!mounted) return;
                context.loaderOverlay.hide();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              leftButton: 'adminMemberScreen.modal.removeModal.cancel'.tr(),
              leftTextColor: kColorContentWeak,
              rightButton: 'adminMemberScreen.modal.removeModal.remove'.tr(),
              rightBackgroundColor: kColorBgPrimary,
              rightTextColor: kColorContentOnBgPrimary,
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: kColorBgDefault,
      title: 'adminMemberScreen.title'.tr(),
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
                  'adminMemberScreen.request.title'.tr(),
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
                                          child: ProfileListWithSubtextWidget(
                                            userNationalityModel:
                                                model.user.user_nationality[0],
                                            name: model.user.profile!.nick_name,
                                            profilePath: model
                                                .user.profile!.profile_photo,
                                            isCreator: false,
                                            subText: context
                                                        .locale.languageCode ==
                                                    'en'
                                                ? '${dateFormatUS.format(DateTime.parse(model.created_time))} Request'
                                                : '${dateFormatKO.format(DateTime.parse(model.created_time))} 신청',
                                            introductions: const [],
                                            onTap: () {
                                              if (model.user.profile == null) {
                                                return;
                                              }
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfileViewScreen(
                                                    userId: model.user.id,
                                                  ),
                                                ),
                                              );
                                            },
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
                                              onTapReject(
                                                  model,
                                                  widget.meetUpDetailModel
                                                      .chat_id);
                                            },
                                            child: OutlinedButtonWidget(
                                              text:
                                                  'adminMemberScreen.request.decline'
                                                      .tr(),
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
                                              onTapApprove(
                                                  model,
                                                  widget.meetUpDetailModel
                                                      .chat_id);
                                            },
                                            child: FilledButtonWidget(
                                              text:
                                                  'adminMemberScreen.request.accept'
                                                      .tr(),
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
                  'adminMemberScreen.request.members'.tr(),
                  style: getTsHeading18(context).copyWith(
                    color: kColorContentDefault,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                ...users.mapIndexed(
                  (index, e) => Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ProfileListWidget(
                              userNationalityModel: e.user_nationality[0],
                              name: e.profile!.nick_name,
                              profilePath: e.profile!.profile_photo,
                              isCreator:
                                  widget.meetUpDetailModel.creator.id == e.id,
                              onTap: () {
                                if (e.profile == null) {
                                  return;
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileViewScreen(
                                      userId: e.id,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          if (widget.meetUpDetailModel.creator.id != e.id)
                            GestureDetector(
                              onTap: () {
                                onTapProfile(e);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: SvgPicture.asset(
                                  'assets/icons/ic_more_vertical_line_24.svg',
                                  width: 24,
                                  height: 24,
                                  colorFilter: const ColorFilter.mode(
                                    kColorContentWeakest,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (index != users.length - 1)
                        const SizedBox(
                          height: 4,
                        ),
                    ],
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
