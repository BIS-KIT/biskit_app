import 'package:biskit_app/common/components/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:photo_manager/photo_manager.dart';

enum ReviewImgType { networkImage, photoModel }

class ReviewCardWidget extends StatelessWidget {
  final double width;
  final ReviewImgType reviewImgType;
  final String? imagePath;
  final PhotoModel? photoModel;
  final bool isShowLock;
  final bool isShowDelete;
  final bool isShowFlag;
  final bool isShowLogo;
  final List<String>? flagCodeList;
  const ReviewCardWidget({
    Key? key,
    required this.width,
    required this.reviewImgType,
    this.imagePath,
    this.photoModel,
    this.isShowLock = false,
    this.isShowDelete = false,
    this.isShowFlag = false,
    this.isShowLogo = false,
    this.flagCodeList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double padding = 0;
    double spacing = 0;
    if (width >= 320) {
      padding = 20;
      spacing = 6;
    } else {
      padding = 12;
      spacing = 4;
    }
    return Stack(
      children: [
        if (reviewImgType == ReviewImgType.networkImage)
          Container(
            width: width,
            height: width,
            decoration: BoxDecoration(
              color: const Color(0xff000000).withOpacity(0.15),
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              image: imagePath == null || imagePath!.isEmpty
                  ? null
                  : DecorationImage(
                      image: NetworkImage(
                        imagePath!,
                      ),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        if (reviewImgType == ReviewImgType.photoModel)
          Container(
            width: width,
            height: width,
            decoration: BoxDecoration(
              color: const Color(0xff000000).withOpacity(0.15),
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              image: photoModel == null
                  ? null
                  : DecorationImage(
                      image: AssetEntityImageProvider(photoModel!.assetEntity!),
                      fit: BoxFit.cover,
                    ),
            ),
          ),

        // show lock
        if (isShowLock)
          Positioned(
            top: padding,
            left: padding,
            child: SvgPicture.asset(
              'assets/icons/ic_lock_fill_24.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                kColorContentInverseWeak,
                BlendMode.srcIn,
              ),
            ),
          ),

        // show delete
        if (isShowDelete)
          Positioned(
            top: padding,
            right: padding,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: kColorBorderWeak,
                  width: 1,
                ),
                color: kColorBgOverlay.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/icons/ic_cancel_line_24.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  kColorContentInverse,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),

        // show logo
        if (isShowFlag || isShowLogo)
          Container(
            // bottom: padding,
            // right: padding,
            width: width,
            height: width,
            padding: EdgeInsets.all(padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: [
                      if (flagCodeList != null && isShowFlag)
                        ...flagCodeList!
                            .map(
                              (e) => FlagWidget(
                                flagCode: e,
                                size: 16,
                              ),
                              // ClipRRect(
                              //       borderRadius: const BorderRadius.all(
                              //         Radius.circular(16),
                              //       ),
                              //       child: SvgPicture.network(
                              //         '$kS3Url$kS3Flag11Path/$e.svg',
                              //         width: 16,
                              //         height: 16,
                              //         fit: BoxFit.cover,
                              //       ),
                              //     ),
                            )
                            .toList(),
                    ],
                  ),
                ),
                if (isShowLogo)
                  SvgPicture.asset(
                    'assets/icons/biskit_signature_mono.svg',
                    width: 43,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      kColorContentInverse,
                      BlendMode.srcIn,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
