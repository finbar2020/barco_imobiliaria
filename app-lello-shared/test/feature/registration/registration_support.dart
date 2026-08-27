// Apoio dos testes de `feature/registration`: Firebase/plugins falsos,
// container de teste com as classes REAIS (API chopper, data sources,
// repositórios, use cases, blocs e stores) ligadas ao `FakeHttp`, fakes
// para o que é inviável (autenticação, upload de foto, sessão, câmera,
// galeria, recorte, share, path_provider, webview) e fixtures de JSON.
import 'dart:io';

import 'package:essentials/configs/lello_configuration.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';
import 'package:shared_features/feature/code_validation/data/data_source/code_validation_api.dart';
import 'package:shared_features/feature/code_validation/presentation/store/code_validation_store.dart';
import 'package:shared_features/feature/registration/data/data_source/registration_api.dart';
import 'package:shared_features/feature/registration/presentation/store/registration_store.dart';
import 'package:shared_features/shared_features.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import '../../helpers/fake_http.dart';
import '../../helpers/fake_permission_handler.dart';
import '../../helpers/fake_url_launcher.dart';
import '../../helpers/firebase_mocks.dart';
import '../../helpers/test_container.dart';
import '../code_validation/code_validation_support.dart';

/// CPF válido usado nos fluxos (com máscara e só dígitos).
const cpfValido = '529.982.247-25';
const cpfDigitos = '52998224725';

/// Canal do fallback nativo do `UrlLauncherNative`.
const nativeUrlChannel = MethodChannel('com.example.app/url_launcher');

/// JSON dos termos de uso e do Resolva Fácil no remote config.
const remoteConfigPadrao = <String, String>{
  'link_termos_de_uso_pdf':
      '{"link":"https://lello.com.br/termos.pdf","name":"termos.pdf"}',
  'link_resolva_facil': '{"link":"https://resolvafacil.lello.com.br"}',
};

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

/// `sessionBloc` dinâmico da store: só `beginLoadSession()` é usado.
class FakeSessionBloc {
  int loads = 0;
  void beginLoadSession() => loads++;
}

class FakeAuthenticate extends Fake implements Authenticate {
  bool fail = false;
  final calls = <Credentials>[];

  @override
  Future<Try<AccessToken?>> call(Credentials params) async {
    calls.add(params);
    if (fail) return Rejection(UnknownFailure('auth'));
    return Success(AccessToken()..accessToken = 'token');
  }
}

/// `uploadRegistrationPicture` dinâmico da store.
class FakeUploadPicture {
  bool fail = false;
  final files = <File?>[];

  Future<Try<String>> call(File? file) async {
    files.add(file);
    if (fail) return Rejection(UnknownFailure('upload'));
    return Success('http://x/foto.png');
  }
}

/// image_picker falso: devolve [path] (ou `null` = usuário cancelou).
class FakeImagePickerPlatform extends ImagePickerPlatform
    with MockPlatformInterfaceMixin {
  String? path;
  final sources = <ImageSource>[];

  @override
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async {
    sources.add(source);
    final p = path;
    return p == null ? null : XFile(p);
  }
}

/// image_cropper falso: devolve [path] recortado (ou `null` = cancelou).
class FakeImageCropperPlatform extends ImageCropperPlatform
    with MockPlatformInterfaceMixin {
  String? path;
  final cropped = <String>[];

  @override
  Future<CroppedFile?> cropImage({
    required String sourcePath,
    int? maxWidth,
    int? maxHeight,
    CropAspectRatio? aspectRatio,
    ImageCompressFormat compressFormat = ImageCompressFormat.jpg,
    int compressQuality = 90,
    List<PlatformUiSettings>? uiSettings,
  }) async {
    cropped.add(sourcePath);
    final p = path;
    return p == null ? null : CroppedFile(p);
  }
}

/// path_provider falso apontando para um diretório temporário.
class FakePathProvider extends PathProviderPlatform {
  FakePathProvider(this.dir);
  final Directory dir;

  @override
  Future<String?> getApplicationDocumentsPath() async => dir.path;

  @override
  Future<String?> getTemporaryPath() async => dir.path;

  @override
  Future<String?> getApplicationSupportPath() async => dir.path;
}

