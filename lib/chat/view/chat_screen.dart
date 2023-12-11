// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:biskit_app/chat/model/chat_room_model.dart';
import 'package:biskit_app/common/components/avatar_with_flag_widget.dart';
import 'package:biskit_app/common/components/thumbnail_icon_widget.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:biskit_app/common/view/photo_view_screen.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/meet/repository/meet_up_repository.dart';
import 'package:biskit_app/meet/view/meet_up_detail_screen.dart';
import 'package:biskit_app/profile/model/profile_photo_model.dart';
import 'package:biskit_app/profile/repository/profile_repository.dart';
import 'package:biskit_app/profile/view/profile_view_screen.dart';
import 'package:biskit_app/setting/repository/setting_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:biskit_app/chat/model/chat_msg_model.dart';
import 'package:biskit_app/chat/repository/chat_repository.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';

import '../../common/utils/date_util.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatRoomUid;

  const ChatScreen({
    Key? key,
    required this.chatRoomUid,
  }) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with WidgetsBindingObserver {
  UserModelBase? userState;
  ChatRoomModel? chatRoomModel;
  MeetUpModel? meetUpModel;
  List<ChatMsgModel> list = [];
  int _limit = 20;
  final int _limitIncrement = 20;
  List<ProfilePhotoModel> profilePhotoList = [];
  late final TextEditingController textEditingController;
  late final ScrollController scrollController;
  final DateFormat msgDateFormat = DateFormat('a hh:mm', 'ko');
  final DateFormat dayFormat = DateFormat('yyyy년 MM월 dd일 EEE', 'ko');
  final DateFormat infoDateFormat1 = DateFormat('MM/dd (EEE)', 'ko');

  // 블럭 유저들
  List<int>? blockUserIds;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addObserver(this);
    textEditingController = TextEditingController();
    initFetchData();
  }

  initFetchData() async {
    await fetchChatRoom();
    await fetchMeetUp();
    await fetchBlockUsers();
    setState(() {});
  }

  fetchBlockUsers() async {
    UserModelBase? user = ref.read(userMeProvider);
    if (user != null && user is UserModel && chatRoomModel != null) {
      blockUserIds = await ref.read(settingRepositoryProvider).getCheckUserBans(
            user_id: user.id,
            target_ids: chatRoomModel!.joinUsers,
          );
      setState(() {});
    }
  }

  fetchMeetUp() async {
    meetUpModel = await ref
        .read(meetUpRepositoryProvider)
        .getMeeting(chatRoomModel!.meetupId!);
  }

  _scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent - 200 &&
        !scrollController.position.outOfRange &&
        _limit <= list.length) {
      // logger.d('_scrollListener');
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void addProfilePhoto(int createUserId) async {
    List<ProfilePhotoModel> list = await ref
        .read(profileRepositoryProvider)
        .getProfilePhotos([createUserId]);
    setState(() {
      profilePhotoList = [
        ...profilePhotoList,
        ...list,
      ];
    });
  }

  fetchChatRoomUserProfile() async {
    // profilePhotoList =
    List<ProfilePhotoModel> list = await ref
        .read(profileRepositoryProvider)
        .getProfilePhotos(chatRoomModel!.joinUsers);
    setState(() {
      profilePhotoList = list;
    });
  }

  fetchChatRoom() async {
    final result = await ref
        .read(chatRepositoryProvider)
        .getChatRoomById(widget.chatRoomUid);
    if (result != null) {
      setState(() {
        chatRoomModel =
            ChatRoomModel.fromMap(result.data() as Map<String, dynamic>);
      });
      await connectChatRoom();
      await fetchChatRoomUserProfile();
    }
  }

  void onTapMeetupCard() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MeetUpDetailScreen(
            meetUpModel: meetUpModel!,
          ),
        ));
  }

  // 이미지 보내기
  sendAttach(UserModel userState) async {
    final List<PhotoModel> result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PhotoManagerScreen(
          isCamera: true,
          maxCnt: 1,
        ),
      ),
    );
    if (result.isNotEmpty) {
      // logger.d(result);
      // 이미지 메시지 처리
      String? msgUid = await ref.read(chatRepositoryProvider).sendMsg(
            msg: '',
            chatMsgType: ChatMsgType.image,
            userId: userState.id,
            chatRoomUid: widget.chatRoomUid,
            chatRowType: ChatRowType.message,
          );
      if (msgUid != null) {
        // 이미지 업로드 처리
        String? imagePath =
            await ref.read(chatRepositoryProvider).postChatUpload(
                  chatRoomUid: widget.chatRoomUid,
                  msgUid: msgUid,
                  result: result,
                );
        if (imagePath != null) {
          // logger.d(imagePath);
          ref.read(chatRepositoryProvider).updateMsg(
            chatRoomUid: widget.chatRoomUid,
            msgUid: msgUid,
            data: {
              'msg': imagePath,
            },
          );
        }
      }
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // logger.d('AppLifecycleState : $state');

    switch (state) {
      case AppLifecycleState.resumed:
        connectChatRoom();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        disConnectChatRoom();
        break;
      case AppLifecycleState.detached:
        disConnectChatRoom();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  connectChatRoom() async {
    if (chatRoomModel != null &&
        !chatRoomModel!.connectingUsers.contains((userState as UserModel).id)) {
      await ref.read(chatRepositoryProvider).updateChatRoom(
        chatRoomUid: chatRoomModel!.uid,
        data: {
          'connectingUsers':
              FieldValue.arrayUnion([(userState as UserModel).id]),
        },
      );
    }
  }

  disConnectChatRoom() async {
    await ref.read(chatRepositoryProvider).updateChatRoom(
      chatRoomUid: chatRoomModel!.uid,
      data: {
        'connectingUsers':
            FieldValue.arrayRemove([(userState as UserModel).id]),
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    textEditingController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void viewBottomSheet() {
    if (chatRoomModel != null) {
      showBiskitBottomSheet(
        context: context,
        title: chatRoomModel!.title,
        customTitleWidget: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: 16,
          ),
          child: Row(
            children: [
              Text(
                '참여자',
                style: getTsBody16Sb(context).copyWith(
                  color: kColorContentDefault,
                ),
              ),
            ],
          ),
        ),
        isScrollControlled: true,
        enableDrag: true,
        contentWidget: SizedBox(
          height: MediaQuery.of(context).size.height - 260,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 40,
                        ),
                        child: Column(
                          children: profilePhotoList
                              .map(
                                (e) => GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileViewScreen(
                                          userId: e.user_id,
                                        ),
                                      ),
                                    );
                                    await fetchBlockUsers();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        AvatarWithFlagWidget(
                                          profilePath: e.profile_photo,
                                          radius: 20,
                                          flagRadius: 16,
                                          flagPath: e.nationalities.isEmpty
                                              ? null
                                              : '$kS3Url$kS3Flag43Path/${e.nationalities[0].code}.svg',
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Text(
                                          e.nick_name,
                                          style:
                                              getTsBody16Rg(context).copyWith(
                                            color: kColorContentWeak,
                                          ),
                                        ),
                                        if (chatRoomModel!.createUserId ==
                                            e.user_id)
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              SvgPicture.asset(
                                                'assets/icons/ic_crown_circle_fill_24.svg',
                                                width: 24,
                                                height: 24,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  kColorContentPrimary,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 8,
                  bottom: 34,
                  right: 16,
                ),
                color: kColorBgElevation1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (meetUpModel == null) return;
                        DateTime meetDate =
                            DateTime.parse(meetUpModel!.meeting_time);
                        DateTime now = DateTime.now();

                        if (now.isAfter(meetDate)) {
                          // 모임 시간이 지난 경우
                          showConfirmModal(
                            context: context,
                            title: '채팅방에서 나가시겠어요?',
                            content: '대화 내용이 모두 사라져요',
                            leftButton: '취소',
                            leftCall: () {
                              Navigator.pop(context);
                            },
                            rightButton: '나가기',
                            rightTextColor: kColorContentError,
                            rightBackgroundColor: kColorBgError,
                            rightCall: () async {
                              Navigator.pop(context);
                              await ref.read(chatRepositoryProvider).chatExist(
                                    chatRoomUid: widget.chatRoomUid,
                                    userId: (userState as UserModel).id,
                                  );
                              if (!mounted) return;
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          );
                        } else {
                          // 모임이 안 끝난 경우
                          showDefaultModal(
                            context: context,
                            title: '모임 종료 전에는 나갈 수 없어요',
                            content:
                                '모임 상세 > 더보기 > 모임 나가기로 나간 후에 채팅방에서 나갈 수 있어요',
                            function: () {
                              Navigator.pop(context);
                            },
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset(
                          'assets/icons/ic_logout_off_line_24.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            kColorContentWeaker,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const Row(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.all(10),
                        //   child: SvgPicture.asset(
                        //     'assets/icons/ic_notifications_line_24.svg',
                        //     width: 24,
                        //     height: 24,
                        //     colorFilter: const ColorFilter.mode(
                        //       kColorContentWeaker,
                        //       BlendMode.srcIn,
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(10),
                        //   child: SvgPicture.asset(
                        //     'assets/icons/ic_siren_line_24.svg',
                        //     width: 24,
                        //     height: 24,
                        //     colorFilter: const ColorFilter.mode(
                        //       kColorContentWeaker,
                        //       BlendMode.srcIn,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    userState = ref.watch(userMeProvider);
    return WillPopScope(
      onWillPop: () async {
        disConnectChatRoom();
        return true;
      },
      child: DefaultLayout(
        title: chatRoomModel == null ? '' : chatRoomModel!.title,
        onTapLeading: () {
          disConnectChatRoom();
          Navigator.pop(context);
        },
        shape: const Border(
          bottom: BorderSide(
            color: kColorBorderDefalut,
            width: 1,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              viewBottomSheet();
            },
            child: Container(
              width: 44,
              height: 44,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(right: 10),
              child: SvgPicture.asset(
                'assets/icons/ic_more_horiz_line_24.svg',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
        child: userState != null &&
                userState is UserModel &&
                chatRoomModel != null
            ? Stack(
                children: [
                  Container(
                    color: kColorBgElevation2,
                    child: Column(
                      children: [
                        if (blockUserIds != null)
                          Expanded(
                            child: StreamBuilder(
                              stream: ref
                                  .read(chatRepositoryProvider)
                                  .getChatMsgStream(
                                    chatRoomUid: widget.chatRoomUid,
                                    fromTimestamp: chatRoomModel!
                                        .firstUserInfoList
                                        .singleWhere((element) =>
                                            element.userId ==
                                            (userState as UserModel).id)
                                        .firstJoinDate,
                                    limit: _limit,
                                    blockUserIds: blockUserIds!,
                                  ),
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data != null &&
                                    snapshot.data!.isNotEmpty) {
                                  list = snapshot.data!;
                                  return ListView.builder(
                                    controller: scrollController,
                                    keyboardDismissBehavior:
                                        ScrollViewKeyboardDismissBehavior
                                            .onDrag,
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 60,
                                    ),
                                    reverse: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      ChatMsgModel chatMsgModel = list[index];
                                      Widget widgetMsg = const Row();

                                      double topPaddingSize = 16;
                                      bool isProfileView = true;
                                      bool isMsgTimeView = true;
                                      bool isDayNoticeView = false;

                                      if (index + 1 < list.length) {
                                        // 이 후 메시지 값을 가져온다

                                        // 1일 차이가 나는지 확인
                                        if (getDayDifference(
                                              list[index + 1]
                                                  .createDate
                                                  .toDate(),
                                              list[index].createDate.toDate(),
                                            ).abs() >
                                            0) {
                                          isDayNoticeView = true;
                                        } else {
                                          isDayNoticeView = false;
                                        }

                                        if (list[index + 1].chatRowType ==
                                                ChatRowType.message.name &&
                                            list[index + 1].createUserId ==
                                                list[index].createUserId) {
                                          // 이전 메시지가 내가 쓴 메시지라면

                                          if (getTimestampDifferenceMin(
                                                      list[index + 1]
                                                          .createDate,
                                                      list[index].createDate)
                                                  .abs() <
                                              1) {
                                            topPaddingSize = isDayNoticeView
                                                ? 16
                                                : 8; // 간격 줄이기
                                            isProfileView = false; // 프로파일 가리기
                                          }
                                        }
                                      }
                                      if (index - 1 >= 0) {
                                        // 이 전 메시지 값을 가져온다
                                        if (list[index - 1].chatRowType ==
                                                ChatRowType.message.name &&
                                            list[index - 1].createUserId ==
                                                list[index].createUserId) {
                                          // 이전 메시지가 내가 쓴 메시지라면

                                          if (getTimestampDifferenceMin(
                                                      list[index - 1]
                                                          .createDate,
                                                      list[index].createDate)
                                                  .abs() <
                                              1) {
                                            isMsgTimeView = false; // 채팅 시간 가리기
                                          }
                                        }
                                      }

                                      if (chatMsgModel.chatRowType ==
                                          ChatRowType.message.name) {
                                        if (chatMsgModel.createUserId ==
                                            (userState as UserModel).id) {
                                          // 나의 메시지
                                          widgetMsg = _buildMyMsg(
                                            context,
                                            list[index],
                                            topPaddingSize,
                                            isMsgTimeView,
                                          );
                                        } else {
                                          // 상대방 메시지
                                          widgetMsg = _buildOtherMsg(
                                            context,
                                            list[index],
                                            topPaddingSize,
                                            isMsgTimeView,
                                            isProfileView,
                                          );
                                        }
                                      } else {
                                        widgetMsg = _buildNotice(list[index],
                                            (userState as UserModel).id);
                                      }

                                      // 제일 처음에 상단 여백을 제공

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          if (isDayNoticeView)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 16,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  _buildNoticeBubble(
                                                    '${dayFormat.format(getDateTimeByTimestamp(list[index].createDate))}요일',
                                                    null,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          widgetMsg,
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ),
                        _buildInput(context, (userState as UserModel)),
                      ],
                    ),
                  ),
                  if (meetUpModel != null)
                    // 모임카드
                    GestureDetector(
                      onTap: () {
                        onTapMeetupCard();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 8,
                          left: 20,
                          right: 20,
                        ),
                        padding: const EdgeInsets.only(
                          top: 12,
                          left: 16,
                          bottom: 12,
                          right: 12,
                        ),
                        decoration: BoxDecoration(
                          color: kColorBgDefault,
                          border: Border.all(
                            width: 1,
                            color: kColorBorderDefalut,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ic_calendar_check_fill_24.svg',
                              width: 20,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                kColorContentWeaker,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    infoDateFormat1.format(
                                      DateTime.parse(meetUpModel!.created_time),
                                    ),
                                    style: getTsBody14Rg(context).copyWith(
                                      color: kColorContentWeak,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    '·',
                                    style: getTsBody14Rg(context).copyWith(
                                      color: kColorContentWeakest,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    msgDateFormat.format(
                                      DateTime.parse(meetUpModel!.created_time),
                                    ),
                                    style: getTsBody14Rg(context).copyWith(
                                      color: kColorContentWeak,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    '·',
                                    style: getTsBody14Rg(context).copyWith(
                                      color: kColorContentWeakest,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Text(
                                      meetUpModel!.location,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: getTsBody14Rg(context).copyWith(
                                        color: kColorContentWeak,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 8,
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
                      ),
                    ),
                ],
              )
            : Container(),
      ),
    );
  }

  Widget _buildOtherMsg(
    BuildContext context,
    ChatMsgModel chatMsgModel,
    double topPaddingSize,
    bool isMsgTimeView,
    bool isProfileView,
  ) {
    ProfilePhotoModel? profilePhotoModel;
    if (profilePhotoList.isNotEmpty &&
        profilePhotoList
            .map((e) => e.user_id)
            .contains(chatMsgModel.createUserId)) {
      profilePhotoModel = profilePhotoList.firstWhere(
        (element) => element.user_id == chatMsgModel.createUserId,
      );
    }
    return Padding(
      padding: EdgeInsets.only(
        top: topPaddingSize,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(
            builder: (context) {
              // logger.d('BUILD!!!!');
              if (isProfileView && profilePhotoModel != null) {
                return AvatarWithFlagWidget(
                  profilePath: profilePhotoModel.profile_photo,
                  flagPath: profilePhotoModel.nationalities.isEmpty
                      ? null
                      : '$kS3Url$kS3Flag43Path/${profilePhotoModel.nationalities[0].code}.svg',
                );
              } else {
                return const SizedBox(
                  width: 32,
                );
              }
            },
          ),
          const SizedBox(
            width: 8,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isProfileView && profilePhotoModel != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      profilePhotoModel.nick_name,
                      style: getTsBody14Rg(context).copyWith(
                        color: kColorContentWeaker,
                      ),
                    ),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildMsgBubble(chatMsgModel, false),
                    const SizedBox(
                      width: 4,
                    ),
                    if (isMsgTimeView)
                      Text(
                        msgDateFormat.format(
                          chatMsgModel.createDate.toDate(),
                        ),
                        style: getTsCaption10Rg(context).copyWith(
                          color: kColorContentWeakest,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyMsg(
    BuildContext context,
    ChatMsgModel chatMsgModel,
    double topPaddingSize,
    bool isMsgTimeView,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        top: topPaddingSize,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(
            width: 20,
          ),
          if (isMsgTimeView)
            Text(
              msgDateFormat.format(
                chatMsgModel.createDate.toDate(),
              ),
              style: getTsCaption10Rg(context).copyWith(
                color: kColorContentWeakest,
              ),
            ),
          const SizedBox(
            width: 4,
          ),
          _buildMsgBubble(chatMsgModel, true),
        ],
      ),
    );
  }

  Flexible _buildMsgBubble(
    ChatMsgModel chatMsgModel,
    bool isMe,
  ) {
    return Flexible(
      child: chatMsgModel.msgType == ChatMsgType.text.name
          ? Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: isMe ? kColorBgPrimary : kColorBgDefault,
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Text(
                chatMsgModel.msg,
                style: getTsBody16Rg(context).copyWith(
                  overflow: TextOverflow.clip,
                  color: kColorContentWeak,
                ),
              ),
            )
          : GestureDetector(
              onTap: () {
                // 이미지 프리뷰
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhotoViewScreen(
                      imageUrl: chatMsgModel.msg,
                      title: profilePhotoList
                          .firstWhere((element) =>
                              element.user_id == chatMsgModel.createUserId)
                          .nick_name,
                    ),
                  ),
                );
              },
              child: Container(
                width: 180,
                height: 144,
                decoration: BoxDecoration(
                  color: isMe ? kColorBgPrimary : kColorBgDefault,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                  image: chatMsgModel.msg.isEmpty
                      ? null
                      : DecorationImage(
                          image: NetworkImage(
                            chatMsgModel.msg,
                          ),
                          fit: BoxFit.cover,
                        ),
                ),
                // child: chatMsgModel.msg.isEmpty ? const CustomLoading() : null,
              ),
            ),
    );
  }

  Widget _buildNotice(ChatMsgModel notice, int userId) {
    if (notice.chatRowType == ChatRowType.noticeOnlyMe.name &&
        notice.createUserId != userId) {
      // 오직 나에게만 보이는 메시지
      // 상대방의 경우 빈값을 리턴
      return Container();
    }

    if (notice.chatRowType == ChatRowType.noticeJoin.name) {
      // 최초 참여시에 프로필 정보 업데이트
      if (!profilePhotoList
              .any((element) => element.user_id == notice.createUserId) &&
          profilePhotoList.isNotEmpty) {
        // 기존에 프로필 정보가 없으면 처리
        addProfilePhoto(notice.createUserId);
      }
    }
    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNoticeBubble(notice.msg, notice.chatRowType),
        ],
      ),
    );
  }

  Flexible _buildNoticeBubble(
    String text,
    String? chatRowType,
  ) {
    // logger.d(chatRowType);
    return Flexible(
      child: chatRowType == null || chatRowType == ChatRowType.noticeJoin.name
          ? Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
              decoration: const BoxDecoration(
                color: kColorBgElevation3,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    50,
                  ),
                ),
              ),
              child: Text(
                text,
                style: getTsCaption12Rg(context).copyWith(
                  color: kColorContentWeaker,
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: kColorBgDefault,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ThumbnailIconWidget(
                    size: 32,
                    isSelected: false,
                    backgroundColor: kColorBgSecondaryWeak,
                    iconColor: kColorBgSecondary,
                    iconSize: 24,
                    radius: 8,
                    padding: 4,
                    iconPath: 'assets/icons/ic_megaphone_fill_24.svg',
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Text(
                      text,
                      style: getTsBody14Rg(context).copyWith(
                        color: kColorContentWeaker,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Container _buildInput(BuildContext context, UserModel userState) {
    return Container(
      padding: EdgeInsets.only(
        top: 8,
        left: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom > 100 ? 8 : 34,
        right: 16,
      ),
      child: Row(
        crossAxisAlignment: textEditingController.text.contains('\n')
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              sendAttach(userState);
            },
            child: Container(
              width: 44,
              height: 44,
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                'assets/icons/ic_image_line_24.svg',
                width: 24,
                height: 24,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                left: 16,
                right: 4,
                top: 4,
                bottom: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: kColorBorderDefalut,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(22)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      minLines: 1,
                      maxLines: 4,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      style: getTsBody16Rg(context).copyWith(
                        color: kColorContentWeak,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: '메세지 입력...',
                        hintStyle: getTsBody16Rg(context).copyWith(
                          color: kColorContentPlaceholder,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 7),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      String msg = textEditingController.text.trim();
                      if (msg.isNotEmpty) {
                        ref.read(chatRepositoryProvider).sendMsg(
                              msg: msg,
                              chatMsgType: ChatMsgType.text,
                              userId: userState.id,
                              chatRoomUid: widget.chatRoomUid,
                              chatRowType: ChatRowType.message,
                            );
                        textEditingController.text = '';
                        scrollController.jumpTo(0);
                        ref.read(chatRepositoryProvider).postChatAlarm(
                              content: msg,
                              chat_id: widget.chatRoomUid,
                              user_id: userState.id,
                            );
                      }
                    },
                    child: textEditingController.text.isEmpty
                        ? Container()
                        : Container(
                            width: 36,
                            height: 36,
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: kColorBgPrimary,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/ic_arrow_upward_line_24.svg',
                              width: 24,
                              height: 24,
                            ),
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
