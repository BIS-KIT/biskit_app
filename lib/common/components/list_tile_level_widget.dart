import 'package:biskit_app/common/utils/string_util.dart';
import 'package:flutter/material.dart';

import 'package:biskit_app/common/components/checkbox_widget.dart';
import 'package:biskit_app/common/components/level_bar_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';

class ListTileLevelWidget extends StatelessWidget {
  final bool isChkecked;
  final int level;
  final Function()? onTap;
  const ListTileLevelWidget({
    Key? key,
    required this.isChkecked,
    required this.level,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(
          top: 16,
          bottom: 16,
          right: 8,
        ),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CheckboxWidget(
                value: isChkecked,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        getLevelTitle(level),
                        style: getTsBody16Rg(context).copyWith(
                          color: kColorContentWeak,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      LevelBarWidget(
                        level: level,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    getLevelSubTitle(level),
                    style: getTsBody14Rg(context).copyWith(
                      color: kColorContentWeakest,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
