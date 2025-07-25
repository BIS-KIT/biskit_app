import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// TODO: Chip 종류에 따라 bg, text 다르게 해서 타입별로 선택할 수 있도록 수정 필요
class ChipWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function()? onClickSelect;
  final ValueChanged<String>? onTapAdd;
  final Function()? onTapDelete;
  final ValueChanged<String>? onTapEnter;
  final FocusNode? focusNode;
  final int? order;
  final String rightIcon;
  final Color rightIconColor;
  final Color? textColor;
  final Color? selectedTextColor;
  final TextEditingController? controller;
  final Color? selectedColor;
  final Color? selectedBorderColor;
  const ChipWidget({
    Key? key,
    required this.text,
    required this.isSelected,
    this.onClickSelect,
    this.onTapAdd,
    this.onTapDelete,
    this.onTapEnter,
    this.focusNode,
    this.order,
    this.rightIcon = 'assets/icons/ic_cancel_line_24.svg',
    this.rightIconColor = kColorContentOnBgPrimary,
    this.textColor = kColorContentOnBgPrimary,
    this.controller,
    this.selectedColor = kColorBgPrimaryWeak,
    this.selectedTextColor = kColorContentDefault,
    this.selectedBorderColor = kColorBorderPrimaryStrong,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClickSelect,
      child: SizedBox(
        height: 36,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? selectedColor : Colors.transparent,
              border: Border.all(
                width: 1,
                color: isSelected ? selectedBorderColor! : kColorBorderStrong,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                          color: isSelected ? selectedTextColor : textColor,
                        ),
                      ),
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: SizedBox(
                            width: 50,
                            child: TextFormField(
                              textInputAction: TextInputAction.go,
                              onFieldSubmitted: onTapEnter,
                              onChanged: onTapAdd,
                              focusNode: focusNode,
                              controller: controller,
                              maxLength: 10,
                              style: getTsBody14Rg(context)
                                  .copyWith(color: kColorContentOnBgPrimary),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                hintText: 'createMeetupScreen1.custom'.tr(),
                                hintStyle: getTsBody14Rg(context).copyWith(
                                  color: kColorContentOnBgPrimary,
                                ),
                                isDense: true,
                                counterText: '',
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
      ),
    );
  }
}
