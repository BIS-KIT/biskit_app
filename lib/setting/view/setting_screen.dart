import 'package:biskit_app/common/components/list_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/view/web_view_screen.dart';
import 'package:biskit_app/setting/model/user_system_model.dart';
import 'package:biskit_app/setting/provider/system_provider.dart';
import 'package:biskit_app/setting/view/account_setting_screen.dart';
import 'package:biskit_app/setting/view/contact_screen.dart';
import 'package:biskit_app/setting/view/language_setting_screen.dart';
import 'package:biskit_app/setting/view/notice_screen.dart';
import 'package:biskit_app/setting/view/notification_setting_screen.dart';
import 'package:biskit_app/setting/view/terms_and_policies_screen.dart';
import 'package:biskit_app/setting/view/user_block_list_screen.dart';
import 'package:biskit_app/setting/view/warning_history_screen.dart';
import 'package:easy_localization/easy_localization.dart';
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
    final state = ref.watch(systemProvider);
    return DefaultLayout(
      title: 'settingScreen.title'.tr(),
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
              text: 'settingScreen.account'.tr(),
              selectIconPath: 'assets/icons/ic_chevron_right_line_24.svg',
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
              text: 'settingScreen.lang'.tr(),
              selectIconPath: 'assets/icons/ic_chevron_right_line_24.svg',
              selectText: (state is UserSystenModelError ||
                      state is UserSystemModelLoading)
                  ? ''
                  : (state as UserSystemModel).system_language == kEn
                      ? 'setLangScreen.english'.tr()
                      : 'setLangScreen.korean'.tr(),
              onTapCallback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LanguageSettingScreen(),
                  ),
                );
              },
            ),
            ListWidget(
              text: 'settingScreen.notification'.tr(),
              selectIconPath: 'assets/icons/ic_chevron_right_line_24.svg',
              onTapCallback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationSettingScreen(),
                  ),
                );
              },
            ),
            _buildDivider(),
            ListWidget(
              text: 'settingScreen.blockedUser'.tr(),
              selectIconPath: 'assets/icons/ic_chevron_right_line_24.svg',
              onTapCallback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserBlockListScreen(),
                  ),
                );
              },
            ),
            ListWidget(
              text: 'settingScreen.warning'.tr(),
              selectIconPath: 'assets/icons/ic_chevron_right_line_24.svg',
              onTapCallback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WarningHistoryScreen(),
                  ),
                );
              },
            ),
            _buildDivider(),
            ListWidget(
              text: 'settingScreen.notice'.tr(),
              selectIconPath: 'assets/icons/ic_chevron_right_line_24.svg',
              onTapCallback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NoticeScreen(),
                  ),
                );
              },
            ),
            ListWidget(
              text: 'settingScreen.guide'.tr(),
              selectIconPath: 'assets/icons/ic_chevron_right_line_24.svg',
              onTapCallback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewScreen(
                      url: kUseGuideUrl,
                      title: 'settingScreen.guide'.tr(),
                    ),
                  ),
                );
              },
            ),
            ListWidget(
              text: 'settingScreen.inquiry'.tr(),
              selectIconPath: 'assets/icons/ic_chevron_right_line_24.svg',
              onTapCallback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactScreen(),
                  ),
                );
              },
            ),
            // ListWidget(
            //   text: '신고하기',
            // selectIconPath: 'assets/icons/ic_chevron_right_line_24.svg',
            //   onTapCallback: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const ReportScreen(),
            //       ),
            //     );
            //   },
            // ),
            ListWidget(
              text: 'settingScreen.terms'.tr(),
              selectIconPath: 'assets/icons/ic_chevron_right_line_24.svg',
              onTapCallback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsAndPoliciesScreen(),
                  ),
                );
              },
            ),
            // TODO: 스토어 앱 버전 가져와서 비교
            // ListWidget(
            //   text: 'settingScreen.ver'.tr(),
            //   selectText: 'settingScreen.update'.tr(),
            //   onTapCallback: () {},
            // ),
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
                '${'settingScreen.ver'.tr()} $deviceVersion',
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
