import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/registration/data/model/registation_model.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('fromJson', () {
    test('Should return an instance of RegistrationModel expected attributes',
        () async {
      final json = fixture("registration_mock");
      final model = RegistrationModel.fromJson(json);
      expect(model, isA<RegistrationModel>());
      expect(model.name, "1");
      expect(model.cpf, "2");
      expect(model.email, "3");
      expect(model.phone, "4");
      expect(model.password, "6");
    });
  });

  group('toJson', () {
    test('Should return a json containing all attributes', () async {
      final model = RegistrationModel()
        ..name = "1"
        ..cpf = "2"
        ..email = "3"
        ..phone = "4"
        ..password = "6";

      final json = model.toJson();
      expect(json['name'], model.name);
      expect(json['cpf'], model.cpf);
      expect(json['email'], model.email);
      expect(json['phone'], model.phone);
      expect(json['password'], model.password);
    });
  });
}
