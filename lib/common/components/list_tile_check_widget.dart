import 'package:biskit_app/common/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:biskit_app/common/components/checkbox_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';

class ListTileCheckWidget extends StatelessWidget {
  final String text;
  final bool isChkecked;
  final bool isLevelView;
  final int level;
  final Function()? onTap;
  final Function()? onTapLevel;
  const ListTileCheckWidget({
    Key? key,
    required this.text,
    required this.isChkecked,
    this.isLevelView = false,
    this.onTap,
    this.level = 0,
    this.onTapLevel,
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
              child: Text(
                text,
                style: getTsBody16Rg(context).copyWith(
                  color: kColorGray8,
                ),
              ),
            ),
            if (isChkecked && isLevelView)
              Row(
                children: [
                  const SizedBox(
                    width: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 8,
                    ),
                    child: GestureDetector(
                      onTap: onTapLevel,
                      child: Container(
                        height: double.infinity,
                        padding: const EdgeInsets.only(
                          left: 24,
                        ),
                        child: Row(
                          children: [
                            Text(
                              getLevelTitle(level),
                              style: getTsBody16Rg(context).copyWith(
                                color: kColorGray7,
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/icons/ic_chevron_down_line_24.svg',
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
