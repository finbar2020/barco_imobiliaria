

import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/condominium/data/model/condominium_balance_model.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance.dart';
import 'package:lello/feature/me/data/model/me_model.dart';
import 'package:lello/feature/me/domain/entity/me.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
	final _mockedDate = "2020-03-12T03:08:43.0000Z";


	group('fromJson', () {
		test('Should return an instance of CondominiumBalance expected attributes', () async {
			var json = fixture("condominium_balance_mock");
			var model = CondominiumBalanceModel.fromJson(json);
			expect(model.id, "1");
			expect(model.balance, 2);
			expect(model.date, DateTime.parse(_mockedDate));
		});
	});

	group('toJson', () {
		test('Should return a json containing all attributes', () async {
			final date = DateTime.parse(_mockedDate);
			final str = date.toIso8601String();

			var model = CondominiumBalanceModel()
				..id = "1"
				..balance = 2
				..date =  date;

			var json = model.toJson();
			expect(json["id"], "1");
			expect(json["balance"], 2.0);
			expect(json["date"], str);
		});

	});
}