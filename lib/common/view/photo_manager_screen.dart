import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/logger_util.dart';

class PhotoManagerScreen extends StatefulWidget {
  static String get routeName => 'photoManager';
  final bool isCamera;
  const PhotoManagerScreen({
    Key? key,
    this.isCamera = false,
  }) : super(key: key);

  @override
  State<PhotoManagerScreen> createState() => _PhotoManagerScreenState();
}

class _PhotoManagerScreenState extends State<PhotoManagerScreen> {
  bool isLoading = false;
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
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2,
                            ),
                            children: [
                              if (widget.isCamera)
                                Container(
                                  color: Colors.grey,
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    size: 40,
                                    color: Colors.black,
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
      fit: StackFit.expand,
      children: [
        AssetEntityImage(
          e.assetEntity,
          isOriginal: false,
          fit: BoxFit.cover,
        ),
        GestureDetector(
          onTap: () {
            logger.d('onTap Container Image:$e');
            setState(() {
              _images = _images.map((i) {
                if (e == i) {
                  return e.copyWith(
                    isSelected: !e.isSelected,
                  );
                } else {
                  return i;
                }
              }).toList();
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border: e.isSelected
                  ? Border.all(
                      width: 4,
                      color: Colors.amber.withOpacity(0.9),
                    )
                  : null,
            ),
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

  Padding _buildTop(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.black,
                ),
              ),
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
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
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
                        elevation: 0,
                        isDense: false,
                        underline: Container(),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: Text(
                  _images
                      .where((element) => element.isSelected)
                      .toList()
                      .length
                      .toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                // color: Colors.amber,
                child: const Text(
                  '완료',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
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
  bool isSelected;
  PhotoModel({
    required this.assetEntity,
    this.isSelected = false,
  });

  PhotoModel copyWith({
    AssetEntity? assetEntity,
    bool? isSelected,
  }) {
    return PhotoModel(
      assetEntity: assetEntity ?? this.assetEntity,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
