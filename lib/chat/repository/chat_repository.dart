import 'dart:io';

import 'package:biskit_app/common/const/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biskit_app/chat/model/chat_msg_model.dart';
import 'package:biskit_app/chat/model/chat_room_model.dart';
import 'package:biskit_app/common/dio/dio.dart';
import 'package:biskit_app/common/provider/firebase_provider.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) => ChatRepository(
      dio: ref.watch(dioProvider),
      userModel: ref.watch(userMeProvider),
      firebaseFirestore: ref.watch(firebaseFirestoreProvider),
      baseUrl: 'http://$kServerIp:$kServerPort/$kServerVersion/chat',
    ));

class ChatRepository {
  final Dio dio;
  final UserModelBase? userModel;
  final FirebaseFirestore firebaseFirestore;
  final String baseUrl;
  ChatRepository({
    required this.dio,
    required this.userModel,
    required this.firebaseFirestore,
    required this.baseUrl,
  });

  Stream<QuerySnapshot> get allChatRoomListStream => firebaseFirestore
      .collection('ChatRoom')
      .orderBy(
        'createDate',
        descending: true,
      )
      .snapshots();

  Future<String> createChatRoom({
    required String title,
    required int userId,
    String? imagePath,
  }) async {
    String chatRoomId = firebaseFirestore.collection('ChatRoom').doc().id;
    logger.d('Create chatRoomId : $chatRoomId');
    await firebaseFirestore.collection('ChatRoom').doc(chatRoomId).set(
          ChatRoomModel(
            uid: chatRoomId,
            roomImagePath: imagePath,
            title: title,
            joinUsers: [userId],
            connectingUsers: [],
            lastMsgReadUsers: [],
            firstUserInfoList: [],
            createUserId: userId,
            createDate: FieldValue.serverTimestamp(),
          ).toMap(),
        );
    return chatRoomId;
  }

  updateChatRoom({
    required String chatRoomUid,
    required Map<String, dynamic> data,
  }) async {
    await firebaseFirestore.collection('ChatRoom').doc(chatRoomUid).update(
          data,
        );
  }

  void goInChatRoom(
      {required ChatRoomModel chatRoom, required int userId}) async {
    await firebaseFirestore.collection('ChatRoom').doc(chatRoom.uid).update({
      'joinUsers': FieldValue.arrayUnion([userId])
    });
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

  void updateMsg({
    required String chatRoomUid,
    required String msgUid,
    required Map<String, String> data,
  }) async {
    await firebaseFirestore
        .collection('ChatRoom')
        .doc(chatRoomUid)
        .collection('Messages')
        .doc(msgUid)
        .update(
          data,
        );
  }

  Future<String?> sendMsg({
    required String msg,
    required ChatMsgType chatMsgType,
    required int userId,
    required String chatRoomUid,
    required ChatRowType chatRowType,
  }) async {
    String msgUid = firebaseFirestore
        .collection('ChatRoom')
        .doc(chatRoomUid)
        .collection('Messages')
        .doc()
        .id;
    logger.d('Create Message UID : $msgUid');
    FieldValue now = FieldValue.serverTimestamp();
    ChatMsgModel chatMsgModel = ChatMsgModel(
      uid: msgUid,
      msg: msg,
      msgType: chatMsgType.name,
      createDate: now,
      createUserId: userId,
      readUsers: [userId],
      chatRowType: chatRowType.name,
    );
    await firebaseFirestore
        .collection('ChatRoom')
        .doc(chatRoomUid)
        .collection('Messages')
        .doc(msgUid)
        .set(
          chatMsgModel.toMap(),
        );
    if (chatRowType == ChatRowType.message) {
      // 메시지인 경우에 마지막 메시지를 넣어준다
      // chat room last msg
      await firebaseFirestore.collection('ChatRoom').doc(chatRoomUid).update({
        'lastMsgUid': msgUid,
        'lastMsg': msg,
        'lastMsgDate': now,
        'lastMsgReadUsers': [userId],
        'lastMsgType': chatMsgType.name,
      });
    }

    return msgUid;
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
            isGreaterThanOrEqualTo:
                fromTimestamp ?? FieldValue.serverTimestamp())
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
    await firebaseFirestore.collection('ChatRoom').doc(chatRoom.uid).update({
      'lastMsgReadUsers': FieldValue.arrayUnion([userId]),
    });
  }

  // 채팅방 처음 입장시 처리
  firstJoin({
    required ChatRoomModel chatRoom,
    required UserModel user,
  }) async {
    // 최초 입장시 데이터 저장
    await firebaseFirestore.collection('ChatRoom').doc(chatRoom.uid).update({
      'firstUserInfoList': FieldValue.arrayUnion([
        ChatRoomFirstUserInfo(
          userId: user.id,
          firstJoinDate: Timestamp.now(),
        ).toMap()
      ])
    });

    await Future.delayed(const Duration(milliseconds: 300));

    // 최초 입장시 안내문구 : 입장문구
    await sendMsg(
      chatMsgType: ChatMsgType.text,
      msg:
          '비스킷은 서로가 신뢰할 수 있는 커뮤니티를 만들어가고 있어요. 여기다가 맨처음 들어오면 알려줄 안내사항 적으면 될듯? 뭐라고 적지',
      userId: user.id,
      chatRoomUid: chatRoom.uid,
      chatRowType: ChatRowType.noticeOnlyMe,
    );
    // 최초 입장시 안내문구 : 참여문구
    sendMsg(
      chatMsgType: ChatMsgType.text,
      msg: '${user.profile!.nick_name}님이 참여했습니다.',
      userId: user.id,
      chatRoomUid: chatRoom.uid,
      chatRowType: ChatRowType.noticeJoin,
    );
  }

  Future<String?> postChatUpload({
    required String chatRoomUid,
    required String msgUid,
    required List<PhotoModel> result,
  }) async {
    String? path;
    if (userModel is UserModel) {
      File? file;
      PhotoModel photoModel = result[0];
      if (photoModel.photoType == PhotoType.asset) {
        file = await photoModel.assetEntity!.originFile;
      } else {
        file = File(photoModel.cameraXfile!.path);
      }

      Response? res;

      try {
        // 메시지 파이어베이스 아이디값 가져오기
        // String msgUid = firebaseFirestore
        //     .collection('ChatRoom')
        //     .doc(chatRoomUid)
        //     .collection('Messages')
        //     .doc()
        //     .id;

        res = await dio.post(
          '$baseUrl/upload',
          options: Options(
            headers: {
              'Content-Type':
                  file == null ? 'application/json' : 'multipart/form-data',
              'Accept': 'application/json',
            },
          ),
          queryParameters: {
            'chat_id': chatRoomUid,
            'message_id': msgUid,
          },
          data: file == null
              ? null
              : FormData.fromMap({
                  'photo': [
                    await MultipartFile.fromFile(
                      file.path,
                      filename: file.path.split('/').last,
                    ),
                  ],
                }),
        );

        if (res.statusCode == 200) {
          logger.d(res);
          path = res.data['image_url'];
        }
      } catch (e) {
        logger.e(e.toString());
      }
    }
    return path;
  }
}
