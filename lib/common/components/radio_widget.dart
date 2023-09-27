import 'package:flutter/material.dart';

import '../const/colors.dart';
import '../const/fonts.dart';

enum RadioWidgetValueType {
  none,
  left,
  right,
}

class RadioWidget extends StatelessWidget {
  final String leftText;
  final String rightText;
  final RadioWidgetValueType value;
  final Function()? onTapLeft;
  final Function()? onTapRight;
  const RadioWidget({
    Key? key,
    this.leftText = '',
    this.rightText = '',
    required this.value,
    required this.onTapLeft,
    required this.onTapRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onTapLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: value == RadioWidgetValueType.left
                    ? kColorBgPrimaryWeak
                    : Colors.transparent,
                border: Border.all(
                  width: 1,
                  color: value == RadioWidgetValueType.left
                      ? kColorBorderPrimaryStrong
                      : kColorBorderStrong,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(6)),
              ),
              alignment: Alignment.center,
              child: Text(
                leftText,
                style: getTsBody16Rg(context).copyWith(
                  color: value == RadioWidgetValueType.left
                      ? kColorContentDefault
                      : kColorContentWeak,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 14,
        ),
        Expanded(
          child: GestureDetector(
            onTap: onTapRight,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: value == RadioWidgetValueType.right
                    ? kColorBgPrimaryWeak
                    : Colors.transparent,
                border: Border.all(
                  width: 1,
                  color: value == RadioWidgetValueType.right
                      ? kColorBorderPrimaryStrong
                      : kColorBorderStrong,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(6)),
              ),
              alignment: Alignment.center,
              child: Text(
                rightText,
                style: getTsBody16Rg(context).copyWith(
                  color: value == RadioWidgetValueType.right
                      ? kColorContentDefault
                      : kColorContentWeak,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
