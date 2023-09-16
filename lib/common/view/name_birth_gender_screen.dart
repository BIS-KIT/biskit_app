import 'package:biskit_app/common/component/custom_text_form_field.dart';
import 'package:biskit_app/common/component/filled_button_widget.dart';
import 'package:biskit_app/common/component/full_bleed_button_widget.dart';
import 'package:biskit_app/common/component/select_widget.dart';
import 'package:biskit_app/common/component/text_input_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NameBirthGenderScreen extends StatefulWidget {
  static String get routeName => 'nameBirthGender';
  const NameBirthGenderScreen({super.key});

  @override
  State<NameBirthGenderScreen> createState() => _NameBirthGenderScreenState();
}

class _NameBirthGenderScreenState extends State<NameBirthGenderScreen> {
  String name = '';
  String birthYear = '';
  String birthMonth = '';
  String birthDay = '';
  String? nameError;
  SelectWidgetValueType selectWidgetValueType = SelectWidgetValueType.none;

  bool isValidName(String name) {
    RegExp koreanEnglishRegExp = RegExp(r'^[a-zA-Zㄱ-ㅎ가-힣]+$');
    return koreanEnglishRegExp.hasMatch(name);
  }

  checkName() {
    if (name == '') {
      setState(() {
        nameError = null;
      });
    } else if (!isValidName(name)) {
      setState(() {
        nameError = '한글 또는 영문으로 입력해주세요';
      });
    } else {
      setState(() {
        nameError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
      child: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
            child: SingleChildScrollView(
                child: Column(children: [
              const SizedBox(
                height: 16,
              ),
              //  이름
              TextInputWidget(
                title: "이름",
                hintText: '실명을 입력해주세요',
                keyboardType: TextInputType.name,
                errorText: nameError,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  name = value;
                  checkName();
                },
              ),
              const SizedBox(
                height: 24,
              ),
              // 생년월일
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '생년월일',
                    style: getTsBody14Sb(context).copyWith(
                      color: kColorGray8,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: CustomTextFormField(
                        textAlign: TextAlign.center,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        hintText: 'YYYY',
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          setState(() {
                            birthYear = value;
                          });
                        },
                      )),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: Row(
                          children: [
                            Flexible(
                                child: CustomTextFormField(
                              textAlign: TextAlign.center,
                              maxLength: 2,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              hintText: 'MM',
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (value) {
                                setState(() {
                                  birthMonth = value;
                                });
                              },
                            )),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                                child: CustomTextFormField(
                              textAlign: TextAlign.center,
                              maxLength: 2,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              hintText: 'DD',
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (value) {
                                setState(() {
                                  birthDay = value;
                                });
                              },
                            )),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '성별',
                    style: getTsBody14Sb(context).copyWith(
                      color: kColorGray8,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SelectWidget(
                      leftText: '여성',
                      rightText: '남성',
                      value: selectWidgetValueType,
                      onTapLeft: () {
                        setState(() {
                          selectWidgetValueType = SelectWidgetValueType.left;
                        });
                      },
                      onTapRight: () {
                        setState(() {
                          selectWidgetValueType = SelectWidgetValueType.right;
                        });
                      })
                ],
              )
            ])),
          )),
          Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: GestureDetector(
              onTap: () {
                // context.pushReplacementNamed()
              },
              child: const FullBleedButtonWidget(
                text: '다음',
                isEnable: false,
              ),
            ),
          )
        ],
      )),
    );
  }
}
