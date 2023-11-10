import 'package:biskit_app/common/components/thumbnail_icon_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:flutter/material.dart';

class CategoryItemWidget extends StatelessWidget {
  final String iconPath;
  final String text;
  const CategoryItemWidget({
    Key? key,
    required this.iconPath,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      child: Column(
        children: [
          ThumbnailIconWidget(
            sizeType: ThumbnailIconSizeType.medium,
            iconColor: kColorContentDefault,
            iconUrl: iconPath,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            text,
            style: getTsBody14Rg(context).copyWith(
              color: kColorContentWeak,
            ),
          ),
        ],
      ),
    );
  }
}
