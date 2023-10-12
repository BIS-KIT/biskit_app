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
            users: [userId],
            createUserId: userId,
            createDate: FieldValue.serverTimestamp(),
          ).toMap(),
        );
  }

  void goInChatRoom(
      {required ChatRoomModel chatRoom, required int userId}) async {
    await firebaseFirestore
        .collection('ChatRoom')
        .doc(chatRoom.uid)
        .set(chatRoom.copyWith(
          users: [
            ...chatRoom.users,
            userId,
          ],
        ).toMap());
  }

  Stream<QuerySnapshot> getMyChatRoomListStream({required int userId}) {
    return firebaseFirestore
        .collection('ChatRoom')
        .where('users', arrayContains: userId)
        .orderBy(
          'lastMsgDate',
          descending: true,
        )
        .snapshots();
  }

  void sendMsg({
    required String msg,
    required int userId,
    required String chatRoomUid,
  }) async {
    String msgUid = firebaseFirestore
        .collection('ChatRoom')
        .doc(chatRoomUid)
        .collection('Messages')
        .doc()
        .id;
    logger.d('Create Message UID : $msgUid');
    FieldValue serverTime = FieldValue.serverTimestamp();
    await firebaseFirestore
        .collection('ChatRoom')
        .doc(chatRoomUid)
        .collection('Messages')
        .doc(msgUid)
        .set(
          ChatMsgModel(
            uid: msgUid,
            msg: msg,
            createDate: serverTime,
            createUserId: userId,
            readUsers: [userId],
          ).toMap(),
        );

    // chat room last msg
    await firebaseFirestore.collection('ChatRoom').doc(chatRoomUid).update({
      'lastMsg': msg,
      'lastMsgDate': serverTime,
      'lastMsgReadUsers': [userId],
    });
  }

  Stream<List<ChatMsgModel>> getChatMsgStream({
    required String chatRoomUid,
    int limit = 20,
  }) {
    return firebaseFirestore
        .collection('ChatRoom')
        .doc(chatRoomUid)
        .collection('Messages')
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
}
