import 'package:biskit_app/common/components/check_circle.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/setting/repository/setting_repository.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<String> reasons = [
  "deleteAccountCautionScreen.description1".tr(),
  "deleteAccountCautionScreen.description2".tr(),
  "deleteAccountCautionScreen.description3".tr(),
  "deleteAccountCautionScreen.description4".tr(),
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
      bool isOk = await ref.read(settingRepositoryProvider).deleteUserAccount(
            userId: (ref.watch(userMeProvider) as UserModel).id,
          );
      if (isOk) {
        isDeleted = true;
      }
    } finally {}
    return isDeleted;
  }

  handleClickDeleteConfirm() async {
    bool reasonRes = await requestDeleteUserAccountReason();
    bool isDeleted = false;
    if (reasonRes) {
      bool isOk = await deleteUserAccount();
      if (isOk) {
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
      title: 'deleteAccountCautionScreen.header'.tr(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              "deleteAccountCautionScreen.title".tr(),
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
                  Text('deleteAccountCautionScreen.agree'.tr()),
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
                        title:
                            'deleteAccountCautionScreen.modal.deleteCompleteModal.title'
                                .tr(),
                        content:
                            'deleteAccountCautionScreen.modal.deleteCompleteModal.subtitle'
                                .tr(),
                        rightBackgroundColor: kColorBgPrimary,
                        rightTextColor: kColorContentOnBgPrimary);
                  },
                  title:
                      'deleteAccountCautionScreen.modal.deleteAccountModal.title'
                          .tr(),
                  leftButton:
                      'deleteAccountCautionScreen.modal.deleteAccountModal.cancel'
                          .tr(),
                  rightButton:
                      'deleteAccountCautionScreen.modal.deleteAccountModal.delete'
                          .tr(),
                  rightBackgroundColor: kColorBgError,
                  rightTextColor: kColorContentError,
                );
              },
              child: FilledButtonWidget(
                text: 'deleteAccountCautionScreen.delete'.tr(),
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
