import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/setting/view/account_delete_step_2_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:flutter_svg/svg.dart';

class AccountDeleteStep1Screen extends ConsumerStatefulWidget {
  const AccountDeleteStep1Screen({
    super.key,
  });

  @override
  ConsumerState<AccountDeleteStep1Screen> createState() =>
      _MeetUpCreateStep1TabState();
}

class _MeetUpCreateStep1TabState
    extends ConsumerState<AccountDeleteStep1Screen> {
  @override
  Widget build(BuildContext context) {
    final List<String> reasons = [
      "자주 사용하지 않아요",
      "사용하기가 불편해요",
      "개인정보가 걱정되어요",
      "새로운 계정으로 가입할거에요",
      "기타"
    ];
    return DefaultLayout(
      title: '계정 삭제',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              "계정을 삭제하시려는\n이유가 무엇인가요?",
              style: getTsHeading20(context).copyWith(
                color: kColorContentDefault,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: reasons.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 56,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccountDeleteStep2Screen(
                            accountDeleteReason: reasons[index],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              reasons[index],
                              style: getTsBody16Rg(context).copyWith(
                                color: kColorContentWeak,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          SvgPicture.asset(
                            'assets/icons/ic_chevron_right_line_24.svg',
                            colorFilter: const ColorFilter.mode(
                              kColorContentWeaker,
                              BlendMode.srcIn,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
