

import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/me/data/model/me_model.dart';
import 'package:lello/feature/me/domain/entity/me.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {


	group('fromJson', () {
		test('Should return an instance of Me expected attributes', () async {
			var json = fixture("me_mock");
			var model = MeModel.fromJson(json);
			expect(model.name, "1");
			expect(model.email, "2");
			expect(model.picture, "3");
			expect(model.phone, "4");
			expect(model.cpf, "5");
		});
	});

	group('toJson', () {
		test('Should return a json containing all attributes', () async {
			var model = MeModel()
			 ..name = "1"
			 ..email = "2"
			 ..picture = "3"
			 ..phone = "4"
			 ..cpf = "5";

			var json = model.toJson();
			expect(json["name"], "1");
			expect(json["email"], "2");
			expect(json["picture"], "3");
			expect(json["phone"], "4");
			expect(json["cpf"], "5");
		});

	});
}