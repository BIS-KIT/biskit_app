import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return {
      'languageModel': languageModel.toMap(),
      'level': level,
      'isChecked': isChecked,
    };
  }

  factory UseLanguageModel.fromMap(Map<String, dynamic> map) {
    return UseLanguageModel(
      languageModel: LanguageModel.fromMap(map['languageModel']),
      level: map['level']?.toInt() ?? 0,
      isChecked: map['isChecked'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UseLanguageModel.fromJson(String source) =>
      UseLanguageModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UseLanguageModel(languageModel: $languageModel, level: $level, isChecked: $isChecked)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UseLanguageModel &&
        other.languageModel == languageModel &&
        other.level == level &&
        other.isChecked == isChecked;
  }

  @override
  int get hashCode =>
      languageModel.hashCode ^ level.hashCode ^ isChecked.hashCode;
}
