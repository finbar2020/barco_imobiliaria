import 'dart:io';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/registration/data/data_source/registration_api.dart';
import 'package:shared_features/feature/registration/data/model/registation_model.dart';
import 'package:shared_features/feature/registration/data/model/register_fcm_token_model.dart';
import 'package:shared_features/feature/registration/data/model/registration_lello_user_model.dart';
import 'package:shared_features/shared_features.dart';

import 'registration_support.dart';

void main() {
  group('RegistrationModel', () {
    test('fromJson/toJson/toEntity', () {
      final model = RegistrationModel.fromJson(registrationJson());
      expect(model.name, 'Ana Silva');
      expect(model.termsAndConditionsCheck, isTrue);
      expect(model.toJson(), registrationJson());
      final entity = model.toEntity();
      expect(entity.cpf, cpfDigitos);
      expect(entity.email, 'ana@lello.com');
      expect(entity.phone, '11988887777');
      expect(entity.token, 'tok');
      expect(entity.password, isNull);
      expect(entity.profilePicture, isNull);
    });

    test('fromEntity nulo e preenchido', () {
      expect(RegistrationModel.fromEntity(null), isNull);
      final model = RegistrationModel.fromEntity(Registration(
        name: 'n',
        cpf: 'c',
        email: 'e',
        phone: 'p',
        password: 's',
        token: 't',
        termsAndConditionsCheck: false,
      ))!;
      expect(model.toJson(), {
        'name': 'n',
        'cpf': 'c',
        'email': 'e',
        'phone': 'p',
        'password': 's',
        'token': 't',
        'terms_and_conditions_check': false,
      });
    });
  });

  group('RegisterFcmTokenModel', () {
    test('json e entidade', () {
      final model = RegisterFcmTokenModel.fromJson(fcmJson());
      expect(model.reference, ['R1', 'R2']);
      expect(model.deviceId, 'dev-1');
      expect(model.toJson(), fcmJson());
      final entity = model.toEntity();
      expect(entity.token, 'fcm-1');
      expect(entity.refreshToken, 'refresh-1');
      expect(entity.type, 'OWNER');
      expect(RegisterFcmTokenModel.fromEntity(null), isNull);
      expect(RegisterFcmTokenModel.fromEntity(buildFcmToken())!.toJson(), {
        'token': 'fcm-1',
        'reference': ['R1'],
        'type': 'OWNER',
        'device_id': 'dev-1',
        'refresh_token': 'refresh-1',
      });
      expect(RegisterFcmTokenModel.fromJson({}).toEntity().token, isNull);
    });
  });

  group('RegistrationLelloUserModel', () {
    test('json e entidade', () {
      final model = RegistrationLelloUserModel.fromJson(lelloUserJson());
      expect(model.phones, ['11988887777', null]);
      expect(model.contexts, [1.0, 2.5]);
      expect(model.toJson()['emails'], ['ana@lello.com']);
      final entity = model.toEntity();
      expect(entity.name, 'Ana Silva');
      expect(entity.cpf, cpfDigitos);
      expect(entity.registered, isFalse);
      expect(entity.contexts, [1.0, 2.5]);
      expect(RegistrationLelloUserModel.fromEntity(null), isNull);
      final back = RegistrationLelloUserModel.fromEntity(entity)!;
      expect(back.toJson(), lelloUserJson(contexts: [1.0, 2.5]));
      expect(RegistrationLelloUserModel.fromJson({}).toEntity().emails, isNull);
    });
  });

  group('entidades', () {
    test('Registration.copyWith substitui só o que foi passado', () {
      final file = File('x.png');
      final base = Registration(
        name: 'n',
        cpf: 'c',
        email: 'e',
        phone: 'p',
        codeValidationId: 'cv',
        password: 's',
        termsAndConditionsCheck: true,
        profilePicture: file,
        registeredError: false,
        token: 't',
        idEmpresa: 1,
      );
      final same = base.copyWith();
      expect(same.name, 'n');
      expect(same.cpf, 'c');
      expect(same.email, 'e');
      expect(same.phone, 'p');
      expect(same.codeValidationId, 'cv');
      expect(same.password, 's');
      expect(same.termsAndConditionsCheck, isTrue);
      expect(same.profilePicture, file);
      expect(same.registeredError, isFalse);
      expect(same.token, 't');
      expect(same.idEmpresa, 1);

      final changed = base.copyWith(
        name: 'n2',
        cpf: 'c2',
        email: 'e2',
        phone: 'p2',
        codeValidationId: 'cv2',
        password: 's2',
        termsAndConditionsCheck: false,
        profilePicture: File('y.png'),
        registeredError: true,
        token: 't2',
        idEmpresa: 2,
      );
      expect(changed.name, 'n2');
      expect(changed.cpf, 'c2');
      expect(changed.email, 'e2');
      expect(changed.phone, 'p2');
      expect(changed.codeValidationId, 'cv2');
      expect(changed.password, 's2');
      expect(changed.termsAndConditionsCheck, isFalse);
      expect(changed.profilePicture!.path, 'y.png');
      expect(changed.registeredError, isTrue);
      expect(changed.token, 't2');
      expect(changed.idEmpresa, 2);
    });

    test('RegistrationLelloUser, RegisterFcmToken, RegistrationStep', () {
      final user = RegistrationLelloUser()
        ..name = 'a'
        ..cpf = 'c'
        ..emails = ['e']
        ..phones = [null]
        ..registered = true
        ..contexts = [1];
      expect(user.emails, ['e']);
      expect(buildFcmToken().reference, ['R1']);
      expect(RegistrationStep.values,
          [RegistrationStep.cpf, RegistrationStep.me, RegistrationStep.picture, RegistrationStep.password]);
      expect(RegistrationApi.user_not_found_failure, 'user_not_found_failure');
      expect(RegistrationApi.user_already_registerd_failure,
          'user_already_registerd_failure');
    });

    test('falhas do cadastro', () {
      expect(InvalidRegistrationFailure(), isA<RegistrationFailure>());
      expect(RegistrationMissingRequiredDataFailure('cpf').field, 'cpf');
      expect(RegistrationUserNotFoundFailure(), isA<RegistrationFailure>());
      expect(RegistrationPhoneAndEmailFoundFailure(), isA<RegistrationFailure>());
      expect(RegistrationLockedRolloutFailure(), isA<RegistrationFailure>());
      expect(RegistrationAuthFailure(), isA<RegistrationFailure>());
      expect(RegistrationUserAlreadyRegisteredFailure(), isA<RegistrationFailure>());
      expect(RegisterFcmTokenParams(fcmToken: buildFcmToken()).fcmToken.token,
          'fcm-1');
    });
  });

  group('eventos e estados', () {
    test('igualdade por props', () {
      final erro = RegistrationAuthFailure();
      final codeData = buildCodeData();
      final request = CodeRequest(
          source: CodeValidationSource.phone,
          origin: CodeValidationOrigin.registration,
          value: 'v',
          token: '');

      expect(const RegistrationEmptyEvent().props, isEmpty);
      expect(const RegistrationLoadingEvent(loadingMessage: 'm'),
          const RegistrationLoadingEvent(loadingMessage: 'm'));
      expect(const RegistrationSucceededEvent().props, isEmpty);
      expect(const RegistrationCodeRequestLoadingEvent(loadingMessage: 'm').props,
          ['m']);
      expect(RegistrationCodeRequestFailedEvent(error: erro).props, [erro]);
      expect(RegistrationRequestMyUserFailedEvent(error: erro).props, [erro]);
      expect(
          const RegistrationRequestMyUserLoadingEvent(cpf: 'c', loadingMessage: 'm')
              .props,
          ['c', 'm']);
      expect(
          RegistrationRequestMyUserSucceededEvent(
                  codeData: codeData, selectedValue: 's', type: CodeValidationSource.email)
              .props,
          [codeData, 's', CodeValidationSource.email]);
      expect(RegistrationCodeRequestSucceededEvent(codeRequest: request).props,
          [request]);
      expect(RegistrationFailedEvent(error: erro).props, [erro]);
      expect(RegistrationAuthFailedEvent(error: erro).props, [erro]);

      expect(const RegistrationEmptyState(), const RegistrationEmptyState());
      expect(const RegistrationLoadingState().props, isEmpty);
      expect(const RegistrationSucceededState().props, isEmpty);
      expect(const RegistrationCodeRequestLoadingState().props, isEmpty);
      expect(RegistrationCodeRequestFailedState(error: erro).props, [erro]);
      expect(RegistrationRequestMyUserFailedState(error: erro).props, [erro]);
      expect(const RegistrationRequestMyUserLoadingState(loadingMessage: 'm').props,
          ['m']);
      expect(
          RegistrationRequestMyUserSucceededState(
                  codeData: codeData, selectedValue: 's')
              .props,
          [codeData, 's', null]);
      expect(RegistrationCodeRequestSucceededState(codeRequest: request).props,
          [request]);
      expect(RegistrationFailedState(error: erro).props, [erro]);
      expect(RegistrationAuthFailedState(error: erro).props, [erro]);
    });
  });
}
