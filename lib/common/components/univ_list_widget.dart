// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:biskit_app/common/components/check_circle.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/list_widget_temp.dart';
import 'package:biskit_app/common/components/search_bar_widget.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/model/university_model.dart';
import 'package:biskit_app/common/repository/util_repository.dart';

import '../const/colors.dart';

class UnivListWidget extends StatefulWidget {
  final UniversityModel? selectedUnivModel;
  final Function(UniversityModel) onTap;
  const UnivListWidget({
    Key? key,
    this.selectedUnivModel,
    required this.onTap,
  }) : super(key: key);

  @override
  State<UnivListWidget> createState() => _UnivListWidgetState();
}

class _UnivListWidgetState extends State<UnivListWidget> {
  List<UniversityModel> univerisyList = [];
  List<UniversityModel> tempList = [];
  UniversityModel? selectedModel;
  bool isLoading = false;
  final TextEditingController searchBarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
    searchBarController.addListener(() {
      onChanged(searchBarController.text);
    });
  }

  init() async {
    setState(() {
      isLoading = true;
    });

    await getUnivList();
    setState(() {
      selectedModel = widget.selectedUnivModel;
    });

    setState(() {
      isLoading = false;
    });
  }

  getUnivList() async {
    final UtilRepository utilRepository = UtilRepository(
      dio: Dio(),
      baseUrl: 'http://$kServerIp:$kServerPort/$kServerVersion',
    );
    await Future.microtask(() => null);
    univerisyList = await utilRepository.getUniversty(
      languageCode: 'ko',
      search: '',
    );
    setState(() {
      tempList = univerisyList;
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchBarController.dispose();
  }

  void onTapTile(UniversityModel model) {
    setState(() {
      selectedModel = model;
    });
    widget.onTap(model);
    FocusScope.of(context).unfocus();
  }

  onChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        tempList = univerisyList;
      });
    } else {
      List<UniversityModel> searchList = univerisyList
          .where((n) => '${n.en_name.toLowerCase()} ${n.kr_name.toLowerCase()}'
              .contains(value.toLowerCase()))
          .toList();
      setState(() {
        tempList = searchList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SearchBarWidget(
              controller: searchBarController,
              onChanged: (value) {},
              hintText: '학교 검색',
            ),
            Expanded(
                child: isLoading
                    ? const Center(
                        child: CustomLoading(),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          child: Column(
                            children: tempList
                                .map(
                                  (e) => ListWidgetTemp(
                                    height: 56,
                                    borderColor: e == tempList.last
                                        ? kColorBgDefault
                                        : kColorBorderDefalut,
                                    touchWidget: CheckCircleWidget(
                                      value: (selectedModel != null &&
                                              e.id == selectedModel!.id)
                                          ? true
                                          : false,
                                    ),
                                    onTap: () {
                                      onTapTile(e);
                                    },
                                    centerWidget: Text(
                                      e.kr_name,
                                      style: getTsBody16Rg(context).copyWith(
                                        color: kColorContentWeak,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      )),
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 34,
              ),
              child: GestureDetector(
                onTap: () {
                  if (selectedModel != null) {
                    Navigator.pop(context, selectedModel);
                  }
                  // Navigator.pop(context);
                  // onTapSelectUnivStudentStatus();
                },
                child: FilledButtonWidget(
                  text: '다음',
                  isEnable: selectedModel != null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
