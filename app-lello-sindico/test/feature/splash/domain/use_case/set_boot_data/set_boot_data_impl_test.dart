import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/splash/domain/repository/boot_data_repository.dart';
import 'package:lello/feature/splash/domain/entity/boot_data.dart';
import 'package:lello/feature/splash/domain/use_case/get_boot_data/get_boot_data.dart';
import 'package:lello/feature/splash/domain/use_case/get_boot_data/get_boot_data_impl.dart';
import 'package:lello/feature/splash/domain/use_case/set_boot_data/set_boot_data.dart';
import 'package:lello/feature/splash/domain/use_case/set_boot_data/set_boot_data_impl.dart';
import 'package:mockito/mockito.dart';

class BootDataRepositoryMock extends Mock implements BootDataRepository {}

void main() {
  BootDataRepositoryMock repository;
  SetBootData setBootData;

  setUp(() {
    repository = BootDataRepositoryMock();
    setBootData = SetBootDataImpl(repository: repository);
  });

  group('Constructor and Factories', () {
    test('Should create na instance of an Use Case', () async {
      expect(setBootData, isA<UseCase<BootData, BootData>>());
    });
  });

  group('Call', () {
    test('Should save data into repository', () async {
      when(repository.save(GetBootData.defaultData))
          .thenAnswer((_) async => Success(GetBootData.defaultData));
      await setBootData(GetBootData.defaultData);
      verify(repository.save(GetBootData.defaultData));
    });

    group('With repository error', () {
      test('Should return rejection when repository throws an error', () async {
        var exception = Exception();
        when(repository.save(any)).thenThrow(exception);
        Try<BootData> result = await setBootData(GetBootData.defaultData);

        expect(result, isA<Rejection<BootData>>());
        var failure = (result as Rejection<BootData>).get();
        expect(failure.error, equals(exception));
      });

      test('Should return rejection when repository returns a rejection',
          () async {
        var failure = UnknownFailure(null);
        when(repository.save(any))
            .thenAnswer((realInvocation) async => Rejection(failure));
        Try<BootData> result = await setBootData(GetBootData.defaultData);

        expect(result, isA<Rejection<BootData>>());
        var actual = (result as Rejection<BootData>).get();
        expect(failure, equals(actual));
      });
    });
    group('With empty data', () {
      test('Should return success with null data', () async {
        when(repository.save(null)).thenAnswer((_) async => Success(null));

        Try<BootData> result = await setBootData(null);
        expect(result, isA<Success<BootData>>());

        var actual = (result as Success<BootData>).get();
        expect(actual, isNull);

        verify(repository.save(null));
      });
    });
  });
}
