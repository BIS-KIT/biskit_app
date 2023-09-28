// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:biskit_app/common/const/colors.dart';

class ListWidget extends StatelessWidget {
  final double? height;
  final Widget touchWidget;
  final Widget centerWidget;
  final Widget? rightWidget;
  final Color borderColor;
  final bool isSubComponent;
  final Function()? onTap;
  const ListWidget({
    Key? key,
    this.height,
    required this.touchWidget,
    required this.centerWidget,
    this.rightWidget,
    this.borderColor = kColorBorderDefalut,
    this.isSubComponent = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: isSubComponent
          ? const EdgeInsets.only(
              top: 16,
              bottom: 16,
              right: 8,
            )
          : const EdgeInsets.only(right: 8),
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
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: touchWidget,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: centerWidget,
                  ),
                ],
              ),
            ),
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
