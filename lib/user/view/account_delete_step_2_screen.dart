import 'package:biskit_app/common/components/check_circle.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:flutter/material.dart';

class AccountDeleteStep2Screen extends StatefulWidget {
  const AccountDeleteStep2Screen({super.key});

  @override
  State<AccountDeleteStep2Screen> createState() =>
      _AccountDeleteStep2ScreenState();
}

class _AccountDeleteStep2ScreenState extends State<AccountDeleteStep2Screen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '계정 삭제',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              "계정 삭제 전 유의사항을\n확인해주세요",
              style: getTsHeading20(context).copyWith(
                color: kColorContentDefault,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '• 7일간 재가입이 불가합니다\n• 모든 계정의 모든 정보는 삭제되며 재가입시에도 복구되지 않습니다\n• 작성한 글? 댓글?\n• 재가입시 전에 사용한 이메일 쓸 수 있는지?',
                style:
                    getTsBody16Rg(context).copyWith(color: kColorContentWeaker),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CheckCircleWidget(
                    value: true,
                    onTap: () {},
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                const Text('유의사항을 확인했으며 모두 동의합니다'),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 20),
            child: GestureDetector(
              onTap: () {
                showConfirmModal(
                  context: context,
                  leftCall: () {
                    Navigator.pop(context);
                  },
                  rightCall: () {
                    // TODO: 삭제 api 추가
                    Navigator.pop(context);
                    showConfirmModal(
                        context: context,
                        rightCall: () {
                          Navigator.pop(context);
                        },
                        title: '정상적으로 삭제되었습니다',
                        content: '그동안 BISKIT을 이용해주셔서 감사합니다',
                        rightBackgroundColor: kColorBgPrimary,
                        rightTextColor: kColorContentOnBgPrimary);
                  },
                  title: '계정을 삭제하시겠습니까?',
                  leftButton: '삭제하지 않기',
                  rightButton: '삭제하기',
                  rightBackgroundColor: kColorBgError,
                  rightTextColor: kColorContentError,
                );
              },
              child: const FilledButtonWidget(
                text: '계정 삭제하기',
                isEnable: true,
                backgroundColor: kColorBgError,
                fontColor: kColorContentError,
              ),
            ),
          )
        ],
      ),
    );
  }
}