/// share_plus falso: guarda os parâmetros compartilhados.
class FakeSharePlatform extends SharePlatform with MockPlatformInterfaceMixin {
  final shared = <ShareParams>[];

  @override
  Future<ShareResult> share(ShareParams params) async {
    shared.add(params);
    return const ShareResult('ok', ShareResultStatus.success);
  }
}

/// webview_flutter falso: registra as URLs carregadas e desenha um
/// `SizedBox` no lugar da WebView.
class FakeWebViewPlatform extends WebViewPlatform {
  final controllers = <FakePlatformWebViewController>[];

  @override
  PlatformWebViewController createPlatformWebViewController(
      PlatformWebViewControllerCreationParams params) {
    final controller = FakePlatformWebViewController(params);
    controllers.add(controller);
    return controller;
  }

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
          PlatformWebViewWidgetCreationParams params) =>
      FakePlatformWebViewWidget(params);
}

class FakePlatformWebViewController extends PlatformWebViewController {
  FakePlatformWebViewController(super.params) : super.implementation();

  final loaded = <Uri>[];
  JavaScriptMode? javaScriptMode;

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {
    this.javaScriptMode = javaScriptMode;
  }

  @override
  Future<void> loadRequest(LoadRequestParams params) async {
    loaded.add(params.uri);
  }
}

class FakePlatformWebViewWidget extends PlatformWebViewWidget {
  FakePlatformWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) =>
      const SizedBox(key: Key('fake-webview'), width: 10, height: 10);
}

/// Bundle de assets que entrega um PNG 1x1 para qualquer `.png` (os PNGs
/// usados pelo diálogo de CPF não encontrado ficam no app hospedeiro, não
/// no pacote) e delega o resto ao `rootBundle`.
class TestAssetBundle extends CachingAssetBundle {
  /// Assets que não existem no pacote e foram substituídos.
  final missing = <String>[];

  @override
  Future<ByteData> load(String key) async {
    if (key.endsWith('.png')) {
      return ByteData.sublistView(Uint8List.fromList(pngBytes));
    }
    try {
      return await rootBundle.load(key);
    } catch (_) {
      if (!key.endsWith('.svg')) rethrow;
      missing.add(key);
      return ByteData.sublistView(Uint8List.fromList(svgBytes));
    }
  }
}

/// SVG vazio 1x1 usado no lugar dos ícones que ficam no app hospedeiro.
final svgBytes =
    '<svg xmlns="http://www.w3.org/2000/svg" width="1" height="1"/>'.codeUnits;

/// Envolve o app com o [TestAssetBundle] (para o `providers` do `pumpPage`).
Widget withTestAssets(Widget app) =>
    DefaultAssetBundle(bundle: TestAssetBundle(), child: app);

/// Repositório de cadastro que sempre lança.
class ThrowingRegistrationRepository extends Fake
    implements RegistrationRepository {
  @override
  Future<Try<Registration>> post(Registration entity) async =>
      throw StateError('boom');

  @override
  Future<Try<RegistrationLelloUser>> get(String cpf) async =>
      throw StateError('boom');

  @override
  Future<Try<RegisterFcmToken>> registerFcmToken(
          RegisterFcmToken registerFcmToken) async =>
      throw StateError('boom');

  @override
  Future<Try<bool>> disableFcmToken(RegisterFcmToken registerFcmToken) async =>
      throw StateError('boom');
}

class FakeAccessTokenRepository extends Fake implements AccessTokenRepository {
  AccessToken? token = AccessToken()..refreshToken = 'refresh-1';
  bool fail = false;

  @override
  Future<Try<AccessToken?>> select({String? role}) async =>
      fail ? Rejection(UnknownFailure('sem token')) : Success(token);
}

// ---------------------------------------------------------------------------
// Harness
// ---------------------------------------------------------------------------

class RegistrationHarness {
  RegistrationHarness._();

