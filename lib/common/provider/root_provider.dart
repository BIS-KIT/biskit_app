import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/utils/local_notification_util.dart';
import 'package:biskit_app/common/utils/permission_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rootProvider = StateNotifierProvider<RootStateNotifier, RootState>(
    (ref) => RootStateNotifier());

class RootStateNotifier extends StateNotifier<RootState> {
  late TabController tabController;
  RootStateNotifier()
      : super(
          RootState(
            scafoldBackgroundColor: kColorBgElevation1,
            index: 0,
          ),
        ) {
    //
    initFcm();
  }

  init() async {
    state = state.copyWith(
      index: 0,
      scafoldBackgroundColor: kColorBgDefault,
    );
  }

  initFcm() async {
    // 로컬노티피케이션 init
    localNotificationInit();
    // 파이어베이스 메시징 처리
    await requestPermission();
    // 파이어베이스 메시지 포그라운드 처리
    await foregroundFcm();
  }

  setTabController(TabController controller) {
    tabController = controller;
  }

  void tabListener(int value) {
    Color color = state.scafoldBackgroundColor;
    if (value == 3) {
      color = kColorBgDefault;
    } else if (value == 0) {
      color = kColorBgDefault;
    } else if (value == 1) {
      color = kColorBgElevation1;
    } else {
      color = kColorBgElevation2;
    }

    state = state.copyWith(
      scafoldBackgroundColor: color,
    );
  }

  void onTapBottomNav(int index) {
    state = state.copyWith(
      index: index,
    );
    tabController.animateTo(index);
  }
}

class RootState {
  final Color scafoldBackgroundColor;
  final int index;
  RootState({
    required this.scafoldBackgroundColor,
    required this.index,
  });

  RootState copyWith({
    Color? scafoldBackgroundColor,
    int? index,
  }) {
    return RootState(
      scafoldBackgroundColor:
          scafoldBackgroundColor ?? this.scafoldBackgroundColor,
      index: index ?? this.index,
    );
  }
}
