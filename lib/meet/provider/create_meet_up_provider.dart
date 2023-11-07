import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biskit_app/chat/repository/chat_repository.dart';
import 'package:biskit_app/common/model/kakao/kakao_document_model.dart';
import 'package:biskit_app/common/repository/util_repository.dart';
import 'package:biskit_app/meet/model/create_meet_up_model.dart';
import 'package:biskit_app/meet/model/tag_model.dart';
import 'package:biskit_app/meet/model/topic_model.dart';
import 'package:biskit_app/meet/repository/meet_up_repository.dart';
import 'package:biskit_app/profile/model/available_language_model.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';

final createMeetUpProvider =
    StateNotifierProvider<CreateMeetUpStateNotifier, CreateMeetUpModel?>((ref) {
  return CreateMeetUpStateNotifier(
    userModelBase: ref.watch(userMeProvider),
    utilRepository: ref.watch(utilRepositoryProvider),
    meetUpRepository: ref.watch(meetUpRepositoryProvider),
    chatRepository: ref.watch(chatRepositoryProvider),
  );
});

class CreateMeetUpStateNotifier extends StateNotifier<CreateMeetUpModel?> {
  final UserModelBase? userModelBase;
  final UtilRepository utilRepository;
  final MeetUpRepository meetUpRepository;
  final ChatRepository chatRepository;
  CreateMeetUpStateNotifier({
    required this.userModelBase,
    required this.utilRepository,
    required this.meetUpRepository,
    required this.chatRepository,
  }) : super(null) {
    //
    init();
  }

  void init() {
    if (userModelBase != null && userModelBase is UserModel) {
      state = CreateMeetUpModel(
        creator_id: (userModelBase as UserModel).id,
        language_ids: [],
        tag_ids: [],
        topic_ids: [],
        custom_tags: [],
        custom_topics: [],
      );
    }
  }

  Future<List<TopicModel>> getTopics() async {
    List<TopicModel> list = [];
    list = await utilRepository.getTopics();
    return list;
  }

  Future<List<TagModel>> getTags() async {
    List<TagModel> list = [];
    list = await utilRepository.getTags();
    return list;
  }

  // 토픽 생성
  onTapTopic(int id) {
    if (state != null) {
      if (state!.topic_ids.contains(id)) {
        state = state!.copyWith(
          topic_ids:
              state!.topic_ids.where((element) => element != id).toList(),
        );
      } else {
        state = state!.copyWith(
          topic_ids: [
            ...state!.topic_ids,
            id,
          ],
        );
      }
    }
  }

  // 커스텀 토픽 생성
  onTapAddCustomTopic(String topic) {
    if (state != null) {
      state = state!.copyWith(
        custom_topics: [
          ...state!.custom_topics,
          topic,
        ],
      );
    }
  }

  onTapDeleteCustomTopic(String topic) {
    if (state != null) {
      if (state!.custom_topics.contains(topic)) {
        state = state!.copyWith(
          custom_topics: state!.custom_topics
              .where((element) => element != topic)
              .toList(),
        );
      }
    }
  }

  getIsBottomButtonEnable(int pageIndex) {
    bool isEnable = false;
    if (state != null) {
      if (pageIndex == 0) {
        if (state!.topic_ids.isNotEmpty) {
          isEnable = true;
        }
      }
    }

    return isEnable;
  }

  void setLocation(location) {
    if (location is String) {
      // 검색된 장소가 없는 경우
      state = state!.copyWith(
        location: location.toString(),
      );
    } else if (location is KakaoDocumentModel) {
      // 검색된 장소가 있는 경우
      state = state!.copyWith(
        location: location.place_name,
      );
    }
  }

  onClickMinus() {
    if (state != null && state!.max_participants > 2) {
      state = state!.copyWith(
        max_participants: state!.max_participants - 1,
      );
    }
  }

  onClickPlus() {
    if (state != null && state!.max_participants < 10) {
      state = state!.copyWith(
        max_participants: state!.max_participants + 1,
      );
    }
  }

  void setMeetDate(DateTime dateTime) {
    if (state != null) {
      state = state!.copyWith(
        meeting_time: dateTime.toIso8601String(),
      );
    }
  }

  getMeetDate() {
    DateTime? dateTime;
    if (state != null &&
        state!.meeting_time != null &&
        state!.meeting_time!.isNotEmpty) {
      dateTime = DateTime.parse(state!.meeting_time!);
    }
    return dateTime;
  }

  onTapLang(AvailableLanguageModel e) {
    if (state != null) {
      if (state!.language_ids.contains(e.language.id)) {
        state = state!.copyWith(
          language_ids: state!.language_ids
              .where((element) => element != e.language.id)
              .toList(),
        );
      } else {
        state = state!.copyWith(
          language_ids: [
            ...state!.language_ids,
            e.language.id,
          ],
        );
      }
    }
  }

  void onTapTag(TagModel e) {
    if (state != null) {
      if (state!.tag_ids.contains(e.id)) {
        state = state!.copyWith(
          tag_ids: state!.tag_ids.where((element) => element != e.id).toList(),
        );
      } else {
        state = state!.copyWith(
          tag_ids: [
            ...state!.tag_ids,
            e.id,
          ],
        );
      }
    }
  }

  // 커스텀 태그 생성
  onTapAddCustomTag(String tag) {
    if (state != null) {
      state = state!.copyWith(
        custom_tags: [
          ...state!.custom_tags,
          tag,
        ],
      );
    }
  }

  onTapDeleteCustomTag(String tag) {
    if (state != null) {
      if (state!.custom_tags.contains(tag)) {
        state = state!.copyWith(
          custom_tags:
              state!.custom_tags.where((element) => element != tag).toList(),
        );
      }
    }
  }

  void onChangedName(String value) {
    if (state != null) {
      state = state!.copyWith(
        name: value,
      );
    }
  }

  void onChangedDescription(String value) {
    if (state != null) {
      state = state!.copyWith(
        description: value,
      );
    }
  }

  createMeetUp() async {
    bool result = false;
    if (state != null) {
      // firebase chat room create
      String chatRoomUid = await chatRepository.createChatRoom(
        title: state!.name ?? '',
        userId: state!.creator_id,
      );

      if (chatRoomUid.isEmpty) {
        return false;
      }

      result = await meetUpRepository.createMeetUp(state!.copyWith(
        chat_id: chatRoomUid,
      ));
      init();
    }
    return result;
  }
}
