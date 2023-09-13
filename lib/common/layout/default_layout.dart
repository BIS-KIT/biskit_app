import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const DefaultLayout({
    super.key,
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
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
        backgroundColor: backgroundColor ?? Colors.white,
        surfaceTintColor: backgroundColor ?? Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title!,
          style: getTsHeading18(context).copyWith(
            color: kColorGray9,
          ),
        ),
        foregroundColor: kColorGray9,
        leadingWidth: 54,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.only(
              left: 10,
            ),
            padding: const EdgeInsets.all(10),
            constraints: const BoxConstraints(),
            child: SvgPicture.asset(
              'assets/icons/ic_arrow_back_ios_line_24.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                kColorGray9,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      );
    }
  }
}
