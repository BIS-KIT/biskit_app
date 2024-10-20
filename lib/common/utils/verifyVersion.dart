import 'package:app_version_update/app_version_update.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void verifyVersion(context) async {
  await AppVersionUpdate.checkForUpdates(
    // appleId: '284882215',
    // playStoreId: 'com.zhiliaoapp.musically',
    appleId: '6467542471',
    playStoreId: 'com.teambiskit.biskit',
    country: 'kr',
  ).then((result) async {
    // if (result.canUpdate!) {
    logger.d('Update URL: ${result.storeUrl}');
    logger.d('Update URL: ${result.storeVersion}');
    // await AppVersionUpdate.showBottomSheetUpdate(context: context, appVersionResult: appVersionResult)
    // await AppVersionUpdate.showPageUpdate(context: context, appVersionResult: appVersionResult)
    // or use your own widget with information received from AppVersionResult

    showConfirmModal(
        context: context,
        title: '최신 버전 업데이트',
        content: '새로운 버전이 출시되었습니다.\n앱 업데이트 후 이용해 주시기 바랍니다.',
        leftButton: '취소',
        rightButton: '업데이트',
        leftCall: () {
          Navigator.pop(context);
        },
        rightBackgroundColor: kColorBgPrimary,
        rightTextColor: kColorContentOnBgPrimary,
        rightCall: () async {
          Navigator.pop(context);
          logger.d('Update URL: ${result.storeVersion}');
          launchUrl(result.storeUrl as Uri);
        });

    //##############################################################################################
    // await AppVersionUpdate.showAlertUpdate(
    //   appVersionResult: result,
    //   context: context,
    //   backgroundColor: Colors.white,
    //   title: '최신 버전 업데이트',
    //   titleTextStyle: getTsHeading18(context).copyWith(
    //     color: kColorContentDefault,
    //   ),
    //   cancelButtonStyle: ButtonStyle(
    //     backgroundColor: MaterialStateProperty.all(Colors.white),
    //     padding: MaterialStateProperty.all(
    //       EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    //     ),
    //     shape: MaterialStateProperty.all(
    //       RoundedRectangleBorder(
    //         side: BorderSide(width: 1, color: Color(0xD3D9E2)),
    //         borderRadius: BorderRadius.circular(6),
    //       ),
    //     ),
    //     textStyle: MaterialStateProperty.all(
    //       TextStyle(
    //         color: kColorContentWeak,
    //         fontSize: 16,
    //         fontFamily: 'Pretendard',
    //         fontWeight: FontWeight.w600,
    //       ),
    //     ),
    //   ),
    //   cancelTextStyle: getTsBody16Sb(context).copyWith(
    //     color: kColorContentWeak,
    //   ),
    //   updateButtonStyle: ButtonStyle(
    //     backgroundColor: MaterialStateProperty.all(kColorBgPrimary),
    //     padding: MaterialStateProperty.all(
    //       EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    //     ),
    //     shape: MaterialStateProperty.all(
    //       RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(6),
    //       ),
    //     ),
    //     textStyle: MaterialStateProperty.all(
    //       TextStyle(
    //         color: kColorContentOnBgPrimary,
    //         fontSize: 16,
    //         fontFamily: 'Pretendard',
    //         fontWeight: FontWeight.w600,
    //       ),
    //     ),
    //   ),
    //   updateTextStyle: getTsBody16Sb(context).copyWith(
    //     color: kColorContentOnBgPrimary,
    //   ),
    //   content: '새로운 버전이 출시되었습니다.\n앱 업데이트 후 이용해 주시기 바랍니다.',
    //   contentTextStyle: getTsBody16Sb(context).copyWith(
    //     color: kColorContentWeaker,
    //   ),
    //   updateButtonText: '업데이트',
    //   cancelButtonText: '취소',
    // );
  });
}
