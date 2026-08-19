import 'dart:io';

import 'package:colaborador/core/bloc/inactivity/inactivity_cubit.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:colaborador/feature/me/domain/use_case/get_me/get_me.dart';
import 'package:colaborador/feature/me/domain/use_case/save_me/save_me.dart';
import 'package:colaborador/feature/me/domain/use_case/update_password_me/update_password_me.dart';
import 'package:colaborador/feature/me/domain/use_case/upload_profile_picture/upload_registration_picture.dart';
import 'package:colaborador/feature/me/domain/use_case/log_me_out/log_me_out.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_bloc.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_state.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart' hide isNotNull;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeGetMe extends Fake implements GetMe {
  _FakeGetMe({this.local, this.remote, this.failRemote = false});

  Me? local;
  Me? remote;
  bool failRemote;
  final origins = <DataOrigin>[];

  @override
  Future<Try<Me?>> call(DataOrigin? params) async {
    origins.add(params!);
    if (params == DataOrigin.local) return Success(local);
    if (failRemote) return Rejection(UnknownFailure('remote'));
    return Success(remote);
  }
}

class _FakeSaveMe extends Fake implements SaveMe {
  _FakeSaveMe({this.fail = false});

  final bool fail;
  final saved = <Me?>[];

  @override
  Future<Try<Me?>> call(SaveMeParam? params) async {
    saved.add(params?.me);
    if (fail) return Rejection(UnknownFailure('save'));
    return Success(params?.me);
  }
}

class _FakeUpdatePassword extends Fake implements UpdatePasswordMe {
  _FakeUpdatePassword({this.fail = false});

  final bool fail;
  UpdatePasswordMeParam? received;

  @override
  Future<Try<dynamic>> call(UpdatePasswordMeParam? params) async {
    received = params;
    if (fail) return Rejection(KnownFailure('400', 'senha inválida'));
    return Success(true);
  }
}

class _FakeUploadPicture extends Fake implements UploadProfilePicture {
  @override
  Future<Try<String>> call(File? params) async => Success('hash');
}

class _FakeLogMeOut extends Fake implements LogMeOut {
  bool called = false;

  @override
  Future<Try<Nothing>> call() async {
    called = true;
    return Success(Nothing());
  }
}

class _FakeDeleteAccount extends Fake implements DeleteAccount {
  _FakeDeleteAccount({this.fail = false});

  final bool fail;

  @override
  Future<Try<String?>> call() async {
    if (fail) return Rejection(UnknownFailure('delete'));
    return Success('ok');
  }
}

class _FakeDisableFcm extends Fake implements DisableFcm {
  bool called = false;

  @override
  Future<Try<bool>> call() async {
    called = true;
    return Success(true);
  }
}

class _FakeGetDados2fa extends Fake implements GetDados2fa {
  _FakeGetDados2fa({
    this.fail = false,
    this.smsContacts = const [],
    this.emailContacts = const [],
  });

  final bool fail;
  final List<CodeDataContact> smsContacts;
  final List<CodeDataContact> emailContacts;

  @override
  Future<Try<CodeData>> call(CodeDataParam? params) async {
    if (fail) return Rejection(UnknownFailure('2fa'));
    return Success(
      CodeData(
        emailContacts: emailContacts,
        smsContacts: smsContacts,
        registered: true,
      ),
    );
  }
}

class _FakeRequest2fa extends Fake implements Request2fa {
  _FakeRequest2fa({this.fail = false});

  final bool fail;
  final requested = <String>[];

  @override
  Future<Try<bool>> call(Tequest2faParam? params) async {
    requested.add(params!.id);
    if (fail) return Rejection(UnknownFailure('request'));
    return Success(true);
  }
}

class _FakeAuthenticationStore extends Fake implements AuthenticationStore {
  bool loggedOut = false;

  @override
  Future<void> logout() async => loggedOut = true;
}

class _FakeSessionBloc extends Fake implements SessionBloc {
  bool loggedOut = false;
  Me? updatedMe;

  @override
  Session? get getSession => testSession();

  @override
  void logout({Failure? error, bool? restartApp}) => loggedOut = true;

  @override
  void updateMe(Me? me) => updatedMe = me;
}

class _FakeInactivityCubit extends Fake implements InactivityCubit {
  bool cancelled = false;

