import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:flutter/material.dart';

class BadgeEmojiWidget extends StatelessWidget {
  final String label;
  final String? emoji;
  const BadgeEmojiWidget({
    Key? key,
    required this.label,
    this.emoji,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: kColorBgElevation1,
        border: Border.all(
          width: 1,
          color: kColorBorderWeak,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(50),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (emoji != null)
            Row(
              children: [
                Text(emoji!),
                const SizedBox(
                  width: 3,
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              label,
              style: getTsBody16Rg(context).copyWith(
                color: kColorContentWeaker,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
