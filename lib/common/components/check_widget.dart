// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:biskit_app/common/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CheckWidget extends StatelessWidget {
  final bool value;
  const CheckWidget({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/ic_check_line_24.svg',
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(
        value ? kColorBorderPrimary : kColorContentPlaceholder,
        BlendMode.srcIn,
      ),
    );
  }
}
