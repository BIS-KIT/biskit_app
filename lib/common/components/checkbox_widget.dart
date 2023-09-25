// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../const/colors.dart';

class CheckboxWidget extends StatelessWidget {
  final bool value;
  const CheckboxWidget({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: value ? kColorBgPrimary : kColorBgElevation3,
      ),
      child: SvgPicture.asset(
        'assets/icons/check.svg',
        width: 16,
        height: 12,
        colorFilter: ColorFilter.mode(
          value ? kColorContentOnBgPrimary : kColorContentInverse,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
