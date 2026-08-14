import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/me/domain/use_case/upload_profile_picture/upload_registration_picture.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  Register register;
  Authenticate authenticate;
  UploadProfilePicture upload;
  RegistrationRepository repository;

  final _registration = Registration()
    ..name = "1"
    ..cpf = "1"
    ..email = "1"
    ..phone = "1"
    ..codeValidationId = "1"
    ..password = "1";

  setUp(() {
    authenticate = AuthenticateMock();
    repository = RegistrationRepositoryMock();
    upload = UploadProfilePictureMock();
    register = RegisterImpl(
        repository: repository,);
  });

  group('call', () {
    group('with invalid parameters', () {
      test(
          'Should return invalid registration failure when calling with null parameter',
          () async {
        Try<Registration> result = await register(null);
        expect(
            result,
            IsAnd<Rejection<Registration>>(
                (r) => r.get() is InvalidRegistrationFailure));
      });

      test(
          'Should return missing registration data failure when calling without name',
          () async {
        final registration = Registration()
          ..name = null
          ..cpf = "1"
          ..email = "1"
          ..phone = "1"
          ..codeValidationId = "1"
          ..password = "1";

        Try<Registration> result = await register(registration);
        expect(
            result,
            IsAnd<Rejection<Registration>>((r) =>
                r.get() is RegistrationMissingRequiredDataFailure &&
                (r.get() as RegistrationMissingRequiredDataFailure).field ==
                    "name"));
      });

      test(
          'Should return missing registration data failure when calling without cpf',
          () async {
        final registration = Registration()
          ..name = "1"
          ..cpf = null
          ..email = "1"
          ..phone = "1"
          ..codeValidationId = "1"
          ..password = "1";

        Try<Registration> result = await register(registration);
        expect(
            result,
            IsAnd<Rejection<Registration>>((r) =>
                r.get() is RegistrationMissingRequiredDataFailure &&
                (r.get() as RegistrationMissingRequiredDataFailure).field ==
                    "cpf"));
      });

      test(
          'Should return missing registration data failure when calling without name',
          () async {
        final registration = Registration()
          ..name = "1"
          ..cpf = "1"
          ..email = null
          ..phone = "1"
          ..codeValidationId = "1"
          ..password = "1";

        Try<Registration> result = await register(registration);
        expect(
            result,
            IsAnd<Rejection<Registration>>((r) =>
                r.get() is RegistrationMissingRequiredDataFailure &&
                (r.get() as RegistrationMissingRequiredDataFailure).field ==
                    "email"));
      });

      test(
          'Should return missing registration data failure when calling without name',
          () async {
        final registration = Registration()
          ..name = "1"
          ..cpf = "1"
          ..email = "1"
          ..phone = null
          ..codeValidationId = "1"
          ..password = "1";

        Try<Registration> result = await register(registration);
        expect(
            result,
            IsAnd<Rejection<Registration>>((r) =>
                r.get() is RegistrationMissingRequiredDataFailure &&
                (r.get() as RegistrationMissingRequiredDataFailure).field ==
                    "phone"));
      });

      test(
          'Should return missing registration data failure when calling without name',
          () async {
        final registration = Registration()
          ..name = "1"
          ..cpf = "1"
          ..email = "1"
          ..phone = "1"
          ..codeValidationId = null
          ..password = "1";

        Try<Registration> result = await register(registration);
        expect(
            result,
            IsAnd<Rejection<Registration>>((r) =>
                r.get() is RegistrationMissingRequiredDataFailure &&
                (r.get() as RegistrationMissingRequiredDataFailure).field ==
                    "codeValidationId"));
      });

      test(
          'Should return missing registration data failure when calling without name',
          () async {
        final registration = Registration()
          ..name = "1"
          ..cpf = "1"
          ..email = "1"
          ..phone = "1"
          ..codeValidationId = "1"
          ..password = null;

        Try<Registration> result = await register(registration);
        expect(
            result,
            IsAnd<Rejection<Registration>>((r) =>
                r.get() is RegistrationMissingRequiredDataFailure &&
                (r.get() as RegistrationMissingRequiredDataFailure).field ==
                    "password"));
      });
    });

    group('with valid parameters', () {
      test('Should call registration repository', () async {
        when(repository.post(_registration))
            .thenAnswer((_) async => Success(_registration));
        await register(_registration);
        verify(repository.post(_registration));
      });

      test('Should return rejection when repository fails to persist data',
          () async {
        final failure = UnknownFailure(null);
        when(repository.post(_registration))
            .thenAnswer((_) async => Rejection(failure));
        Try<Registration> result = await register(_registration);
        expect(
            result, IsAnd<Rejection<Registration>>((r) => r.get() == failure));
      });

      test('Should return success when repository succeeds to persist data',
          () async {
        when(repository.post(_registration))
            .thenAnswer((_) async => Success(_registration));
        Try<Registration> result = await register(_registration);
        expect(result, isA<Success<Registration>>());
      });

      test('Should authenticate when repository succeeds to persist data',
          () async {
        when(repository.post(_registration))
            .thenAnswer((_) async => Success(_registration));
        await register(_registration);
        verify(authenticate.call(any));
      });
    });
  });
}

class AuthenticateMock extends Mock implements Authenticate {}

class RegistrationRepositoryMock extends Mock
    implements RegistrationRepository {}

class UploadProfilePictureMock extends Mock implements UploadProfilePicture {}
