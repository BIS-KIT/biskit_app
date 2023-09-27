// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:biskit_app/common/const/fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/model/national_flag_model.dart';

import 'check_circle.dart';

class ListFlagWidget extends StatelessWidget {
  final NationalFlagModel model;
  final double height;
  final bool isCheck;
  final Function()? onTap;
  const ListFlagWidget({
    Key? key,
    required this.model,
    this.height = 56,
    required this.isCheck,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: kColorBgElevation3,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: kColorBorderStrong,
              ),
            ),
            child: SvgPicture.network(
              '$kS3Url$kS3Flag43Path/${model.code}.svg',
              width: 32,
              height: 24,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Text(
              context.locale.languageCode == kEn
                  ? model.en_name
                  : model.kr_name,
              style: getTsBody16Rg(context).copyWith(
                color: kColorContentWeak,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CheckCircleWidget(
                value: isCheck,
              ),
            ),
          ),
        ],
      ),
    );
    // GestureDetector(
    //   onTap: onTap,
    //   child: Container(
    //     height: 56,
    //     decoration: const BoxDecoration(
    //       border: Border(
    //         bottom: BorderSide(
    //           width: 1,
    //           color: kColorBgElevation3,
    //         ),
    //       ),
    //     ),
    //     child: Row(
    //       children: [
    //         Container(
    //           decoration: BoxDecoration(
    //             border: Border.all(
    //               width: 1,
    //               color: kColorBorderStrong,
    //             ),
    //           ),
    //           child: SvgPicture.network(
    //             '$kS3Url$kS3Flag43Path/${model.code}.svg',
    //             width: 32,
    //             height: 24,
    //             fit: BoxFit.contain,
    //           ),
    //         ),
    //         const SizedBox(
    //           width: 12,
    //         ),
    //         const SizedBox(
    //           width: 12,
    //         ),
    //         CheckCircleWidget(
    //           value: isCheck,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
