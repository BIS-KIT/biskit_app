import 'package:biskit_app/common/components/check_circle.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/setting/repository/setting_repository.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<String> reasons = [
  '7일간 재가입이 불가합니다',
  '모든 계정의 모든 정보는 삭제되며 재가입시에도 복구되지 않습니다',
  '작성한 글? 댓글?',
];

class AccountDeleteStep2Screen extends ConsumerStatefulWidget {
  final String accountDeleteReason;
  const AccountDeleteStep2Screen({
    Key? key,
    required this.accountDeleteReason,
  }) : super(key: key);

  @override
  ConsumerState<AccountDeleteStep2Screen> createState() =>
      _AccountDeleteStep2ScreenState();
}

class _AccountDeleteStep2ScreenState
    extends ConsumerState<AccountDeleteStep2Screen> {
  bool isAgree = false;
  Future<bool> requestDeleteUserAccountReason() async {
    bool isRequested = false;
    try {
      bool? res = await ref
          .read(settingRepositoryProvider)
          .requestDeleteUserAccountReason(
            reason: widget.accountDeleteReason,
          );
      if (res) {
        isRequested = true;
      }
    } finally {}
    return isRequested;
  }

  Future<bool> deleteUserAccount() async {
    bool isDeleted = false;
    try {
      bool? res = await ref.read(settingRepositoryProvider).deleteUserAccount(
            userId: (ref.watch(userMeProvider) as UserModel).id,
          );
      if (res) {
        isDeleted = true;
      }
    } finally {}
    return isDeleted;
  }

  handleClickDeleteConfirm() async {
    bool reasonRes = await requestDeleteUserAccountReason();
    bool isDeleted = false;
    if (reasonRes) {
      bool? res = await deleteUserAccount();
      if (res) {
        isDeleted = true;
      }
    }
    if (isDeleted) {
      ref.read(userMeProvider.notifier).logout();
    } else if (!isDeleted && mounted) {
      showSnackBar(
        context: context,
        text: '계정 탈퇴에 실패했습니다.',
      );
    }
  }

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
              '계정 삭제 전 유의사항을\n확인해주세요',
              style: getTsHeading20(context).copyWith(
                color: kColorContentDefault,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: reasons
                    .map(
                      (e) => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: getTsBody16Rg(context)
                                .copyWith(color: kColorContentWeaker),
                          ),
                          Expanded(
                            child: Text(
                              e,
                              style: getTsBody16Rg(context)
                                  .copyWith(color: kColorContentWeaker),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: GestureDetector(
              onTap: () {
                setState(
                  () {
                    isAgree = !isAgree;
                  },
                );
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CheckCircleWidget(
                      value: isAgree,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Text('유의사항을 확인했으며 모두 동의합니다'),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 34),
            child: GestureDetector(
              onTap: () {
                if (isAgree == false) return;
                showConfirmModal(
                  context: context,
                  leftCall: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  rightCall: () {
                    Navigator.pop(context);
                    showConfirmModal(
                        context: context,
                        rightCall: () async {
                          handleClickDeleteConfirm();
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
              child: FilledButtonWidget(
                text: '계정 삭제하기',
                isEnable: isAgree,
                backgroundColor: kColorBgError,
                fontColor: kColorContentError,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
