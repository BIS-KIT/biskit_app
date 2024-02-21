// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:biskit_app/common/components/badge_widget.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/level_bar_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/components/text_input_widget.dart';
import 'package:biskit_app/common/components/univ_student_graduate_status.dart';
import 'package:biskit_app/common/components/univ_student_status_list_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/enums.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/model/university_graduate_status_model.dart';
import 'package:biskit_app/common/model/university_student_status_model.dart';
import 'package:biskit_app/common/repository/util_repository.dart';
import 'package:biskit_app/common/utils/input_validate_util.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/string_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:biskit_app/profile/components/lang_list_widget.dart';
import 'package:biskit_app/profile/model/available_language_create_model.dart';
import 'package:biskit_app/profile/model/profile_model.dart';
import 'package:biskit_app/profile/model/student_verification_model.dart';
import 'package:biskit_app/profile/model/use_language_model.dart';
import 'package:biskit_app/profile/provider/use_language_provider.dart';
import 'package:biskit_app/profile/repository/profile_repository.dart';
import 'package:biskit_app/profile/view/profile_id_confirm_screen.dart';
import 'package:biskit_app/profile/view/profile_keyword_screen.dart';
import 'package:biskit_app/user/model/user_university_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_manager/photo_manager.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  final ProfileModel profile;
  final UserUniversityModel user_university;
  const ProfileEditScreen({
    Key? key,
    required this.profile,
    required this.user_university,
  }) : super(key: key);

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  late final TextEditingController nickNameController;
  late final TextEditingController contextController;
  String? nickNameError;
  bool isNickNameOk = false;
  Timer? _debounce;

  bool isSaveEnable = false;

  PhotoModel? selectedPhotoModel;
  String? profileImageUrl;
  bool isDefaultImage = true;

  List<KeywordModel> introductions = [];
  List<UseLanguageModel> useLanguageModelList = [];
  // List<UseLanguageModel>? useLangState = [];
  StudentVerificationModel? student_verification;
  UniversityStudentStatusModel? selectedStudentStatusModel;
  UniversityGraduateStatusModel? selectedGraduateStatusModel;

  @override
  void initState() {
    // logger.d('initState>>>${widget.profile.toJson()}');
    init();
    super.initState();
  }

  init() async {
    nickNameController = TextEditingController(text: widget.profile.nick_name)
      ..addListener(() {
        onSearchChanged(nickNameController.text);
      });
    contextController =
        TextEditingController(text: widget.profile.context ?? '');
    useLanguageModelList = [
      ...widget.profile.available_languages.map(
        (e) => UseLanguageModel(
          languageModel: e.language,
          level: getLevelServerValueToInt(e.level),
          isChecked: true,
        ),
      ),
    ];
    isDefaultImage = widget.profile.is_default_photo;
    profileImageUrl = widget.profile.profile_photo;
    // if (widget.profile.is_default_photo) {
    //   setState(() {
    //     randomProfile = widget.profile.profile_photo!;
    //   });
    // } else {
    //   randomProfile =
    //       await ref.read(profileRepositoryProvider).getRandomProfile();
    //   setState(() {});
    // }
    // if (widget.profile.is_default_photo == false &&
    //     selectedPhotoModel == null) {
    //   setState(() {
    //     isUserInitialPhotoDeleted = false;
    //   });
    // }
    introductions = widget.profile.introductions
        .map((e) => KeywordModel(keyword: e.keyword, context: e.context))
        .toList();
    student_verification = widget.profile.student_verification;
    selectedStudentStatusModel = UniversityStudentStatusModel(
      ename: widget.profile.user_university.department,
      kname: widget.profile.user_university.department,
    );
    selectedGraduateStatusModel = UniversityGraduateStatusModel(
      ename: widget.profile.user_university.education_status,
      kname: widget.profile.user_university.education_status,
    );
    setState(() {});
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
      if (value == widget.profile.nick_name) {
        checkValue();
        return;
      }
      if (value.isNickName()) {
        bool isOk =
            await ref.read(profileRepositoryProvider).getCheckNickName(value);
        if (!isOk) {
          // 이미 사용중일 때
          setState(() {
            nickNameError = 'editProfileScreen.nickname.duplicateError'.tr();
            isNickNameOk = false;
          });
        } else {
          // 정상
          setState(() {
            nickNameError = null;
            isNickNameOk = true;
          });
        }
      } else {
        if (value.length < 2) {
          setState(() {
            nickNameError = 'editProfileScreen.nickname.numError'.tr();
            isNickNameOk = false;
          });
        } else {
          setState(() {
            nickNameError = 'editProfileScreen.nickname.formatError'.tr();
            isNickNameOk = false;
          });
        }
      }
      checkValue();
    });
  }

  // 저장 가능 여부 확인
  checkValue() {
    if (useLanguageModelList.isEmpty ||
        nickNameController.text.isEmpty ||
        useLanguageModelList.isEmpty) {
      // 필수 입력 확인
      setState(() {
        isSaveEnable = false;
      });
      return;
    }
    if (selectedPhotoModel != null ||
        widget.profile.profile_photo != profileImageUrl ||
        nickNameController.text.trim() != widget.profile.nick_name ||
        contextController.text.trim() != (widget.profile.context ?? '') ||
        !checkEqualLang() ||
        !checkEqualIntroduction() ||
        !checkEqualUniv()) {
      // 수정여부 확인
      setState(() {
        isSaveEnable = true;
      });
      return;
    }

    setState(() {
      isSaveEnable = false;
    });
    return;
  }

  // 저장
  onTapSave() async {
    FocusScope.of(context).unfocus();
    if (!isSaveEnable) return;

    Map<String, dynamic> data = {};

    // 프로필 사진
    if (selectedPhotoModel != null) {
      // profile image upload
      String? profilePhoto = await ref.read(utilRepositoryProvider).uploadImage(
            photo: selectedPhotoModel!,
            uploadImageType: UploadImageType.PROFILE,
          );
      data.addEntries(<String, dynamic>{
        'profile_photo': profilePhoto,
        'is_default_photo': false,
      }.entries);
    } else {
      if (widget.profile.is_default_photo != isDefaultImage) {
        data.addEntries(<String, dynamic>{
          'profile_photo': profileImageUrl,
          'is_default_photo': true,
        }.entries);
      }
    }

    // 닉네임
    if (nickNameController.text != widget.profile.nick_name) {
      data.addEntries(<String, dynamic>{
        'nick_name': nickNameController.text,
      }.entries);
    }

    // 자기소개
    if (contextController.text != (widget.profile.context ?? '')) {
      data.addEntries(<String, dynamic>{
        'context': contextController.text,
      }.entries);
    }

    // 좋아하는 것
    if (!checkEqualIntroduction()) {
      data.addEntries(<String, dynamic>{
        'introductions': introductions.map((x) => x.toMap()).toList(),
      }.entries);
    }

    // 사용가능언어
    if (!checkEqualLang()) {
      List<AvailableLanguageCreateModel> langList = useLanguageModelList
          .map((x) => AvailableLanguageCreateModel(
                language_id: x.languageModel.id,
                level: getLevelServerValue(x.level),
              ))
          .toList();
      data.addEntries(<String, dynamic>{
        'available_languages': langList.map((x) => x.toMap()).toList(),
      }.entries);
    }

    // 학교 정보
    if (!checkEqualUniv() &&
        selectedStudentStatusModel != null &&
        selectedGraduateStatusModel != null) {
      data.addEntries(<String, dynamic>{
        'university_info': {
          "department": selectedStudentStatusModel!.kname,
          "education_status": selectedGraduateStatusModel!.kname,
        },
      }.entries);
    }

    final bool isOk = await ref.read(profileRepositoryProvider).updateProfile(
          profile_id: widget.profile.id,
          data: data,
        );
    if (isOk && mounted) {
      ref.read(userMeProvider.notifier).getMe();
      Navigator.pop(context);
    }
  }

  onTapCertifyUniv() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileIdConfirmScreen(
          isEditor: true,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    nickNameController.dispose();
    contextController.dispose();
    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DefaultLayout(
        leadingIconPath: 'assets/icons/ic_cancel_line_24.svg',
        title: 'editProfileScreen.title'.tr(),
        actions: [
          GestureDetector(
            onTap: () {
              onTapSave();
            },
            child: Container(
              margin: const EdgeInsets.only(
                right: 10,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Text(
                'editProfileScreen.save'.tr(),
                style: getTsBody16Sb(context).copyWith(
                  color: isSaveEnable
                      ? kColorContentDefault
                      : kColorContentDisabled,
                ),
              ),
            ),
          )
        ],
        shape: const Border(
          bottom: BorderSide(
            width: 1,
            color: kColorBorderDefalut,
          ),
        ),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Photo,Name,Intro
              _buildPhotoNameIntro(context),
              _buildDivider(),

              // Like
              _buildLike(context),

              _buildDivider(),

              // Language
              _buildLang(context),

              _buildDivider(),

              // University
              _buildUniv(context),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildUniv(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'editProfileScreen.univInfo.label'.tr(),
            style: getTsBody16Sb(context).copyWith(
              color: kColorContentDefault,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Column(
            children: [
              widget.profile.student_verification == null
                  ? Column(
                      children: [
                        SizedBox(
                          height: 44,
                          child: Row(
                            children: [
                              Text(
                                'editProfileScreen.univInfo.univ'.tr(),
                                style: getTsBody16Sb(context).copyWith(
                                  color: kColorContentWeak,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                widget.user_university.university.kr_name,
                                style: getTsBody16Rg(context).copyWith(
                                  color: kColorContentWeak,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            onTapCertifyUniv();
                          },
                          child: FilledButtonWidget(
                            text: 'editProfileScreen.univInfo.verifyUniv'.tr(),
                            height: 40,
                            isEnable: true,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 44,
                          child: Row(
                            children: [
                              Text(
                                'editProfileScreen.univInfo.univ'.tr(),
                                style: getTsBody16Sb(context).copyWith(
                                  color: kColorContentDisabled,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                widget.user_university.university.kr_name,
                                style: getTsBody16Rg(context).copyWith(
                                  color: kColorContentDisabled,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: kColorBorderDefalut,
                          ),
                        ),
                      ],
                    ),
              SizedBox(
                height: 44,
                child: Row(
                  children: [
                    Text(
                      'editProfileScreen.univInfo.degree'.tr(),
                      style: getTsBody16Sb(context).copyWith(
                        color: kColorContentWeak,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    if (selectedStudentStatusModel != null)
                      Text(
                        selectedStudentStatusModel!.kname,
                        style: getTsBody16Rg(context).copyWith(
                          color: kColorContentWeak,
                        ),
                      ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: kColorBorderDefalut,
                ),
              ),
              SizedBox(
                height: 44,
                child: Row(
                  children: [
                    Text(
                      'editProfileScreen.univInfo.state'.tr(),
                      style: getTsBody16Sb(context).copyWith(
                        color: kColorContentWeak,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    if (selectedGraduateStatusModel != null)
                      Text(
                        selectedGraduateStatusModel!.kname,
                        style: getTsBody16Rg(context).copyWith(
                          color: kColorContentWeak,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () async {
                  final result1 = await showBiskitBottomSheet(
                    context: context,
                    title: 'editProfileScreen.univ.selectDegree'.tr(),
                    // leftIcon: 'assets/icons/ic_arrow_back_ios_line_24.svg',
                    isDismissible: false,
                    onLeftTap: () async {
                      Navigator.pop(context);
                      // await onTapStartSelectedUniv();
                    },
                    rightIcon: 'assets/icons/ic_cancel_line_24.svg',
                    onRightTap: () {
                      Navigator.pop(context);
                    },
                    contentWidget: UnivStudentStatusListWidget(
                      selectedUnivStudentStatusModel:
                          selectedStudentStatusModel,
                      onTap: (model) async {},
                    ),
                  );

                  if (result1 != null && mounted) {
                    final result2 = await showBiskitBottomSheet(
                      context: context,
                      title: 'editProfileScreen.univ.selectState'.tr(),
                      leftIcon: 'assets/icons/ic_arrow_back_ios_line_24.svg',
                      isDismissible: false,
                      onLeftTap: () async {
                        Navigator.pop(context);
                      },
                      rightIcon: 'assets/icons/ic_cancel_line_24.svg',
                      onRightTap: () {
                        Navigator.pop(context);
                      },
                      contentWidget: UnivGraduateStatusListWidget(
                        selectedStudentStatusModel: result1!,
                        selectedGraduateStatusModel:
                            selectedGraduateStatusModel,
                        onTap: (model) {},
                        submit: () {},
                      ),
                    );

                    if (result2 != null) {
                      setState(() {
                        selectedStudentStatusModel = result1;
                        selectedGraduateStatusModel = result2;
                      });
                    }
                  }
                  checkValue();
                },
                child: OutlinedButtonWidget(
                  text: 'editProfileScreen.univ.edit'.tr(),
                  isEnable: true,
                  height: 44,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _buildLang(BuildContext context) {
    ref.watch(useLanguageProvider);
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'availableLang.label'.tr(),
            style: getTsBody16Sb(context).copyWith(
              color: kColorContentDefault,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          useLanguageModelList.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: kColorBgError,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    'availableLang.noLang'.tr(),
                    textAlign: TextAlign.center,
                    style: getTsBody16Rg(context).copyWith(
                      color: kColorContentError,
                    ),
                  ),
                )
              : Column(
                  children: useLanguageModelList
                      .mapIndexed((index, element) => Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          element.languageModel.kr_name,
                                          style:
                                              getTsBody16Sb(context).copyWith(
                                            color: kColorContentWeak,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Text(
                                          getLevelTitle(element.level),
                                          style:
                                              getTsBody16Sb(context).copyWith(
                                            color: kColorContentSecondary,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        LevelBarWidget(
                                          level: element.level,
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        onTapLangDelete(element);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: SvgPicture.asset(
                                          'assets/icons/ic_cancel_line_24.svg',
                                          width: 24,
                                          height: 24,
                                          colorFilter: const ColorFilter.mode(
                                            kColorContentWeakest,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (index != useLanguageModelList.length - 1)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: kColorBorderDefalut,
                                  ),
                                )
                            ],
                          ))
                      .toList(),
                ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              ref
                  .read(useLanguageProvider.notifier)
                  .setSelectedList(useLanguageModelList);
              showDefaultModalBottomSheet(
                context: context,
                title: 'availableLang.chooseLang'.tr(),
                titleRightButton: true,
                enableDrag: false,
                isDismissible: false,
                contentWidget: LangListWidget(
                  callback: () {
                    setState(() {
                      useLanguageModelList = ref
                          .read(useLanguageProvider.notifier)
                          .getSelectedList();
                    });
                    ref.read(useLanguageProvider.notifier).init();
                    checkValue();
                    Navigator.pop(context);
                  },
                ),
              );
            },
            child: OutlinedButtonWidget(
              text: 'availableLang.edit'.tr(),
              isEnable: true,
              height: 44,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildLike(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'editProfileScreen.favorites.label'.tr(),
            style: getTsBody16Sb(context).copyWith(
              color: kColorContentDefault,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Wrap(
            spacing: 6,
            children: introductions
                .map(
                  (e) => BadgeWidget(
                    text: e.keyword,
                    backgroundColor: kColorBgSecondary,
                    textColor: kColorContentInverse,
                    sizeType: BadgeSizeType.L,
                  ),
                )
                .toList(),
          ),
          const SizedBox(
            height: 24,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileKeywordScreen(
                    isEditorMode: true,
                    editorCallback: (List<KeywordModel> keywordList) {
                      setState(() {
                        introductions = keywordList;
                      });
                      Navigator.pop(context);
                      checkValue();
                    },
                    introductions: introductions,
                    userNickName: widget.profile.nick_name,
                  ),
                ),
              );
            },
            child: OutlinedButtonWidget(
              text: 'editProfileScreen.favorites.edit'.tr(),
              isEnable: true,
              height: 44,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildPhotoNameIntro(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 20,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: selectedPhotoModel != null
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPhotoModel = null;
                      });
                      checkValue();
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
                              foregroundImage: selectedPhotoModel == null
                                  ? NetworkImage(widget.profile.profile_photo!)
                                  : selectedPhotoModel!.photoType ==
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
                  )
                : GestureDetector(
                    onTap: () async {
                      if (!isDefaultImage) {
                        profileImageUrl = await ref
                            .read(profileRepositoryProvider)
                            .getRandomProfile();
                        isDefaultImage = true;
                        setState(() {});
                      } else {
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
                      }
                      checkValue();
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(44),
                          ),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              isDefaultImage
                                  ? Colors.black.withOpacity(0)
                                  : Colors.black.withOpacity(0.3),
                              BlendMode.srcOver,
                            ),
                            child: CircleAvatar(
                              radius: 44,
                              foregroundImage: profileImageUrl == null
                                  ? null
                                  : NetworkImage(profileImageUrl!),
                            ),
                          ),
                        ),
                        isDefaultImage
                            ? Positioned(
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
                              )
                            : Positioned(
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
            height: 24,
          ),

          // Nickname
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextInputWidget(
                controller: nickNameController,
                title: 'editProfileScreen.nickname.label'.tr(),
                titleStyle: getTsBody16Sb(context).copyWith(
                  color: kColorContentDefault,
                ),
                hintText: 'editProfileScreen.nickname.placeholder'.tr(),
                maxLength: 12,
                // onChanged: onSearchChanged,
                errorText: nickNameError,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Zㄱ-ㅎ가-힣0-9]'))
                ],
                suffixIcon: nickNameController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          nickNameController.clear();
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
                        ? 'editProfileScreen.nickname.available'.tr()
                        : 'editProfileScreen.nickname.numError'.tr(),
                    style: getTsCaption12Rg(context).copyWith(
                      color: isNickNameOk
                          ? kColorContentSeccess
                          : kColorContentWeakest,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(
            height: 24,
          ),

          // Intro
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'editProfileScreen.aboutMe.label'.tr(),
                style: getTsBody16Sb(context).copyWith(
                  color: kColorContentDefault,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: kColorBorderDefalut,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6),
                  ),
                  color: kColorBgElevation1,
                ),
                child: TextFormField(
                  controller: contextController,
                  onChanged: (value) {
                    checkValue();
                  },
                  maxLines: 5,
                  maxLength: 300,
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'editProfileScreen.aboutMe.placeholder'.tr(),
                    hintStyle: getTsBody16Rg(context).copyWith(
                      color: kColorContentPlaceholder,
                    ),
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${contextController.text.length}/300',
                    style: getTsCaption11Rg(context).copyWith(
                      color: kColorContentWeakest,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      width: double.infinity,
      height: 8,
      color: kColorBorderWeak,
    );
  }

  void onTapLangDelete(UseLanguageModel languageModel) {
    setState(() {
      useLanguageModelList.remove(languageModel);
    });
    checkValue();
  }

  bool checkEqualLang() {
    List<UseLanguageModel> list1 = widget.profile.available_languages
        .map(
          (e) => UseLanguageModel(
            languageModel: e.language,
            level: getLevelServerValueToInt(e.level),
            isChecked: true,
          ),
        )
        .toList();
    return listEquals(list1, useLanguageModelList);
  }

  bool checkEqualIntroduction() {
    List<KeywordModel> list1 = widget.profile.introductions
        .map(
          (e) => KeywordModel(
            keyword: e.keyword,
            context: e.context,
          ),
        )
        .toList();
    logger.d(list1);
    logger.d(introductions);
    return listEquals(list1, introductions);
  }

  bool checkEqualUniv() {
    return selectedStudentStatusModel!.kname ==
            widget.profile.user_university.department &&
        selectedGraduateStatusModel!.kname ==
            widget.profile.user_university.education_status;
  }
}
