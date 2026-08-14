import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/space/registration/domain/entity/space_registration_request.dart';
import 'package:lello/feature/space/registration/domain/repository/space_registrtion_request_repository.dart';
import 'package:lello/feature/space/registration/domain/use_case/request_space_registration/request_space_registration.dart';
import 'package:lello/feature/space/registration/domain/use_case/request_space_registration/request_space_registration_impl.dart';
import 'package:essentials/essentials.dart';
import 'package:mockito/mockito.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  SpaceRegistrationRequestRepository repository;
  RequestSpaceRegistration requestSpaceRegistration;

  final _registration = SpaceRegistrationRequest();

  final _param =
      RequestSpaceRegistrationParam(condominiumId: "123", data: _registration);

  setUp(() {
    repository = SpaceRegistrationRequestRepositoryMock();
    requestSpaceRegistration =
        RequestSpaceRegistrationImpl(repository: repository);
  });

  group('call', () {
    test('Should return invalid param failure if params is null', () async {
      final result = await requestSpaceRegistration(null);
      expect(
          result,
          IsAnd<Rejection<SpaceRegistrationRequest>>(
              (it) => it.get() is InvalidParamFailure));
    });

    test('Should return invalid param failure if condominium id is null',
        () async {
      final result = await requestSpaceRegistration(
          RequestSpaceRegistrationParam(
              condominiumId: null, data: _registration));
      expect(
          result,
          IsAnd<Rejection<SpaceRegistrationRequest>>(
              (it) => it.get() is InvalidParamFailure));
    });

    test('Should return invalid param failure if condominium id is empty',
        () async {
      final result = await requestSpaceRegistration(
          RequestSpaceRegistrationParam(
              condominiumId: "", data: _registration));
      expect(
          result,
          IsAnd<Rejection<SpaceRegistrationRequest>>(
              (it) => it.get() is InvalidParamFailure));
    });

    test('Should return invalid param failure if data is null', () async {
      final result = await requestSpaceRegistration(
          RequestSpaceRegistrationParam(condominiumId: "1", data: null));
      expect(
          result,
          IsAnd<Rejection<SpaceRegistrationRequest>>(
              (it) => it.get() is InvalidParamFailure));
    });

    test('Should call repository insert', () async {
      await requestSpaceRegistration(_param);
      verify(repository.insert(_param.condominiumId, _param.data));
    });

    test('Should return success if repository succeeds', () async {
      when(repository.insert(_param.condominiumId, _param.data))
          .thenAnswer((_) async => Success(_registration));
      final result = await requestSpaceRegistration(_param);
      expect(
          result,
          IsAnd<Success<SpaceRegistrationRequest>>(
              (it) => it.get() == _registration));
    });

    test('Should return rejection if repository fails', () async {
      when(repository.insert(_param.condominiumId, _param.data))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      final result = await requestSpaceRegistration(_param);
      expect(result, isA<Rejection<SpaceRegistrationRequest>>());
    });
  });
}

class SpaceRegistrationRequestRepositoryMock extends Mock
    implements SpaceRegistrationRequestRepository {}
