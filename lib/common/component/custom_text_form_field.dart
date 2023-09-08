import 'package:flutter/material.dart';

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
      decoration: InputDecoration(
        counterText: '',
        isDense: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 4,
        ),
        prefix: const SizedBox(
          width: 16,
        ),
        // suffixIcon: obscureButton
        //     ? IconButton(
        //         onPressed: () {
        //           setState(() {
        //             obscureText = !obscureText;
        //           });
        //         },
        //         icon: Icon(
        //           obscureText
        //               ? Icons.visibility_off_outlined
        //               : Icons.visibility_outlined,
        //           color: kColorGray7,
        //         ),
        //       )
        //     : null,
        suffixIcon: suffixIcon,
        suffix: const SizedBox(
          width: 16,
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
