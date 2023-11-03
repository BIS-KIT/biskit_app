import 'package:biskit_app/chat/model/chat_msg_model.dart';
import 'package:biskit_app/chat/model/chat_room_model.dart';
import 'package:biskit_app/chat/repository/chat_repository.dart';
import 'package:biskit_app/chat/view/chat_screen.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/date_util.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userMeProvider);
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 12,
              left: 20,
              right: 10,
            ),
            child: Text(
              '채팅',
              style: getTsHeading20(context).copyWith(
                color: Colors.black,
              ),
            ),
          ),
          if (userState is UserModel)
            Expanded(
              child: StreamBuilder(
                stream: ref
                    .read(chatRepositoryProvider)
                    .getMyChatRoomListStream(userId: userState.id),
                builder: (context, snapshot) {
                  logger.d(snapshot.connectionState);
                  // 깜빡임 현상으로 인하여 삭제
                  // if (snapshot.connectionState == ConnectionState.waiting) {
                  //   return const Center(
                  //     child: CircularProgressIndicator(),
                  //   );
                  // } else {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    List<ChatRoomModel> docs = snapshot.data!.docs
                        .map((e) => ChatRoomModel.fromMap(
                            e.data() as Map<String, dynamic>))
                        .toList();

                    return ListView.separated(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      // padding: const EdgeInsets.only(
                      //   top: 20,
                      //   left: 20,
                      //   right: 20,
                      // ),
                      itemBuilder: (context, index) {
                        ChatRoomFirstUserInfo? chatRoomFirstUserInfo;
                        if (docs[index]
                            .firstUserInfoList
                            .map((element) => element.userId)
                            .toList()
                            .contains(userState.id)) {
                          chatRoomFirstUserInfo = docs[index]
                              .firstUserInfoList
                              .singleWhere(
                                  (element) => element.userId == userState.id);
                        }
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () async {
                            // 마지막 메시지 읽음으로 변경
                            ref.read(chatRepositoryProvider).lastMsgRead(
                                  chatRoom: docs[index],
                                  userId: userState.id,
                                );

                            if (!docs[index].firstUserInfoList.any(
                                (element) => element.userId == userState.id)) {
                              // 최초 채팅방 입장시 처리
                              await ref.read(chatRepositoryProvider).firstJoin(
                                    chatRoom: docs[index],
                                    user: userState,
                                  );
                            }

                            if (!mounted) return;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    chatRoomUid: docs[index].uid,
                                  ),
                                ));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage: const AssetImage(
                                    'assets/images/88.png',
                                  ),
                                  foregroundImage:
                                      docs[index].roomImagePath == null
                                          ? null
                                          : NetworkImage(
                                              docs[index].roomImagePath!,
                                            ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        docs[index].title,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: getTsBody16Sb(context).copyWith(
                                          color: kColorContentDefault,
                                        ),
                                      ),
                                      if (chatRoomFirstUserInfo != null &&
                                          chatRoomFirstUserInfo.firstJoinDate !=
                                              null &&
                                          docs[index].lastMsgDate != null &&
                                          chatRoomFirstUserInfo.firstJoinDate
                                                  .microsecondsSinceEpoch <=
                                              docs[index]
                                                  .lastMsgDate
                                                  .microsecondsSinceEpoch &&
                                          ([
                                            ChatMsgType.text.name,
                                            ChatMsgType.image.name,
                                          ].contains(docs[index].lastMsgType)))
                                        Text(
                                          docs[index].lastMsgType ==
                                                  ChatMsgType.text.name
                                              ? docs[index].lastMsg ?? ''
                                              : '사진',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style:
                                              getTsBody14Rg(context).copyWith(
                                            color: kColorContentWeaker,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                if (chatRoomFirstUserInfo != null &&
                                    chatRoomFirstUserInfo.firstJoinDate !=
                                        null &&
                                    docs[index].lastMsgDate != null &&
                                    chatRoomFirstUserInfo.firstJoinDate
                                            .microsecondsSinceEpoch <=
                                        docs[index]
                                            .lastMsgDate
                                            .microsecondsSinceEpoch)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        docs[index].lastMsgDate == null
                                            ? ''
                                            : getDateTimeToString(
                                                docs[index]
                                                    .lastMsgDate
                                                    .toDate(),
                                              ),
                                        style:
                                            getTsCaption12Rg(context).copyWith(
                                          color: kColorContentWeakest,
                                        ),
                                      ),
                                      docs[index].lastMsgUid == null ||
                                              docs[index]
                                                  .lastMsgReadUsers
                                                  .contains(userState.id)
                                          ? Container()
                                          : const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 8.0),
                                              child: CircleAvatar(
                                                radius: 4,
                                                backgroundColor:
                                                    kColorContentError,
                                              ),
                                            ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(),
                      itemCount: docs.length,
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/ic_chat_fill_24.svg',
                            width: 56,
                            height: 56,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '채팅방이 없어요',
                            style: getTsBody16Rg(context).copyWith(
                              color: kColorContentWeakest,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  // }
                },
              ),
            ),
        ],
      ),
    );
  }
}
