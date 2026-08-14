
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/splash/data/model/boot_data_model.dart';
import 'package:lello/feature/splash/domain/entity/boot_data.dart';

import '../../../../fixture/fixture_reader.dart';


void main() {

	group('fromJson', () {
		test('Should return an instance of BootData expected attributes', () async {
			var json = fixture("boot_data_mock");
			var model = BootDataModel.fromJson(json);
			expect(model.showOnBoarding, true);
		});
	});

	group('toJson', () {
		test('Should return a json containing all attributes', () async {
			var model = BootDataModel()..showOnBoarding = true;
			var json = model.toJson();
			expect(json["show_on_boarding"], model.showOnBoarding);
		});

	});
}