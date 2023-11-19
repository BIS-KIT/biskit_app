import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:flutter/material.dart';

class NumberBadgeWidget extends StatelessWidget {
  final int number;
  final Color backgroundColor;
  final Color numberColor;
  const NumberBadgeWidget({
    Key? key,
    required this.number,
    this.backgroundColor = kColorBgNotification,
    this.numberColor = kColorContentInverse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 16,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            color: backgroundColor,
          ),
        ),
        Text(
          '$number',
          style: getTsCaption11Rg(context).copyWith(
            color: numberColor,
          ),
        ),
      ],
    );
  }
}
