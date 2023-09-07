// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../const/colors.dart';
import '../const/fonts.dart';
import 'custom_text_form_field.dart';

class TextInputWidget extends StatelessWidget {
  final String title;
  final String? hintText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  const TextInputWidget({
    Key? key,
    required this.title,
    this.hintText,
    this.errorText,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: getTsBody14Sb(context).copyWith(
            color: kColorGray8,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        CustomTextFormField(
          hintText: hintText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          errorText: errorText,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
