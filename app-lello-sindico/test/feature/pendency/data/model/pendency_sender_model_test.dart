

import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/me/data/model/me_model.dart';
import 'package:lello/feature/pendency/data/model/pendency_model.dart';
import 'package:lello/feature/pendency/data/model/pendency_sender_model.dart';
import 'package:lello/feature/pendency/domain/entity/pendency.dart';
import 'package:lello/feature/pendency/domain/entity/pendency_sender.dart';

import '../../../../fixture/fixture_reader.dart';


void main() {
	group('fromJson', () {
		test('Should return an instance of Pendency expected attributes', () async {
			var json = fixture("pendency_sender_model_mock");
			var model = PendencySenderModel.fromJson(json);
			expect(model, isA<PendencySenderModel>());
			expect(model.id, "1");
			expect(model.name, "2");
			expect(model.picture, "3");
		});
	});

	group('toJson', () {
		test('Should return a json containing all attributes', () async {
			var model = PendencySenderModel()
				..id = "1"
				..name = "2"
				..picture = "3";

			var json = model.toJson();
			expect(json["id"], "1");
			expect(json["name"], "2");
			expect(json["picture"], "3");
		});

	});
}