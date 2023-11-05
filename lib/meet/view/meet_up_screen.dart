import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MeetUpScreen extends ConsumerStatefulWidget {
  final MeetUpModel meetUp;
  const MeetUpScreen({
    Key? key,
    required this.meetUp,
  }) : super(key: key);

  @override
  ConsumerState<MeetUpScreen> createState() => _MeetUpScreenState();
}

class _MeetUpScreenState extends ConsumerState<MeetUpScreen> {
  @override
  Widget build(BuildContext context) {
    logger.d(widget.meetUp);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: DefaultLayout(
        title: '',
        onTapLeading: () {
          Navigator.pop(context);
        },
        shape: const Border(
          bottom: BorderSide(
            color: kColorBorderDefalut,
            width: 1,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 44,
              height: 44,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(right: 10),
              child: SvgPicture.asset(
                'assets/icons/ic_more_horiz_line_24.svg',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
        child: Container(),
      ),
    );
  }
}
