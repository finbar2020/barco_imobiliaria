import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/data/model/access_token_model.dart';
import 'package:shared_features/shared_features.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {

	AccessTokenLocalDataSource dataSource;
	final String _key = "ACCESS_TOKEN";
	final validModel = AccessTokenModel()
		..accessToken = "1"
		..refreshToken = "2"
		..expiresIn = 3;

	setUp(() async{
		WidgetsFlutterBinding.ensureInitialized();

		SharedPreferences.setMockInitialValues({}); // set initial values here if desired

		dataSource = AccessTokenLocalDataSourceImpl();
	});

	group('Select', () {
		test('Should return null when shared preferences has not persisted any value', () async {
			var data = await dataSource.select();
			expect(data, isNull);
		});

		test('Should return null when shared preferences has not persisted empty value', () async {
			var preferences = await SharedPreferences.getInstance();
			preferences.setString(_key, "");

			var data = await dataSource.select();
			expect(data, isNull);
		});

		test('Should return null when shared preferences has not persisted invalid value', () async {
			var preferences = await SharedPreferences.getInstance();
			preferences.setString(_key, "invalid");

			var data = await dataSource.select();
			expect(data, isNull);
		});

		test('Should return valid AccessTokenModel when shared preferences has persisted data', () async {
			var preferences = await SharedPreferences.getInstance();
			preferences.setString(_key, json.encode(fixture("access_token_mock")));

			var data = await dataSource.select();
			expect(data, isNotNull);
			expect(data.accessToken, "1");
		});
	});

	group('Save', () {

		test('Should return persisted AccessToken', () async {
			var data = await dataSource.save(validModel);
			expect(data, equals(validModel));
		});

		test('Should return persisted in shared preferences', () async {
			await dataSource.save(validModel);

			var preferences = await SharedPreferences.getInstance();
			var persisted = preferences.get(_key);

			expect(persisted, isNotNull);
			expect(persisted, isNotEmpty);
		});

		test('Should return null saving null value', () async {
			var data = await dataSource.save(null);
			expect(data, isNull);
		});

		test('Should clear shared preferences when saving null value', () async {
			await dataSource.save(validModel);
			await dataSource.save(null);

			var preferences = await SharedPreferences.getInstance();
			var persisted = preferences.get(_key);

			expect(persisted, isNull);
		});
	});

	group('Save and Select', () {
		test('Should return persisted AccessToken when selecting after saving', () async {
			var data = await dataSource.save(validModel);
			var retrieved = await dataSource.select();
			expect(data.accessToken, equals(retrieved.accessToken));
		});
	});
}