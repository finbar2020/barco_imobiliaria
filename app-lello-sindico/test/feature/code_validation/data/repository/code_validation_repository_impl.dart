import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_features/feature/code_validation/data/model/code_request_model.dart';
import 'package:shared_features/feature/code_validation/data/model/code_validation_model.dart';
import 'package:shared_features/shared_features.dart';

void main() {
  CodeValidationRepository repository;
  PhoneValidationRemoteDataSourceMock dataSourceMock;

  final request = CodeRequest(source: CodeValidationSource.email, value: "2");
  final requestModel = CodeRequestModel.fromEntity(request);
  final _entity = CodeValidation()
    ..id = "1"
    ..value = "2"
    ..source = CodeValidationSource.email
    ..code = "3";

  final _validationModel = CodeValidationModel()
    ..id = "1"
    ..value = "2"
    ..source = "email"
    ..code = "3";

  final _registrationModel = CodeRequestModel()
    ..id = "1"
    ..value = "2"
    ..source = "email";

  setUp(() {
    dataSourceMock = PhoneValidationRemoteDataSourceMock();
    repository = CodeValidationRepositoryImpl(dataSource: dataSourceMock);
  });

  group('validate', () {
    test('Should call remote data source when posting', () async {
      when(dataSourceMock.insertValidation(any))
          .thenAnswer((_) async => _validationModel);
      await repository.validate(_entity);
      verify(dataSourceMock.insertValidation(any));
    });

    test('Should return success when data sources succeeds', () async {
      when(dataSourceMock.insertValidation(any))
          .thenAnswer((_) async => _validationModel);
      Try<CodeValidation> result = await repository.validate(_entity);
      expect(result, isA<Success<CodeValidation>>());
    });

    test('Should return rejection when data source throws an error', () async {
      when(dataSourceMock.insertValidation(any)).thenThrow(Exception());
      Try<CodeValidation> result = await repository.validate(_entity);
      expect(result, isA<Rejection<CodeValidation>>());
    });
  });

  group('register', () {
    test('Should call remote data source when posting', () async {
      when(dataSourceMock.insertRequest(requestModel))
          .thenAnswer((_) async => _registrationModel);
      await repository.register(request);
      verify(dataSourceMock.insertValidation(any));
    });

    test('Should return success when data sources succeeds', () async {
      when(dataSourceMock.insertRequest(any))
          .thenAnswer((_) async => _registrationModel);
      Try<CodeRequest> result = await repository.register(request);
      expect(result, isA<Success<CodeRequest>>());
    });

    test('Should return rejection when data source throws an error', () async {
      when(dataSourceMock.insertRequest(any)).thenThrow(Exception());
      Try<CodeRequest> result = await repository.register(request);
      expect(result, isA<Rejection<CodeRequest>>());
    });
  });
}

class PhoneValidationRemoteDataSourceMock extends Mock
    implements CodeValidationRemoteDataSource {}
