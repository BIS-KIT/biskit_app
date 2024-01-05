import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:biskit_app/common/components/btn_icon_widget.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/utils/logger_util.dart';

import '../../common/components/custom_text_form_field.dart';
import '../../common/const/colors.dart';
import '../../common/const/fonts.dart';

class KeywordInputWidget extends StatefulWidget {
  final String? keyword;
  final String? context;
  const KeywordInputWidget({
    Key? key,
    this.keyword,
    this.context,
  }) : super(key: key);

  @override
  State<KeywordInputWidget> createState() => _KeywordInputWidgetState();
}

class _KeywordInputWidgetState extends State<KeywordInputWidget> {
  late final TextEditingController keywordController;
  late final TextEditingController contextController;
  late final FocusNode keywordFocusNode;
  late final FocusNode reasonFocusNode;

  // 이유 작성
  bool isReasonView = false;

  @override
  void initState() {
    super.initState();
    keywordFocusNode = FocusNode();
    reasonFocusNode = FocusNode();

    keywordController = TextEditingController(text: widget.keyword ?? '')
      ..addListener(() {
        logger.d(
            'keywordController:${keywordController.text}, ${keywordController.text.contains('\n')}');
        if (keywordController.text.contains('\n')) {
          if (keywordController.text.replaceAll('\n', '').isNotEmpty) {
            setState(() {
              isReasonView = true;
              // keywordFocusNode.nextFocus();
              // FocusScope.of(context).nextFocus();
              reasonFocusNode.requestFocus();
            });
          }

          keywordController.text = keywordController.text.replaceAll('\n', '');
        }

        setState(() {});
      });
    contextController = TextEditingController(
      text: widget.context ?? '',
    );

    if (contextController.text.isNotEmpty) {
      isReasonView = true;
    }
    setState(() {});
  }

  @override
  void dispose() {
    keywordController.dispose();
    contextController.dispose();
    keywordFocusNode.dispose();
    reasonFocusNode.dispose();
    super.dispose();
  }

  getButtonEnable() {
    return keywordController.text.isNotEmpty &&
        contextController.text.isNotEmpty;
  }

  onTapSubmit() {
    if (getButtonEnable()) {
      Navigator.pop(context, {
        'keyword': keywordController.text,
        'context': contextController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    controller: keywordController,
                    focusNode: keywordFocusNode,
                    onChanged: (value) {
                      // logger.d(value.contains('\n'));
                    },
                    hintText: '좋아하는 것을 알려주세요',
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLength: 20,
                    maxLines: null,
                    autofocus: true,
                    suffixIcon: keywordController.text.isNotEmpty &&
                            keywordFocusNode.hasFocus
                        ? GestureDetector(
                            onTap: () {
                              keywordController.clear();
                            },
                            child: SvgPicture.asset(
                              'assets/icons/ic_cancel_fill_16.svg',
                              width: 16,
                              height: 16,
                              colorFilter: const ColorFilter.mode(
                                kColorContentDisabled,
                                BlendMode.srcIn,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
                if (!reasonFocusNode.hasFocus && contextController.text.isEmpty)
                  Row(
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      BtnIconWidget(
                        iconPath: 'assets/icons/ic_plus_line_24.svg',
                        isDisable: keywordController.text.isEmpty,
                        onTap: () {
                          setState(() {
                            isReasonView = true;
                            reasonFocusNode.requestFocus();
                          });
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
          isReasonView
              ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: kColorBgElevation1,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
                                    border: Border.all(
                                      width: 1,
                                      color: kColorBgElevation3,
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: contextController,
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        setState(() {});
                                      }
                                    },
                                    onTap: () {
                                      if (MediaQuery.of(context)
                                              .viewInsets
                                              .bottom >
                                          0) {
                                        FocusScope.of(context).unfocus();
                                      }
                                    },
                                    maxLength: 300,
                                    autofocus: true,
                                    focusNode: reasonFocusNode,
                                    expands: true,
                                    maxLines: null,
                                    minLines: null,
                                    decoration: InputDecoration(
                                      hintText: '좋아하는 이유를 알려주세요',
                                      border: InputBorder.none,
                                      isDense: true,
                                      counterText: '',
                                      contentPadding: EdgeInsets.zero,
                                      hintStyle:
                                          getTsBody16Rg(context).copyWith(
                                        color: kColorContentPlaceholder,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                '${contextController.text.length}/300',
                                style: getTsCaption12Rg(context).copyWith(
                                  color: kColorContentWeakest,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (MediaQuery.of(context).viewInsets.bottom > 150)
                        Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                onTapSubmit();
                              },
                              child: FilledButtonWidget(
                                text: '완료',
                                isEnable: getButtonEnable(),
                                height: 52,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                )
              : Expanded(
                  child: Column(
                  children: [
                    const Spacer(),
                    if (MediaQuery.of(context).viewInsets.bottom > 150)
                      GestureDetector(
                        onTap: () {
                          onTapSubmit();
                        },
                        child: FilledButtonWidget(
                          text: '완료',
                          isEnable: getButtonEnable(),
                          height: 52,
                        ),
                      ),
                  ],
                )),
          if (MediaQuery.of(context).viewInsets.bottom > 150)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height:
                      MediaQuery.of(context).viewInsets.bottom - (16 + 34 + 52),
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 34,
              left: 20,
              right: 20,
            ),
            child: GestureDetector(
              onTap: () {
                onTapSubmit();
              },
              child: FilledButtonWidget(
                text: '완료',
                isEnable: getButtonEnable(),
                height: 52,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
