import 'package:biskit_app/common/components/list_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/setting/view/account_delete_step_1_screen.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:biskit_app/setting/view/current_password_verify_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class AccountSettingScreen extends ConsumerWidget {
  const AccountSettingScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final userState = ref.watch(userMeProvider);
    final DateFormat dateFormat = DateFormat('yyyy/MM/dd', 'ko');
    return DefaultLayout(
      title: '계정',
      shape: const Border(
        bottom: BorderSide(
          width: 1,
          color: kColorBorderDefalut,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: kColorBgDefault,
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: kColorBorderWeak,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '가입정보',
                  style: getTsBody16Rg(context).copyWith(
                    color: kColorContentWeak,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    if (userState is UserModel)
                      SvgPicture.asset(
                        userState.sns_type == null
                            ? 'assets/icons/ic_login_email.svg'
                            // TODO: sns_type 에 따라 아이콘 다르게 처리
                            : 'assets/icon/ic_login_kakao.svg',
                        width: 40,
                        height: 40,
                      ),
                    const SizedBox(
                      width: 12,
                    ),
                    if (userState is UserModel)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (userState.email != null)
                              Text(
                                '${userState.email}',
                                style: getTsBody16Rg(context).copyWith(
                                  color: kColorContentWeak,
                                ),
                              ),
                            if (userState.email != null)
                              const SizedBox(
                                height: 4,
                              ),
                            Row(
                              children: [
                                Text(
                                  dateFormat.format(
                                    DateTime.parse(userState.created_time),
                                  ),
                                  style: getTsCaption12Rg(context).copyWith(
                                    color: kColorContentWeakest,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  userState.sns_type == null
                                      ? '이메일 회원가입'
                                      // TODO: sns_type 에 따라 텍스트 다르게 처리
                                      : '카카오 회원가입',
                                  style: getTsCaption12Rg(context).copyWith(
                                    color: kColorContentWeakest,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          ListWidget(
            text: '비밀번호 변경',
            onTapCallback: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CurrentPasswordVerifyScreen(),
                ),
              );
            },
          ),
          ListWidget(
            text: '로그아웃',
            onTapCallback: () {
              showConfirmModal(
                context: context,
                title: '로그아웃 하시겠어요?',
                leftButton: '취소',
                leftCall: () {
                  Navigator.pop(context);
                },
                rightButton: '로그아웃',
                rightBackgroundColor: kColorBgError,
                rightTextColor: kColorContentError,
                rightCall: () {
                  ref.read(userMeProvider.notifier).logout();
                },
              );
            },
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: kColorBgElevation2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AccountDeleteStep1Screen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 16,
                        bottom: 16,
                        left: 20,
                        right: 20,
                      ),
                      child: Text(
                        '계정 삭제',
                        style: getTsBody14Rg(context).copyWith(
                          color: kColorContentWeakest,
                          decoration: TextDecoration.underline,
                          decorationColor: kColorContentWeakest,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
