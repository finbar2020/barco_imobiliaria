import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/reset_password/data/model/password_reset_model.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('fromJson', () {
    test('Should return an instance with expected attributes', () async {
      var json = fixture("password_reset_mock");
      var model = PasswordResetModel.fromJson(json);
      expect(model.password, "1");
    });
  });

  group('toJson', () {
    test('Should return a json containing all attributes', () async {
      var model = PasswordResetModel()..password = "1";

      var json = model.toJson();
      expect(json["password"], "1");
    });
  });
}
