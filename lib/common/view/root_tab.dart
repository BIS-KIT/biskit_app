import 'package:biskit_app/chat/model/chat_room_model.dart';
import 'package:biskit_app/chat/repository/chat_repository.dart';
import 'package:biskit_app/chat/view/chat_screen.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/string_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RootTab extends ConsumerStatefulWidget {
  static String get routeName => 'home';
  const RootTab({super.key});

  @override
  ConsumerState<RootTab> createState() => _RootTabState();
}

class _RootTabState extends ConsumerState<RootTab>
    with SingleTickerProviderStateMixin {
  int index = 0;
  late TabController controller;
  final DateFormat dayFormat = DateFormat('MM월 dd일', 'ko');

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 3, vsync: this);

    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);

    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userMeProvider);
    // logger.d((userState as UserModel).toJson());
    return DefaultLayout(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey.shade500,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 26,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.tickets),
            label: '이용권',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity_rounded),
            label: 'My',
          ),
        ],
      ),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          userState is UserModel
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: const AssetImage(
                        'assets/images/88.png',
                      ),
                      foregroundImage: userState.profile!.profile_photo == null
                          ? null
                          : NetworkImage(
                              '${(userState).profile!.profile_photo}',
                            ),
                    ),
                    Text('userId : ${(userState).id}'),
                    Text('email : ${(userState).email}'),
                    Text('snsType : ${(userState).sns_type}'),
                    Text('nickname : ${(userState).profile!.nick_name}'),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(userMeProvider.notifier).deleteUser();
                      },
                      child: const Text(
                        'Delete User',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(userMeProvider.notifier).logout();
                      },
                      child: const Text(
                        'Logout',
                      ),
                    ),
                  ],
                )
              : Container(),
          userState is UserModel ? _buildGroupTap(userState) : Container(),
          userState is UserModel ? _buildChatTap(userState) : Container(),
        ],
      ),
    );
  }

  SafeArea _buildChatTap(UserModel userState) {
    // final stream = ref.watch(chatRoomListStreamProvider);
    return SafeArea(
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
          Expanded(
            child: StreamBuilder(
              stream: ref
                  .read(chatRepositoryProvider)
                  .getMyChatRoomListStream(userId: userState.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
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
                      itemBuilder: (context, index) => GestureDetector(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      docs[index].title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: getTsBody16Sb(context).copyWith(
                                        color: kColorContentDefault,
                                      ),
                                    ),
                                    if (docs[index]
                                        .firstUserInfoList
                                        .where((element) =>
                                            element.userId == userState.id)
                                        .isNotEmpty)
                                      Text(
                                        docs[index].lastMsg ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: getTsBody14Rg(context).copyWith(
                                          color: kColorContentWeaker,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              if (docs[index]
                                  .firstUserInfoList
                                  .where((element) =>
                                      element.userId == userState.id)
                                  .isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      docs[index].lastMsgDate == null
                                          ? ''
                                          : dayFormat.format(
                                              getDateTimeByTimestamp(
                                                  docs[index].lastMsgDate),
                                            ),
                                      style: getTsCaption12Rg(context).copyWith(
                                        color: kColorContentWeakest,
                                      ),
                                    ),
                                    docs[index].lastMsgUid == null ||
                                            docs[index]
                                                .lastMsgReadUsers
                                                .contains(userState.id)
                                        ? Container()
                                        : const Padding(
                                            padding: EdgeInsets.only(top: 8.0),
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
                      ),
                      separatorBuilder: (context, index) => const SizedBox(),
                      itemCount: docs.length,
                    );
                  } else {
                    return const Center(child: Text('데이터 없음'));
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  SafeArea _buildGroupTap(UserModel userState) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              '모임 개설',
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (value) async {
                      // 모임 개설 하면서 채팅방 생성
                      await ref.read(chatRepositoryProvider).createChatRoom(
                            title: value.trim(),
                            userId: userState.id,
                          );
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: ref.read(chatRepositoryProvider).allChatRoomListStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  logger.d(snapshot.data);
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData) {
                      List<ChatRoomModel> docs = snapshot.data!.docs
                          .map((e) => ChatRoomModel.fromMap(
                              e.data() as Map<String, dynamic>))
                          .toList();
                      return ListView.separated(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.only(top: 20),
                        itemBuilder: (context, index) => GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (docs[index].joinUsers.contains(userState.id)) {
                              showSnackBar(
                                context: context,
                                text: '이미 참여한 채팅방',
                              );
                            } else {
                              ref.read(chatRepositoryProvider).goInChatRoom(
                                    chatRoom: docs[index],
                                    userId: userState.id,
                                  );
                              showSnackBar(
                                context: context,
                                text: '참여 완료',
                              );
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  docs[index].title,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '인원 : ${docs[index].joinUsers.length.toString()}',
                                  ),
                                  Text(
                                    docs[index].createDate == null
                                        ? ''
                                        : '개설일 : ${dayFormat.format(getDateTimeByTimestamp(docs[index].createDate))}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: docs.length,
                      );
                    } else {
                      return const Text('데이터 없음');
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
