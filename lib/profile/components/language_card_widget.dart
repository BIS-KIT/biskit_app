import 'package:biskit_app/common/utils/string_util.dart';
import 'package:flutter/material.dart';

import 'package:biskit_app/common/components/level_bar_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/profile/model/available_language_model.dart';

class LanguageCardWidget extends StatelessWidget {
  final List<AvailableLanguageModel> langList;
  const LanguageCardWidget({
    Key? key,
    required this.langList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 4,
        left: 12,
        bottom: 10,
        right: 12,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: kColorBgDefault,
        boxShadow: [
          BoxShadow(
            color: Color(0x11495B7D),
            blurRadius: 4,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Wrap(
        spacing: 12,
        children: [
          // Language level
          ...langList
              .map((l) => Column(
                    children: [
                      Text(
                        // TODO 언어 코드 가져오는거 필요함
                        'KR',
                        style: getTsBody14Sb(context).copyWith(
                          color: kColorContentWeaker,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      LevelBarWidget(
                        level: getLevelServerValueToInt(l.level),
                      ),
                    ],
                  ))
              .toList(),
        ],
      ),
    );
  }
}
