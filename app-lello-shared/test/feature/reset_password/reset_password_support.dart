// Apoio dos testes de `feature/reset_password`: Firebase/plugins falsos,
// container de teste com as classes REAIS (APIs chopper de troca de senha e
// de validação de código, data sources, repositórios, use cases, bloc,
// controller e store de login) ligadas ao `FakeHttp`, e fixtures.
import 'package:essentials/configs/lello_configuration.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/feature/code_validation/data/data_source/code_validation_api.dart';
import 'package:shared_features/feature/code_validation/presentation/store/code_validation_store.dart';
import 'package:shared_features/feature/reset_password/data/data_source/password_reset_api.dart';
import 'package:shared_features/feature/reset_password/data/model/password_reset_model.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../helpers/fake_http.dart';
import '../../helpers/firebase_mocks.dart';
import '../../helpers/test_container.dart';
import '../authentication/authentication_support.dart';
import '../code_validation/code_validation_support.dart';

/// CPF válido usado nos fluxos (com máscara e só dígitos).
const cpfValido = '529.982.247-25';
const cpfDigitos = '52998224725';

/// `GetMyUser` não é chamado pelo controller; só precisa existir.
class FakeGetMyUser extends Fake implements GetMyUser {}

/// Repositório de troca de senha que sempre lança.
class ThrowingPasswordResetRepository extends Fake
    implements PasswordResetRepository {
  @override
  Future<Try<PasswordReset>> post(PasswordReset reset) async =>
      throw StateError('boom');

  @override
  Future<Try<PasswordReset>> post2fa(ResetPassword2faParams params) async =>
      throw StateError('boom');
}

/// Data source de troca de senha que sempre lança.
class ThrowingPasswordResetDataSource extends Fake
    implements PasswordResetRemoteDataSource {
  @override
  Future<PasswordResetModel> post(PasswordResetModel model) async =>
      throw StateError('boom');
}

class ResetPasswordHarness {
  ResetPasswordHarness._();

  final FakeHttp http = FakeHttp();
  final TestSharedContainer container = TestSharedContainer();
  late final PasswordResetRepositoryImpl repository;
  late final CodeValidationRepositoryImpl codeRepository;
  late final AuthenticationStore loginStore;
  late final List<MethodCall> smsCalls;

  /// `idEmpresa` passado ao controller (nulo = usa o do `FlavorConfig`).
  int? idEmpresa;

  ResetPasswordController? lastController;
  CodeValidationStore? lastCodeStore;

  ResetPasswordController buildController({ResetPasswordBloc? bloc}) {
    final controller = ResetPasswordController(
      resetPasswordBloc: bloc ?? ResetPasswordBloc(),
      requestValidationCodeUseCase:
          RequestValidationCodeImpl(repository: codeRepository),
      resetPasswordUseCase: ResetPasswordImpl(repository: repository),
      resetPassword2fa: ResetPassword2faImpl(repository: repository),
      myUserUseCase: FakeGetMyUser(),
      loginStore: loginStore,
      getDados2faUseCase: GetDados2faImpl(repository: codeRepository),
      request2faUseCase: Request2faImpl(repository: codeRepository),
      validate2faUseCase: Validate2faImpl(repository: codeRepository),
      idEmpresa: idEmpresa,
    );
    lastController = controller;
    return controller;
  }

  CodeValidationStore buildCodeStore() {
    final store = CodeValidationStore(
      bloc: CodeValidationBloc(),
      validateCode: ValidateCodeImpl(repository: codeRepository),
      requestValidationCode:
          RequestValidationCodeImpl(repository: codeRepository),
      validate2fa: Validate2faImpl(repository: codeRepository),
    );
    lastCodeStore = store;
    return store;
  }

  // Rotas ------------------------------------------------------------------

