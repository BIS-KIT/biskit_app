import 'package:flutter/material.dart';

import '../const/colors.dart';
import '../const/fonts.dart';

class CustomTextFormField extends StatefulWidget {
  final String? initialValue;
  final String? hintText;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  const CustomTextFormField({
    Key? key,
    this.initialValue,
    this.hintText,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool obscureButton = false;
  bool obscureText = false;

  @override
  void initState() {
    obscureText = widget.obscureText;
    obscureButton = widget.obscureText;
    super.initState();
  }

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
      initialValue: widget.initialValue,
      style: kTsEnBody16Rg.copyWith(
        color: kColorGray8,
      ),
      cursorColor: kColorGray8,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        isDense: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 4,
        ),
        prefix: const SizedBox(
          width: 16,
        ),
        suffixIcon: obscureButton
            ? IconButton(
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: kColorGray7,
                ),
              )
            : null,
        suffix: const SizedBox(
          width: 16,
        ),
        fillColor: kColorGray1,
        filled: true,
        hintText: widget.hintText,
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
        errorText: widget.errorText,
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
