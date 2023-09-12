import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../const/colors.dart';
import '../const/fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final String? initialValue;
  final String? hintText;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final Widget? suffixIcon;
  final int? maxLength;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  const CustomTextFormField({
    Key? key,
    this.initialValue,
    this.hintText,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    required this.onChanged,
    this.readOnly = false,
    this.suffixIcon,
    this.maxLength,
    this.controller,
    this.focusNode,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder baseBorder = const OutlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: kColorGray3,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(6),
      ),
    );
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      initialValue: initialValue,
      style: kTsEnBody16Rg.copyWith(
        color: kColorGray8,
      ),
      readOnly: readOnly,
      cursorColor: kColorGray8,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      obscureText: obscureText,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        counterText: '',
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 14,
        ),
        prefix: const SizedBox(
          width: 16,
        ),
        suffixIcon: suffixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(right: 16),
                child: suffixIcon,
              ),
        suffixIconConstraints: suffixIcon == null
            ? null
            : const BoxConstraints(
                maxHeight: 24,
                // maxWidth: 24 + 16,
                minHeight: 24,
                minWidth: 24,
              ),
        suffix: SizedBox(
          width: suffixIcon == null ? 16 : 8,
        ),
        fillColor: kColorGray1,
        filled: true,
        hintText: hintText,
        hintStyle: getTsBody16Rg(context).copyWith(
          color: kColorGray5,
        ),
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: const BorderSide(
            width: 1,
            color: kColorGray7,
          ),
        ),
        errorText: errorText,
        errorStyle: getTsCaption12Rg(context).copyWith(
          color: kColorDangerDark,
        ),
        errorBorder: baseBorder.copyWith(
          borderSide: const BorderSide(
            width: 1,
            color: kColorDangerDark,
          ),
        ),
        focusedErrorBorder: baseBorder.copyWith(
          borderSide: const BorderSide(
            width: 1,
            color: kColorDangerDark,
          ),
        ),
      ),
    );
  }
}
