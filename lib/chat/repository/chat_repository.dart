import 'package:biskit_app/chat/model/chat_room_model.dart';
import 'package:biskit_app/common/dio/dio.dart';
import 'package:biskit_app/common/provider/firebase_provider.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) => ChatRepository(
      dio: ref.watch(dioProvider),
      firebaseFirestore: ref.watch(firebaseFirestoreProvider),
    ));

class ChatRepository {
  final Dio dio;
  final FirebaseFirestore firebaseFirestore;
  ChatRepository({
    required this.dio,
    required this.firebaseFirestore,
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
            createDate: DateTime.now(),
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
}
