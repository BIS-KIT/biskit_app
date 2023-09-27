import 'package:biskit_app/profile/model/language_model.dart';

class UseLanguageModel {
  final LanguageModel languageModel;
  final int level;
  final bool isChecked;
  UseLanguageModel({
    required this.languageModel,
    required this.level,
    required this.isChecked,
  });

  UseLanguageModel copyWith({
    LanguageModel? languageModel,
    int? level,
    bool? isChecked,
  }) {
    return UseLanguageModel(
      languageModel: languageModel ?? this.languageModel,
      level: level ?? this.level,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
