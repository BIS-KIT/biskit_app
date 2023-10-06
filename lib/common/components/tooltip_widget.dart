// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

import '../const/colors.dart';
import '../const/fonts.dart';

class TooltipWidget extends StatefulWidget {
  final String tooltipText;
  final AxisDirection preferredDirection;
  final Widget child;
  const TooltipWidget({
    Key? key,
    required this.tooltipText,
    this.preferredDirection = AxisDirection.down,
    required this.child,
  }) : super(key: key);

  @override
  State<TooltipWidget> createState() => _TooltipWidgetState();
}

class _TooltipWidgetState extends State<TooltipWidget> {
  final JustTheController tooltipController = JustTheController();

  @override
  void dispose() {
    tooltipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return JustTheTooltip(
      controller: tooltipController,
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      backgroundColor: kColorBgOverlay,
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      elevation: 0,
      tailBaseWidth: 20,
      tailLength: 6,
      preferredDirection: widget.preferredDirection,
      content: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          widget.tooltipText,
          style: getTsCaption12Rg(context).copyWith(
            color: kColorContentInverse,
          ),
        ),
      ),
      offset: 8,
      tailBuilder: (tip, point2, point3) {
        return Path()
          ..moveTo(tip.dx - (tip.dx * 0.5), tip.dy)
          ..lineTo(point2.dx - (point2.dx * 0.5), point2.dy)
          ..lineTo(point3.dx - (point3.dx * 0.5), point3.dy)
          ..close();
      },
      // showDuration: const Duration(seconds: 3),
      // isModal: true,

      // waitDuration: const Duration(seconds: 3),
      child: GestureDetector(
        onTap: () {
          tooltipController.showTooltip();
        },
        child: widget.child,
      ),
    );
  }
}
