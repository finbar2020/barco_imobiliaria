

import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/account/data/model/account_model.dart';
import 'package:lello/feature/account/domain/entity/account.dart';
import 'package:lello/feature/me/data/model/me_model.dart';
import 'package:lello/feature/me/domain/entity/me.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {


	group('fromJson', () {
		test('Should return an instance of Account expected attributes', () async {
			var json = fixture("account_mock");
			var model = AccountModel.fromJson(json);
			expect(model.id, "1");
			expect(model.name, "2");
			expect(model.number, "3");

		});
	});

	group('toJson', () {
		test('Should return a json containing all attributes', () async {
			var model = AccountModel()
				..id = "1"
				..name = "2"
				..number = "3";

			var json = model.toJson();
			expect(json["id"], "1");
			expect(json["name"], "2");
			expect(json["number"], "3");
		});

	});
}