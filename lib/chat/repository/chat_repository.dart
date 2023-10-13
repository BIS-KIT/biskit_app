import 'package:biskit_app/user/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biskit_app/chat/model/chat_msg_model.dart';
import 'package:biskit_app/chat/model/chat_room_model.dart';
import 'package:biskit_app/common/dio/dio.dart';
import 'package:biskit_app/common/provider/firebase_provider.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/user/repository/users_repository.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) => ChatRepository(
      dio: ref.watch(dioProvider),
      firebaseFirestore: ref.watch(firebaseFirestoreProvider),
      usersRepository: ref.watch(usersRepositoryProvider),
    ));

class ChatRepository {
  final Dio dio;
  final FirebaseFirestore firebaseFirestore;
  final UsersRepository usersRepository;
  ChatRepository({
    required this.dio,
    required this.firebaseFirestore,
    required this.usersRepository,
  });

  Stream<QuerySnapshot> get allChatRoomListStream => firebaseFirestore
      .collection('ChatRoom')
      .orderBy(
        'createDate',
        descending: true,
      )
      .snapshots();

  createChatRoom({
    required String title,
    required int userId,
  }) async {
    String chatRoomId = firebaseFirestore.collection('ChatRoom').doc().id;
    logger.d('Create chatRoomId : $chatRoomId');
    await firebaseFirestore.collection('ChatRoom').doc(chatRoomId).set(
          ChatRoomModel(
            uid: chatRoomId,
            title: title,
            joinUsers: [userId],
            lastMsgReadUsers: [],
            firstUserInfoList: [],
            createUserId: userId,
            createDate: Timestamp.now(),
          ).toMap(),
        );
  }

  void goInChatRoom(
      {required ChatRoomModel chatRoom, required int userId}) async {
    await firebaseFirestore
        .collection('ChatRoom')
        .doc(chatRoom.uid)
        .set(chatRoom.copyWith(
          joinUsers: [
            ...chatRoom.joinUsers,
            userId,
          ],
        ).toMap());
  }

  getChatRoomById(String chatRoomUid) async {
    return await firebaseFirestore
        .collection('ChatRoom')
        .doc(chatRoomUid)
        .get();
  }

  Stream<QuerySnapshot> getMyChatRoomListStream({required int userId}) {
    return firebaseFirestore
        .collection('ChatRoom')
        .where('joinUsers', arrayContains: userId)
        .orderBy(
          'lastMsgDate',
          descending: true,
        )
        .snapshots();
  }

  sendMsg({
    required String msg,
    required int userId,
    required String chatRoomUid,
    required ChatRowType chatRowType,
    String? noticeText,
  }) async {
    String msgUid = firebaseFirestore
        .collection('ChatRoom')
        .doc(chatRoomUid)
        .collection('Messages')
        .doc()
        .id;
    logger.d('Create Message UID : $msgUid');
    await firebaseFirestore
        .collection('ChatRoom')
        .doc(chatRoomUid)
        .collection('Messages')
        .doc(msgUid)
        .set(
          ChatMsgModel(
            uid: msgUid,
            msg: msg,
            createDate: Timestamp.now(),
            createUserId: userId,
            readUsers: [userId],
            chatRowType: chatRowType.name,
            noticeText: noticeText,
          ).toMap(),
        );

    // chat room last msg
    await firebaseFirestore.collection('ChatRoom').doc(chatRoomUid).update({
      'lastMsgUid': msgUid,
      'lastMsg': msg,
      'lastMsgDate': Timestamp.now(),
      'lastMsgReadUsers': [userId],
    });
  }

  Stream<List<ChatMsgModel>> getChatMsgStream({
    required String chatRoomUid,
    required Timestamp? fromTimestamp,
    int limit = 20,
  }) {
    // logger.d(fromTimestamp!.toDate());
    return firebaseFirestore
        .collection('ChatRoom')
        .doc(chatRoomUid)
        .collection('Messages')
        .where('createDate',
            isGreaterThanOrEqualTo: fromTimestamp ?? Timestamp.now())
        .orderBy('createDate', descending: true)
        .limit(limit)
        .snapshots()
        .asyncMap((snapshot) async {
      // logger.d(snapshot.docs[0].data());
      final result =
          snapshot.docs.map((e) => ChatMsgModel.fromMap(e.data())).toList();
      return result;
      // for (var e in snapshot.docs) {
      //   logger.d(e.data());

      // }
      // return snapshot;
    });
  }

  void lastMsgRead({
    required ChatRoomModel chatRoom,
    required int userId,
  }) async {
    if (chatRoom.lastMsgReadUsers.contains(userId)) {
      // 이미 읽었으면 처리 안함
      return;
    }
    await firebaseFirestore
        .collection('ChatRoom')
        .doc(chatRoom.uid)
        .set(chatRoom.copyWith(
          lastMsgReadUsers: [
            ...chatRoom.lastMsgReadUsers,
            userId,
          ],
        ).toMap());
  }

  // 채팅방 처음 입장시 처리
  firstJoin({
    required ChatRoomModel chatRoom,
    required UserModel user,
  }) async {
    // 최초 입장시 데이터 저장
    await firebaseFirestore
        .collection('ChatRoom')
        .doc(chatRoom.uid)
        .set(chatRoom.copyWith(
          firstUserInfoList: [
            ...chatRoom.firstUserInfoList,
            ChatRoomFirstUserInfo(
              userId: user.id,
              firstJoinDate: Timestamp.now(),
            ),
          ],
        ).toMap());

    // 최초 입장시 안내문구 : 입장문구
    await sendMsg(
      msg: '',
      noticeText:
          '비스킷은 서로가 신뢰할 수 있는 커뮤니티를 만들어가고 있어요. 여기다가 맨처음 들어오면 알려줄 안내사항 적으면 될듯? 뭐라고 적지',
      userId: user.id,
      chatRoomUid: chatRoom.uid,
      chatRowType: ChatRowType.noticeOnlyMe,
    );
    // 최초 입장시 안내문구 : 참여문구
    sendMsg(
      msg: '',
      noticeText: '${user.profile!.nick_name}님이 참여했습니다.',
      userId: user.id,
      chatRoomUid: chatRoom.uid,
      chatRowType: ChatRowType.notice,
    );
  }
}
