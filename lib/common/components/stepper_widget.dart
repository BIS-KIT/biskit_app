import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';

class StepperWidget extends StatelessWidget {
  final Function() onClickMinus;
  final Function() onClickPlus;
  final int value;
  final int maxValue;
  final int minValue;

  const StepperWidget({
    Key? key,
    required this.onClickMinus,
    required this.onClickPlus,
    required this.value,
    this.maxValue = 10,
    this.minValue = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onClickMinus,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    minValue == value ? kColorBgElevation1 : kColorBgElevation2,
              ),
              child: SvgPicture.asset(
                'assets/icons/ic_minus_line_24.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  minValue == value
                      ? kColorContentDisabled
                      : kColorContentDefault,
                  BlendMode.srcIn,
                ),
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
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    maxValue == value ? kColorBgElevation1 : kColorBgElevation2,
              ),
              child: SvgPicture.asset(
                'assets/icons/ic_plus_line_24.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  maxValue == value
                      ? kColorContentDisabled
                      : kColorContentDefault,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
