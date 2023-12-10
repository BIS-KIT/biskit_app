import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:flutter/material.dart';

class BtnTagWidget extends StatelessWidget {
  final String label;
  final String emoji;
  final Function()? onTap;
  const BtnTagWidget({
    Key? key,
    required this.label,
    required this.emoji,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 6,
        left: 6,
        bottom: 6,
        right: 16,
      ),
      decoration: const BoxDecoration(
        color: kColorBgDefault,
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: kColorBgElevation2,
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            label,
            style: getTsBody16Rg(context).copyWith(
              color: kColorContentWeak,
            ),
          )
        ],
      ),
    );
  }
}
