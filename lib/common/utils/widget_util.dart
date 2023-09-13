import 'package:biskit_app/common/const/fonts.dart';
import 'package:flutter/material.dart';

import '../component/filled_button_widget.dart';
import '../const/colors.dart';

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
