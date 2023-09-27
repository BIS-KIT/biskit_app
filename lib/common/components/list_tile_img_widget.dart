import 'package:biskit_app/common/components/check_circle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/model/national_flag_model.dart';

class ListTileImgWidget extends StatelessWidget {
  final NationalFlagModel model;
  final bool isCheck;
  final Function()? onTap;
  const ListTileImgWidget({
    Key? key,
    required this.model,
    required this.isCheck,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
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
            // TODO 국기 이미지 추가
            Container(
              width: 32,
              height: 24,
              color: Colors.amber,
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
            CheckCircleWidget(
              value: isCheck,
            ),
          ],
        ),
      ),
    );
  }
}
