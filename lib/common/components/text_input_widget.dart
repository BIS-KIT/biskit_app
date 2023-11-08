// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../const/colors.dart';
import '../const/fonts.dart';
import 'custom_text_form_field.dart';

class TextInputWidget extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final String? hintText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool readOnly;
  final String? initialValue;
  final Widget? suffixIcon;
  final int? maxLength;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  const TextInputWidget({
    Key? key,
    required this.title,
    this.titleStyle,
    this.hintText,
    this.errorText,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.readOnly = false,
    this.initialValue,
    this.suffixIcon,
    this.maxLength,
    this.controller,
    this.focusNode,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: titleStyle ??
              getTsBody14Sb(context).copyWith(
                color: kColorContentWeak,
              ),
        ),
        const SizedBox(
          height: 8,
        ),
        CustomTextFormField(
          initialValue: initialValue,
          hintText: hintText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          errorText: errorText,
          onChanged: onChanged,
          readOnly: readOnly,
          suffixIcon: suffixIcon,
          maxLength: maxLength,
          controller: controller,
          focusNode: focusNode,
          inputFormatters: inputFormatters,
        ),
      ],
    );
  }
}
