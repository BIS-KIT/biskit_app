import 'package:biskit_app/common/const/fonts.dart';
import 'package:flutter/material.dart';

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
