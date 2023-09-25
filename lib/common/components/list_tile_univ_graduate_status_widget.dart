import 'package:biskit_app/common/model/university_graduate_status_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:biskit_app/common/components/checkbox_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';

class ListTileUnivGraduateStatusWidget extends StatelessWidget {
  final UniversityGraduateStatusModel model;
  final Function()? onTap;
  const ListTileUnivGraduateStatusWidget({
    Key? key,
    required this.model,
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
              color: kColorGray3,
            ),
          ),
        ),
        child: Row(
          children: [
            CheckboxWidget(
              value: model.isCheck,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Text(
                context.locale.countryCode == 'KR' ? model.kname : model.ename,
                style: getTsBody16Rg(context).copyWith(
                  color: kColorGray8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
