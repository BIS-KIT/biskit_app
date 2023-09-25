import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/const/colors.dart';
import '../../common/const/fonts.dart';
import '../../common/components/custom_text_form_field.dart';

class KeywordInputWidget extends StatefulWidget {
  const KeywordInputWidget({super.key});

  @override
  State<KeywordInputWidget> createState() => _KeywordInputWidgetState();
}

class _KeywordInputWidgetState extends State<KeywordInputWidget> {
  late final TextEditingController keywordController;
  late final TextEditingController reasonController;
  late final FocusNode keywordFocusNode;
  late final FocusNode reasonFocusNode;

  // 이유 작성
  bool isReasonView = false;

  @override
  void initState() {
    super.initState();
    keywordFocusNode = FocusNode();
    reasonFocusNode = FocusNode();

    keywordController = TextEditingController()
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
    reasonController = TextEditingController();
  }

  @override
  void dispose() {
    keywordController.dispose();
    reasonController.dispose();
    keywordFocusNode.dispose();
    reasonFocusNode.dispose();
    super.dispose();
  }

  getButtonEnable() {
    return keywordController.text.isNotEmpty &&
        reasonController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            CustomTextFormField(
              controller: keywordController,
              focusNode: keywordFocusNode,
              onChanged: (value) {
                // logger.d(value.contains('\n'));
              },
              hintText: '키워드를 적어주세요',
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              maxLines: null,
              suffixIcon: keywordController.text.isNotEmpty
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
            isReasonView
                ? Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(top: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: kColorBgElevation1,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                              border: Border.all(
                                width: 1,
                                color: kColorBgElevation3,
                              ),
                            ),
                            child: TextFormField(
                              controller: reasonController,
                              onChanged: (value) {
                                setState(() {});
                              },
                              focusNode: reasonFocusNode,
                              expands: true,
                              maxLines: null,
                              minLines: null,
                              decoration: InputDecoration(
                                hintText: '',
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                hintStyle: getTsBody16Rg(context).copyWith(
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
                          '${reasonController.text.length}/300',
                          style: getTsCaption12Rg(context).copyWith(
                            color: kColorContentWeakest,
                          ),
                        ),
                      ],
                    ),
                  )
                : const Spacer(),
            if (MediaQuery.of(context).viewInsets.bottom > 150)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom -
                        (16 + 34 + 52) +
                        20,
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 34,
              ),
              child: GestureDetector(
                onTap: () {
                  if (getButtonEnable()) {
                    Navigator.pop(context, {
                      'keyword': keywordController.text,
                      'reason': reasonController.text,
                    });
                  }
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
      ),
    );
  }
}
