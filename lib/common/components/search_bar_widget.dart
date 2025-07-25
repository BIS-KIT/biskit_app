// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:biskit_app/common/utils/logger_util.dart';

import '../const/colors.dart';
import '../const/fonts.dart';

enum SearchBarStatus {
  defaultType,
  focused,
  typing,
  completed,
}

class SearchBarWidget extends StatefulWidget {
  final String? hintText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final Function(String)? onFieldSubmitted;
  final int? maxLength;
  final bool autofocus;
  const SearchBarWidget({
    Key? key,
    this.hintText,
    required this.controller,
    required this.onChanged,
    this.onFieldSubmitted,
    this.maxLength,
    this.autofocus = false,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  FocusNode focusNode = FocusNode();
  SearchBarStatus status = SearchBarStatus.defaultType;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      logger.d(focusNode.hasFocus);
      if (focusNode.hasFocus) {
        setState(() {
          if (widget.controller.text.isEmpty) {
            status = SearchBarStatus.focused;
          } else {
            status = SearchBarStatus.typing;
          }
        });
      } else {
        setState(() {
          status = SearchBarStatus.defaultType;
        });
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 14,
        bottom: 14,
        left: 12,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: kColorBgElevation1,
        border: Border.all(
          width: 1,
          color: status == SearchBarStatus.defaultType ||
                  status == SearchBarStatus.completed
              ? kColorBgElevation3
              : kColorBorderStronger,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/ic_search_line_24.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              kColorContentWeaker,
              BlendMode.srcIn,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller: widget.controller,
                focusNode: focusNode,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      status = SearchBarStatus.typing;
                    });
                  }
                  widget.onChanged.call(value);
                },
                autofocus: widget.autofocus,
                onFieldSubmitted: widget.onFieldSubmitted,
                style: getTsBody16Rg(context).copyWith(
                  color: kColorContentWeak,
                ),
                maxLength: widget.maxLength ?? widget.maxLength,
                cursorColor: kColorContentWeak,
                scrollPadding: EdgeInsets.zero,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  counterText: '',
                  hintStyle: getTsBody16Rg(context).copyWith(
                    color: kColorContentPlaceholder,
                  ),
                ),
              ),
            ),
          ),
          if (status == SearchBarStatus.typing)
            GestureDetector(
              onTap: () {
                widget.controller.text = '';
              },
              child: SvgPicture.asset(
                'assets/icons/ic_cancel_fill_16.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  kColorContentWeakest,
                  BlendMode.srcIn,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
