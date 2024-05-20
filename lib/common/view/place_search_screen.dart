import 'dart:async';

import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:biskit_app/common/components/list_widget_temp.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/components/search_bar_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/model/kakao/kakao_document_model.dart';
import 'package:biskit_app/common/model/kakao/kakao_local_keyword_res_model.dart';
import 'package:biskit_app/common/repository/kakao_map_repository.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PlaceSearchScreen extends StatefulWidget {
  final bool isEng;
  const PlaceSearchScreen({
    Key? key,
    this.isEng = false,
  }) : super(key: key);

  @override
  State<PlaceSearchScreen> createState() => _PlaceSearchScreenState();
}

class _PlaceSearchScreenState extends State<PlaceSearchScreen> {
  final PagingController<int, KakaoDocumentModel> _pagingController =
      PagingController(firstPageKey: 0);
  final TextEditingController searchController = TextEditingController();
  final KakaoMapReposity kakaoMapReposity = KakaoMapReposity();

  KakaoLocalKeywordResModel? kakaoLocalKeywordResModel;
  List<KakaoDocumentModel> resultList = [];
  bool isFirstSearch = false;
  // int page = 1;
  Timer? _debounce;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetch(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    searchController.dispose();
    _debounce?.cancel();

    super.dispose();
  }

  _fetch(int pageKey) async {
    logger.d('pageKey : $pageKey');
    final KakaoLocalKeywordResModel? res =
        await kakaoMapReposity.getLocalSearchKeyword(
      query: searchController.text.trim(),
      page: pageKey + 1,
      isEng: widget.isEng,
    );
    if (res != null) {
      final isLastPage = res.meta.is_end;
      if (isLastPage) {
        _pagingController.appendLastPage(res.documents);
      } else {
        int nextPageKey = pageKey + 1;
        _pagingController.appendPage(res.documents, nextPageKey);
      }
    }
  }

  _search() {
    if (!isFirstSearch) {
      setState(() {
        isFirstSearch = true;
      });
    }
    _pagingController.refresh();
  }

  _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (value.isNotEmpty) {
        _search();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.of(context).viewPadding;
    final viewInsets = MediaQuery.of(context).viewInsets;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SearchBarWidget(
              controller: searchController,
              hintText: 'selectLocationBottomSheet.find'.tr(),
              maxLength: 20,
              onChanged: (value) {
                _onSearchChanged(value);
              },
              onFieldSubmitted: (value) {
                _search();
              },
            ),
            const SizedBox(
              height: 8,
            ),
            if (isFirstSearch)
              Expanded(
                child: PagedListView(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (context, KakaoDocumentModel item, index) =>
                        ListWidgetTemp(
                      onTap: () {
                        Navigator.pop(context, item);
                      },
                      isSubComponent: true,
                      centerWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.place_name,
                            style: getTsBody16Sb(context).copyWith(
                              color: kColorContentWeak,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            (context.locale.languageCode == 'en' &&
                                    item.eng_road_address_name != '')
                                ? item.eng_road_address_name
                                : item.road_address_name,
                            style: getTsBody14Rg(context).copyWith(
                              color: kColorContentWeakest,
                            ),
                          ),
                        ],
                      ),
                    ),
                    noItemsFoundIndicatorBuilder: (context) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '검색 결과가 없어요',
                          style: getTsBody16Rg(context).copyWith(
                            color: kColorContentWeaker,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(
                                  context,
                                  searchController.text.trim(),
                                );
                              },
                              child: OutlinedButtonWidget(
                                leftIconPath:
                                    'assets/icons/ic_plus_line_24.svg',
                                text:
                                    '\'${searchController.text.trim()}\' 장소 입력',
                                isEnable: true,
                                textAlign: TextAlign.center,
                                alignment: AlignmentDirectional.center,
                                height: 44,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: viewInsets.bottom,
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                    firstPageProgressIndicatorBuilder: (context) =>
                        const CustomLoading(),
                    newPageProgressIndicatorBuilder: (context) =>
                        const CustomLoading(),
                    newPageErrorIndicatorBuilder: (context) => Text(
                      _pagingController.error,
                    ),
                    firstPageErrorIndicatorBuilder: (context) => Text(
                      _pagingController.error.toString(),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    bottom: viewPadding.bottom,
                  ),
                ),

                // SingleChildScrollView(
                //   padding: EdgeInsets.only(
                //     bottom: viewPadding.bottom,
                //   ),
                //   child: Column(
                //     children: resultList
                //         .map(
                //           (e) => ListWidget(
                //             isSubComponent: true,
                //             centerWidget: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Text(
                //                   e.place_name,
                //                   style: getTsBody16Sb(context).copyWith(
                //                     color: kColorContentWeak,
                //                   ),
                //                 ),
                //                 const SizedBox(
                //                   height: 4,
                //                 ),
                //                 Text(
                //                   e.road_address_name,
                //                   style: getTsBody14Rg(context).copyWith(
                //                     color: kColorContentWeakest,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         )
                //         .toList(),
                //   ),
                // ),
              ),
          ],
        ),
      ),
    );
  }
}
