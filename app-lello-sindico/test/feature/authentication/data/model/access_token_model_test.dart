
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/data/model/access_token_model.dart';

import '../../../../fixture/fixture_reader.dart';


void main() {
	group('fromJson', () {
		test('Should return an instance of AccessToken expected attributes', () async {
			var json = fixture("access_token_mock");
			var model = AccessTokenModel.fromJson(json);
			expect(model, isA<AccessTokenModel>());
			expect(model.accessToken, "1");
			expect(model.refreshToken, "2");
			expect(model.expiresIn, 3);
		});
	});

	group('toJson', () {
		test('Should return a json containing all attributes', () async {
			var model = AccessTokenModel()
				..accessToken = "1"
				..refreshToken = "2"
				..expiresIn = 3;

			var json = model.toJson();
			expect(json["access_token"], "1");
			expect(json["refresh_token"], "2");
			expect(json["expires_in"], 3);
		});

	});
}