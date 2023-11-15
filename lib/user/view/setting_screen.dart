import 'package:biskit_app/common/components/list_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/user/view/account_setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingScreen extends ConsumerStatefulWidget {
  static String get routeName => 'SettingScreen';
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  String deviceVersion = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      deviceVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '설정',
      appBarBackgroundColor: kColorBgDefault,
      backgroundColor: kColorBorderWeak,
      shape: const Border(
        bottom: BorderSide(
          width: 1,
          color: kColorBorderDefalut,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListWidget(
              text: '계정',
              onTapCallback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountSettingScreen(),
                  ),
                );
              },
            ),
            _buildDivider(),
            ListWidget(
              text: '언어',
              selectText: '한국어',
              onTapCallback: () {},
            ),
            ListWidget(
              text: '알림',
              onTapCallback: () {},
            ),
            _buildDivider(),
            ListWidget(
              text: '차단 사용자 관리',
              onTapCallback: () {},
            ),
            ListWidget(
              text: '경고 내역',
              onTapCallback: () {},
            ),
            _buildDivider(),
            ListWidget(
              text: '공지사항',
              onTapCallback: () {},
            ),
            ListWidget(
              text: '이용 가이드',
              onTapCallback: () {},
            ),
            ListWidget(
              text: '문의하기',
              onTapCallback: () {},
            ),
            ListWidget(
              text: '신고하기',
              onTapCallback: () {},
            ),
            ListWidget(
              text: '약관 및 정책',
              onTapCallback: () {},
            ),
            ListWidget(
              text: '앱 버전',
              selectText: '업데이트가 필요해요',
              onTapCallback: () {},
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 24,
                bottom: 35,
                left: 20,
                right: 20,
              ),
              color: kColorBorderWeak,
              child: Text(
                '앱 버전 $deviceVersion',
                style: getTsBody14Rg(context).copyWith(
                  color: kColorContentWeakest,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      width: double.infinity,
      height: 8,
      color: kColorBorderWeak,
    );
  }
}
