import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/splash/data/data_source/boot_data_source.dart';
import 'package:lello/feature/splash/data/model/boot_data_model.dart';
import 'package:lello/feature/splash/domain/repository/boot_data_repository.dart';
import 'package:lello/feature/splash/data/repository/boot_data_repository_impl.dart';
import 'package:lello/feature/splash/domain/entity/boot_data.dart';
import 'package:mockito/mockito.dart';

import '../../../../matcher/is_and_matcher.dart';

class MockBootDataSource extends Mock implements BootDataSource {}

void main() {
  BootDataRepository repository;
  BootDataSource dataSource;

  final validModel = BootDataModel()..showOnBoarding = true;
  final validEntity = BootData()..showOnBoarding = true;

  setUp(() {
    dataSource = MockBootDataSource();
    repository = BootDataRepositoryImpl(dataSource: dataSource);
  });

  group('select', () {
    test('Should request data from data source', () async {
      await repository.select();
      verify(dataSource.select());
    });

    test('Should return success with null when data source returns no data',
        () async {
      when(dataSource.select()).thenAnswer((_) => null);

      Try<BootData> data = await repository.select();
      expect(data, isA<Success<BootData>>());

      var result = (data as Success<BootData>).get();
      expect(result, isNull);
    });

    test(
        'Should return success with model when data source returns expected data',
        () async {
      when(dataSource.select()).thenAnswer((_) async => validModel);

      Try<BootData> data = await repository.select();
      expect(
          data,
          IsAnd<Success<BootData>>(
              (it) => it.get().showOnBoarding == validModel.showOnBoarding));
    });

    test('Should return rejection when data source throws an error', () async {
      var exception = Exception();
      when(dataSource.select()).thenThrow(exception);

      Try<BootData> data = await repository.select();
      expect(data, isA<Rejection<BootData>>());

      var result = (data as Rejection<BootData>).get();
      expect(result.error, equals(exception));
    });
  });

  group('save', () {
    test('Should store data into data source', () async {
      when(dataSource.save(validModel)).thenAnswer((_) async => validModel);

      await repository.save(validEntity);
      verify(dataSource.save(any));
    });

    group('Saving null data', () {
      test('Should return success with null when storing null data', () async {
        when(dataSource.save(null)).thenAnswer((_) async => null);

        Try<BootData> data = await repository.save(null);
        expect(data, isA<Success<BootData>>());

        var result = (data as Success<BootData>).get();
        expect(result, isNull);
      });
    });

    group('Saving valid data', () {
      test('Should return success with null when storing null data', () async {
        when(dataSource.save(any)).thenAnswer((_) async => validModel);

        Try<BootData> data = await repository.save(validEntity);
        expect(
            data,
            IsAnd<Success<BootData>>(
                (it) => it.get().showOnBoarding == validModel.showOnBoarding));
      });
    });
  });
}
