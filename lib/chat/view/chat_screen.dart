// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:biskit_app/chat/model/chat_room_model.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/date_util.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:biskit_app/profile/model/profile_photo_model.dart';
import 'package:biskit_app/profile/repository/profile_repository.dart';
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

class ChatScreen extends ConsumerStatefulWidget {
  final String chatRoomUid;

  const ChatScreen({
    Key? key,
    required this.chatRoomUid,
  }) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  ChatRoomModel? chatRoomModel;
  List<ProfilePhotoModel> profilePhotoList = [];
  late final TextEditingController textEditingController;
  late final ScrollController scrollController;
  final DateFormat msgDateFormat = DateFormat('a hh:mm', 'ko');
  final DateFormat dayFormat = DateFormat('yyyy년 MM월 dd일 EEE', 'ko');

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    scrollController = ScrollController();
    fetchChatRoom();
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
      await fetchChatRoomUserProfile();
    }
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
      logger.d(result);
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
          logger.d(imagePath);
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
  void dispose() {
    textEditingController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  makeChatWidgetList(List<ChatMsgModel> list) {}

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userMeProvider);
    return DefaultLayout(
      title: chatRoomModel == null ? '' : chatRoomModel!.title,
      shape: const Border(
        bottom: BorderSide(
          color: kColorBorderDefalut,
          width: 1,
        ),
      ),
      actions: [
        Container(
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
      ],
      child: userState is UserModel && chatRoomModel != null
          ? Container(
              color: kColorBgElevation1,
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: ref.read(chatRepositoryProvider).getChatMsgStream(
                            chatRoomUid: widget.chatRoomUid,
                            fromTimestamp: chatRoomModel!.firstUserInfoList
                                .singleWhere(
                                    (element) => element.userId == userState.id)
                                .firstJoinDate,
                            limit: 60,
                          ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data != null &&
                            snapshot.data!.isNotEmpty) {
                          List<ChatMsgModel> list = snapshot.data!;
                          return ListView.builder(
                            controller: scrollController,
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            reverse: true,
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              ChatMsgModel chatMsgModel = list[index];
                              Widget widgetMsg = const Row();
                              // DateTime createDateTime = getDateTimeByTimestamp(
                              //   list[index].createDate,
                              // );
                              if (chatMsgModel.chatRowType ==
                                  ChatRowType.message.name) {
                                if (chatMsgModel.createUserId == userState.id) {
                                  // 나의 메시지
                                  widgetMsg = _buildMyMsg(context, list, index);
                                } else {
                                  // 상대방 메시지
                                  widgetMsg =
                                      _buildOtherMsg(list, index, context);
                                }
                              } else {
                                widgetMsg =
                                    _buildNotice(list[index], userState.id);
                              }

                              return widgetMsg;
                            },
                          );
                        } else {
                          return const Text('데이터 없음');
                        }
                      },
                    ),
                  ),
                  _buildInput(context, userState),
                ],
              ),
            )
          : Container(),
    );
  }

  Widget _buildOtherMsg(
      List<ChatMsgModel> list, int index, BuildContext context) {
    double topPaddingSize = 16;
    bool isProfileView = true;
    bool isMsgTimeView = true;

    if (index + 1 < list.length) {
      // 이 후 메시지 값을 가져온다
      if (list[index + 1].chatRowType == ChatRowType.message.name &&
          list[index + 1].createUserId == list[index].createUserId) {
        // 이전 메시지가 내가 쓴 메시지라면

        if (getTimestampDifferenceMin(
                    list[index + 1].createDate, list[index].createDate)
                .abs() <
            1) {
          topPaddingSize = 8; // 간격 줄이기
          isProfileView = false; // 프로파일 가리기
        }
      }
    }
    if (index - 1 >= 0) {
      // 이 전 메시지 값을 가져온다
      if (list[index - 1].chatRowType == ChatRowType.message.name &&
          list[index - 1].createUserId == list[index].createUserId) {
        // 이전 메시지가 내가 쓴 메시지라면

        if (getTimestampDifferenceMin(
                    list[index - 1].createDate, list[index].createDate)
                .abs() <
            1) {
          isMsgTimeView = false; // 채팅 시간 가리기
        }
      }
    }
    return Padding(
      padding: EdgeInsets.only(
        top: topPaddingSize,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Builder(
            builder: (context) {
              ProfilePhotoModel? profilePhotoModel;
              if (profilePhotoList.isNotEmpty) {
                profilePhotoModel = profilePhotoList.firstWhere(
                  (element) => element.user_id == list[index].createUserId,
                );
              }
              // logger.d('BUILD!!!!');
              if (isProfileView) {
                return Stack(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: const AssetImage(
                        'assets/images/88.png',
                      ),
                      foregroundImage: profilePhotoModel?.profile_photo == null
                          ? null
                          : NetworkImage(profilePhotoModel!.profile_photo!),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: kColorBorderStrong,
                            width: 1,
                          ),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: profilePhotoModel!.nationalities.isEmpty
                            ? Container()
                            : ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(16)),
                                child: SvgPicture.network(
                                  '$kS3Url$kS3Flag43Path/${profilePhotoModel.nationalities[0].code}.svg',
                                  width: 16,
                                  height: 16,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ],
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
          _buildMsgBubble(list[index], false),
          // Flexible(
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(
          //       vertical: 8,
          //       horizontal: 12,
          //     ),
          //     decoration: const BoxDecoration(
          //       color: kColorBgDefault,
          //       borderRadius: BorderRadius.all(Radius.circular(12)),
          //     ),
          //     child: Text(
          //       list[index].msg,
          //     ),
          //   ),
          // ),
          const SizedBox(
            width: 4,
          ),
          if (isMsgTimeView)
            Text(
              msgDateFormat.format(
                list[index].createDate.toDate(),
              ),
              style: getTsCaption10Rg(context).copyWith(
                color: kColorContentWeakest,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMyMsg(BuildContext context, List<ChatMsgModel> list, int index) {
    double topPaddingSize = 16;
    bool isMsgTimeView = true;

    if (index + 1 < list.length) {
      // 이 후 메시지 값을 가져온다
      if (list[index + 1].chatRowType == ChatRowType.message.name &&
          list[index + 1].createUserId == list[index].createUserId) {
        // 이전 메시지가 내가 쓴 메시지라면

        if (getTimestampDifferenceMin(
                    list[index + 1].createDate, list[index].createDate)
                .abs() <
            1) {
          topPaddingSize = 8; // 간격 줄이기
        }
      }
    }
    if (index - 1 >= 0) {
      // 이 전 메시지 값을 가져온다
      if (list[index - 1].chatRowType == ChatRowType.message.name &&
          list[index - 1].createUserId == list[index].createUserId) {
        // 이전 메시지가 내가 쓴 메시지라면

        if (getTimestampDifferenceMin(
                    list[index - 1].createDate, list[index].createDate)
                .abs() <
            1) {
          isMsgTimeView = false; // 채팅 시간 가리기
        }
      }
    }
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
                list[index].createDate.toDate(),
              ),
              style: getTsCaption10Rg(context).copyWith(
                color: kColorContentWeakest,
              ),
            ),
          const SizedBox(
            width: 4,
          ),
          _buildMsgBubble(list[index], true),
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
                style: const TextStyle(
                  overflow: TextOverflow.clip,
                ),
              ),
            )
          : Container(
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
          Flexible(
            child: Container(
              padding: notice.chatRowType == ChatRowType.notice.name
                  ? const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    )
                  : const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kColorBgElevation2,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    notice.chatRowType == ChatRowType.notice.name ? 50 : 12,
                  ),
                ),
              ),
              child: Text(
                notice.msg,
                style: getTsCaption12Rg(context).copyWith(
                  color: kColorContentWeakest,
                ),
              ),
            ),
          ),
        ],
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
        crossAxisAlignment: CrossAxisAlignment.end,
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
                      style: getTsBody16Rg(context).copyWith(
                        color: kColorContentWeak,
                      ),
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
                      }
                    },
                    child: Container(
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
