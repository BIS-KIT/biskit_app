import 'package:flutter/material.dart';

import 'package:biskit_app/common/const/colors.dart';

class ListWidget extends StatelessWidget {
  final double height;
  final Widget touchWidget;
  final Widget text;
  final Widget? rightWidget;
  final Color borderColor;
  final Function()? onTap;
  const ListWidget({
    Key? key,
    this.height = 56,
    required this.touchWidget,
    required this.text,
    this.rightWidget,
    this.borderColor = kColorBorderDefalut,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: kColorBgDefault,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: borderColor,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: touchWidget,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(
            child: text,
          ),
          const SizedBox(
            width: 4,
          ),
          rightWidget == null ? Container() : rightWidget!,
        ],
      ),
    );
  }
}
