import 'package:biskit_app/chat/components/chat_room_card_widget.dart';
import 'package:biskit_app/chat/model/chat_room_model.dart';
import 'package:biskit_app/chat/repository/chat_repository.dart';
import 'package:biskit_app/chat/view/chat_screen.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  onTapChatRoom({
    required ChatRoomModel chatRoom,
    required UserModel user,
  }) async {
    await ref.read(chatRepositoryProvider).goChatRoom(
          chatRoomUid: chatRoom.uid,
          user: user,
        );

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatRoomUid: chatRoom.uid,
        ),
      ),
    );
  }

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
              'chatListScreen.title'.tr(),
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
                  logger.d(snapshot.hasData);
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
                      itemBuilder: (context, index) {
                        ChatRoomFirstUserInfo? chatRoomFirstUserInfo;

                        if (docs[index]
                            .firstUserInfoList
                            .any((element) => element.userId == userState.id)) {
                          chatRoomFirstUserInfo = docs[index]
                              .firstUserInfoList
                              .firstWhere(
                                  (element) => element.userId == userState.id);
                        }

                        return Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: kColorBorderWeak,
                              ),
                            ),
                          ),
                          child: ChatRoomCardWidget(
                            chatRoomModel: docs[index],
                            user: userState,
                            chatRoomFirstUserInfo: chatRoomFirstUserInfo,
                            onTapChatRoom: () {
                              onTapChatRoom(
                                chatRoom: docs[index],
                                user: userState,
                              );
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(),
                      itemCount: docs.length,
                    );
                  } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              top: 16.12,
                              left: 8.51,
                              right: 8.44,
                              bottom: 16.05,
                            ),
                            child: SvgPicture.asset(
                              'assets/images/img_chat_empty_states.svg',
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'chatListScreen.noResult'.tr(),
                            style: getTsBody16Rg(context).copyWith(
                              color: kColorContentWeakest,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container();
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
