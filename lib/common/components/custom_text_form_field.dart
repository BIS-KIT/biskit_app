import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../const/colors.dart';
import '../const/fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final TextAlign textAlign;
  final String? initialValue;
  final String? hintText;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool readOnly;
  final Widget? suffixIcon;
  final int? maxLength;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final Color borderColor;
  final bool autofocus;
  final Function()? onEditingComplete;
  const CustomTextFormField({
    Key? key,
    this.textAlign = TextAlign.start,
    this.initialValue,
    this.hintText,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    required this.onChanged,
    this.onFieldSubmitted,
    this.readOnly = false,
    this.suffixIcon,
    this.maxLength,
    this.controller,
    this.focusNode,
    this.inputFormatters,
    this.maxLines = 1,
    this.borderColor = kColorBgElevation3,
    this.autofocus = false,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: borderColor,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(6),
      ),
    );
    return TextFormField(
      onEditingComplete: onEditingComplete,
      maxLines: maxLines,
      onFieldSubmitted: onFieldSubmitted,
      textAlign: textAlign,
      controller: controller,
      focusNode: focusNode,
      initialValue: initialValue,
      style: kTsEnBody16Rg.copyWith(
        color: kColorContentWeak,
      ),
      autofocus: autofocus,
      readOnly: readOnly,
      cursorColor: kColorContentWeak,
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
        fillColor: kColorBgElevation1,
        filled: true,
        hintText: hintText,
        hintStyle: getTsBody16Rg(context).copyWith(
          color: kColorContentPlaceholder,
        ),
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: const BorderSide(
            width: 1,
            color: kColorBorderStronger,
          ),
        ),
        errorText: errorText,
        errorStyle: getTsCaption12Rg(context).copyWith(
          color: kColorContentError,
        ),
        errorBorder: baseBorder.copyWith(
          borderSide: const BorderSide(
            width: 1,
            color: kColorBorderError,
          ),
        ),
        focusedErrorBorder: baseBorder.copyWith(
          borderSide: const BorderSide(
            width: 1,
            color: kColorBorderError,
          ),
        ),
      ),
    );
  }
}
