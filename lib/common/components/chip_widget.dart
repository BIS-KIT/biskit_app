import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChipWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function() onClickSelect;
  final Function()? onTapAdd;
  final Function()? onTapDelete;

  const ChipWidget({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onClickSelect,
    this.onTapAdd,
    this.onTapDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClickSelect,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: isSelected ? kColorBgPrimaryWeak : kColorBgElevation1,
              border: Border.all(
                  width: 1,
                  color: isSelected
                      ? kColorBorderPrimaryStrong
                      : kColorBorderDefalut),
              borderRadius: const BorderRadius.all(Radius.circular(50))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                if (onTapAdd != null)
                  GestureDetector(
                    onTap: onTapAdd,
                    child: SvgPicture.asset(
                      'assets/icons/ic_plus_line_24.svg',
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        kColorContentDefault,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: getTsBody14Rg(context)
                        .copyWith(color: kColorContentOnBgPrimary),
                  ),
                ),
                if (onTapDelete != null)
                  GestureDetector(
                    onTap: onTapDelete,
                    child: SvgPicture.asset(
                      'assets/icons/ic_cancel_line_24.svg',
                      width: 16,
                      height: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
