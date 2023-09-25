import 'package:flutter/material.dart';

import '../const/colors.dart';
import '../const/fonts.dart';

enum SelectWidgetValueType {
  none,
  left,
  right,
}

class SelectWidget extends StatelessWidget {
  final String leftText;
  final String rightText;
  final SelectWidgetValueType value;
  final Function()? onTapLeft;
  final Function()? onTapRight;
  const SelectWidget({
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
                color: value == SelectWidgetValueType.left
                    ? kColorYellow1
                    : Colors.transparent,
                border: Border.all(
                  width: 1,
                  color: value == SelectWidgetValueType.left
                      ? kColorYellow5
                      : kColorGray4,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(6)),
              ),
              alignment: Alignment.center,
              child: Text(
                leftText,
                style: value == SelectWidgetValueType.left
                    ? getTsBody16Sb(context).copyWith(
                        color: kColorGray8,
                      )
                    : getTsBody16Rg(context).copyWith(
                        color: kColorGray8,
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
                color: value == SelectWidgetValueType.right
                    ? kColorYellow1
                    : Colors.transparent,
                border: Border.all(
                  width: 1,
                  color: value == SelectWidgetValueType.right
                      ? kColorYellow5
                      : kColorGray4,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(6)),
              ),
              alignment: Alignment.center,
              child: Text(
                rightText,
                style: value == SelectWidgetValueType.right
                    ? getTsBody16Sb(context).copyWith(
                        color: kColorGray8,
                      )
                    : getTsBody16Rg(context).copyWith(
                        color: kColorGray8,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
