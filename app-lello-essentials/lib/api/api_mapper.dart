import 'dart:convert';

import 'package:chopper/chopper.dart';

class ApiMapper {
  static List<T> mapList<T>(
      Response response, T Function(Map<String, dynamic> json) map) {
    if (response.isSuccessful) {
      final List<dynamic> list = jsonDecode(response.bodyString);
      return list.map((e) => map(e)).toList();
    }
    throw response.error ?? "";
  }

  static T map<T>(
      Response response, T Function(Map<String, dynamic> json) map) {
    if (response.isSuccessful) {
      return map(jsonDecode(response.bodyString));
    }
    throw response.error ?? "";
  }
}
