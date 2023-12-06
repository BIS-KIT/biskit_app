// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/univ_student_graduate_status.dart';
import 'package:biskit_app/common/components/univ_student_status_list_widget.dart';
import 'package:biskit_app/common/const/enums.dart';
import 'package:biskit_app/common/model/university_graduate_status_model.dart';
import 'package:biskit_app/common/model/university_student_status_model.dart';
import 'package:biskit_app/common/repository/util_repository.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:biskit_app/profile/components/lang_list_widget.dart';
import 'package:biskit_app/profile/model/available_language_create_model.dart';
import 'package:biskit_app/profile/model/use_language_model.dart';
import 'package:biskit_app/profile/provider/use_language_provider.dart';
import 'package:biskit_app/profile/view/profile_id_confirm_screen.dart';
import 'package:biskit_app/profile/view/profile_keyword_screen.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:biskit_app/common/components/badge_widget.dart';
import 'package:biskit_app/common/components/level_bar_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/components/text_input_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/input_validate_util.dart';
import 'package:biskit_app/common/utils/string_util.dart';
import 'package:biskit_app/profile/model/profile_model.dart';
import 'package:biskit_app/profile/model/student_verification_model.dart';
import 'package:biskit_app/profile/repository/profile_repository.dart';
import 'package:biskit_app/user/model/user_university_model.dart';
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

  init() {
    nickNameController = TextEditingController(text: widget.profile.nick_name)
      ..addListener(() {
        onSearchChanged(nickNameController.text);
      });
    contextController =
        TextEditingController(text: widget.profile.context ?? '');
    useLanguageModelList = [
      ...widget.profile.available_languages.map((e) => UseLanguageModel(
            languageModel: e.language,
            level: getLevelServerValueToInt(e.level),
            isChecked: true,
          ))
    ];
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
            nickNameError = '이미 사용중인 닉네임이에요';
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
            nickNameError = '2자 이상 입력해주세요';
            isNickNameOk = false;
          });
        } else {
          setState(() {
            nickNameError = '한글/영문/숫자만 사용가능해요';
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
      }.entries);
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

    logger.d(data);
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
        title: '프로필 수정',
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
                '저장',
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
            '학교 정보',
            style: getTsBody16Sb(context).copyWith(
              color: kColorContentDefault,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Column(
            children: [
              widget.profile.student_verification!.verification_status ==
                      VerificationStatus.UNVERIFIED.name
                  ? Column(
                      children: [
                        SizedBox(
                          height: 44,
                          child: Row(
                            children: [
                              Text(
                                '학교',
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
                          child: const FilledButtonWidget(
                            text: '학교 인증하기',
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
                                '학교',
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
                      '소속',
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
                      '학적상태',
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
                    title: '소속 선택',
                    leftIcon: 'assets/icons/ic_arrow_back_ios_line_24.svg',
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
                      title: '학적상태 선택',
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
                child: const OutlinedButtonWidget(
                  text: '수정하기',
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
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '사용가능언어',
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
                    '사용가능언어를\n1개 이상 선택해주세요',
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
                title: '언어 선택',
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
            child: const OutlinedButtonWidget(
              text: '수정하기',
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
            '좋아하는 것',
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
            child: const OutlinedButtonWidget(
              text: '수정하기',
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
          // Avatar
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
              if (result.length == 1) {
                setState(() {
                  selectedPhotoModel = result[0];
                });
                checkValue();
              }
            },
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundImage: const AssetImage(
                    'assets/images/88.png',
                  ),
                  foregroundImage: selectedPhotoModel == null
                      ? (widget.profile.profile_photo == null
                          ? null
                          : NetworkImage(widget.profile.profile_photo!))
                      : selectedPhotoModel!.photoType == PhotoType.asset
                          ? AssetEntityImageProvider(
                              selectedPhotoModel!.assetEntity!,
                              isOriginal: true,
                            )
                          : Image.file(
                              File(
                                selectedPhotoModel!.cameraXfile!.path,
                              ),
                            ).image,
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
                title: '닉네임',
                titleStyle: getTsBody16Sb(context).copyWith(
                  color: kColorContentDefault,
                ),
                hintText: '닉네임을 입력해주세요',
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
                    isNickNameOk ? '사용 가능한 닉네임이에요' : '한글/영문/숫자 2자 이상',
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
                '자기소개',
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
                    hintText: '나에 대해 소개해볼까요?',
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
