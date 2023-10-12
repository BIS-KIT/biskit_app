// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:biskit_app/chat/model/chat_msg_model.dart';
import 'package:biskit_app/chat/repository/chat_repository.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:biskit_app/user/repository/users_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatRoomUid;
  final String chatRoomTitle;
  const ChatScreen({
    Key? key,
    required this.chatRoomUid,
    required this.chatRoomTitle,
  }) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late final TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userMeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoomTitle),
        centerTitle: true,
        elevation: 8,
      ),
      body: userState is UserModel
          ? Container(
              color: kColorBgElevation1,
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: ref.read(chatRepositoryProvider).getChatMsgStream(
                            chatRoomUid: widget.chatRoomUid,
                            limit: 20,
                          ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data != null &&
                            snapshot.data!.isNotEmpty) {
                          List<ChatMsgModel> list = snapshot.data!;
                          int currentUserId = -1;
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

                              if (chatMsgModel.createUserId == userState.id) {
                                // 나의 메시지
                                widgetMsg = Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      width: 20,
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
                                );
                              } else {
                                // 상대방 메시지
                                String? text;
                                widgetMsg = Row(
                                  children: [
                                    FutureBuilder(
                                        future: ref
                                            .read(usersRepositoryProvider)
                                            .getUserProfilePath(
                                                list[index].createUserId),
                                        builder: (context, snapshot) {
                                          text = snapshot.data.toString();
                                          logger.d(text);
                                          if (snapshot.hasData) {
                                            return CircleAvatar(
                                              radius: 16,
                                              backgroundImage: const AssetImage(
                                                'assets/images/88.png',
                                              ),
                                              foregroundImage:
                                                  NetworkImage(text!),
                                            );
                                          }
                                          return const CircleAvatar(
                                            radius: 16,
                                            backgroundImage: AssetImage(
                                              'assets/images/88.png',
                                            ),

                                            // child: ,
                                          );
                                        }),

                                    // FutureBuilder(
                                    //     future: ref
                                    //         .read(usersRepositoryProvider)
                                    //         .getUserProfilePath(
                                    //             list[index].createUserId),
                                    //     builder: (context, snapshot) {
                                    //       text = snapshot.data.toString();
                                    //       return CircleAvatar(
                                    //         radius: 16,
                                    //         backgroundImage: const AssetImage(
                                    //           'assets/images/88.png',
                                    //         ),
                                    //         child: Text(
                                    //             text == null ? 'B' : text!),
                                    //       );
                                    //     }),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        child: Text(
                                          list[index].msg,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }

                              // 메시지간 간격처리
                              Widget gapWidget = const SizedBox(
                                height: 16,
                              );
                              if (currentUserId == list[index].createUserId) {
                                gapWidget = const SizedBox(
                                  height: 8,
                                );
                              }
                              currentUserId = list[index].createUserId;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  widgetMsg,
                                  if (index != 0) gapWidget,
                                ],
                              );
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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.image_outlined),
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
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      String msg = textEditingController.text.trim();
                      if (msg.isNotEmpty) {
                        ref.read(chatRepositoryProvider).sendMsg(
                              msg: msg,
                              userId: userState.id,
                              chatRoomUid: widget.chatRoomUid,
                            );
                        textEditingController.text = '';
                      }
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.yellow,
                    ),
                    icon: const Icon(
                      Icons.arrow_upward,
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
