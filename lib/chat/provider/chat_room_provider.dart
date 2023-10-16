import 'package:biskit_app/chat/model/chat_room_model.dart';
import 'package:biskit_app/chat/repository/chat_repository.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRoomListStreamProvider = StreamProvider.autoDispose((ref) {
  final service = ChatRoomService(
    chatRepository: ref.watch(chatRepositoryProvider),
    userId: (ref.watch(userMeProvider) as UserModel).id,
  );
  service.init();
  return service.myChatRoomListStream!;
});

class ChatRoomService {
  final int? userId;
  final ChatRepository chatRepository;
  late Stream<List<ChatRoomModel>>? myChatRoomListStream;
  ChatRoomService({
    this.userId,
    required this.chatRepository,
    this.myChatRoomListStream,
  });
  Future<void> init() async {
    if (userId != null) {
      myChatRoomListStream = chatRepository
          .getMyChatRoomListStream(userId: userId!)
          .map((snapshot) {
        final result = snapshot.docs
            .map((e) => ChatRoomModel.fromMap(e.data() as Map<String, dynamic>))
            .toList();
        return result;
      });
    }
  }
}
