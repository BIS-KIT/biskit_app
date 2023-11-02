import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChipWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function()? onClickSelect;
  final ValueChanged<String>? onTapAdd;
  // final Function()? onTapAdd;
  final Function()? onTapDelete;
  final FocusNode? focusNode;
  final int? order;
  final String rightIcon;
  final Color rightIconColor;
  final Color textColor;
  const ChipWidget({
    Key? key,
    required this.text,
    required this.isSelected,
    this.onClickSelect,
    this.onTapAdd,
    this.onTapDelete,
    this.focusNode,
    this.order,
    this.rightIcon = 'assets/icons/ic_cancel_line_24.svg',
    this.rightIconColor = kColorContentOnBgPrimary,
    this.textColor = kColorContentOnBgPrimary,
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
            color: isSelected ? kColorBgPrimaryWeak : Colors.transparent,
            border: Border.all(
              width: 1,
              color:
                  isSelected ? kColorBorderPrimaryStrong : kColorBorderStrong,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                if (order != null)
                  CircleAvatar(
                    backgroundColor: kColorBgInverse,
                    minRadius: 8,
                    child: Text(
                      order.toString(),
                      textAlign: TextAlign.center,
                      style: kTsKrCaption11Rg.copyWith(
                        color: kColorContentInverse,
                      ),
                    ),
                  ),
                if (onTapAdd != null)
                  GestureDetector(
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
                if (onTapAdd == null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: getTsBody14Rg(context).copyWith(
                        color: kColorContentOnBgPrimary,
                      ),
                    ),
                  )
                else
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: SizedBox(
                          width: 57,
                          height: 20,
                          child: TextFormField(
                            onChanged: onTapAdd,
                            focusNode: focusNode,
                            cursorHeight: 14,
                            style: getTsBody14Rg(context)
                                .copyWith(color: kColorContentOnBgPrimary),
                            decoration: InputDecoration.collapsed(
                              border: InputBorder.none,
                              hintText: '직접 입력',
                              hintStyle: getTsBody14Rg(context).copyWith(
                                color: kColorContentOnBgPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (onTapDelete != null)
                  GestureDetector(
                    onTap: onTapDelete,
                    child: SvgPicture.asset(
                      rightIcon,
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        rightIconColor,
                        BlendMode.srcIn,
                      ),
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
