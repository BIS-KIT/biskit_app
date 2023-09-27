// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CheckCircleWidget extends StatelessWidget {
  final bool value;
  final Function()? onTap;
  const CheckCircleWidget({
    Key? key,
    required this.value,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        value ? 'assets/icons/Checked=Yes.svg' : 'assets/icons/Checked=No.svg',
        width: 24,
        height: 24,
      ),
    );
  }
}
