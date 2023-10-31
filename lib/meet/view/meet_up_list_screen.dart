import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MeetUpListScreen extends StatefulWidget {
  const MeetUpListScreen({super.key});

  @override
  State<MeetUpListScreen> createState() => _MeetUpListScreenState();
}

class _MeetUpListScreenState extends State<MeetUpListScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 2,
              bottom: 2,
              left: 20,
              right: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '탐색',
                  style: getTsHeading20(context).copyWith(
                    color: kColorContentDefault,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        'assets/icons/ic_filter_line_24.svg',
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          kColorContentDefault,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        'assets/icons/ic_search_line_24.svg',
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          kColorContentDefault,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