  final FakeHttp http = FakeHttp();
  final TestSharedContainer container = TestSharedContainer();
  final FakeSessionBloc session = FakeSessionBloc();
  final FakeAuthenticate authenticate = FakeAuthenticate();
  final FakeUploadPicture upload = FakeUploadPicture();
  final FakeImagePickerPlatform picker = FakeImagePickerPlatform();
  final FakeImageCropperPlatform cropper = FakeImageCropperPlatform();
  final FakeSharePlatform share = FakeSharePlatform();
  final FakeWebViewPlatform webView = FakeWebViewPlatform();
  final FakePermissionHandler permissions =
      FakePermissionHandler(status: PermissionStatus.granted);
  late final FakeUrlLauncherPlatform launcher;
  late final FakeRemoteConfigPlatform remoteConfig;
  late final Directory tempDir;
  late final RegistrationRepository repository;
  late final CodeValidationRepository codeRepository;
  final nativeUrlCalls = <MethodCall>[];

  /// `idEmpresa` passado à store (nulo = usa o do `FlavorConfig`).
  int? idEmpresa;

  /// Última store criada pela factory do container.
  RegistrationStore? lastStore;
  CodeValidationStore? lastCodeStore;

  RegistrationStore buildStore() {
    final store = RegistrationStore(
      bloc: RegistrationBloc(),
      requestValidationCode:
          RequestValidationCodeImpl(repository: codeRepository),
      registerUsecase: RegisterImpl(repository: repository),
      myUser: GetMyUserImpl(repository: repository),
      authenticate: authenticate,
      sessionBloc: session,
      uploadRegistrationPicture: upload,
      getDados2faUseCase: GetDados2faImpl(repository: codeRepository),
      request2faUseCase: Request2faImpl(repository: codeRepository),
      validate2faUseCase: Validate2faImpl(repository: codeRepository),
      idEmpresa: idEmpresa,
    );
    lastStore = store;
    return store;
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

  /// Cria um arquivo de imagem (bytes de um PNG 1x1) no diretório temporário.
  File writeImage(String name) {
    final file = File('${tempDir.path}/$name');
    file.writeAsBytesSync(pngBytes);
    return file;
  }

  // Rotas ------------------------------------------------------------------

  void mockDados2fa({
    String cpf = cpfDigitos,
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

  void mockValidate2fa({String token = 'TOKEN-OK', int status = 200, Object? body}) =>
      http.on('POST', '/code_request/2fa/validate',
          status: status, body: body ?? {'token': token});

  void mockRegistration({int status = 200, Object? body}) =>
      http.on('POST', '/registration',
          status: status, body: body ?? registrationJson());

  void mockSindico(String cpf, {int status = 200, Object? body}) =>
      http.on('GET', '/registration/sindico/$cpf',
          status: status, body: body ?? lelloUserJson());

  void mockRegisterFcm({int status = 200, Object? body}) =>
      http.on('POST', '/dashboard/register_fcm_token',
          status: status, body: body ?? fcmJson());

  void mockDisableFcm({int status = 200, Object? body = const {}}) =>
      http.on('PUT', '/dashboard/disable_fcm_token', status: status, body: body);

  /// Rotas do fluxo feliz completo do cadastro.
  void mockHappyPath() {
    mockDados2fa(
      emails: [contact('e1', 'ana@lello.com')],
      sms: [contact('s1', '(11) 98888-7777'), contact('s2', '(11) 97777-6666')],
    );
    mockRequest2fa();
    mockValidate2fa();
    mockRegistration();
  }

  List<String> get requestedPaths =>
      http.requests.map((r) => r.url.path).toList();
}

/// Sobe Firebase/Adjust/Datadog falsos, `FlavorConfig`, SharedPreferences,
/// PackageInfo, `AppInfo`, canal do `sms_autofill`, url_launcher,
/// permissões, câmera/galeria/recorte, share, path_provider e webview
/// falsos, e o container de teste. Chame no `setUp` (fora do fake async).
Future<RegistrationHarness> installRegistrationHarness({
  Map<String, String> remoteConfigValues = remoteConfigPadrao,
  String packageName = 'br.com.lello.morar',
  String appName = 'Lello Morar',
  PermissionStatus permission = PermissionStatus.granted,
}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final harness = RegistrationHarness._();
  harness.remoteConfig =
      await setUpFakeFirebase(remoteConfigValues: remoteConfigValues);
  FlavorConfig.config = const LelloConfiguration();
  SharedPreferences.setMockInitialValues({});
  PackageInfo.setMockInitialValues(
    appName: appName,
    packageName: packageName,
    version: '9.9.9',
    buildNumber: '1',
    buildSignature: '',
  );
  await AppInfo.init();
  mockSmsAutofill();

  harness.launcher = installFakeUrlLauncher();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(nativeUrlChannel, (call) async {
    harness.nativeUrlCalls.add(call);
    throw PlatformException(code: 'sem-plugin');
  });
  addTearDown(() => messenger.setMockMethodCallHandler(nativeUrlChannel, null));

  harness.permissions.status = permission;
  setFakePermissionHandler(harness.permissions);
  ImagePickerPlatform.instance = harness.picker;
  ImageCropperPlatform.instance = harness.cropper;
  SharePlatform.instance = harness.share;
  WebViewPlatform.instance = harness.webView;
  harness.tempDir = Directory.systemTemp.createTempSync('shared_registration');
  PathProviderPlatform.instance = FakePathProvider(harness.tempDir);
  addTearDown(() {
    if (harness.tempDir.existsSync()) {
      harness.tempDir.deleteSync(recursive: true);
    }
  });

  harness.repository = RegistrationRepositoryImpl(
    dataSource: RegistrationRemoteDataSourceImpl(
      api: RegistrationApi.create(buildChopperClient(harness.http)),
    ),
  );
  harness.codeRepository = CodeValidationRepositoryImpl(
    dataSource: CodeValidationRemoteDataSourceImpl(
      api: CodeValidationApi.create(buildChopperClient(harness.http)),
    ),
  );
  harness.container
    ..register<Validator>(ValidatorImpl())
    ..registerFactory<RegistrationStore>(harness.buildStore)
    ..registerFactory<CodeValidationStore>(harness.buildCodeStore)
    ..registerFactory<ResetPasswordBloc>(ResetPasswordBloc.new);
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

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

Map<String, dynamic> registrationJson({
  String name = 'Ana Silva',
  String cpf = cpfDigitos,
  String? email = 'ana@lello.com',
  String? phone = '11988887777',
  String? token = 'tok',
  bool? terms = true,
}) =>
    {
      'name': name,
      'cpf': cpf,
      'email': email,
      'phone': phone,
      'password': null,
      'token': token,
      'terms_and_conditions_check': terms,
    };

Map<String, dynamic> lelloUserJson({
  String name = 'Ana Silva',
  String cpf = cpfDigitos,
  List<String> emails = const ['ana@lello.com'],
  List<String?> phones = const ['11988887777', null],
  bool registered = false,
  List<num> contexts = const [1, 2.5],
}) =>
    {
      'name': name,
      'cpf': cpf,
      'emails': emails,
      'phones': phones,
      'registered': registered,
      'contexts': contexts,
    };

Map<String, dynamic> fcmJson({
  String token = 'fcm-1',
  List<String> reference = const ['R1', 'R2'],
  String type = 'OWNER',
  String deviceId = 'dev-1',
  String refreshToken = 'refresh-1',
}) =>
    {
      'token': token,
      'reference': reference,
      'type': type,
      'device_id': deviceId,
      'refresh_token': refreshToken,
    };

RegisterFcmToken buildFcmToken() => RegisterFcmToken()
  ..token = 'fcm-1'
  ..reference = ['R1']
  ..type = 'OWNER'
  ..deviceId = 'dev-1'
  ..refreshToken = 'refresh-1';

CodeData buildCodeData({
  List<CodeDataContact>? emails,
  List<CodeDataContact>? sms,
  bool registered = false,
}) =>
    CodeData(
      emailContacts: emails ?? [CodeDataContact(key: 'e1', value: 'ana@lello.com')],
      smsContacts: sms ?? [CodeDataContact(key: 's1', value: '(11) 98888-7777')],
      registered: registered,
    );

/// PNG 1x1 transparente.
final pngBytes = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, //
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, //
  0x0D, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x60, 0x00, 0x02, 0x00, //
  0x00, 0x05, 0x00, 0x01, 0xE2, 0x26, 0x05, 0x9B, 0x00, 0x00, 0x00, 0x00, //
  0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82, //
];
