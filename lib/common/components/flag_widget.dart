import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FlagWidget extends StatelessWidget {
  final String flagCode;
  final double size;
  const FlagWidget({
    Key? key,
    required this.flagCode,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(size),
        ),
        border: Border.all(
          width: 1,
          color: kColorBorderStrong,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(size),
        ),
        child: SvgPicture.network(
          '$kS3Url$kS3Flag11Path/$flagCode.svg',
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
