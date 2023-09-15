import 'package:biskit_app/common/const/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../component/filled_button_widget.dart';
import '../const/colors.dart';

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
    backgroundColor: Colors.white,
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
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 9,
                horizontal: 12,
              ),
              child: Row(
                children: [
                  if (titleLeftButton)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        'assets/icons/ic_arrow_back_ios_line_24.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  const SizedBox(
                    width: 9,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: getTsHeading20(context).copyWith(
                        color: kColorGray9,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 9,
                  ),
                  if (titleRightButton)
                    GestureDetector(
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
                    ),
                ],
              ),
            ),
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
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black,
      padding: const EdgeInsets.all(16),
    ),
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
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
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
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: getTsHeading20(context).copyWith(
            color: kColorGray9,
          ),
        ),
        content: content.isEmpty
            ? null
            : Text(
                content,
                textAlign: TextAlign.center,
                style: getTsBody16Rg(context).copyWith(
                  color: kColorGray7,
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
            ),
          ),
        ],
      );
    },
  );
}
