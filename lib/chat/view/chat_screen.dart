// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:biskit_app/chat/model/chat_room_model.dart';
import 'package:biskit_app/common/utils/date_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:biskit_app/chat/model/chat_msg_model.dart';
import 'package:biskit_app/chat/repository/chat_repository.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/string_util.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:biskit_app/user/repository/users_repository.dart';

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
  late final TextEditingController textEditingController;
  final DateFormat msgDateFormat = DateFormat('a hh:mm', 'ko');
  final DateFormat dayFormat = DateFormat('yyyy년 MM월 dd일 EEE', 'ko');

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    fetchChatRoom();
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
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  makeChatWidgetList(List<ChatMsgModel> list) {}

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userMeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(chatRoomModel == null ? '' : chatRoomModel!.title),
        centerTitle: true,
        elevation: 8,
      ),
      body: userState is UserModel && chatRoomModel != null
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
                              DateTime createDateTime = getDateTimeByTimestamp(
                                list[index].createDate,
                              );
                              if (chatMsgModel.chatRowType ==
                                  ChatRowType.message.name) {
                                if (chatMsgModel.createUserId == userState.id) {
                                  // 나의 메시지
                                  widgetMsg = _buildMyMsg(
                                      createDateTime, context, list, index);
                                } else {
                                  // 상대방 메시지
                                  String? text;
                                  widgetMsg = _buildOtherMsg(list, index, text,
                                      createDateTime, context);
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

  Widget _buildOtherMsg(List<ChatMsgModel> list, int index, String? text,
      DateTime createDateTime, BuildContext context) {
    double topPaddingSize = 16;
    bool isProfileView = true;
    bool isMsgTimeView = true;

    if (index + 1 < list.length) {
      // 이 후 메시지 값을 가져온다
      if (list[index + 1].chatRowType == ChatRowType.message.name &&
          list[index + 1].createUserId == list[index].createUserId) {
        // 이전 메시지가 내가 쓴 메시지라면

        if (getTimestampDifference(
                    list[index + 1].createDate, list[index].createDate)
                .inMinutes
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

        if (getTimestampDifference(
                    list[index - 1].createDate, list[index].createDate)
                .inMinutes
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
          isProfileView
              ? FutureBuilder(
                  future: ref
                      .read(usersRepositoryProvider)
                      .getUserProfilePath(list[index].createUserId),
                  builder: (context, snapshot) {
                    text = snapshot.data.toString();
                    // logger.d(text);
                    if (snapshot.hasData) {
                      return CircleAvatar(
                        radius: 16,
                        backgroundImage: const AssetImage(
                          'assets/images/88.png',
                        ),
                        foregroundImage: NetworkImage(text!),
                      );
                    }
                    return const CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage(
                        'assets/images/88.png',
                      ),

                      // child: ,
                    );
                  })
              : const SizedBox(
                  width: 32,
                ),
          const SizedBox(
            width: 8,
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              decoration: const BoxDecoration(
                color: kColorBgDefault,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Text(
                list[index].msg,
              ),
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          if (isMsgTimeView)
            Text(
              msgDateFormat.format(
                createDateTime,
              ),
              style: getTsCaption10Rg(context).copyWith(
                color: kColorContentWeakest,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMyMsg(DateTime createDateTime, BuildContext context,
      List<ChatMsgModel> list, int index) {
    // logger.d('[$index]:${list[index].toString()}');
    double topPaddingSize = 16;
    if (index + 1 < list.length) {
      // 이 전 메시지 값을 가져온다
      if (list[index + 1].chatRowType == ChatRowType.message.name &&
          list[index + 1].createUserId == list[index].createUserId) {
        topPaddingSize = 8;
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
          Text(
            msgDateFormat.format(
              createDateTime,
            ),
            style: getTsCaption10Rg(context).copyWith(
              color: kColorContentWeakest,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              decoration: const BoxDecoration(
                color: kColorBgPrimary,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Text(
                list[index].msg,
                style: const TextStyle(
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotice(ChatMsgModel notice, int userId) {
    if (notice.noticeText == null) {
      // error 경우
      return Container();
    }

    if (notice.chatRowType == ChatRowType.noticeOnlyMe.name &&
        notice.createUserId != userId) {
      // 오직 나에게만 보이는 메시지
      // 상대방의 경우 빈값을 리턴
      return Container();
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
                notice.noticeText!,
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
          Container(
            width: 44,
            height: 44,
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              'assets/icons/ic_image_line_24.svg',
              width: 24,
              height: 24,
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
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 7),
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
                              userId: userState.id,
                              chatRoomUid: widget.chatRoomUid,
                              chatRowType: ChatRowType.message,
                            );
                        textEditingController.text = '';
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
