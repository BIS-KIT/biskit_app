import 'dart:io';
import 'dart:typed_data';

import 'package:biskit_app/common/components/thumbnail_icon_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/review/components/review_card_widget.dart';
import 'package:biskit_app/review/model/res_review_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';
// import 'package:social_share/social_share.dart';

class ReviewShareScreen extends StatefulWidget {
  final String imageUrl;
  final MeetUpModel meetUpModel;
  final ResReviewModel resReviewModel;

  const ReviewShareScreen({
    Key? key,
    required this.imageUrl,
    required this.meetUpModel,
    required this.resReviewModel,
  }) : super(key: key);

  @override
  State<ReviewShareScreen> createState() => _ReviewShareScreenState();
}

class _ReviewShareScreenState extends State<ReviewShareScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  // Future<String?> screenshot() async {
  //   var data = await screenshotController.capture();
  //   logger.d(data);
  //   if (data == null) {
  //     return null;
  //   }
  //   final tempDir = await getTemporaryDirectory();
  //   final assetPath = '${tempDir.path}/temp.png';
  //   File file = await File(assetPath).create();
  //   await file.writeAsBytes(data);
  //   return file.path;
  // }

  Future<String> saveImage(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final assetPath = '${tempDir.path}/temp.png';
    File file = await File(assetPath).create();
    await file.writeAsBytes(bytes);
    logger.d('hi ${file.path}');

    // final time = DateTime.now()
    //     .toIso8601String()
    //     .replaceAll('.', '-')
    //     .replaceAll(':', '-');
    // final name = 'biskit_screenshot_$time';

    // final result = await ImageGallerySaver.saveImage(bytes, name: name);
    // logger.d('aaa ${result['filePath']}');
    return file.path;
  }

  // Future saveAndShare(Uint8List bytes) async {
  //   await Share
  // }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final DateFormat dateFormat1 = DateFormat('MM/dd(EEE)', 'ko');
    final DateFormat dateFormat2 = DateFormat('a h:mm', 'ko');

    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        backgroundColor: kColorBgDefault,
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              kColorBgPrimaryWeak,
              kColorBgSecondaryWeak,
            ],
          )),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: GestureDetector(
                      onTap: () async {
                        final image = await screenshotController.capture();
                        logger.d('bbb $image');
                        if (image == null) return;
                        var path = await saveImage(image);
                        logger.d(path);
                        // SocialShare.shareInstagramStory(
                        //   appId: '',
                        //   imagePath:
                        //       'https://mblogthumb-phinf.pstatic.net/MjAxOTA1MTBfMjUz/MDAxNTU3NDU5NTk3NTAz.sAXFbUkcZREWgmKkKSp5mW0EfEgwktGgKNI5WY5fBnQg.HiAwbIRexCr-sDi-PFJZV9Gp-8jR85EbDTwAjTrSRxQg.PNG.jinmichu/02.png?type=w800',
                        // ).then((data) {
                        //   print('kkkkk $path $data');
                        // });
                      },
                      child: const Text('Instagram')),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ReviewCardWidget(
                          width: size.width,
                          imagePath: widget.imageUrl,
                          reviewImgType: ReviewImgType.networkImage,
                          isShowLogo: true,
                          isShowFlag: true,
                          flagCodeList: widget
                              .resReviewModel.creator.user_nationality
                              .map((e) => e.nationality.code)
                              .toList(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            ThumbnailIconWidget(
                              size: 40,
                              isSelected: false,
                              radius: 8,
                              iconSize: 32,
                              padding: 4,
                              iconPath: widget.meetUpModel.image_url ??
                                  kCategoryDefaultPath,
                              thumbnailIconType: ThumbnailIconType.network,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    widget.meetUpModel.name,
                                    style: getTsBody14Sb(context).copyWith(
                                      color: kColorContentDefault,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        widget.meetUpModel.meeting_time.isEmpty
                                            ? ''
                                            : dateFormat1.format(DateTime.parse(
                                                widget
                                                    .meetUpModel.meeting_time)),
                                        style: getTsBody14Rg(context).copyWith(
                                          color: kColorContentWeaker,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '·',
                                        style: getTsBody14Rg(context).copyWith(
                                          color: kColorContentWeakest,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        widget.meetUpModel.meeting_time.isEmpty
                                            ? ''
                                            : dateFormat2.format(DateTime.parse(
                                                widget
                                                    .meetUpModel.meeting_time)),
                                        style: getTsBody14Rg(context).copyWith(
                                          color: kColorContentWeaker,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '·',
                                        style: getTsBody14Rg(context).copyWith(
                                          color: kColorContentWeakest,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: Text(
                                          widget.meetUpModel.location,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              getTsBody14Rg(context).copyWith(
                                            color: kColorContentWeaker,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
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
