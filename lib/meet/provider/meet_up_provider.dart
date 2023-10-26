import 'package:biskit_app/meet/model/create_meet_up_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createMeetUpProvider =
    StateNotifierProvider<MeetUpStateNotifier, CreateMeetUpModel>((ref) {
  return MeetUpStateNotifier();
});

class MeetUpStateNotifier extends StateNotifier<CreateMeetUpModel> {
  MeetUpStateNotifier()
      : super(
          CreateMeetUpModel(
            isWritten: false,
            pageIndex: 0,
          ),
        );

  void init() {
    state = CreateMeetUpModel(
      isWritten: false,
      pageIndex: 0,
    );
  }

  void checkChange() {}

  void setTempSave(bool isWritten) {
    state = state.copyWith(isWritten: isWritten);
  }

  void setPageIndex(int index) {
    state = state.copyWith(
      pageIndex: index,
    );
    if (index > 0) {
      setTempSave(true);
    }
  }
}
