import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/code_validation/data/model/code_request_model.dart';

import '../../../../fixture/fixture_reader.dart';

final id = "1";
final value = "2";
final code = "3";
final source = "email";

void main() {
  group('fromJson', () {
    test('Should return an instance of CodeRequestModel expected attributes',
        () async {
      var json = fixture("code_request_mock");
      var model = CodeRequestModel.fromJson(json);
      expect(model.id, id);
      expect(model.value, value);
      expect(model.source, source);
    });
  });

  group('toJson', () {
    test('Should return a json containing all attributes', () async {
      var model = CodeRequestModel()
        ..id = id
        ..value = value
        ..source = source;
      var json = model.toJson();
      expect(json["id"], model.id);
      expect(json["value"], model.value);
      expect(json["source"], source);
    });
  });
}
