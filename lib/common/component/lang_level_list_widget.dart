import 'package:flutter/material.dart';

import 'package:biskit_app/common/component/filled_button_widget.dart';
import 'package:biskit_app/common/component/list_tile_level_widget.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...levelList
                      .map(
                        (e) => GestureDetector(
                          onTap: () {
                            onTapLevel(e);
                          },
                          child: ListTileLevelWidget(
                            isChkecked: e.isChecked,
                            level: e.level,
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 34,
            ),
            child: GestureDetector(
              onTap: () {
                int level =
                    levelList.singleWhere((element) => element.isChecked).level;
                if (levelList
                    .where((element) => element.isChecked)
                    .isNotEmpty) {
                  widget.callback(level);
                }
                Navigator.pop(context, level);
              },
              child: FilledButtonWidget(
                text: '완료',
                isEnable:
                    levelList.where((element) => element.isChecked).isNotEmpty,
              ),
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
