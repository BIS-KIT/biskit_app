import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/filled_button_widget.dart';
import '../const/colors.dart';

showBiskitBottomSheet({
  required BuildContext context,
  required String title,
  double? height,
  String? leftIcon,
  String? rightIcon,
  Function()? onLeftTap,
  Function()? onRightTap,
  bool isDismissible = true,
  Widget? contentWidget,
}) {
  return showModalBottomSheet(
    context: context,
    isDismissible: isDismissible,
    backgroundColor: kColorBgDefault,
    clipBehavior: Clip.hardEdge,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    isScrollControlled: true,
    useSafeArea: true,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) {
      return Material(
        child: Container(
          height: height,
          color: kColorBgDefault,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 9,
                  horizontal: 12,
                ),
                child: Row(
                  children: [
                    // if (leftIcon)
                    leftIcon != null
                        ? GestureDetector(
                            onTap: onLeftTap,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                leftIcon,
                                width: 24,
                                height: 24,
                              ),
                            ),
                          )
                        : const SizedBox(
                            width: 44,
                            height: 44,
                          ),

                    const SizedBox(
                      width: 9,
                    ),
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: getTsHeading18(context).copyWith(
                          color: kColorContentDefault,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 9,
                    ),
                    rightIcon != null
                        ? GestureDetector(
                            onTap: onRightTap,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                rightIcon,
                                width: 24,
                                height: 24,
                              ),
                            ),
                          )
                        : const SizedBox(
                            width: 44,
                            height: 44,
                          ),
                  ],
                ),
              ),
              contentWidget ?? Container(),
            ],
          ),
        ),
      );
    },
  );
}

// TODO 문제가 많아 삭제 예정
showDefaultModalBottomSheet({
  required BuildContext context,
  required String title,
  double? height,
  bool titleLeftButton = false,
  bool titleRightButton = false,
  Widget? contentWidget,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: kColorBgDefault,
    clipBehavior: Clip.hardEdge,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    isScrollControlled: true,
    useSafeArea: true,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) {
      return Container(
        height: height ??
            MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                70,
        color: kColorBgDefault,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 9,
                horizontal: 12,
              ),
              child: Row(
                children: [
                  // if (titleLeftButton)
                  titleLeftButton
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              'assets/icons/ic_arrow_back_ios_line_24.svg',
                              width: 24,
                              height: 24,
                            ),
                          ))
                      : const SizedBox(
                          width: 44,
                          height: 44,
                        ),

                  const SizedBox(
                    width: 9,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: getTsHeading18(context).copyWith(
                        color: kColorContentDefault,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 9,
                  ),
                  titleRightButton
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              'assets/icons/ic_cancel_line_24.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        )
                      : const SizedBox(
                          width: 44,
                          height: 44,
                        ),
                ],
              ),
            ),
            Expanded(child: contentWidget ?? Container()),
          ],
        ),
      );
    },
  );
}

showSnackBar({
  required BuildContext context,
  required String text,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        text,
        style: kTsKrBody14Sb.copyWith(
          color: kColorBgDefault,
        ),
      ),
      backgroundColor: Colors.black,
      padding: const EdgeInsets.all(16),
    ),
  );
}

showConfirmModal({
  required BuildContext context,
  String title = '',
  String content = '',
  String leftButton = '취소',
  Color? leftColor,
  String rightButton = '확인',
  Color? rightColor,
  required Function leftCall,
  required Function rightCall,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        insetPadding: EdgeInsets.zero,
        buttonPadding: EdgeInsets.zero,
        backgroundColor: kColorBgDefault,
        surfaceTintColor: kColorBgDefault,
        titlePadding: const EdgeInsets.only(
          top: 32,
          left: 20,
          right: 20,
          bottom: 0,
        ),
        contentPadding: EdgeInsets.only(
          top: content.isEmpty ? 0 : 8,
          left: content.isEmpty ? 0 : 20,
          right: content.isEmpty ? 0 : 20,
        ),
        actionsPadding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: 20,
        ),
        alignment: Alignment.center,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              12,
            ),
          ),
        ),
        title: SizedBox(
          width: 287,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: getTsHeading18(context).copyWith(
              color: kColorContentDefault,
            ),
          ),
        ),
        content: content.isEmpty
            ? null
            : Text(
                content,
                textAlign: TextAlign.center,
                style: getTsBody16Rg(context).copyWith(
                  color: kColorContentWeaker,
                ),
              ),
        actions: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    leftCall();
                  },
                  child: OutlinedButtonWidget(
                    text: leftButton,
                    isEnable: true,
                    height: 44,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    rightCall();
                  },
                  child: FilledButtonWidget(
                    text: rightButton,
                    isEnable: true,
                    backgroundColor: kColorContentError,
                    fontColor: kColorBgDefault,
                    height: 44,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

showDefaultModal({
  required BuildContext context,
  String title = '',
  String content = '',
  String buttonText = '확인',
  required Function function,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        insetPadding: EdgeInsets.zero,
        buttonPadding: EdgeInsets.zero,
        backgroundColor: kColorBgDefault,
        surfaceTintColor: kColorBgDefault,
        titlePadding: const EdgeInsets.only(
          top: 32,
          left: 20,
          right: 20,
          bottom: 0,
        ),
        contentPadding: EdgeInsets.only(
          top: content.isEmpty ? 0 : 8,
          left: content.isEmpty ? 0 : 20,
          right: content.isEmpty ? 0 : 20,
        ),
        actionsPadding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: 20,
        ),
        alignment: Alignment.center,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              12,
            ),
          ),
        ),
        title: SizedBox(
          width: 287,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: getTsHeading18(context).copyWith(
              color: kColorContentDefault,
            ),
          ),
        ),
        content: content.isEmpty
            ? null
            : Text(
                content,
                textAlign: TextAlign.center,
                style: getTsBody16Rg(context).copyWith(
                  color: kColorContentWeaker,
                ),
              ),
        actions: [
          GestureDetector(
            onTap: () {
              function();
            },
            child: FilledButtonWidget(
              text: buttonText,
              isEnable: true,
              height: 44,
            ),
          ),
        ],
      );
    },
  );
}