  @override
  void cancel() => cancelled = true;
}

late _FakeAuthenticationStore _authStore;
late _FakeSessionBloc _sessionBloc;
late _FakeInactivityCubit _inactivityCubit;
late AuthenticationBloc _authenticationBloc;

Future<void> _installContainer() async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  _inactivityCubit = _FakeInactivityCubit();
  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<InactivityCubit>(_inactivityCubit);
}

MeBloc _bloc({
  _FakeGetMe? getMe,
  _FakeSaveMe? saveMe,
  _FakeUpdatePassword? updatePassword,
  _FakeLogMeOut? logMeOut,
  _FakeDeleteAccount? deleteAccount,
  _FakeDisableFcm? disableFcm,
  _FakeGetDados2fa? getDados2fa,
  _FakeRequest2fa? request2fa,
}) {
  _authStore = _FakeAuthenticationStore();
  _sessionBloc = _FakeSessionBloc();
  _authenticationBloc = AuthenticationBloc();

  final bloc = MeBloc(
    getMe: getMe ?? _FakeGetMe(remote: testMe()),
    saveMe: saveMe ?? _FakeSaveMe(),
    sessionBloc: _sessionBloc,
    authenticationStore: _authStore,
    getDados2faUseCase: getDados2fa ?? _FakeGetDados2fa(),
    request2faUseCase: request2fa ?? _FakeRequest2fa(),
    uploadProfilePicture: _FakeUploadPicture(),
    updatePasswordMe: updatePassword ?? _FakeUpdatePassword(),
    authenticationBloc: _authenticationBloc,
    logMeOut: logMeOut ?? _FakeLogMeOut(),
    deleteUser: deleteAccount ?? _FakeDeleteAccount(),
    baseUrl: 'http://localhost',
    disableFcm: disableFcm ?? _FakeDisableFcm(),
  );
  addTearDown(() async {
    await bloc.close();
    await _authenticationBloc.close();
  });
  return bloc;
}

