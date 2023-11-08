// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:biskit_app/profile/view/profile_keyword_screen.dart';
import 'package:collection/collection.dart';
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
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/string_util.dart';
import 'package:biskit_app/profile/model/available_language_model.dart';
import 'package:biskit_app/profile/model/profile_model.dart';
import 'package:biskit_app/profile/model/student_verification_model.dart';
import 'package:biskit_app/profile/repository/profile_repository.dart';
import 'package:biskit_app/user/model/user_university_model.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  final ProfileModel profile;
  final List<UserUniversityModel> user_university;
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
  String? nickNameError;
  bool isNickNameOk = false;
  Timer? _debounce;

  bool isSaveEnable = false;

  List<KeywordModel> introductions = [];
  List<AvailableLanguageModel> available_languages = [];
  StudentVerificationModel? student_verification;

  @override
  void initState() {
    logger.d('initState>>>${widget.profile.toJson()}');
    super.initState();

    nickNameController = TextEditingController(text: widget.profile.nick_name)
      ..addListener(() {
        onSearchChanged(nickNameController.text);
      });
    available_languages = [...widget.profile.available_languages];
    student_verification = widget.profile.student_verification;
    introductions = widget.profile.introductions
        .map((e) => KeywordModel(keyword: e.keyword, reason: e.context))
        .toList();
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
            nickNameError = '이미 사용중인 닉네임이에요';
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
            nickNameError = '2자 이상 입력해주세요';
            isNickNameOk = false;
          });
          return;
        } else {
          setState(() {
            nickNameError = '한글/영문/숫자만 사용가능해요';
            isNickNameOk = false;
          });
          return;
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    nickNameController.dispose();
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
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Text(
              '저장',
              style: getTsBody16Sb(context).copyWith(
                color:
                    isSaveEnable ? kColorContentDefault : kColorContentDisabled,
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
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    // Avatar
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundImage: const AssetImage(
                            'assets/images/88.png',
                          ),
                          foregroundImage: widget.profile.profile_photo == null
                              ? null
                              : NetworkImage(widget.profile.profile_photo!),
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
                            FilteringTextInputFormatter.allow(
                                RegExp('[a-zA-Zㄱ-ㅎ가-힣0-9]'))
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
                              '0/300',
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
              ),
              _buildDivider(),

              // Like
              Container(
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
              ),

              _buildDivider(),

              // Language
              Container(
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
                    Column(
                      children: available_languages
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
                                              element.language.kr_name,
                                              style: getTsBody16Sb(context)
                                                  .copyWith(
                                                color: kColorContentWeak,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Text(
                                              getLevelServerValueToKrString(
                                                  element.level),
                                              style: getTsBody16Sb(context)
                                                  .copyWith(
                                                color: kColorContentSecondary,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            LevelBarWidget(
                                              level: getLevelServerValueToInt(
                                                  element.level),
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
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                kColorContentWeakest,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (index != available_languages.length - 1)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 4),
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
                  ],
                ),
              ),

              _buildDivider(),

              // University
              Container(
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
                                widget.user_university[0].university.kr_name,
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
                              Text(
                                widget.user_university[0].department,
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
                              Text(
                                widget.user_university[0].education_status,
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
                        const OutlinedButtonWidget(
                          text: '수정하기',
                          isEnable: true,
                          height: 44,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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

  void onTapLangDelete(AvailableLanguageModel languageModel) {
    setState(() {
      available_languages.remove(languageModel);
    });
  }
}
