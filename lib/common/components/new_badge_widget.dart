import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';

enum BadgeType { primary, secondary, teritary }

enum BadgeSize { L, M }

Map<String, Map<BadgeType, Color>> badgeColorVariants = {
  'bgColor': {
    BadgeType.primary: kColorBgInverseWeak,
    BadgeType.secondary: kColorBgSecondaryWeak,
    BadgeType.teritary: kColorBgElevation2,
  },
  'textColor': {
    BadgeType.primary: kColorContentInverse,
    BadgeType.secondary: kColorContentSecondary,
    BadgeType.teritary: kColorContentWeaker,
  },
};
Map<String, Map<String, TextStyle>> badgeTextStyleMap = {
  'BadgeType.primaryL': {'font': kTsKrBody14Sb},
  'secondaryL': {'font': kTsKrBody14Sb},
  'tertiaryL': {'font': kTsKrBody14Rg},
  'primaryM': {'font': kTsKrCaption12Sb},
  'secondaryM': {'font': kTsKrCaption12Sb},
  'tertiaryM': {'font': kTsKrCaption12Rg},
};

class NewBadgeWidget extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isShowLeftIcon;
  final bool isShowRightIcon;
  final BadgeType type;
  final BadgeSize size;
  const NewBadgeWidget({
    Key? key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.isShowLeftIcon = false,
    this.isShowRightIcon = false,
    required this.type,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String getKey(BadgeType type, BadgeSize size) {
      return '${type.toString().split('.').last}${size.toString().split('.').last}';
    }

    String key = getKey(type, size);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: size == BadgeSize.L ? 6 : 4,
      ),
      decoration: BoxDecoration(
        color: badgeColorVariants['bgColor']?[type] ?? kColorBgInverseWeak,
        borderRadius: BorderRadius.all(
          Radius.circular(size == BadgeSize.L ? 8 : 6),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isShowLeftIcon)
            SvgPicture.asset(
              'assets/icons/ic_cancel_line_24.svg',
              width: size == BadgeSize.L ? 16 : 12,
              height: size == BadgeSize.L ? 16 : 12,
              colorFilter: const ColorFilter.mode(
                kColorContentWeaker,
                BlendMode.srcIn,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 2,
            ),
            child: Text(
              text,
              style: badgeTextStyleMap[key]?['font']!
                  .copyWith(color: badgeColorVariants['textColor']![type]),
            ),
          ),
          if (isShowRightIcon)
            SvgPicture.asset(
              'assets/icons/ic_cancel_line_24.svg',
              width: size == BadgeSize.L ? 16 : 12,
              height: size == BadgeSize.L ? 16 : 12,
              colorFilter: const ColorFilter.mode(
                kColorContentWeaker,
                BlendMode.srcIn,
              ),
            ),
        ],
      ),
    );
  }
}
