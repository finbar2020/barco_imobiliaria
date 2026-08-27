// Apoio dos testes de `feature/code_validation`: canal `sms_autofill`
// mockado, container de teste com as classes REAIS (API chopper, data
// source, repositório, use cases, bloc e store) ligadas ao `FakeHttp` e
// atalhos para as rotas HTTP da validação de código.
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/code_validation/data/data_source/code_validation_api.dart';
import 'package:shared_features/feature/code_validation/presentation/store/code_validation_store.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/fake_http.dart';
import '../../helpers/test_container.dart';

/// Canal do plugin `sms_autofill`.
const smsAutofillChannel = MethodChannel('sms_autofill');

/// Responde `getAppSignature` (e os demais métodos) do `sms_autofill`;
/// devolve a lista de chamadas recebidas.
List<MethodCall> mockSmsAutofill({String signature = 'ASSINATURA'}) {
  final calls = <MethodCall>[];
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(smsAutofillChannel, (call) async {
    calls.add(call);
    if (call.method == 'getAppSignature') return signature;
    return null;
  });
  addTearDown(
      () => messenger.setMockMethodCallHandler(smsAutofillChannel, null));
  return calls;
}

/// Repositório que sempre lança: cobre os `catch` dos use cases.
class ThrowingCodeValidationRepository extends Fake
    implements CodeValidationRepository {
  @override
  Future<Try<CodeData>> getDados2faAsync(String cpf, [int? idEmpresa]) async =>
      throw StateError('boom');

  @override
  Future<Try<bool>> request2faAsync(String id, String appSignature) async =>
      throw StateError('boom');

  @override
  Future<Try<CodeValidToken>> validate2faAsync(
          String hashToken, String tokenValue) async =>
      throw StateError('boom');

  @override
  Future<Try<CodeRequest>> register(CodeRequest request) async =>
      throw StateError('boom');

  @override
  Future<Try<CodeValidation?>> validate(CodeValidation validation) async =>
      throw StateError('boom');
}

/// Container com as classes reais da feature ligadas ao [http] falso.
class CodeValidationHarness {
  CodeValidationHarness() {
    repository = CodeValidationRepositoryImpl(
      dataSource: CodeValidationRemoteDataSourceImpl(
        api: CodeValidationApi.create(buildChopperClient(http)),
      ),
    );
    container.registerFactory<CodeValidationStore>(buildStore);
  }

  final FakeHttp http = FakeHttp();
  final TestSharedContainer container = TestSharedContainer();
  late final CodeValidationRepository repository;

  /// Última store criada pela factory do container.
  CodeValidationStore? lastStore;

  CodeValidationStore buildStore() {
    final store = CodeValidationStore(
      bloc: CodeValidationBloc(),
      validateCode: ValidateCodeImpl(repository: repository),
      requestValidationCode: RequestValidationCodeImpl(repository: repository),
      validate2fa: Validate2faImpl(repository: repository),
    );
    lastStore = store;
    return store;
  }

  // Rotas ------------------------------------------------------------------

  void mockDados2fa(
    String cpf, {
    List<Map<String, String>> emails = const [],
    List<Map<String, String>> sms = const [],
    bool? registered = false,
    int status = 200,
    Object? body,
  }) =>
      http.on('GET', '/code_request/2fa/$cpf',
          status: status,
          body: body ??
              {
                'email_contacts': emails,
                'sms_contacts': sms,
                'registered': registered,
              });

  void mockRequest2fa({int status = 200, Object? body = const {}}) =>
      http.on('POST', '/code_request/2fa/request', status: status, body: body);

  void mockValidate2fa({
    String token = 'TOKEN-OK',
    int status = 200,
    Object? body,
  }) =>
      http.on('POST', '/code_request/2fa/validate',
          status: status, body: body ?? {'token': token});

  void mockGenerated({int status = 200, Object? body}) =>
      http.on('POST', '/code_request/generated',
          status: status,
          body: body ??
              {
                'id': 'REQ-1',
                'source': 'phone',
                'origin': 'registration',
                'value': '11988887777',
                'token': 'tok',
              });

  void mockGeneratedValidate({int status = 202, Object? body = const {}}) =>
      http.on('POST', '/code_request/generated/validate',
          status: status, body: body);

  List<String> get requestedPaths =>
      http.requests.map((r) => r.url.path).toList();
}

/// Corpo de erro no formato do `ApiFailure`.
Map<String, dynamic> apiFailureBody({int status = 500, String? failure}) => {
      'status': status,
      'title': 'erro',
      'failure': failure,
      'message': 'mensagem',
    };

Map<String, String> contact(String key, String value) =>
    {'key': key, 'value': value};

CodeRequest phoneRequest({
  String? id = 'K1',
  CodeValidationOrigin origin = CodeValidationOrigin.registration,
  String token = '',
  String value = '11988887777',
  String? cpf = '529.982.247-25',
}) =>
    CodeRequest(
      id: id,
      source: CodeValidationSource.phone,
      origin: origin,
      value: value,
      token: token,
      cpf: cpf,
    );

CodeRequest emailRequest({
  String? id = 'E1',
  CodeValidationOrigin origin = CodeValidationOrigin.other,
  String token = 'tok',
  String value = 'ana.silva@lello.com',
  String? cpf = '529.982.247-25',
}) =>
    CodeRequest(
      id: id,
      source: CodeValidationSource.email,
      origin: origin,
      value: value,
      token: token,
      cpf: cpf,
    );
