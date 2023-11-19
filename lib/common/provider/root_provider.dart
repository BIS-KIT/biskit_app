import 'package:biskit_app/common/const/colors.dart';
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
  }

  init() {
    state = state.copyWith(
      index: 0,
      scafoldBackgroundColor: kColorBgDefault,
    );
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
