import 'package:biskit_app/common/repository/util_repository.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/profile/model/language_model.dart';
import 'package:biskit_app/profile/model/use_language_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final useLanguageProvider =
    StateNotifierProvider<UseLanguageStateNotifier, List<UseLanguageModel>?>(
        (ref) {
  return UseLanguageStateNotifier(
    utilRepository: ref.watch(utilRepositoryProvider),
  );
});

class UseLanguageStateNotifier extends StateNotifier<List<UseLanguageModel>?> {
  final UtilRepository utilRepository;
  UseLanguageStateNotifier({
    required this.utilRepository,
  }) : super(null) {
    getList();
  }

  init() {
    state = state!
        .map((e) => UseLanguageModel(
              languageModel: e.languageModel,
              level: 0,
              isChecked: false,
            ))
        .toList();
  }

  void setSort() {
    List<UseLanguageModel> selectedList = state != null
        ? state!.where((element) => element.isChecked).toList()
        : [];
    selectedList.sort(
        (a, b) => a.languageModel.kr_name.compareTo(b.languageModel.kr_name));
    selectedList.sort((a, b) => b.level.compareTo(a.level));
    state = [
      ...selectedList,
      ...state!
          .where((e) => !(selectedList
              .map((l) => l.languageModel.id)
              .contains(e.languageModel.id)))
          .toList()
    ];
  }

  setSelectedList(List<UseLanguageModel> list) {
    list.sort(
        (a, b) => a.languageModel.kr_name.compareTo(b.languageModel.kr_name));
    list.sort((a, b) => b.level.compareTo(a.level));
    state = [
      ...list,
      ...state!
          .where((e) => !(list
              .map((l) => l.languageModel.id)
              .contains(e.languageModel.id)))
          .toList()
    ];
    logger.d(state);
  }

  getList() async {
    final List<LanguageModel> list = await utilRepository.getLanguages();
    state = list
        .map((e) => UseLanguageModel(
              languageModel: e,
              level: 0,
              isChecked: false,
            ))
        .toList();
  }

  toggleLang(UseLanguageModel useLanguage) {
    if (state != null) {
      state = state!
          .map((e) => e == useLanguage
              ? e.copyWith(
                  isChecked: !e.isChecked,
                  level: e.isChecked ? 0 : e.level,
                )
              : e)
          .toList();
    }
    setSort();
  }

  setLevel({
    required UseLanguageModel useLanguage,
    required int level,
  }) {
    if (state != null) {
      state = state!
          .map((e) => e.languageModel == useLanguage.languageModel
              ? e.copyWith(
                  level: level,
                )
              : e)
          .toList();
    }
    setSort();
  }

  List<UseLanguageModel> getSelectedList() {
    return state != null
        ? state!.where((element) => element.isChecked).toList()
        : [];
  }

  void deleteLang(UseLanguageModel useLanguage) {
    if (state != null) {
      state = state!
          .map((e) => e == useLanguage
              ? e.copyWith(
                  isChecked: false,
                  level: 0,
                )
              : e)
          .toList();
    }
  }
}
