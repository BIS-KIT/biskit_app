import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StepperWidget extends StatelessWidget {
  final Function() onClickMinus;
  final Function() onClickPlus;
  final int value;

  const StepperWidget({
    Key? key,
    required this.onClickMinus,
    required this.onClickPlus,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onClickMinus,
          child: Container(
            width: 40,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kColorBgElevation2,
            ),
            child: SvgPicture.asset(
              'assets/icons/ic_minus_line_24.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                kColorContentDefault,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        Container(
          width: 72,
          alignment: Alignment.center,
          child: Text(
            value.toString(),
            style: getTsHeading18(context).copyWith(
              color: kColorContentWeak,
            ),
          ),
        ),
        GestureDetector(
          onTap: onClickPlus,
          child: Container(
            width: 40,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kColorBgElevation2,
            ),
            child: SvgPicture.asset(
              'assets/icons/ic_plus_line_24.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                kColorContentDefault,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
