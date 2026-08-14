import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/code_validation/data/model/code_validation_model.dart';

import '../../../../fixture/fixture_reader.dart';

final id = "1";
final value = "2";
final code = "3";
final source = "email";

void main() {
  group('fromJson', () {
    test('Should return an instance of CodeValidation expected attributes',
        () async {
      var json = fixture("code_validation_mock");
      var model = CodeValidationModel.fromJson(json);
      expect(model.id, id);
      expect(model.value, value);
      expect(model.code, code);
      expect(model.source, source);
    });
  });

  group('toJson', () {
    test('Should return a json containing all attributes', () async {
      var model = CodeValidationModel()
        ..id = id
        ..value = value
        ..code = code
        ..source = "email";
      var json = model.toJson();
      expect(json["id"], model.id);
      expect(json["value"], model.value);
      expect(json["code"], model.code);
      expect(json["source"], source);
    });
  });
}
