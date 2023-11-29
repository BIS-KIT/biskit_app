import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/meet/view/my_meet_up_list_screen.dart';

class ReviewWriteCardWidget extends StatelessWidget {
  final double? width;
  const ReviewWriteCardWidget({
    Key? key,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(MyMeetUpListScreen.routeName);
      },
      child: Container(
        height: width ?? 164,
        width: width,
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          color: kColorBgElevation3,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/ic_plus_line_24.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                kColorContentWeaker,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              '인증샷을 남겨보세요',
              style: getTsBody14Sb(context).copyWith(
                color: kColorContentWeaker,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
