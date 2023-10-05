import 'package:biskit_app/common/components/check_circle.dart';
import 'package:biskit_app/common/components/level_bar_widget.dart';
import 'package:biskit_app/common/components/list_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/string_util.dart';
import 'package:flutter/material.dart';

class LangLevelListWidget extends StatefulWidget {
  final int level;
  final Function(int) callback;
  const LangLevelListWidget({
    Key? key,
    this.level = 0,
    required this.callback,
  }) : super(key: key);

  @override
  State<LangLevelListWidget> createState() => _LangLevelListWidgetState();
}

class _LangLevelListWidgetState extends State<LangLevelListWidget> {
  List<LevelModel> levelList = [
    LevelModel(
      level: 5,
      isChecked: false,
    ),
    LevelModel(
      level: 4,
      isChecked: false,
    ),
    LevelModel(
      level: 3,
      isChecked: false,
    ),
    LevelModel(
      level: 2,
      isChecked: false,
    ),
    LevelModel(
      level: 1,
      isChecked: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    setState(() {
      levelList = levelList
          .map((e) => e.level == widget.level
              ? e.copyWith(
                  isChecked: true,
                )
              : e)
          .toList();
    });
  }

  onTapLevel(LevelModel l) {
    setState(() {
      levelList = levelList
          .map((e) => e.level == l.level
              ? e.copyWith(
                  isChecked: !l.isChecked,
                )
              : e.copyWith(
                  isChecked: l.isChecked ? e.isChecked : l.isChecked,
                ))
          .toList();
    });

    if (!l.isChecked) {
      // 선택시
      widget.callback(l.level);
      Navigator.pop(context, l.level);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Column(
            children: [
              ...levelList
                  .map(
                    (e) => ListWidget(
                      touchWidget: CheckCircleWidget(
                        value: e.isChecked,
                      ),
                      onTap: () {
                        onTapLevel(e);
                      },
                      isSubComponent: true,
                      borderColor: e == levelList.last
                          ? kColorBgDefault
                          : kColorBorderDefalut,
                      centerWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                getLevelTitle(e.level),
                                style: getTsBody16Sb(context).copyWith(
                                  color: kColorContentWeak,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              LevelBarWidget(
                                level: e.level,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            getLevelSubTitle(e.level),
                            style: getTsBody14Rg(context).copyWith(
                              color: kColorContentWeakest,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(
              bottom: 34,
            ),
          ),
        ],
      ),
    );
  }
}

class LevelModel {
  final int level;
  final bool isChecked;
  LevelModel({
    required this.level,
    required this.isChecked,
  });

  LevelModel copyWith({
    int? level,
    String? title,
    String? subTitle,
    bool? isChecked,
  }) {
    return LevelModel(
      level: level ?? this.level,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
