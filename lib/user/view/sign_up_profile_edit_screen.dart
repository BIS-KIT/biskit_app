import 'package:biskit_app/common/component/filled_button_widget.dart';
import 'package:biskit_app/common/component/full_bleed_button_widget.dart';
import 'package:biskit_app/common/component/text_input_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_manager/photo_manager.dart';

class SignUpProfileEditScreen extends StatefulWidget {
  const SignUpProfileEditScreen({super.key});

  @override
  State<SignUpProfileEditScreen> createState() =>
      _SignUpProfileEditScreenState();
}

class _SignUpProfileEditScreenState extends State<SignUpProfileEditScreen> {
  final TextEditingController controller = TextEditingController();

  PhotoModel? selectedPhotoModel;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
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
                                  isSingle: true,
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
                        onChanged: (value) {
                          setState(() {});
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp('[a-zA-Zㄱ-ㅎ가-힣0-9]'))
                        ],
                        suffixIcon: controller.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  controller.text = '';
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
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '한글/영문/숫자 2자 이상',
                          style: getTsCaption12Rg(context).copyWith(
                            color: kColorGray6,
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
              ? const Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 34,
                  ),
                  child: FilledButtonWidget(
                    text: '다음',
                    isEnable: false,
                  ),
                )
              : const FullBleedButtonWidget(
                  text: '다음',
                  isEnable: false,
                ),
        ],
      ),
    );
  }
}
