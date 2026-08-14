

import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/me/data/model/me_model.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/session/data/model/session_model.dart';

import '../../../../fixture/fixture_reader.dart';


void main() {
	group('fromJson', () {
		test('Should return an instance of SessionModel expected attributes', () async {
			var json = fixture("session_mock");
			var model = SessionModel.fromJson(json);
			expect(model, isA<SessionModel>());
			expect(model.selectedCondominium, "1");
		});
	});

	group('toJson', () {
		test('Should return a json containing all attributes', () async {
			var model = SessionModel()
			 ..selectedCondominium = "1";

			var json = model.toJson();
			expect(json["selected_condominium"], "1");
		});

	});
}