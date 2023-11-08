// ignore_for_file: non_constant_identifier_names

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:biskit_app/common/components/level_bar_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/string_util.dart';
import 'package:biskit_app/profile/model/available_language_model.dart';

class UseLanguageModalWidget extends StatelessWidget {
  final List<AvailableLanguageModel> available_languages;
  const UseLanguageModalWidget({
    Key? key,
    required this.available_languages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.only(
          top: 16,
          bottom: 24,
        ),
        decoration: const BoxDecoration(
          color: kColorBgDefault,
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '사용가능언어',
                      style: getTsHeading18(context).copyWith(
                        color: kColorContentDefault,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        'assets/icons/ic_cancel_line_24.svg',
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          kColorContentDefault,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ...available_languages
                      .mapIndexed(
                        (index, l) => Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: index == available_languages.length - 1
                                    ? 0
                                    : 1,
                                color: kColorBorderDefalut,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l.language.kr_name,
                                style: getTsBody16Sb(context).copyWith(
                                  color: kColorContentWeak,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    getLevelServerValueToKrString(l.level),
                                    style: getTsBody16Sb(context).copyWith(
                                      color: kColorContentSecondary,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  LevelBarWidget(
                                    level: getLevelServerValueToInt(l.level),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
