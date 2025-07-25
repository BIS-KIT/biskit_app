import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/provider/home_provider.dart';
import 'package:biskit_app/common/utils/local_notification_util.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/permission_util.dart';
import 'package:biskit_app/setting/provider/system_provider.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rootProvider = StateNotifierProvider<RootStateNotifier, RootState>(
    (ref) => RootStateNotifier(
          ref: ref,
        ));

class RootStateNotifier extends StateNotifier<RootState> {
  final Ref ref;
  RootStateNotifier({
    required this.ref,
  }) : super(
          RootState(
            scafoldBackgroundColor: kColorBgElevation1,
            index: 0,
            // 홈에서 태그나 토픽 선택해서 탐색 탭으로 넘어가는 경우 = true
            isLoading: false,
            isPublic: false,
          ),
        ) {
    //
    initFcm(ref);
  }

  init() async {
    state = state.copyWith(
      index: 0,
      scafoldBackgroundColor: kColorBgDefault,
    );
  }

  initFcm(final Ref ref) async {
    logger.d('initFcm');
    // 알림
    criticalNotification =
        await ref.read(systemProvider.notifier).getCriticalNotification();

    generalNotification =
        await ref.read(systemProvider.notifier).getGeneralNotification();

    // 로컬노티피케이션 init
    localNotificationInit();
    // 파이어베이스 메시징 처리
    await requestPermission();
    // 파이어베이스 메시지 포그라운드 처리
    await foregroundFcm(ref, criticalNotification, generalNotification);
    // 파이어베이스 메시지 백그라운드 처리
    await backgroundFcm(ref, criticalNotification, generalNotification);
  }

  // setTabController(TabController controller) {
  //   tabController = controller;
  // }

  // void tabListener(int value) {
  //   Color color = state.scafoldBackgroundColor;
  //   if (value == 3) {
  //     color = kColorBgDefault;
  //   } else if (value == 0) {
  //     color = kColorBgDefault;
  //   } else if (value == 1) {
  //     color = kColorBgElevation1;
  //   } else {
  //     color = kColorBgElevation2;
  //   }

  //   state = state.copyWith(
  //     scafoldBackgroundColor: color,
  //   );
  // }

  // 전체/우리 학교
  void onSelectPublic(final isPublic) {
    state = state.copyWith(
      isPublic: isPublic,
    );
  }

  void onTapBottomNav({
    required final int index,
    final bool isLoading = false,
    final Color color = kColorBgDefault,
  }) {
    logger.d('root tap: $index');

    ref.read(userMeProvider.notifier).getMe();
    Color? scafoldColor = color;
    if (index == 3) {
      scafoldColor = kColorBgDefault;
    } else if (index == 0) {
      if (ref.read(homeProvider).approveMeetings.isEmpty) {
        scafoldColor = kColorBgDefault;
      } else {
        scafoldColor = Colors.transparent;
      }
    } else if (index == 1) {
      scafoldColor = kColorBgElevation1;
    } else {
      scafoldColor = kColorBgElevation2;
    }

    state = state.copyWith(
      index: index,
      scafoldBackgroundColor: scafoldColor,
      isLoading: isLoading,
    );
    // tabController.animateTo(index);
    // tabListener(index);
  }

  void setScaffoldColor(Color color) {
    state = state.copyWith(
      scafoldBackgroundColor: color,
    );
  }
}

class RootState {
  final Color scafoldBackgroundColor;
  final int index;
  final bool? isLoading;
  // 탐색 탭에서 전체학교/우리학교 isPublic
  final bool? isPublic;
  RootState({
    required this.scafoldBackgroundColor,
    required this.index,
    required this.isLoading,
    required this.isPublic,
  });

  RootState copyWith({
    Color? scafoldBackgroundColor,
    int? index,
    bool? isLoading,
    bool? isPublic,
  }) {
    return RootState(
      scafoldBackgroundColor:
          scafoldBackgroundColor ?? this.scafoldBackgroundColor,
      index: index ?? this.index,
      isLoading: isLoading ?? this.isLoading,
      isPublic: isPublic ?? this.isPublic,
    );
  }
}
