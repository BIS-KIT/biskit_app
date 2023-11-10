import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';

class DefaultLayout extends StatelessWidget {
  final String? leadingIconPath;
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final List<Widget>? actions;
  final bool resizeToAvoidBottomInset;
  final VoidCallback? onTapLeading;
  final bool borderShape;

  final ShapeBorder? shape;
  const DefaultLayout({
    Key? key,
    this.leadingIconPath = 'assets/icons/ic_arrow_back_ios_line_24.svg',
    this.backgroundColor,
    required this.child,
    this.title,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.actions,
    this.resizeToAvoidBottomInset = true,
    this.shape,
    this.onTapLeading,
    this.borderShape = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor ?? kColorBgDefault,
      body: child,
      appBar: renderAppBar(context),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }

  AppBar? renderAppBar(BuildContext context) {
    // logger.d(context.locale.languageCode);
    if (title == null) {
      return null;
    } else {
      return AppBar(
        toolbarHeight: 48,
        backgroundColor: backgroundColor ?? kColorBgDefault,
        surfaceTintColor: backgroundColor ?? kColorBgDefault,
        elevation: 0,
        centerTitle: true,
        shape: borderShape ? shape : null,
        title: Text(
          title!,
          style: getTsHeading18(context).copyWith(
            color: kColorContentDefault,
          ),
        ),
        foregroundColor: kColorContentDefault,
        leadingWidth: 54,
        leading: GestureDetector(
          onTap: () {
            if (onTapLeading == null) {
              Navigator.pop(context);
            } else {
              onTapLeading!();
            }
          },
          child: Container(
            margin: const EdgeInsets.only(
              left: 10,
            ),
            padding: const EdgeInsets.all(10),
            constraints: const BoxConstraints(),
            child: SvgPicture.asset(
              leadingIconPath!,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                kColorContentDefault,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        actions: actions,
      );
    }
  }
}
