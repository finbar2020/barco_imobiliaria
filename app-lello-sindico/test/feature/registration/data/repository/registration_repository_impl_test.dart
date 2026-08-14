import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_features/feature/registration/data/model/registation_model.dart';
import 'package:shared_features/shared_features.dart';

void main() {
  RegistrationRemoteDataSource dataSource;
  RegistrationRepository repository;

  final _registration = Registration()
    ..name = "1"
    ..cpf = "1"
    ..email = "1"
    ..phone = "1"
    ..codeValidationId = "1"
    ..password = "1";

  final _registrationModel = RegistrationModel.fromEntity(_registration);

  setUp(() {
    dataSource = RegistrationRemoteDataSourceMock();
    repository = RegistrationRepositoryImpl(dataSource: dataSource);
  });

  group('post', () {
    test('Should call remote data source when posting', () async {
      when(dataSource.post(any)).thenAnswer((_) async => _registrationModel);
      await repository.post(_registration);
      verify(dataSource.post(any));
    });

    test('Should return success when data sources succeeds', () async {
      when(dataSource.post(any)).thenAnswer((_) async => _registrationModel);
      Try<Registration> result = await repository.post(_registration);
      expect(result, isA<Success<Registration>>());
    });

    test('Should return rejection when data source throws an error', () async {
      when(dataSource.post(any)).thenThrow(Exception());
      Try<Registration> result = await repository.post(_registration);
      expect(result, isA<Rejection<Registration>>());
    });
  });
}

class RegistrationRemoteDataSourceMock extends Mock
    implements RegistrationRemoteDataSource {}
