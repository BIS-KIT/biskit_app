import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationListScreen extends ConsumerStatefulWidget {
  const NotificationListScreen({super.key});

  @override
  ConsumerState<NotificationListScreen> createState() =>
      _NotificationListScreenState();
}

class _NotificationListScreenState
    extends ConsumerState<NotificationListScreen> {
  List notificationHistories = [1, 2, 3];
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '알림',
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                '알림이 없어요',
                style: getTsBody16Rg(context)
                    .copyWith(color: kColorContentWeakest),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
