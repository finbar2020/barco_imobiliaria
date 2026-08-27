import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/code_validation/presentation/store/code_validation_store.dart';
import 'package:shared_features/shared_features.dart';

import 'code_validation_support.dart';

void main() {
  late CodeValidationHarness harness;
  late CodeValidationStore store;
  late List<CodeValidationState> states;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockSmsAutofill();
    harness = CodeValidationHarness();
    store = harness.buildStore();
    states = [];
    store.bloc.stream.listen(states.add);
  });

  Future<void> settle() async {
    for (var i = 0; i < 3; i++) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  test('sem pedido não faz nada', () async {
    store.code = '123456';
    await store.validate();
    await settle();
    expect(states, isEmpty);
    expect(harness.http.requests, isEmpty);
  });

  test('origem registration valida pelo 2FA e devolve o token', () async {
    harness.mockValidate2fa(token: 'TOK');
    store
      ..request = phoneRequest(id: 'K1')
      ..code = '123456';
    await store.validate();
    await settle();

    expect(states.first, const CodeValidationValidatingState());
    final success = states.last as CodeValidationSucceededState;
    expect(success.validation.id, 'K1');
    expect(success.validation.code, '123456');
    expect(success.validation.token, 'TOK');
    final url = harness.http.requests.single.url;
    expect(url.path, '/code_request/2fa/validate');
    expect(url.queryParameters, {'hashToken': 'K1', 'tokenValue': '123456'});
  });

  test('origem forgotPassword também usa o 2FA e falha vira inválido',
      () async {
    harness.mockValidate2fa(status: 400, body: apiFailureBody(status: 400));
    store
      ..request = phoneRequest(
          id: 'K1', origin: CodeValidationOrigin.forgotPassword)
      ..code = '123456';
    await store.validate();
    await settle();

    expect(states.last, isA<CodeValidationFailedState>());
    expect((states.last as CodeValidationFailedState).error,
        isA<InvalidCodeValidationFailure>());
  });

  test('id preenchido com token vazio usa o 2FA mesmo em outra origem',
      () async {
    harness.mockValidate2fa(token: 'T2');
    store
      ..request = emailRequest(id: 'E9', origin: CodeValidationOrigin.other, token: '')
      ..code = '111111';
    await store.validate();
    await settle();
    expect(harness.requestedPaths, ['/code_request/2fa/validate']);
    expect((states.last as CodeValidationSucceededState).validation.token, 'T2');
  });

  test('usuário de teste com código 1234 passa sem chamar a API', () async {
    store
      ..request = emailRequest(cpf: '396.048.388-06')
      ..code = '1234';
    await store.validate();
    await settle();
    expect(harness.http.requests, isEmpty);
    final success = states.last as CodeValidationSucceededState;
    expect(success.validation.id, 'E1');
    expect(success.validation.code, '1234');
    expect(success.validation.token, isNull);
  });

  test('fluxo legado valida pelo código gerado', () async {
    harness.mockGeneratedValidate();
    store
      ..request = emailRequest()
      ..code = '4321';
    await store.validate();
    await settle();
    expect(harness.requestedPaths, ['/code_request/generated/validate']);
    expect(harness.http.requests.single.body, '{"id":"E1","code":"4321"}');
    expect(states.last, isA<CodeValidationSucceededState>());
  });

  test('fluxo legado com erro emite falha', () async {
    harness.mockGeneratedValidate(status: 500, body: apiFailureBody());
    store
      ..request = emailRequest()
      ..code = '4321';
    await store.validate();
    await settle();
    expect(states, [
      const CodeValidationValidatingState(),
      isA<CodeValidationFailedState>(),
    ]);
  });

  test('listenSMSTokenCode não falha fora do Android', () async {
    await store.listenSMSTokenCode();
  });
}
