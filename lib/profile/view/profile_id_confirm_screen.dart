// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/tooltip_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/enums.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/repository/util_repository.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:biskit_app/profile/model/profile_create_model.dart';
import 'package:biskit_app/profile/model/student_card_model.dart';
import 'package:biskit_app/profile/model/student_verification_model.dart';
import 'package:biskit_app/profile/repository/profile_repository.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:photo_manager/photo_manager.dart';

class ProfileIdConfirmScreen extends ConsumerStatefulWidget {
  static String get routeName => 'profileIdConfirm';
  final ProfileCreateModel? profileCreateModel;
  final bool isEditor;
  const ProfileIdConfirmScreen({
    Key? key,
    this.profileCreateModel,
    this.isEditor = false,
  }) : super(key: key);

  @override
  ConsumerState<ProfileIdConfirmScreen> createState() =>
      _ProfileIdConfirmScreenState();
}

class _ProfileIdConfirmScreenState
    extends ConsumerState<ProfileIdConfirmScreen> {
  PhotoModel? selectedPhotoModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 파일 업로드
  Future<String?> studentCardPhotoUpload() async {
    String? studentCardPhoto;
    if (selectedPhotoModel != null) {
      try {
        studentCardPhoto = await ref.read(utilRepositoryProvider).uploadImage(
              photo: selectedPhotoModel!,
              uploadImageType: UploadImageType.STUDENT_CARD,
            );
      } finally {}
      logger.d('uploadFilePath : $studentCardPhoto');
    }
    return studentCardPhoto;
  }

  // 인증하기
  onTapAuthenticate() async {
    context.loaderOverlay.show();
    final UserModelBase? userModelBase = ref.watch(userMeProvider);
    String? studentCardPhoto = await studentCardPhotoUpload();

    if (studentCardPhoto != null &&
        userModelBase != null &&
        userModelBase is UserModel) {
      StudentVerificationModel? studentVerificationModel =
          await ref.read(profileRepositoryProvider).postStudentVarification(
                student_card: studentCardPhoto,
                user_id: userModelBase.id,
              );
      if (studentVerificationModel != null) {
        if (!mounted) return;
        ref.read(userMeProvider.notifier).getMe();
        Navigator.pop(context);
      }
    }
    if (!mounted) return;
    context.loaderOverlay.hide();
  }

  // 등록하기
  submit(bool isPhoto) async {
    context.loaderOverlay.show();
    String? studentCardPhoto;
    if (isPhoto) {
      if (selectedPhotoModel != null) {
        studentCardPhoto = await studentCardPhotoUpload();
      } else {
        return;
      }
    }
    if (widget.profileCreateModel != null) {
      await ref.read(profileRepositoryProvider).createProfile(
            profileCreateModel: isPhoto
                ? widget.profileCreateModel!.copyWith(
                    student_card: StudentCard(
                      student_card: studentCardPhoto!,
                      verification_status: VerificationStatus.PENDING.name,
                    ),
                  )
                : widget.profileCreateModel!,
          );
    }

    if (!mounted) return;
    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return DefaultLayout(
      title: '',
      leadingIconPath: widget.isEditor
          ? 'assets/icons/ic_cancel_line_24.svg'
          : 'assets/icons/ic_arrow_back_ios_line_24.svg',
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            padding: const EdgeInsets.only(
              right: 10,
            ),
            child: Text(
              widget.isEditor ? '' : '4 / 4',
              style: getTsBody14Rg(context).copyWith(
                color: kColorContentWeakest,
              ),
            ),
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 설명
            _buildTop(context),
            const SizedBox(
              height: 24,
            ),

            // Student ID area
            GestureDetector(
              onTap: () async {
                final List result = await Navigator.push(
                      context,
                      createUpDownRoute(
                        const PhotoManagerScreen(
                          isCamera: true,
                          maxCnt: 1,
                        ),
                      ),
                    ) ??
                    [];
                logger.d(result);
                setState(() {
                  selectedPhotoModel = result[0];
                });
              },
              child: Container(
                width: size.width - 40,
                height: size.height * 0.47,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: kColorBgElevation3,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                clipBehavior: Clip.hardEdge,
                child: selectedPhotoModel == null
                    ? _buildIdCard(context)
                    : selectedPhotoModel!.photoType == PhotoType.asset
                        ? AssetEntityImage(
                            selectedPhotoModel!.assetEntity!,
                            fit: BoxFit.contain,
                          )
                        : Image.file(
                            File(
                              selectedPhotoModel!.cameraXfile!.path,
                            ),
                            fit: BoxFit.contain,
                          ),
              ),
            ),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 34,
              ),
              child: Column(
                children: [
                  if (!widget.isEditor)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            submit(false);
                          },
                          child: Text(
                            'verifyUnivScreen.later'.tr(),
                            style: getTsBody14Rg(context).copyWith(
                              color: kColorBorderStrong,
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  widget.isEditor
                      ? GestureDetector(
                          onTap: () async {
                            await onTapAuthenticate();
                          },
                          child: FilledButtonWidget(
                            text: 'verifyUnivScreen.verify'.tr(),
                            fontSize: FontSize.l,
                            isEnable: selectedPhotoModel != null,
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            // context.loaderOverlay.show();

                            if (selectedPhotoModel != null) {
                              await submit(true);
                            }
                            // if (mounted) {
                            //   context.loaderOverlay.hide();
                            // }
                          },
                          child: FilledButtonWidget(
                            text: 'verifyUnivScreen.done'.tr(),
                            fontSize: FontSize.l,
                            isEnable: selectedPhotoModel != null,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildIdCard(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            // height: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            color: kColorBgPrimary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/ic_plus_line_24.svg',
                  width: 40,
                  height: 40,
                  colorFilter: const ColorFilter.mode(
                    kColorContentOnBgPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  'verifyUnivScreen.addIdCard.title'.tr(),
                  style: getTsHeading18(context).copyWith(
                    color: kColorContentOnBgPrimary,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'verifyUnivScreen.addIdCard.subtitle'.tr(),
                  style: getTsBody14Rg(context).copyWith(
                    color: kColorContentOnBgPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'verifyUnivScreen.addIdCard.description1'.tr(),
                style: getTsBody14Sb(context).copyWith(
                  color: kColorContentWeaker,
                ),
              ),
              Text(
                'verifyUnivScreen.addIdCard.description2'.tr(),
                style: getTsBody14Rg(context).copyWith(
                  color: kColorContentWeaker,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _buildTop(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        Text(
          'verifyUnivScreen.title'.tr(),
          style: getTsHeading24(context).copyWith(
            color: kColorContentDefault,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        TooltipWidget(
          preferredDirection: AxisDirection.down,
          tooltipText: 'verifyUnivScreen.reason.description'.tr(),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/ic_help_fill_24.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  kColorContentWeaker,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                'verifyUnivScreen.reason.label'.tr(),
                style: getTsBody14Rg(context).copyWith(
                  color: kColorContentWeaker,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
