import 'dart:io';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/me/domain/use_case/get_me/get_me.dart';
import 'package:morar/feature/me/domain/use_case/log_me_out/log_me_out.dart';
import 'package:morar/feature/me/domain/use_case/save_me/save_me.dart';
import 'package:morar/feature/me/domain/use_case/update_password_me/update_password_me.dart';
import 'package:morar/feature/me/domain/use_case/upload_profile_picture/upload_registration_picture.dart';
import 'package:morar/feature/me/presentation/controllers/me_controller.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/page_harness.dart';

/// `GetMe` falso: [local] responde a origem local e [remote] a remota.
class FakeGetMe extends Fake implements GetMe {
  Me? local;
  Try<Me?> remote = Success(testMe());
  final origins = <DataOrigin>[];

  @override
  Future<Try<Me?>> call(DataOrigin origin) async {
    origins.add(origin);
    if (origin == DataOrigin.local) return Success(local);
    return remote;
  }
}

class FakeSaveMe extends Fake implements SaveMe {
  bool fail = false;
  final calls = <SaveMeParam>[];
  SaveMeParam? get params => calls.isEmpty ? null : calls.last;

  @override
  Future<Try<Me?>> call(SaveMeParam p) async {
    calls.add(p);
    if (fail) return Rejection(UnknownFailure('save'));
    return Success(p.me);
  }
}

class FakeUpdatePassword extends Fake implements UpdatePasswordMe {
  bool fail = false;
  UpdatePasswordMeParam? params;

  @override
  Future<Try> call(UpdatePasswordMeParam p) async {
    params = p;
    if (fail) return Rejection(UnknownFailure('pwd'));
    return Success(null);
  }
}

class FakeUploadProfilePicture extends Fake implements UploadProfilePicture {
  bool fail = false;
  final files = <File>[];

  @override
  Future<Try<String>> call(File params) async {
    files.add(params);
    if (fail) return Rejection(UnknownFailure('upload'));
    return Success('http://x/foto.png');
  }
}

class FakeGetDados2fa extends Fake implements GetDados2fa {
  bool fail = false;
  List<CodeDataContact> sms = [CodeDataContact(key: 'k1', value: '(11) 98888-7777')];
  List<CodeDataContact> emails = [CodeDataContact(key: 'e1', value: 'ana@lello.com')];

  @override
  Future<Try<CodeData>> call(CodeDataParam params) async {
    if (fail) return Rejection(UnknownFailure('2fa'));
    return Success(
        CodeData(emailContacts: emails, smsContacts: sms, registered: true));
  }
}

class FakeRequest2fa extends Fake implements Request2fa {
  bool fail = false;
  final calls = <Tequest2faParam>[];

  @override
  Future<Try<bool>> call(Tequest2faParam p) async {
    calls.add(p);
    if (fail) return Rejection(UnknownFailure('req'));
    return Success(true);
  }
}

/// Store de autenticação falso: nunca toca token/hive. O [bloc] é o
/// `AuthenticationBloc` real do container (a `MePage` escuta ele).
class FakeAuthenticationStore extends Fake implements AuthenticationStore {
  FakeAuthenticationStore(this._bloc);
  final AuthenticationBloc _bloc;
  Map<String, String>? customHeader;
  int logouts = 0;

  @override
  AuthenticationBloc get bloc => _bloc;

  @override
  Map<String, String>? getCustomHeader() => customHeader;

  @override
  String getRefreshToken() => 'refresh-token';

  @override
  String getExpirationDate() => '01/01/2030';

  @override
  Future<void> logout() async => logouts++;
}

class FakeLogMeOut extends Fake implements LogMeOut {
  int calls = 0;
  @override
  Future<Try<Nothing>> call() async {
    calls++;
    return Success(Nothing());
  }
}

class FakeDeleteAccount extends Fake implements DeleteAccount {
  bool fail = false;
  int calls = 0;
  @override
  Future<Try<String?>> call() async {
    calls++;
    return fail ? Rejection(UnknownFailure('del')) : Success('ok');
  }
}

class FakeDisableFcm extends Fake implements DisableFcm {
  int calls = 0;
  @override
  Future<Try<bool>> call() async {
    calls++;
    return Success(true);
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

/// Conjunto de fakes instalados no container para os testes de tela do
/// perfil. O `MeController` (lazy singleton) é criado depois deles, então
/// recebe exatamente estas instâncias.
class MeFakes {
  MeFakes(this.harness);
  final PageHarness harness;

  final getMe = FakeGetMe();
  final saveMe = FakeSaveMe();
  final updatePassword = FakeUpdatePassword();
  final upload = FakeUploadProfilePicture();
  final dados2fa = FakeGetDados2fa();
  final request2fa = FakeRequest2fa();
  final logMeOut = FakeLogMeOut();
  final deleteAccount = FakeDeleteAccount();
  final disableFcm = FakeDisableFcm();
  final picker = FakeImagePickerPlatform();
  final cropper = FakeImageCropperPlatform();
  late final FakeAuthenticationStore authStore;
  final reviewCalls = <String>[];
  final installationsCalls = <String>[];

  AuthenticationBloc get authBloc => harness.resolve<AuthenticationBloc>();
  MeController get controller => harness.resolve<MeController>();
}

const _inAppReviewChannel = MethodChannel('dev.britannio.in_app_review');
const _installationsChannel =
    MethodChannel('plugins.flutter.io/firebase_app_installations');

Future<MeFakes> installMeFakes(PageHarness harness) async {
  final fakes = MeFakes(harness);
  fakes.authStore = FakeAuthenticationStore(fakes.authBloc);

  await harness.override<GetMe>(fakes.getMe);
  await harness.override<SaveMe>(fakes.saveMe);
  await harness.override<UpdatePasswordMe>(fakes.updatePassword);
  await harness.override<UploadProfilePicture>(fakes.upload);
  await harness.override<GetDados2fa>(fakes.dados2fa);
  await harness.override<Request2fa>(fakes.request2fa);
  await harness.override<LogMeOut>(fakes.logMeOut);
  await harness.override<DeleteAccount>(fakes.deleteAccount);
  await harness.override<DisableFcm>(fakes.disableFcm);
  await harness.override<AuthenticationStore>(fakes.authStore);

  final previousImage = ImagePickerPlatform.instance;
  final previousCropper = ImageCropperPlatform.instance;
  ImagePickerPlatform.instance = fakes.picker;
  ImageCropperPlatform.instance = fakes.cropper;

  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(_inAppReviewChannel, (call) async {
    fakes.reviewCalls.add(call.method);
    return false;
  });
  messenger.setMockMethodCallHandler(_installationsChannel, (call) async {
    fakes.installationsCalls.add(call.method);
    return 'installation-token';
  });

  addTearDown(() {
    ImagePickerPlatform.instance = previousImage;
    ImageCropperPlatform.instance = previousCropper;
    messenger.setMockMethodCallHandler(_inAppReviewChannel, null);
    messenger.setMockMethodCallHandler(_installationsChannel, null);
  });
  return fakes;
}

/// Troca a sessão do [harness] (e o `state`, que o FakeSessionBloc congela
/// no construtor).
void useSession(PageHarness harness, Session session) {
  harness.sessionBloc.session = session;
  harness.sessionBloc.currentState = SessionLoadedState(session);
}
