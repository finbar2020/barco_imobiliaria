import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/code_validation/data/data_source/code_validation_api.dart';
import 'package:shared_features/feature/code_validation/data/model/code_data_contact_model.dart';
import 'package:shared_features/feature/code_validation/data/model/code_data_model.dart';
import 'package:shared_features/feature/code_validation/data/model/code_request_model.dart';
import 'package:shared_features/feature/code_validation/data/model/code_valid_token_model.dart';
import 'package:shared_features/feature/code_validation/data/model/code_validation_model.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('CodeDataContactModel', () {
    test('fromJson/toJson/toEntity', () {
      final model = CodeDataContactModel.fromJson({'key': 'K', 'value': 'V'});
      expect(model.key, 'K');
      expect(model.value, 'V');
      expect(model.toJson(), {'key': 'K', 'value': 'V'});
      final entity = model.toEntity();
      expect(entity.key, 'K');
      expect(entity.value, 'V');
    });

    test('toEntity com campos nulos lança (uso de `!`)', () {
      expect(() => CodeDataContactModel().toEntity(), throwsA(isA<TypeError>()));
    });
  });

  group('CodeDataModel', () {
    test('fromJson completo e toEntity', () {
      final model = CodeDataModel.fromJson({
        'email_contacts': [
          {'key': 'e1', 'value': 'a@b.com'}
        ],
        'sms_contacts': [
          {'key': 's1', 'value': '11999998888'},
          {'key': 's2', 'value': '11999997777'},
        ],
        'registered': true,
      });
      expect(model.registered, isTrue);
      final entity = model.toEntity();
      expect(entity.registered, isTrue);
      expect(entity.emailContacts.single.value, 'a@b.com');
      expect(entity.smsContacts.map((c) => c.key), ['s1', 's2']);
      expect(model.toJson()['registered'], isTrue);
      expect(model.toJson()['email_contacts'], hasLength(1));
    });

    test('nulos viram listas vazias e registered false', () {
      final entity = CodeDataModel.fromJson({}).toEntity();
      expect(entity.registered, isFalse);
      expect(entity.emailContacts, isEmpty);
      expect(entity.smsContacts, isEmpty);

      final vazio = CodeDataModel(emailContacts: [], smsContacts: []).toEntity();
      expect(vazio.emailContacts, isEmpty);
      expect(vazio.smsContacts, isEmpty);
    });
  });

  group('CodeRequestModel', () {
    test('fromEntity/toEntity mantém os campos', () {
      final entity = CodeRequest(
        id: 'ID',
        source: CodeValidationSource.phone,
        origin: CodeValidationOrigin.changeNumber,
        value: '11999998888',
        token: 'tok',
        cpf: '123',
        appSignature: 'sig',
      );
      final model = CodeRequestModel.fromEntity(entity)!;
      expect(model.source, 'phone');
      expect(model.origin, 'changeNumber');
      expect(model.toJson(), {
        'id': 'ID',
        'source': 'phone',
        'origin': 'changeNumber',
        'value': '11999998888',
        'token': 'tok',
        'cpf': '123',
        'app_signature': 'sig',
      });
      final back = CodeRequestModel.fromJson(model.toJson()).toEntity();
      expect(back.id, 'ID');
      expect(back.source, CodeValidationSource.phone);
      expect(back.origin, CodeValidationOrigin.changeNumber);
      expect(back.value, '11999998888');
      expect(back.token, 'tok');
      expect(back.cpf, '123');
      expect(back.appSignature, 'sig');
    });

    test('fromEntity nulo devolve nulo e toEntity usa padrões', () {
      expect(CodeRequestModel.fromEntity(null), isNull);
      final entity = CodeRequestModel.fromJson({'source': 'xyz'}).toEntity();
      expect(entity.origin, CodeValidationOrigin.other);
      expect(entity.source, CodeValidationSource.email);
      expect(entity.token, '');
      expect(entity.value, '');
      expect(entity.cpf, isNull);
    });
  });

  group('CodeValidTokenModel', () {
    test('json e entidade', () {
      final model = CodeValidTokenModel.fromJson({'token': 'T'});
      expect(model.toJson(), {'token': 'T'});
      expect(model.toEntity().token, 'T');
      expect(CodeValidTokenModel().toEntity().token, '');
    });
  });

  group('CodeValidationModel', () {
    test('json, fromEntity e toEntity', () {
      final model = CodeValidationModel.fromJson({'id': 'I', 'code': '1234'});
      expect(model.toJson(), {'id': 'I', 'code': '1234'});
      expect(model.toEntity().id, 'I');
      expect(model.toEntity().code, '1234');
      expect(CodeValidationModel.fromEntity(null), isNull);
      final fromEntity = CodeValidationModel.fromEntity(
          CodeValidation(id: 'X', code: '9', token: 't'))!;
      expect(fromEntity.id, 'X');
      expect(fromEntity.code, '9');
    });
  });

  group('entidades', () {
    test('CodeData, CodeDataContact, CodeValidToken, CodeValidation', () {
      final data = CodeData(
        emailContacts: [CodeDataContact(key: 'k', value: 'v')],
        smsContacts: [],
        registered: true,
      );
      expect(data.emailContacts.single.key, 'k');
      expect(CodeValidToken(token: 't').token, 't');
      final validation = CodeValidation(id: 'i', code: 'c', token: 't');
      expect(validation.id, 'i');
      expect(validation.code, 'c');
      expect(validation.token, 't');
    });

    test('constantes de falha da API', () {
      expect(CodeValidationApi.max_attempts_exceeded_failure,
          'validate_code_max_failed_attempts_exceeded_failure');
      expect(CodeValidationApi.code_previously_validated_failure,
          'validate_code_code_previously_validated_failure');
    });

    testWidgets('getWarningMessage varia por origem e fonte', (tester) async {
      late BuildContext ctx;
      await pumpApp(tester, Builder(builder: (c) {
        ctx = c;
        return const SizedBox();
      }));
      final troca = CodeRequest(
          source: CodeValidationSource.phone,
          origin: CodeValidationOrigin.changeNumber,
          value: '',
          token: '');
      expect(troca.getWarningMessage(ctx), contains('bloqueados'));
      expect(troca.getWarningMessage(ctx), isNot(contains('email')));

      final email = CodeRequest(
          source: CodeValidationSource.email,
          origin: CodeValidationOrigin.registration,
          value: '',
          token: '');
      expect(email.getWarningMessage(ctx), contains('spam'));

      final sms = CodeRequest(
          source: CodeValidationSource.phone,
          origin: CodeValidationOrigin.registration,
          value: '',
          token: '');
      expect(sms.getWarningMessage(ctx), contains('tente receber o código por email'));
    });
  });

  group('eventos e estados', () {
    test('igualdade por props', () {
      final validation = CodeValidation(id: 'a', code: 'b');
      expect(const CodeValidationEmptyEvent(), const CodeValidationEmptyEvent());
      expect(const CodeValidationLoadingEvent().props, isEmpty);
      expect(CodeValidationSucceededEvent(validation: validation),
          CodeValidationSucceededEvent(validation: validation));
      expect(CodeValidationResendEvent(validation: validation).props,
          [validation]);
      final erro = InvalidCodeValidationFailure();
      expect(CodeValidationFailedEvent(error: erro),
          CodeValidationFailedEvent(error: erro));

      expect(const CodeValidationEmptyState(), const CodeValidationEmptyState());
      expect(const CodeValidationValidatingState().props, isEmpty);
      expect(CodeValidationSucceededState(validation: validation).props,
          [validation]);
      expect(CodeValidationResendState(validation: validation),
          CodeValidationResendState(validation: validation));
      expect(CodeValidationFailedState(error: erro).props, [erro]);
    });

    test('parâmetros dos use cases', () {
      expect(CodeDataParam(cpf: '1', idEmpresa: 2).idEmpresa, 2);
      expect(Tequest2faParam(id: 'i', appSignature: 's').appSignature, 's');
      expect(Validate2faParam(id: 'i', value: 'v').value, 'v');
      expect(UserUnkonwFailure(), isA<Failure>());
      expect(InvalidGetDados2faFailure(), isA<Failure>());
      expect(InvalidRequest2faFailure(), isA<Failure>());
      expect(InvalidCodeSourceFailure(), isA<Failure>());
      expect(InvalidValidate2faFailure(), isA<Failure>());
      expect(InvalidValue2faFailure(), isA<Failure>());
      expect(InvalidRequestCodeFailure(), isA<Failure>());
      expect(ValidateCodeMaxAttemptsExceededFailure(), isA<Failure>());
      expect(RequestCodeAlreadyValidatedFailure(), isA<Failure>());
    });
  });
}
