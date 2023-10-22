import 'package:biskit_app/common/const/colors.dart';
import 'package:flutter/material.dart';

class ProgressBarWidget extends StatelessWidget {
  final bool isFirstDone;
  final bool isSecondDone;
  final bool isThirdDone;
  final bool isFourthDone;

  const ProgressBarWidget({
    Key? key,
    required this.isFirstDone,
    required this.isSecondDone,
    required this.isThirdDone,
    required this.isFourthDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 4,
            decoration: ShapeDecoration(
              color: isFirstDone ? kColorBgPrimaryStrong : kColorBgElevation2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        Expanded(
          child: Container(
            height: 4,
            decoration: ShapeDecoration(
              color: isSecondDone ? kColorBgPrimaryStrong : kColorBgElevation2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        Expanded(
          child: Container(
            height: 4,
            decoration: ShapeDecoration(
              color: isThirdDone ? kColorBgPrimaryStrong : kColorBgElevation2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        Expanded(
          child: Container(
            height: 4,
            decoration: ShapeDecoration(
              color: isFourthDone ? kColorBgPrimaryStrong : kColorBgElevation2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
