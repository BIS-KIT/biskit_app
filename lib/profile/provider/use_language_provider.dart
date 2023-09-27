import 'package:biskit_app/common/repository/util_repository.dart';
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