  void mockDados2fa({
    String cpf = cpfDigitos,
    List<Map<String, String>> emails = const [],
    List<Map<String, String>> sms = const [],
    bool? registered = true,
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

  void mockChangePassword({int status = 200, Object? body = const {}}) =>
      http.on('POST', '/change_password', status: status, body: body);

  /// Rotas do fluxo feliz completo.
  void mockHappyPath() {
    mockDados2fa(
      emails: [contact('e1', 'ana@lello.com')],
      sms: [contact('s1', '(11) 98888-7777')],
    );
    mockRequest2fa();
    mockValidate2fa();
    mockChangePassword();
  }

  List<String> get requestedPaths =>
      http.requests.map((r) => r.url.path).toList();
}

/// Sobe Firebase falso, `FlavorConfig`, SharedPreferences, PackageInfo, o
/// canal do `sms_autofill` e o container de teste. Chame no `setUp` (fora
/// do fake async).
Future<ResetPasswordHarness> installResetPasswordHarness({
  String packageName = 'br.com.lello.morar',
  String loginUsername = '',
}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final harness = ResetPasswordHarness._();
  await setUpFakeFirebase();
  FlavorConfig.config = const LelloConfiguration();
  SharedPreferences.setMockInitialValues({});
  PackageInfo.setMockInitialValues(
    appName: 'Lello',
    packageName: packageName,
    version: '9.9.9',
    buildNumber: '1',
    buildSignature: '',
  );
  harness.smsCalls = mockSmsAutofill();

  harness.repository = PasswordResetRepositoryImpl(
    dataSource: PasswordResetRemoteDataSourceImpl(
      api: PasswordResetApi.create(buildChopperClient(harness.http)),
    ),
  );
  harness.codeRepository = CodeValidationRepositoryImpl(
    dataSource: CodeValidationRemoteDataSourceImpl(
      api: CodeValidationApi.create(buildChopperClient(harness.http)),
    ),
  );
  harness.loginStore = AuthenticationHarness().buildStore()
    ..credentials = Credentials(username: loginUsername, password: '');
  harness.container
    ..register<Validator>(ValidatorImpl())
    ..registerLazy<ResetPasswordController>(harness.buildController)
    ..registerFactory<ResetPasswordBloc>(ResetPasswordBloc.new)
    ..registerFactory<CodeValidationBloc>(CodeValidationBloc.new)
    ..registerFactory<CodeValidationStore>(harness.buildCodeStore);
  return harness;
}

/// Emite [state] direto no [bloc] e espera a tela reagir.
Future<void> emitState(
  WidgetTester tester,
  Bloc bloc,
  Object state, {
  bool settle = true,
}) async {
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  bloc.emit(state);
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
    await tester.pump();
  }
}

Map<String, String> contact(String key, String value) =>
    {'key': key, 'value': value};

/// Corpo de erro no formato do `ApiFailure`.
Map<String, dynamic> apiFailureBody({int status = 500, String? failure}) => {
      'status': status,
      'title': 'erro',
      'failure': failure,
      'message': 'mensagem',
    };

CodeData buildCodeData({
  List<CodeDataContact>? emails,
  List<CodeDataContact>? sms,
  bool registered = true,
}) =>
    CodeData(
      emailContacts:
          emails ?? [CodeDataContact(key: 'e1', value: 'ana@lello.com')],
      smsContacts:
          sms ?? [CodeDataContact(key: 's1', value: '(11) 98888-7777')],
      registered: registered,
    );

PasswordReset buildReset({
  String? cpf = cpfDigitos,
  String? password = 'Senha123',
  String? token = 'TOKEN-OK',
  String? phone,
  String? email,
  String? codeValidationId,
}) =>
    PasswordReset()
      ..cpf = cpf
      ..password = password
      ..token = token
      ..phone = phone
      ..email = email
      ..codeValidationId = codeValidationId;

CodeRequest buildCodeRequest({String? id = 'K1', String value = '11988887777'}) =>
    CodeRequest(
      id: id,
      source: CodeValidationSource.phone,
      origin: CodeValidationOrigin.forgotPassword,
      value: value,
      token: '',
      cpf: cpfValido,
    );