Future<MeState> _waitFor(MeBloc bloc, bool Function(MeState) test) =>
    bloc.stream.firstWhere(test);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    FlavorConfig.init();
    // O pedido de código usa a assinatura do app (canal do sms_autofill).
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('sms_autofill'),
      (call) async => 'assinatura',
    );
    await _installContainer();
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('sms_autofill'),
      null,
    );
    await resetTestApplicationContainer();
  });

  group('MeBloc carregamento', () {
    test('carrega o perfil remoto ao iniciar', () async {
      final getMe = _FakeGetMe(remote: testMe());
      final bloc = _bloc(getMe: getMe);

      final loaded = await _waitFor(bloc, (s) => s is MeLoadedState);

      expect(loaded.me?.name, 'ana silva');
      expect(getMe.origins, contains(DataOrigin.remote));
      expect(_sessionBloc.updatedMe?.name, 'ana silva');
    });

    test('usa o cache local antes do remoto', () async {
      final cached = testMe()..name = 'ana cache';
      final bloc = _bloc(
        getMe: _FakeGetMe(local: cached, remote: testMe()),
      );

      final fromCache = await _waitFor(bloc, (s) => s is MeLoadedCacheState);

      expect(fromCache.me?.name, 'ana cache');
    });

    test('falha remota sem cache emite estado de erro', () async {
      final bloc = _bloc(getMe: _FakeGetMe(failRemote: true));

      final failed = await _waitFor(bloc, (s) => s is MeLoadFailedState);

      expect(failed, isA<MeLoadFailedState>());
    });
  });

  group('MeBloc edição', () {
    test('beginEdit entra em modo de edição', () async {
      final bloc = _bloc();
      await _waitFor(bloc, (s) => s is MeLoadedState);

      bloc.beginEdit();

      expect(await _waitFor(bloc, (s) => s is MeEditState), isA<MeEditState>());
    });

    test('revertEdit volta para o perfil carregado', () async {
      final bloc = _bloc();
      await _waitFor(bloc, (s) => s is MeLoadedState);
      bloc.beginEdit();
      await _waitFor(bloc, (s) => s is MeEditState);

      bloc.revertEdit();

      final reverted = await _waitFor(
        bloc,
        (s) => s is MeLoadedState && s is! MeEditState,
      );
      expect(reverted, isA<MeLoadedState>());
    });

    test('telefone alterado exige validação por código', () async {
      final bloc = _bloc();
      await _waitFor(bloc, (s) => s is MeLoadedState);
      bloc.beginEdit();
      final editState = await _waitFor(bloc, (s) => s is MeEditState);
      editState.me!.phone = '(11)90000-0000';

      bloc.beginSave();

      final changed = await _waitFor(bloc, (s) => s is MeEditPhoneChangedState)
          as MeEditPhoneChangedState;
      expect(changed.isPhone, isTrue);
    });

    test('email alterado exige validação por código', () async {
      final bloc = _bloc();
      await _waitFor(bloc, (s) => s is MeLoadedState);
      bloc.beginEdit();
      final editState = await _waitFor(bloc, (s) => s is MeEditState);
      editState.me!.email = 'outro@lello.com';

      bloc.beginSave();

      final changed = await _waitFor(bloc, (s) => s is MeEditPhoneChangedState)
          as MeEditPhoneChangedState;
      expect(changed.isEmail, isTrue);
    });
  });

  group('MeBloc senha', () {
    test('troca de senha bem-sucedida', () async {
      final updatePassword = _FakeUpdatePassword();
      final bloc = _bloc(updatePassword: updatePassword);
      await _waitFor(bloc, (s) => s is MeLoadedState);

      bloc.beginEditSavePassword('Nova@1234', 'Senha@123');

      await _waitFor(bloc, (s) => s is MeEditSucceededState);
      expect(updatePassword.received?.password, 'Nova@1234');
      expect(updatePassword.received?.originPassword, 'Senha@123');
    });

    test('troca de senha com falha emite o erro', () async {
      final bloc = _bloc(updatePassword: _FakeUpdatePassword(fail: true));
      await _waitFor(bloc, (s) => s is MeLoadedState);

      bloc.beginEditSavePassword('Nova@1234', 'Senha@123');

      final failed = await _waitFor(bloc, (s) => s is MeEditPasswordFailedState)
          as MeEditPasswordFailedState;
      expect(failed.error, isA<KnownFailure>());
    });
  });

  group('MeBloc sessão', () {
    test('logout encerra sessão, fcm e inatividade', () async {
      final disableFcm = _FakeDisableFcm();
      final logMeOut = _FakeLogMeOut();
      final bloc = _bloc(disableFcm: disableFcm, logMeOut: logMeOut);
      await _waitFor(bloc, (s) => s is MeLoadedState);

      bloc.beginLogOut();

      await _waitFor(bloc, (s) => s is MeUnauthenticatedState);
      expect(disableFcm.called, isTrue);
      expect(logMeOut.called, isTrue);
      expect(_sessionBloc.loggedOut, isTrue);
      expect(_authStore.loggedOut, isTrue);
      expect(_inactivityCubit.cancelled, isTrue);
    });

    test('exclusão de conta bem-sucedida', () async {
      final bloc = _bloc();
      await _waitFor(bloc, (s) => s is MeLoadedState);

      bloc.deleteAccount(testMe());

      expect(
        await _waitFor(bloc, (s) => s is MeDeleteAccountSuccessState),
        isA<MeDeleteAccountSuccessState>(),
      );
    });

    test('exclusão de conta com falha', () async {
      final bloc = _bloc(deleteAccount: _FakeDeleteAccount(fail: true));
      await _waitFor(bloc, (s) => s is MeLoadedState);

      bloc.deleteAccount(testMe());

      expect(
        await _waitFor(bloc, (s) => s is MeDeleteAccountFailedState),
        isA<MeDeleteAccountFailedState>(),
      );
    });
  });

  group('MeBloc atalhos de evento', () {
    test('beginLoad recarrega o perfil', () async {
      final getMe = _FakeGetMe(remote: testMe());
      final bloc = _bloc(getMe: getMe);
      await _waitFor(bloc, (s) => s is MeLoadedState);
      final antes = getMe.origins.length;

      bloc.beginLoad(true);
      await _waitFor(bloc, (s) => s is MeLoadedState);

      expect(getMe.origins.length, greaterThan(antes));
    });

    test('beginEditPassword abre o formulário de senha', () async {
      final bloc = _bloc();
      await _waitFor(bloc, (s) => s is MeLoadedState);

      bloc.beginEditPassword();

      final state = await _waitFor(bloc, (s) => s is MeEditPasswordState);
      expect(state, isA<MeEditPasswordState>());
      expect(state.me?.name, 'ana silva');
    });

    test('escolher foto da galeria sem seleção não muda o estado', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/image_picker'),
        (call) async => null,
      );
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/image_picker'),
          null,
        );
      });

      final bloc = _bloc();
      await _waitFor(bloc, (s) => s is MeLoadedState);

      bloc.beginPickImage();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(bloc.state, isA<MeLoadedState>());
    });
  });

  group('MeBloc validação por código', () {
    test('pede o código por SMS para o contato do colaborador', () async {
      final request2fa = _FakeRequest2fa();
      final bloc = _bloc(
        getDados2fa: _FakeGetDados2fa(
          smsContacts: [CodeDataContact(key: 'c1', value: '(11)98765-4321')],
        ),
        request2fa: request2fa,
      );
      await _waitFor(bloc, (s) => s is MeLoadedState);

      bloc.beginCodeRequest(isPhoneCheck: true, isEmailCheck: false);

      final state = await _waitFor(bloc, (s) => s is MeEditValidateCodeState)
          as MeEditValidateCodeState;
      expect(state.codeRequest?.value, '(11)98765-4321');
      expect(request2fa.requested, ['c1']);
    });

    test('pede o código por email quando é o canal escolhido', () async {
      final bloc = _bloc(
        getDados2fa: _FakeGetDados2fa(
          emailContacts: [CodeDataContact(key: 'e1', value: 'ana@lello.com')],
        ),
      );
      await _waitFor(bloc, (s) => s is MeLoadedState);

      bloc.beginCodeRequest(isPhoneCheck: false, isEmailCheck: true);

      final state = await _waitFor(bloc, (s) => s is MeEditValidateCodeState)
          as MeEditValidateCodeState;
      expect(state.codeRequest?.value, 'ana@lello.com');
    });

    test('com vários telefones escolhe o que bate com o cadastro', () async {
      final bloc = _bloc(
        getMe: _FakeGetMe(remote: testMe(phone: '(11) 98765-4321')),
        getDados2fa: _FakeGetDados2fa(
          smsContacts: [
            CodeDataContact(key: 'c1', value: '(11)91111-2222'),
            CodeDataContact(key: 'c2', value: '11987654321'),
          ],
        ),
      );
      await _waitFor(bloc, (s) => s is MeLoadedState);

      bloc.beginCodeRequest(isPhoneCheck: true, isEmailCheck: false);

      final state = await _waitFor(bloc, (s) => s is MeEditValidateCodeState)
          as MeEditValidateCodeState;
      expect(state.codeRequest?.id, 'c2');
    });

    test('sem correspondência exata usa os quatro últimos dígitos', () async {
      final bloc = _bloc(
        getMe: _FakeGetMe(remote: testMe(phone: '+55 (11) 98765-4321')),
        getDados2fa: _FakeGetDados2fa(
          smsContacts: [
            CodeDataContact(key: 'c1', value: '(11)91111-2222'),
            CodeDataContact(key: 'c2', value: '(11)90000-4321'),
          ],
        ),
      );
      await _waitFor(bloc, (s) => s is MeLoadedState);

      bloc.beginCodeRequest(isPhoneCheck: true, isEmailCheck: false);

      final state = await _waitFor(bloc, (s) => s is MeEditValidateCodeState)
          as MeEditValidateCodeState;
      expect(state.codeRequest?.id, 'c2');
    });

    test('sem nenhuma correspondência usa o primeiro telefone', () async {
      final bloc = _bloc(
        getMe: _FakeGetMe(remote: testMe(phone: '(11) 90000-0000')),
        getDados2fa: _FakeGetDados2fa(
          smsContacts: [
            CodeDataContact(key: 'c1', value: '(11)91111-2222'),
            CodeDataContact(key: 'c2', value: '(11)93333-4444'),
          ],
        ),
      );
      await _waitFor(bloc, (s) => s is MeLoadedState);

      bloc.beginCodeRequest(isPhoneCheck: true, isEmailCheck: false);

      final state = await _waitFor(bloc, (s) => s is MeEditValidateCodeState)
          as MeEditValidateCodeState;
      expect(state.codeRequest?.id, 'c1');
    });

    test('com vários e-mails ignora maiúsculas e espaços', () async {
      final bloc = _bloc(
        getMe: _FakeGetMe(remote: testMe(email: '  Ana@Lello.com ')),
        getDados2fa: _FakeGetDados2fa(
          emailContacts: [
            CodeDataContact(key: 'e1', value: 'outro@lello.com'),
            CodeDataContact(key: 'e2', value: 'ana@lello.com'),
          ],
        ),
      );
      await _waitFor(bloc, (s) => s is MeLoadedState);

      bloc.beginCodeRequest(isPhoneCheck: false, isEmailCheck: true);

      final state = await _waitFor(bloc, (s) => s is MeEditValidateCodeState)
          as MeEditValidateCodeState;
      expect(state.codeRequest?.id, 'e2');
    });

    test('sem contato cadastrado avisa o colaborador', () async {
      final bloc = _bloc(getDados2fa: _FakeGetDados2fa());
      await _waitFor(bloc, (s) => s is MeLoadedState);

      bloc.beginCodeRequest(isPhoneCheck: true, isEmailCheck: false);

      expect(
        await _waitFor(bloc, (s) => s is MeEditNoContactAvailableState),
        isA<MeEditNoContactAvailableState>(),
      );
    });

    test('falha ao buscar os contatos emite erro', () async {
      final bloc = _bloc(getDados2fa: _FakeGetDados2fa(fail: true));
      await _waitFor(bloc, (s) => s is MeLoadedState);

      bloc.beginCodeRequest(isPhoneCheck: true, isEmailCheck: false);

      expect(
        await _waitFor(bloc, (s) => s is MeEditRequestCodeFailedState),
        isA<MeEditRequestCodeFailedState>(),
      );
    });

    test('falha ao solicitar o envio do código emite erro', () async {
      final bloc = _bloc(
        getDados2fa: _FakeGetDados2fa(
          smsContacts: [CodeDataContact(key: 'c1', value: '(11)98765-4321')],
        ),
        request2fa: _FakeRequest2fa(fail: true),
      );
      await _waitFor(bloc, (s) => s is MeLoadedState);

      bloc.beginCodeRequest(isPhoneCheck: true, isEmailCheck: false);

      expect(
        await _waitFor(bloc, (s) => s is MeEditRequestCodeFailedState),
        isA<MeEditRequestCodeFailedState>(),
      );
    });

    test('reenviar o token repete o pedido', () async {
      final request2fa = _FakeRequest2fa();
      final bloc = _bloc(
        getDados2fa: _FakeGetDados2fa(
          smsContacts: [CodeDataContact(key: 'c1', value: '(11)98765-4321')],
        ),
        request2fa: request2fa,
      );
      await _waitFor(bloc, (s) => s is MeLoadedState);
      bloc.beginEdit();
      await _waitFor(bloc, (s) => s is MeEditState);

      bloc.resendToken();

      await _waitFor(bloc, (s) => s is MeEditValidateCodeState);
      expect(request2fa.requested, isNotEmpty);
    });
  });

  group('MeBloc salvamento do perfil', () {
    test('sem alteração de contato o perfil é salvo direto', () async {
      final saveMe = _FakeSaveMe();
      final bloc = _bloc(saveMe: saveMe);
      await _waitFor(bloc, (s) => s is MeLoadedState);
      bloc.beginEdit();
      await _waitFor(bloc, (s) => s is MeEditState);

      bloc.beginSave();

      final saved = await _waitFor(bloc, (s) => s is MeEditSucceededState);
      expect(saved, isA<MeEditSucceededState>());
      expect(saveMe.saved, hasLength(1));
      expect(_sessionBloc.updatedMe, isNotNull);
    });

    test('falha ao salvar mantém a edição com o erro', () async {
      final bloc = _bloc(saveMe: _FakeSaveMe(fail: true));
      await _waitFor(bloc, (s) => s is MeLoadedState);
      bloc.beginEdit();
      await _waitFor(bloc, (s) => s is MeEditState);

      bloc.beginSave();

      expect(
        await _waitFor(bloc, (s) => s is MeEditFailedState),
        isA<MeEditFailedState>(),
      );
    });
  });
}
