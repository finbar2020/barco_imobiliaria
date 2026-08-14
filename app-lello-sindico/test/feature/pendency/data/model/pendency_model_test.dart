

import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/me/data/model/me_model.dart';
import 'package:lello/feature/pendency/data/model/pendency_model.dart';
import 'package:lello/feature/pendency/domain/entity/pendency.dart';

import '../../../../fixture/fixture_reader.dart';


void main() {

	group('fromJson', () {
		test('Should return an instance of Pendency expected attributes', () async {
			var json = fixture("pendency_model_mock");
			var model = PendencyModel.fromJson(json);
			expect(model, isA<PendencyModel>());
			expect(model.id, "1");
			expect(model.title, "2");
			expect(model.message, "3");
		});
	});

	group('toJson', () {
		test('Should return a json containing all attributes', () async {
			var model = PendencyModel()
				..id = "1"
				..title = "2"
				..message = "3";

			var json = model.toJson();
			expect(json["id"], "1");
			expect(json["title"], "2");
			expect(json["message"], "3");
		});

	});
}