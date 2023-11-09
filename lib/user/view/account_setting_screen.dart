import 'package:biskit_app/common/components/list_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountSettingScreen extends ConsumerWidget {
  const AccountSettingScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
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
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'test00@gmail.com',
                            style: getTsBody16Rg(context).copyWith(
                              color: kColorContentWeak,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Text(
                                '2023.11.02',
                                style: getTsCaption12Rg(context).copyWith(
                                  color: kColorContentWeakest,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                '카카오로 가입',
                                style: getTsCaption12Rg(context).copyWith(
                                  color: kColorContentWeakest,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          ListWidget(
            text: '비밀번호 변경',
            onTapCallback: () {},
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
                  Container(
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
