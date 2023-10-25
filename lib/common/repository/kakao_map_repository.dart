import 'dart:convert';

import 'package:biskit_app/common/model/kakao/kakao_document_model.dart';
import 'package:biskit_app/common/model/kakao/kakao_local_keyword_res_model.dart';
import 'package:biskit_app/common/model/kakao/kakao_meta_model.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:dio/dio.dart';

import '../const/keys.dart';

class KakaoMapReposity {
  final Dio dio = Dio(
    BaseOptions(
      headers: {
        'Authorization': 'KakaoAK $kKakaoRestApiKey',
      },
    ),
  );
  final String baseUrl = 'https://dapi.kakao.com';
  // KakaoMapReposity({
  //   required this.dio,
  // });

  // 카카오 로컬 키워드 검색
  Future<KakaoLocalKeywordResModel?> getLocalSearchKeyword({
    required String query,
    int page = 1,
    bool isEng = false,
  }) async {
    // logger.d('page : $page');
    KakaoLocalKeywordResModel? kakaoLocalKeywordResModel;
    try {
      var res = await dio.get(
        "$baseUrl/v2/local/search/keyword.json",
        queryParameters: {
          'query': query,
          'page': page,
          'size': 15, // 45개가 최대값인데 15 넘으면 에러남 kakao 문제 같음
        },
      );
      if (res.statusCode == 200) {
        // logger.d(res.data);
        KakaoMetaModel? kakaoMetaModel =
            KakaoMetaModel.fromMap(res.data['meta']);
        // logger.d(kakaoMetaModel);
        List<KakaoDocumentModel> documents = List.from(
            res.data['documents'].map((e) => KakaoDocumentModel.fromMap(e)));
        // logger.d(documents);

        if (isEng) {
          // 영문 포함
          final Dio engDio = Dio();
          List<KakaoDocumentModel> engDocuments = [];
          for (KakaoDocumentModel doc in documents) {
            doc = doc.copyWith(
              eng_road_address_name:
                  await getEngAddress(engDio, doc.road_address_name),
            );
            engDocuments.add(doc);
          }
          documents = engDocuments;
        }

        kakaoLocalKeywordResModel = KakaoLocalKeywordResModel(
          meta: kakaoMetaModel,
          documents: documents,
        );
      }
    } catch (e) {
      logger.d(e);
    }
    return kakaoLocalKeywordResModel;
  }

  Future<String> getEngAddress(Dio engDio, String roadAddress) async {
    String engAddress = '';

    final res = await engDio.post(
      'https://business.juso.go.kr/addrlink/addrEngApiJsonp.do',
      data: FormData.fromMap({
        'confmKey': 'devU01TX0FVVEgyMDIzMTAyNTEwMDMwOTExNDIwNzI=',
        'currentPage': '1',
        'countPerPage': '1',
        'resultType': 'json',
        'keyword': roadAddress,
      }),
    );
    String str = res.data.toString();
    str = str.substring(
      1,
      str.length - 1,
    );

    final Map data = jsonDecode(str);
    if (res.statusCode == 200 &&
        data['results'] != null &&
        data['results']['juso'] != null) {
      List engList = data['results']['juso'];
      if (engList.isNotEmpty) {
        engAddress = engList[0]['roadAddr'];
      }
    }

    return engAddress;
  }
}
