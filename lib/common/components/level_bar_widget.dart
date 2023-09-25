import 'package:biskit_app/common/const/colors.dart';
import 'package:flutter/material.dart';

class LevelBarWidget extends StatelessWidget {
  final int level;
  const LevelBarWidget({
    Key? key,
    required this.level,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 4,
      decoration: const BoxDecoration(
        color: kColorBgElevation3,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          _buildLevel(),
        ],
      ),
    );
  }

  Container _buildLevel() {
    if (level == 1) {
      return Container(
        width: 4,
        height: 4,
        decoration: const BoxDecoration(
          color: kColorContentSecondary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
      );
    } else if (level == 2) {
      return Container(
        width: 8,
        height: 4,
        decoration: const BoxDecoration(
          color: kColorContentSecondary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
      );
    } else if (level == 3) {
      return Container(
        width: 12,
        height: 4,
        decoration: const BoxDecoration(
          color: kColorContentSecondary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
      );
    } else if (level == 4) {
      return Container(
        width: 16,
        height: 4,
        decoration: const BoxDecoration(
          color: kColorContentSecondary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
      );
    } else if (level == 5) {
      return Container(
        width: 20,
        height: 4,
        decoration: const BoxDecoration(
          color: kColorContentSecondary,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      );
    } else {
      return Container();
    }
  }
}
