import 'package:biskit_app/common/components/select_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:flutter/material.dart';

enum ListWidgetType { select, toggle }

class ListWidget extends StatefulWidget {
  final String text;
  final String? subText;
  final String selectText;
  final String? selectIconPath;
  final VoidCallback onTapCallback;
  final ListWidgetType type;
  const ListWidget({
    Key? key,
    required this.text,
    this.subText,
    this.selectText = '',
    this.selectIconPath,
    required this.onTapCallback,
    this.type = ListWidgetType.select,
  }) : super(key: key);

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        setState(() {
          _pressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          _pressed = false;
        });
      },
      onTapUp: (details) async {
        setState(() {
          _pressed = false;
        });
        widget.onTapCallback();
      },
      child: Container(
        height: widget.subText == null ? 56 : null,
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: widget.subText == null ? 0 : 16,
        ),
        decoration: BoxDecoration(
          color: _pressed ? kColorBgElevation1 : kColorBgDefault,
        ),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.text,
                    style: getTsBody16Rg(context).copyWith(
                      color: kColorContentWeak,
                    ),
                  ),
                  if (widget.subText != null)
                    Column(
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          widget.subText!,
                          style: getTsBody14Rg(context).copyWith(
                            color: kColorContentWeakest,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            if (ListWidgetType.select == widget.type)
              SelectWidget(
                usageType: 'body',
                text: widget.selectText,
                iconPath: widget.selectIconPath,
              ),
          ],
        ),
      ),
    );
  }
}
