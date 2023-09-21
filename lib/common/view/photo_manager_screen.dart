// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/logger_util.dart';

class PhotoManagerScreen extends StatefulWidget {
  static String get routeName => 'photoManager';
  final bool isCamera;
  final int maxCnt;
  const PhotoManagerScreen({
    Key? key,
    this.isCamera = false,
    this.maxCnt = 30,
  }) : super(key: key);

  @override
  State<PhotoManagerScreen> createState() => _PhotoManagerScreenState();
}

class _PhotoManagerScreenState extends State<PhotoManagerScreen> {
  bool isLoading = false;
  final List<PhotoModel> _selectedPhoto = []; // 모든 파일 정보
  List<AssetPathEntity>? _paths; // 모든 파일 정보
  List<Album> _albums = []; // 드롭다운 앨범 목록
  List<PhotoModel> _images = []; // 앨범의 이미지 목록
  int _currentPage = 0; // 현재 페이지
  late Album _currentAlbum; // 드롭다운 선택된 앨범

  PhotoModel? viewPhoto;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    checkPermission();
    scrollController.addListener(() {
      if (scrollController.offset >
          scrollController.position.maxScrollExtent - 300) {
        getPhotos(
          _currentAlbum,
          albumChange: false,
        );
      }
    });
  }

  // 권한 확인
  checkPermission() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      logger.d(androidInfo.toString());

      // android sdk 33부터 권한 요청이 다름
      // 아직까지는 분기처리 사용안해도 잘 되는듯 함.
      if (androidInfo.version.sdkInt > 32) {
      } else {}
    }

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

    _albums = _paths!.map((e) {
      // logger.d(e);
      return Album(
        id: e.id,
        name: e.isAll ? '모든 사진' : e.name,
      );
    }).toList();

    await getPhotos(_albums[0], albumChange: true);
  }

  // 앨범 이미지 목록
  getPhotos(
    Album album, {
    bool albumChange = false,
  }) async {
    // setState(() {
    //   isLoading = true;
    // });
    _currentAlbum = album;
    albumChange ? _currentPage = 0 : _currentPage++;

    final loadImages = await _paths!
        .singleWhere((AssetPathEntity e) => e.id == album.id)
        .getAssetListPaged(
          page: _currentPage,
          size: 20,
        );

    setState(() {
      if (albumChange) {
        _images = loadImages.map((e) => PhotoModel(assetEntity: e)).toList();
        logger.d(_images.map((e) => e.assetEntity.id).toList().toString());
      } else {
        _images
            .addAll(loadImages.map((e) => PhotoModel(assetEntity: e)).toList());
      }
      // isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        child: viewPhoto != null
            ? _buildPreview()
            : Column(
                children: [
                  _buildTop(context),

                  // 사진들
                  Expanded(
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : GridView(
                            controller: scrollController,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 3,
                              mainAxisSpacing: 3,
                            ),
                            children: [
                              if (widget.isCamera)
                                Container(
                                  color: kColorGray3,
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    size: 40,
                                    color: kColorGray6,
                                  ),
                                ),
                              ..._images.map(
                                (e) => _buildPhoto(e),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Stack _buildPhoto(PhotoModel e) {
    return Stack(
      // fit: StackFit.expand,
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: AssetEntityImage(
            e.assetEntity,
            isOriginal: false,
            fit: BoxFit.cover,
          ),
        ),
        GestureDetector(
          onTap: () {
            if (_selectedPhoto
                .where((element) => element.assetEntity.id == e.assetEntity.id)
                .isEmpty) {
              // 비활성화 상태를 선택한 경우
              if (_selectedPhoto.length >= widget.maxCnt) {
                // 이미 최대 수량을 선택한 경우
                if (widget.maxCnt == 1) {
                  // 만약 최대 수량이 1개인 경우는 선택한 사진으로 변경
                  setState(() {
                    _selectedPhoto.clear();
                    _selectedPhoto.add(e);
                  });
                }
                return;
              } else {
                setState(() {
                  _selectedPhoto.add(e);
                });
              }
            } else {
              // 활성화 상태를 선택한 경우
              setState(() {
                _selectedPhoto.removeWhere(
                    (element) => element.assetEntity.id == e.assetEntity.id);
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: _selectedPhoto
                      .where((element) =>
                          element.assetEntity.id == e.assetEntity.id)
                      .isNotEmpty
                  ? Border.all(
                      width: 3,
                      color: kColorYellow4,
                    )
                  : null,
            ),
          ),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _selectedPhoto
                      .where((element) =>
                          element.assetEntity.id == e.assetEntity.id)
                      .isNotEmpty
                  ? kColorYellow4
                  : Colors.white.withOpacity(0.4),
              border: Border.all(
                width: 2,
                color: _selectedPhoto
                        .where((element) =>
                            element.assetEntity.id == e.assetEntity.id)
                        .isNotEmpty
                    ? kColorYellow4
                    : Colors.black.withOpacity(0.4),
              ),
              shape: BoxShape.circle,
            ),
            child: _selectedPhoto
                    .where(
                        (element) => element.assetEntity.id == e.assetEntity.id)
                    .isNotEmpty
                ? Text(
                    (_selectedPhoto
                                .map((e) => e.assetEntity.id)
                                .toList()
                                .indexOf(e.assetEntity.id) +
                            1)
                        .toString(),
                    textAlign: TextAlign.center,
                    style: getTsBody14Sb(context).copyWith(
                      color: kColorGray9,
                    ),
                  )
                : null,
          ),
        ),
        Positioned(
          bottom: 0,
          child: GestureDetector(
            onTap: () {
              // preview
              logger.d('onTap fullscreen:${e.assetEntity}');
              setState(() {
                viewPhoto = e;
              });
            },
            child: Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
              ),
              child: const Icon(
                Icons.fullscreen_sharp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTop(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: kColorGray3,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const SizedBox(
                    width: 44,
                    height: 44,
                    child: Icon(
                      Icons.close_rounded,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: _albums.isNotEmpty
                      ? DropdownButton(
                          value: _currentAlbum,
                          items: _albums
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e.name,
                                    style: getTsHeading18(context).copyWith(
                                      color: kColorGray9,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (Album? value) {
                            getPhotos(
                              value!,
                              albumChange: true,
                            );
                          },
                          iconEnabledColor: kColorGray9,
                          elevation: 0,
                          isDense: false,
                          underline: Container(),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (_selectedPhoto.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            _selectedPhoto.length.toString(),
                            style: getTsBody16Rg(context).copyWith(
                              color: kColorYellow6,
                            ),
                          ),
                        ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(
                            context,
                            _selectedPhoto,
                          );
                        },
                        child: Text(
                          '완료',
                          style: getTsBody16Sb(context).copyWith(
                            color: _selectedPhoto.isEmpty
                                ? kColorGray5
                                : kColorGray9,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stack _buildPreview() {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: AssetEntityImage(
                viewPhoto!.assetEntity,
                isOriginal: true,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            setState(() {
              viewPhoto = null;
            });
          },
          icon: const Icon(
            Icons.close_rounded,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class Album {
  String id;
  String name;

  Album({
    required this.id,
    required this.name,
  });
}

class PhotoModel {
  final AssetEntity assetEntity;
  PhotoModel({
    required this.assetEntity,
  });

  PhotoModel copyWith({
    AssetEntity? assetEntity,
  }) {
    return PhotoModel(
      assetEntity: assetEntity ?? this.assetEntity,
    );
  }
}
