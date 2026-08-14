import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';

import 'package:mockito/mockito.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../matcher/is_and_matcher.dart';

void main() {
  RegistrationBloc bloc;
  AuthenticationBloc loginBloc;
  GetMyUser myUser;
  RequestValidationCode requestValidationCode;
  Register register;

  final codeRequest = CodeRequest(
    id: "1",
    value: "123",
    source: CodeValidationSource.email,
    origin: CodeValidationOrigin.other,
  );
  final registration = Registration();

  setUp(() {
    register = RegisterMock();
    myUser = MyUserMock();
    requestValidationCode = RequestValidationCodeMock();
    loginBloc = LoginBlocMock();

    bloc = RegistrationBlocImpl(
        requestValidationCode: requestValidationCode,
        register: register,
        myUser: myUser);
  });

  group('nextStep', () {
    test(
        'Should emit state with next step when current step is not the last step',
        () async {
      bloc.nextStep(RegistrationBlocImpl.stepOrder.first);
      expectLater(
          bloc,
          emitsInOrder([
            IsAnd<RegistrationState>(
                (item) => item.step == RegistrationBlocImpl.stepOrder[0]),
            IsAnd<RegistrationState>(
                (item) => item.step == RegistrationBlocImpl.stepOrder[1])
          ]));
    });

    test('Should begin registration when current step is the last step',
        () async {
      when(register.call(any)).thenAnswer((_) async => Success(registration));

      bloc.nextStep(RegistrationBlocImpl.stepOrder.last);

      expectLater(
          bloc,
          emitsInOrder([
            IsAnd<RegistrationState>(
                (item) => item.step == RegistrationBlocImpl.stepOrder[0]),
            isA<RegistrationLoadingState>(),
          ]));
    });
  });

  group('previousStep', () {
    test(
        'Should emit state with previous step when current step is not the first step',
        () async {
      bloc.previousStep(RegistrationBlocImpl.stepOrder.last);
      expectLater(
          bloc,
          emitsInOrder([
            IsAnd<RegistrationState>(
                (item) => item.step == RegistrationBlocImpl.stepOrder[0]),
            IsAnd<RegistrationState>((item) =>
                item.step ==
                RegistrationBlocImpl
                    .stepOrder[RegistrationBlocImpl.stepOrder.length - 2])
          ]));
    });

    test('Should return false when current step is not the first step',
        () async {
      expect(bloc.previousStep(RegistrationBlocImpl.stepOrder.last), false);
    });

    test('Should return true when current step is not the first step',
        () async {
      expect(bloc.previousStep(RegistrationBlocImpl.stepOrder.first), true);
    });

    test('Should not emit any state when current step is not the first step',
        () async {
      bloc.previousStep(RegistrationBlocImpl.stepOrder.first);
      expect(
          bloc,
          emitsInOrder([
            IsAnd<RegistrationState>(
                (item) => item.step == RegistrationBlocImpl.stepOrder[0]),
          ]));
    });
  });

  group('beginRequestCode with phone number', () {
    test('Should emit state of registration phone progress', () async {
      when(requestValidationCode.call(any))
          .thenAnswer((_) async => Success(codeRequest));
      bloc.beginRequestCode("123", CodeValidationSource.phone);

      expect(
          bloc,
          emitsInOrder([
            IsAnd<RegistrationState>(
                (item) => item.step == RegistrationBlocImpl.stepOrder[0]),
            isA<RegistrationCodeRequestLoadingState>(),
          ]));
    });

    test('Should call request validation code use case', () async {
      final phone = "123";
      when(requestValidationCode.call(any))
          .thenAnswer((_) async => Success(codeRequest));
      bloc.beginRequestCode(phone, CodeValidationSource.phone);
      await expectLater(
          bloc,
          emitsInOrder([
            isA<RegistrationState>(),
            isA<RegistrationCodeRequestLoadingState>()
          ]));
      verify(requestValidationCode.call(any));
    });

    test(
        'Should emit  state of registration phone success when phone registration succeeeds',
        () async {
      final phone = "123";
      when(requestValidationCode.call(any))
          .thenAnswer((_) async => Success(codeRequest));
      bloc.beginRequestCode("123", CodeValidationSource.phone);

      expect(
          bloc,
          emitsInOrder([
            IsAnd<RegistrationState>(
                (item) => item.step == RegistrationBlocImpl.stepOrder[0]),
            isA<RegistrationCodeRequestLoadingState>(),
            isA<RegistrationCodeRequestSucceededState>(),
          ]));
    });

    test(
        'Should emit state of registration phone failure when phone registration fails',
        () async {
      final phone = "123";
      when(requestValidationCode.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginRequestCode(phone, CodeValidationSource.phone);

      expect(
          bloc,
          emitsInOrder([
            IsAnd<RegistrationState>(
                (item) => item.step == RegistrationBlocImpl.stepOrder[0]),
            isA<RegistrationCodeRequestLoadingState>(),
            isA<RegistrationCodeRequestFailedState>(),
          ]));
    });
  });

  group('beginRequestCode with email', () {
    test('Should emit state of registration email progress', () async {
      when(requestValidationCode.call(any))
          .thenAnswer((_) async => Success(codeRequest));
      bloc.beginRequestCode("email@noknox.com", CodeValidationSource.email);

      expect(
          bloc,
          emitsInOrder([
            IsAnd<RegistrationState>(
                (item) => item.step == RegistrationBlocImpl.stepOrder[0]),
            isA<RegistrationCodeRequestLoadingState>(),
          ]));
    });

    test('Should call request validation code use case', () async {
      final email = "email@noknox.com";
      when(requestValidationCode.call(any))
          .thenAnswer((_) async => Success(codeRequest));
      bloc.beginRequestCode(email, CodeValidationSource.email);
      await expectLater(
          bloc,
          emitsInOrder([
            isA<RegistrationState>(),
            isA<RegistrationCodeRequestLoadingState>()
          ]));
      verify(requestValidationCode.call(any));
    });

    test(
        'Should emit  state of registration phone success when email registration succeeeds',
        () async {
      final email = "email@noknox.com";
      when(requestValidationCode.call(any))
          .thenAnswer((_) async => Success(codeRequest));
      bloc.beginRequestCode(email, CodeValidationSource.email);

      expect(
          bloc,
          emitsInOrder([
            IsAnd<RegistrationState>(
                (item) => item.step == RegistrationBlocImpl.stepOrder[0]),
            isA<RegistrationCodeRequestLoadingState>(),
            isA<RegistrationCodeRequestSucceededState>(),
          ]));
    });

    test(
        'Should emit state of registration phone failure when phone registration fails',
        () async {
      final email = "email@noknox.com";
      when(requestValidationCode.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginRequestCode(email, CodeValidationSource.email);

      expect(
          bloc,
          emitsInOrder([
            IsAnd<RegistrationState>(
                (item) => item.step == RegistrationBlocImpl.stepOrder[0]),
            isA<RegistrationCodeRequestLoadingState>(),
            isA<RegistrationCodeRequestFailedState>(),
          ]));
    });
  });

  group('beginRegistration', () {
    test('Should emit state of registration progress', () async {
      when(register.call(any)).thenAnswer((_) async => Success(registration));
      bloc.beginRegistration();

      expect(
          bloc,
          emitsInOrder([
            IsAnd<RegistrationState>(
                (item) => item.step == RegistrationBlocImpl.stepOrder[0]),
            isA<RegistrationLoadingState>(),
          ]));
    });

    test('Should call register use case', () async {
      when(register.call(any)).thenAnswer((_) async => Success(registration));
      bloc.beginRegistration();
      await expectLater(
          bloc,
          emitsInOrder([
            IsAnd<RegistrationState>(
                (item) => item.step == RegistrationBlocImpl.stepOrder[0]),
            isA<RegistrationLoadingState>(),
          ]));
      verify(register.call(any));
    });

    test(
        'Should emit state of registration success when registration succeeeds',
        () async {
      when(register.call(any)).thenAnswer((_) async => Success(registration));
      bloc.beginRegistration();

      expectLater(
          bloc,
          emitsInOrder([
            IsAnd<RegistrationState>(
                (item) => item.step == RegistrationBlocImpl.stepOrder[0]),
            isA<RegistrationLoadingState>(),
            isA<RegistrationSucceededState>(),
          ]));
    });

    test(
        'Should emit state of registration phone failure when phone registration fails',
        () async {
      when(register.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginRegistration();

      expect(
          bloc,
          emitsInOrder([
            IsAnd<RegistrationState>(
                (item) => item.step == RegistrationBlocImpl.stepOrder[0]),
            isA<RegistrationLoadingState>(),
//				isA<RegistrationFailedEvent>(),
          ]));
    });
  });
}

class RegisterMock extends Mock implements Register {}

class RequestValidationCodeMock extends Mock implements RequestValidationCode {}

class MyUserMock extends Mock implements GetMyUser {}

class LoginBlocMock extends Mock implements AuthenticationBloc {}
