import 'dart:async';

import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/full_bleed_button_widget.dart';
import 'package:biskit_app/common/components/text_input_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/input_validate_util.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:biskit_app/profile/repository/profile_repository.dart';
import 'package:biskit_app/profile/view/profile_language_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_manager/photo_manager.dart';

class ProfileNicknameScreen extends ConsumerStatefulWidget {
  const ProfileNicknameScreen({super.key});

  @override
  ConsumerState<ProfileNicknameScreen> createState() =>
      _ProfileNicknameScreenState();
}

class _ProfileNicknameScreenState extends ConsumerState<ProfileNicknameScreen> {
  PhotoModel? selectedPhotoModel;

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

  onTapNext() {
    FocusScope.of(context).unfocus();
    if (isNickNameOk) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileLanguageScreen(),
          ));
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
                color: kColorGray6,
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
                    '사진과 닉네임을\n등록해주세요',
                    style: getTsHeading24(context).copyWith(
                      color: kColorGray9,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () async {
                        final List result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PhotoManagerScreen(
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
                            backgroundImage: const AssetImage(
                              'assets/images/88.png',
                            ),
                            foregroundImage: selectedPhotoModel == null
                                ? null
                                : AssetEntityImageProvider(
                                    selectedPhotoModel!.assetEntity,
                                    isOriginal: true,
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: kColorGray8,
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
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextInputWidget(
                        controller: controller,
                        title: '닉네임',
                        hintText: '닉네임을 입력해주세요',
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
                                    kColorGray5,
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
                              color: isNickNameOk ? kColorSuccess : kColorGray6,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          MediaQuery.of(context).viewInsets.bottom == 0
              ? Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 34,
                  ),
                  child: GestureDetector(
                    onTap: onTapNext,
                    child: FilledButtonWidget(
                      text: '다음',
                      isEnable: isNickNameOk,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: onTapNext,
                  child: FullBleedButtonWidget(
                    text: '다음',
                    isEnable: isNickNameOk,
                  ),
                ),
        ],
      ),
    );
  }
}
