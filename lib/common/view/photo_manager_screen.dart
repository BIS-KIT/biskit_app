import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoManagerScreen extends StatefulWidget {
  static String get routeName => 'photoManager';
  const PhotoManagerScreen({super.key});

  @override
  State<PhotoManagerScreen> createState() => _PhotoManagerScreenState();
}

class _PhotoManagerScreenState extends State<PhotoManagerScreen> {
  List<AssetPathEntity>? _paths; // 모든 파일 정보

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  // 권한 확인
  checkPermission() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    logger.d(androidInfo.toString());

    // android sdk 33부터 권한 요청이 다름
    // 아직까지는 분기처리 사용안해도 잘 되는듯 함.
    if (androidInfo.version.sdkInt > 32) {
    } else {}

    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    logger.d('ps.isAuth:${ps.isAuth}');
    if (ps.isAuth) {
      // 권한 수락
      await getAlbum();
    } else {
      // 권한 거절
      await PhotoManager.openSetting();
    }
  }

  // 앨범리스트 가져오기
  getAlbum() async {
    _paths = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    _paths!.map((e) {
      logger.d(e);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      child: Column(),
    );
  }
}
