import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/components/time_picker_widget.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/filled_button_widget.dart';
import '../const/colors.dart';

/// widget 사이즈 반환
Size? getWidgetSize(GlobalKey key) {
  Size? size;
  if (key.currentContext != null) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    size = renderBox.size;
  }
  return size;
}

class MoreButton {
  final String text;
  final Color color;
  final Function()? onTap;
  MoreButton({
    required this.text,
    required this.color,
    this.onTap,
  });
}

/// 모임원관리 버튼 바텀 시트
showMoreBottomSheet({
  required BuildContext context,
  required List<MoreButton> list,
}) {
  return showModalBottomSheet(
    context: context,
    elevation: 0,
    backgroundColor: Colors.transparent,
    barrierColor: kColorBgDimmed.withOpacity(0.5),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: kColorBgDefault,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: list
                    .map((e) => GestureDetector(
                          onTap: e.onTap,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: double.infinity,
                            height: 56,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              e.text,
                              style: getTsBody16Rg(context).copyWith(
                                color: e.color,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                height: 56,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                decoration: const BoxDecoration(
                  color: kColorBgDefault,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '취소',
                  style: getTsBody16Rg(context).copyWith(
                    color: kColorContentDefault,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      );
    },
  );
}

/// more 버튼 바텀 시트
showReviewMoreBottomSheet({
  required BuildContext context,
  Function()? onTapFix,
  Function()? onTapDelete,
}) {
  return showModalBottomSheet(
    context: context,
    elevation: 0,
    backgroundColor: Colors.transparent,
    barrierColor: kColorBgDimmed.withOpacity(0.5),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onTapFix,
              child: Container(
                width: double.infinity,
                height: 56,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                decoration: const BoxDecoration(
                  color: kColorBgDefault,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'detailReviewScreen.actionSheet.edit'.tr(),
                  style: getTsBody16Rg(context).copyWith(
                    color: kColorContentDefault,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: onTapDelete,
              child: Container(
                width: double.infinity,
                height: 56,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                decoration: const BoxDecoration(
                  color: kColorBgDefault,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'detailReviewScreen.actionSheet.remove'.tr(),
                  style: getTsBody16Rg(context).copyWith(
                    color: kColorContentError,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                height: 56,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                decoration: const BoxDecoration(
                  color: kColorBgDefault,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'detailReviewScreen.actionSheet.cancel'.tr(),
                  style: getTsBody16Rg(context).copyWith(
                    color: kColorContentDefault,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      );
    },
  );
}

/// 시간 선택 바텀 시트
showTimeBottomSheet({
  required BuildContext context,
  required DateTime time,
  // required Function(DateTime newTime) onDateTimeChanged,
  required Function() onTapBack,
}) async {
  return await showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return TimePickerWidget(
        time: time,
        onTapBack: onTapBack,
      );
    },
  );
}

showBiskitBottomSheet({
  required BuildContext context,
  required String title,
  Widget? customTitleWidget,
  double? height,
  String? leftIcon,
  String? rightIcon,
  Function()? onLeftTap,
  Function()? onRightTap,
  bool isDismissible = true,
  Widget? contentWidget,
  bool isScrollControlled = true,
  bool enableDrag = true,
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
    enableDrag: enableDrag,
    isScrollControlled: isScrollControlled,
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
              customTitleWidget ??
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

showDefaultModalBottomSheet({
  required BuildContext context,
  required String title,
  double? height,
  bool titleLeftButton = false,
  bool titleRightButton = false,
  Widget? contentWidget,
  bool enableDrag = true,
  bool isDismissible = true,
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
    enableDrag: enableDrag,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: isDismissible,
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
  EdgeInsetsGeometry? margin,
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
      backgroundColor: kColorBgOverlay.withOpacity(0.7),
      padding: const EdgeInsets.all(16),
      margin: margin,
    ),
  );
}

showConfirmModal({
  required BuildContext context,
  String title = '',
  String content = '',
  String leftButton = '취소',
  Color? leftBackgroundColor,
  Color? leftTextColor,
  String rightButton = '확인',
  Color rightBackgroundColor = kColorContentError,
  Color rightTextColor = kColorBgDefault,
  Function? leftCall,
  required Function rightCall,
}) {
  return showDialog(
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
              if (leftCall != null)
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
              if (leftCall != null)
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
                    backgroundColor: rightBackgroundColor,
                    fontColor: rightTextColor,
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
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
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

/// 다음화면시 업다운 애니메이션
Route<List<dynamic>> createUpDownRoute(Widget nextScreen) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
