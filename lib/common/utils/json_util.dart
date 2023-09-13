import 'dart:convert';

import 'package:flutter/services.dart';

Future<dynamic> readJson({
  required String jsonPath,
}) async {
  final String res = await rootBundle.loadString(jsonPath);
  final data = await json.decode(res);

  return data;
}
