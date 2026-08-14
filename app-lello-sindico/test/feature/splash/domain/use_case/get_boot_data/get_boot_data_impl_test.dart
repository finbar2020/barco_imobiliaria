import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/splash/domain/repository/boot_data_repository.dart';
import 'package:lello/feature/splash/domain/entity/boot_data.dart';
import 'package:lello/feature/splash/domain/use_case/get_boot_data/get_boot_data.dart';
import 'package:lello/feature/splash/domain/use_case/get_boot_data/get_boot_data_impl.dart';
import 'package:mockito/mockito.dart';

class BootDataRepositoryMock extends Mock implements BootDataRepository {}

void main() {
  BootDataRepositoryMock repository;
  GetBootData getBootData;

  setUp(() {
    repository = BootDataRepositoryMock();
    getBootData = GetBootDataImpl(repository: repository);
  });

  group('Constructor and Factories', () {
    test('Should create na instance of an Unit Use Case', () async {
      expect(getBootData, isA<UnitUseCase<BootData>>());
    });
  });

  group('Call', () {
    test('Should select data from repository', () async {
      when(repository.select())
          .thenAnswer((_) async => Success(GetBootData.defaultData));
      await getBootData();
      verify(repository.select());
    });

    group('With repository error', () {
      test('Should return success with default data', () async {
        when(repository.select())
            .thenAnswer((_) async => Rejection(UnknownFailure(null)));
        var result = await getBootData();
        var data = result.getOrElse(() => null);

        expect(result, isA<Success<BootData>>());
        expect(data, isNotNull);
        expect(data, GetBootData.defaultData);
      });
    });
    group('With empty data', () {
      test('Should return success with default data', () async {
        when(repository.select()).thenAnswer((_) async {
          return Success(GetBootData.defaultData);
        });
        var result = await getBootData();
        var data = result.getOrElse(() => null);

        expect(result, isA<Success<BootData>>());
        expect(data, isNotNull);
        expect(data, GetBootData.defaultData);
      });
    });
  });
}
