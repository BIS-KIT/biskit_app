import 'dart:async';
import 'dart:io';

import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/full_bleed_button_widget.dart';
import 'package:biskit_app/common/components/text_input_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/enums.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/repository/util_repository.dart';
import 'package:biskit_app/common/utils/input_validate_util.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:biskit_app/profile/model/profile_create_model.dart';
import 'package:biskit_app/profile/repository/profile_repository.dart';
import 'package:biskit_app/profile/view/profile_language_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:photo_manager/photo_manager.dart';

class ProfileNicknameScreen extends ConsumerStatefulWidget {
  static String get routeName => 'profileNickname';
  const ProfileNicknameScreen({super.key});

  @override
  ConsumerState<ProfileNicknameScreen> createState() =>
      _ProfileNicknameScreenState();
}

class _ProfileNicknameScreenState extends ConsumerState<ProfileNicknameScreen> {
  PhotoModel? selectedPhotoModel;
  String? randomProfile;

  late final TextEditingController controller;
  // String nickName = '';
  String? nickNameError;
  bool isNickNameOk = false;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController()
      ..addListener(() {
        onSearchChanged(controller.text);
      });

    init();
  }

  init() async {
    final res = await ref.read(profileRepositoryProvider).getRandomNickname();
    if (res != null) {
      String temp = res.data['kr_nick_name'] ?? '';

      controller.text = temp.replaceAll(' ', '');
    }
    randomProfile =
        await ref.read(profileRepositoryProvider).getRandomProfile();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    _debounce?.cancel();
  }

  onSearchChanged(String value) {
    setState(() {
      nickNameError = null;
      isNickNameOk = false;
    });
    if (value.isEmpty) {
      return;
    }
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      // logger.d('$value : ${value.isNickName()}');
      if (value.isNickName()) {
        if (!await ref
            .read(profileRepositoryProvider)
            .getCheckNickName(value)) {
          // 이미 사용중일 때
          setState(() {
            nickNameError = 'uploadPhotoScreen.nickname.duplicateError'.tr();
            isNickNameOk = false;
          });
        } else {
          // 정상
          setState(() {
            nickNameError = null;
            isNickNameOk = true;
          });
          return;
        }
      } else {
        if (value.length < 2) {
          setState(() {
            nickNameError = 'uploadPhotoScreen.nickname.numError'.tr();
            isNickNameOk = false;
          });
          return;
        } else {
          setState(() {
            nickNameError = 'uploadPhotoScreen.nickname.formatError'.tr();
            isNickNameOk = false;
          });
          return;
        }
      }
    });
  }

  onTapNext() async {
    FocusScope.of(context).unfocus();
    if (isNickNameOk) {
      // ProfileResponseModel profileResponseModel =
      //     await ref.read(profileRepositoryProvider).createProfile(
      //           nickName: controller.text,
      //           profilePhoto: selectedPhotoModel,
      //         );
      // logger.d(profileResponseModel.toJson());

      // 사진이 있는 경우 바로 업로드 처리 후 프로필 사진 패스 전달
      String? profilePhoto;
      if (selectedPhotoModel != null) {
        context.loaderOverlay.show();
        try {
          profilePhoto = await ref.read(utilRepositoryProvider).uploadImage(
                photo: selectedPhotoModel!,
                uploadImageType: UploadImageType.PROFILE,
              );
        } finally {
          // ignore: use_build_context_synchronously
          context.loaderOverlay.hide();
        }
        logger.d('uploadFilePath : $profilePhoto');
      }
      if (!mounted) return;
      context.pushNamed(
        ProfileLanguageScreen.routeName,
        extra: ProfileCreateModel(
          nick_name: controller.text,
          profile_photo:
              selectedPhotoModel != null ? profilePhoto : randomProfile,
          is_default_photo: selectedPhotoModel == null,
          available_languages: [],
          introductions: [],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            padding: const EdgeInsets.only(
              right: 10,
            ),
            child: Text(
              '1 / 4',
              style: getTsBody14Rg(context).copyWith(
                color: kColorContentWeakest,
              ),
            ),
          ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'uploadPhotoScreen.title'.tr(),
                    style: getTsHeading24(context).copyWith(
                      color: kColorContentDefault,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: selectedPhotoModel == null
                        ? GestureDetector(
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
                              if (result.length == 1) {
                                setState(() {
                                  selectedPhotoModel = result[0];
                                });
                              }
                            },
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 44,
                                  foregroundImage: randomProfile == null
                                      ? null
                                      : NetworkImage(
                                          randomProfile!,
                                        ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: kColorBgInverseWeak,
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/icons/ic_pencil_fill_16.svg',
                                      width: 16,
                                      height: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPhotoModel = null;
                              });
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(44),
                                  ),
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.3),
                                      BlendMode.srcOver,
                                    ),
                                    child: CircleAvatar(
                                      radius: 44,
                                      foregroundImage: selectedPhotoModel!
                                                  .photoType ==
                                              PhotoType.asset
                                          ? AssetEntityImageProvider(
                                              selectedPhotoModel!.assetEntity!,
                                              isOriginal: true,
                                            )
                                          : Image.file(
                                              File(
                                                selectedPhotoModel!
                                                    .cameraXfile!.path,
                                              ),
                                            ).image,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 32,
                                  left: 32,
                                  child: SvgPicture.asset(
                                    'assets/icons/ic_cancel_line_24.svg',
                                    width: 24,
                                    height: 24,
                                    colorFilter: const ColorFilter.mode(
                                      kColorContentInverse,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextInputWidget(
                        controller: controller,
                        title: 'uploadPhotoScreen.nickname'.tr(),
                        hintText: 'uploadPhotoScreen.placeholder'.tr(),
                        maxLength: 12,
                        // onChanged: onSearchChanged,
                        errorText: nickNameError,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp('[a-zA-Zㄱ-ㅎ가-힣0-9]'))
                        ],
                        suffixIcon: controller.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  controller.clear();
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/ic_cancel_fill_16.svg',
                                  width: 16,
                                  height: 16,
                                  colorFilter: const ColorFilter.mode(
                                    kColorContentWeakest,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      if (nickNameError == null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            isNickNameOk
                                ? 'uploadPhotoScreen.nickname.subtitle.available'
                                    .tr()
                                : 'uploadPhotoScreen.nickname.subtitle.error'
                                    .tr(),
                            style: getTsCaption12Rg(context).copyWith(
                              color: isNickNameOk
                                  ? kColorContentSeccess
                                  : kColorContentWeakest,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          MediaQuery.of(context).viewInsets.bottom < 100
              ? Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 34,
                  ),
                  child: GestureDetector(
                    onTap: onTapNext,
                    child: FilledButtonWidget(
                      text: 'uploadPhotoScreen.next'.tr(),
                      fontSize: FontSize.l,
                      isEnable: isNickNameOk,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: onTapNext,
                  child: FullBleedButtonWidget(
                    text: 'uploadPhotoScreen.next'.tr(),
                    isEnable: isNickNameOk,
                  ),
                ),
        ],
      ),
    );
  }
}
