import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/me/domain/use_case/get_me/get_me.dart';
import 'package:morar/feature/me/domain/use_case/log_me_out/log_me_out.dart';
import 'package:morar/feature/me/domain/use_case/save_me/save_me.dart';
import 'package:morar/feature/me/domain/use_case/update_password_me/update_password_me.dart';
import 'package:morar/feature/me/domain/use_case/upload_profile_picture/upload_registration_picture.dart';
import 'package:morar/feature/me/presentation/bloc/me_bloc.dart';
import 'package:morar/feature/me/presentation/bloc/me_event.dart';
import 'package:morar/feature/me/presentation/bloc/me_state.dart';
import 'package:morar/feature/me/presentation/controllers/me_controller.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/test_application_container.dart';

class _FakeGetMe extends Fake implements GetMe {
  Me? local;
  Try<Me?>? remote;
  final origins = <DataOrigin>[];

  @override
  Future<Try<Me?>> call(DataOrigin origin) async {
    origins.add(origin);
    if (origin == DataOrigin.local) return Success(local);
    return remote ?? Rejection(UnknownFailure('remote'));
  }
}

class _FakeSaveMe extends Fake implements SaveMe {
  _FakeSaveMe({this.fail = false});
  final bool fail;
  SaveMeParam? params;
  @override
  Future<Try<Me?>> call(SaveMeParam p) async {
    params = p;
    if (fail) return Rejection(UnknownFailure('save'));
    return Success(p.me);
  }
}

class _FakeUpdatePassword extends Fake implements UpdatePasswordMe {
  _FakeUpdatePassword({this.fail = false});
  final bool fail;
  UpdatePasswordMeParam? params;
  @override
  Future<Try> call(UpdatePasswordMeParam p) async {
    params = p;
    if (fail) return Rejection(UnknownFailure('pwd'));
    return Success(null);
  }
}

class _FakeUpload extends Fake implements UploadProfilePicture {}

class _FakeGetDados2fa extends Fake implements GetDados2fa {
  _FakeGetDados2fa({this.fail = false, this.sms = const [], this.emails = const []});
  final bool fail;
  final List<CodeDataContact> sms;
  final List<CodeDataContact> emails;
  @override
  Future<Try<CodeData>> call(CodeDataParam params) async {
    if (fail) return Rejection(UnknownFailure('2fa'));
    return Success(CodeData(emailContacts: emails, smsContacts: sms, registered: true));
  }
}

class _FakeRequest2fa extends Fake implements Request2fa {
  _FakeRequest2fa({this.fail = false});
  final bool fail;
  Tequest2faParam? params;
  @override
  Future<Try<bool>> call(Tequest2faParam p) async {
    params = p;
    if (fail) return Rejection(UnknownFailure('req'));
    return Success(true);
  }
}

class _FakeAuthStore extends Fake implements AuthenticationStore {
  int logouts = 0;
  @override
  Future<void> logout() async => logouts++;
}

class _FakeLogMeOut extends Fake implements LogMeOut {
  @override
  Future<Try<Nothing>> call() async => Success(Nothing());
}

class _FakeDeleteAccount extends Fake implements DeleteAccount {
  _FakeDeleteAccount({this.fail = false});
  final bool fail;
  @override
  Future<Try<String?>> call() async =>
      fail ? Rejection(UnknownFailure('del')) : Success('ok');
}

class _FakeDisableFcm extends Fake implements DisableFcm {
  int calls = 0;
  @override
  Future<Try<bool>> call() async {
    calls++;
    return Success(true);
  }
}

void main() {
  late MeBloc bloc;
  late FakeSessionBloc sessionBloc;
  late _FakeGetMe getMe;
  late _FakeSaveMe saveMe;
  late _FakeUpdatePassword updatePassword;
  late _FakeAuthStore authStore;
  late _FakeDisableFcm disableFcm;
  late _FakeDeleteAccount deleteAccount;
  late _FakeGetDados2fa dados2fa;
  late _FakeRequest2fa request2fa;

  setUpAll(() async {
    await setUpFakeFirebase();
    FlavorConfig.init();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('sms_autofill'),
      (call) async => call.method == 'getAppSignature' ? 'sig-123' : null,
    );
  });

  setUp(() {
    bloc = MeBloc();
    sessionBloc = FakeSessionBloc();
    getMe = _FakeGetMe();
    saveMe = _FakeSaveMe();
    updatePassword = _FakeUpdatePassword();
    authStore = _FakeAuthStore();
    disableFcm = _FakeDisableFcm();
    deleteAccount = _FakeDeleteAccount();
    dados2fa = _FakeGetDados2fa();
    request2fa = _FakeRequest2fa();
  });

  tearDown(() => bloc.close());

  MeController build() => MeController(
        bloc: bloc,
        getMe: getMe,
        saveMe: saveMe,
        sessionBloc: sessionBloc,
        getDados2faUseCase: dados2fa,
        request2faUseCase: request2fa,
        uploadProfilePicture: _FakeUpload(),
        updatePasswordMe: updatePassword,
        authenticationBloc: AuthenticationBloc(),
        authStore: authStore,
        logMeOut: _FakeLogMeOut(),
        deleteAccountUser: deleteAccount,
        disableFcm: disableFcm,
        baseUrl: 'http://x',
      );

  Future<List<MeState>> collect(Future<void> Function() run) async {
    final states = <MeState>[];
    final sub = bloc.stream.listen(states.add);
    await run();
    await Future<void>.delayed(const Duration(milliseconds: 20));
    await sub.cancel();
    return states;
  }

  group('meLoad', () {
    test('cache recente não consulta o remoto', () async {
      getMe.local = testMe(name: 'cache', lastUpdatedAt: DateTime.now());
      final controller = build();
      final states = await collect(controller.meLoad);
      expect(states.map((s) => s.runtimeType), [MeLoadingState, MeLoadedCacheState]);
      expect(getMe.origins, [DataOrigin.local]);
      expect(controller.originalMe!.name, 'cache');
    });

    test('cache antigo atualiza pelo remoto', () async {
      getMe.local = testMe(name: 'cache', lastUpdatedAt: DateTime(2020));
      getMe.remote = Success(testMe(name: 'remoto'));
      final controller = build();
      final states = await collect(controller.meLoad);
      expect(states.last, isA<MeLoadedState>());
      expect(states.last.me.name, 'remoto');
      expect(sessionBloc.updatedMes.single!.name, 'remoto');
      expect(controller.originalMe!.name, 'remoto');
    });

    test('cache antigo com remoto falhando mantém o cache', () async {
      getMe.local = testMe(name: 'cache', lastUpdatedAt: DateTime(2020));
      final states = await collect(build().meLoad);
      expect(states.last, isA<MeLoadedCacheState>());
      expect(states.last.me.name, 'cache');
    });

    test('sem cache e remoto falhando', () async {
      final states = await collect(build().meLoad);
      expect(states.last, isA<MeLoadFailedState>());
    });

    test('forceUpdate ignora o cache e aceita remoto nulo', () async {
      getMe.local = testMe(name: 'cache', lastUpdatedAt: DateTime.now());
      getMe.remote = Success(null);
      final states = await collect(() => build().meLoad(forceUpdate: true));
      expect(getMe.origins, [DataOrigin.remote]);
      expect(states.last, isA<MeLoadedState>());
      expect(states.last.me.name, '');
    });
  });

  test('beginEdit clona o usuário e loga analytics', () async {
    fakeAnalytics.reset();
    bloc.add(MeLoadedEvent(testMe()));
    await Future<void>.delayed(Duration.zero);
    final states = await collect(build().beginEdit);
    expect(states.map((s) => s.runtimeType), [MeEditLoadingState, MeEditState]);
    expect(identical(states.last.me, bloc.state.me), isTrue);
    expect(fakeAnalytics.eventNames, contains('edicao_cadastro_acessar'));
  });

  test('senha: edição, sucesso e falha', () async {
    bloc.add(MeLoadedEvent(testMe()));
    await Future<void>.delayed(Duration.zero);
    var states = await collect(build().beginEditPassword);
    expect(states.single, isA<MeEditPasswordState>());

    fakeAnalytics.reset();
    states = await collect(() => build().beginEditSavePassword('old', 'new'));
    expect(states.map((s) => s.runtimeType), [MeEditPasswordLoadingState, MeEditSucceededState]);
    expect(updatePassword.params!.cpf, '12345678901');
    expect(fakeAnalytics.eventNames, contains('redefinir_senha'));

    updatePassword = _FakeUpdatePassword(fail: true);
    states = await collect(() => build().beginEditSavePassword('old', 'new'));
    expect(states.last, isA<MeEditPasswordFailedState>());
  });

  test('revertEdit volta para o usuário original', () async {
    final controller = build();
    var states = await collect(() async => controller.revertEdit());
    expect(states, isEmpty);
    controller.originalMe = testMe(name: 'orig');
    states = await collect(() async => controller.revertEdit());
    expect(states.single, isA<MeLoadedState>());
    expect(states.single.me.name, 'orig');
  });

  group('mapSave', () {
    Future<MeController> editing(Me original, Me edited) async {
      final controller = build()..originalMe = original;
      bloc.add(MeEditLoadedEvent(me: edited));
      await Future<void>.delayed(Duration.zero);
      return controller;
    }

    test('telefone alterado pede validação', () async {
      final controller = await editing(testMe(phone: '11999990000'), testMe(phone: '(11) 98888-0000'));
      final states = await collect(controller.mapSave);
      expect(states.single, isA<MeEditPhoneChangedState>());
      expect(saveMe.params, isNull);
    });

    test('email alterado pede validação', () async {
      final controller = await editing(testMe(email: 'a@a'), testMe(email: 'b@b'));
      final states = await collect(controller.mapSave);
      expect(states.single, isA<MeEditEmailChangedState>());
    });

    test('sem alterações salva e atualiza a sessão', () async {
      fakeAnalytics.reset();
      final controller = await editing(testMe(), testMe(name: 'novo'));
      final states = await collect(controller.mapSave);
      expect(states.map((s) => s.runtimeType), [MeEditLoadingState, MeEditSucceededState]);
      expect(saveMe.params!.me!.name, 'novo');
      expect(sessionBloc.updatedMes.single!.name, 'novo');
      expect(controller.originalMe!.name, 'novo');
      expect(fakeAnalytics.eventNames, contains('edicao_cadastro_tela_de_sucesso'));
    });

    test('falha ao salvar', () async {
      saveMe = _FakeSaveMe(fail: true);
      final controller = await editing(testMe(), testMe());
      final states = await collect(controller.mapSave);
      expect(states.last, isA<MeEditFailedState>());
    });

    test('após upload de foto salva direto', () async {
      final controller = build()..originalMe = testMe();
      bloc.add(MeUploadProfileSucceededEvent(testMe()));
      await Future<void>.delayed(Duration.zero);
      final states = await collect(controller.mapSave);
      expect(states.last, isA<MeEditSucceededState>());
    });

    test('sem estado de edição nada acontece', () async {
      final controller = build()..originalMe = testMe();
      final states = await collect(controller.mapSave);
      expect(states, isEmpty);
    });
  });

  group('validationCode', () {
    test('escolhe o contato do telefone atual e pede o código', () async {
      dados2fa = _FakeGetDados2fa(sms: [
        CodeDataContact(key: 'k1', value: '(11) 90000-0000'),
        CodeDataContact(key: 'k2', value: '(11) 99999-8888'),
      ]);
      bloc.add(MeLoadedEvent(testMe(phone: '11999998888')));
      await Future<void>.delayed(Duration.zero);
      final states = await collect(() => build().validationCode(isPhoneCheck: true, isEmailCheck: false));
      expect(states.map((s) => s.runtimeType), [MeEditRequestingCodeState, MeEditValidateCodeState]);
      final request = (states.last as MeEditValidateCodeState).codeRequest!;
      expect(request.id, 'k2');
      expect(request.source, CodeValidationSource.phone);
      expect(request.cpf, '12345678901');
      expect(request2fa.params!.appSignature, 'sig-123');
    });

    test('usa o sufixo do telefone ou o primeiro contato', () async {
      dados2fa = _FakeGetDados2fa(sms: [
        CodeDataContact(key: 'k1', value: '***-0000'),
        CodeDataContact(key: 'k2', value: '***-8888'),
      ]);
      bloc.add(MeLoadedEvent(testMe(phone: '11999998888')));
      await Future<void>.delayed(Duration.zero);
      var states = await collect(() => build().validationCode(isPhoneCheck: true, isEmailCheck: false));
      expect((states.last as MeEditValidateCodeState).codeRequest!.id, 'k2');

      dados2fa = _FakeGetDados2fa(sms: [
        CodeDataContact(key: 'k1', value: '111'),
        CodeDataContact(key: 'k2', value: '222'),
      ]);
      states = await collect(() => build().validationCode(isPhoneCheck: true, isEmailCheck: false));
      expect((states.last as MeEditValidateCodeState).codeRequest!.id, 'k1');
    });

    test('email com um único contato', () async {
      dados2fa = _FakeGetDados2fa(emails: [CodeDataContact(key: 'e1', value: 'ANA@lello.com')]);
      bloc.add(MeLoadedEvent(testMe()));
      await Future<void>.delayed(Duration.zero);
      final states = await collect(() => build().validationCode(isPhoneCheck: false, isEmailCheck: true));
      final request = (states.last as MeEditValidateCodeState).codeRequest!;
      expect(request.source, CodeValidationSource.email);
      expect(request.value, 'ANA@lello.com');
    });

    test('email escolhe o contato igual ao atual', () async {
      dados2fa = _FakeGetDados2fa(emails: [
        CodeDataContact(key: 'e1', value: 'outro@x'),
        CodeDataContact(key: 'e2', value: ' Ana@Lello.com '),
      ]);
      bloc.add(MeLoadedEvent(testMe()));
      await Future<void>.delayed(Duration.zero);
      final states = await collect(() => build().validationCode(isPhoneCheck: false, isEmailCheck: true));
      expect((states.last as MeEditValidateCodeState).codeRequest!.id, 'e2');
    });

    test('sem contatos, falha nos dados e falha no envio', () async {
      bloc.add(MeLoadedEvent(testMe()));
      await Future<void>.delayed(Duration.zero);
      var states = await collect(() => build().validationCode(isPhoneCheck: true, isEmailCheck: false));
      expect(states.last, isA<MeEditNoContactAvailableState>());

      dados2fa = _FakeGetDados2fa(fail: true);
      states = await collect(() => build().validationCode(isPhoneCheck: true, isEmailCheck: false));
      expect(states.last, isA<MeEditRequestCodeFailedState>());

      dados2fa = _FakeGetDados2fa(sms: [CodeDataContact(key: 'k', value: '1')]);
      request2fa = _FakeRequest2fa(fail: true);
      states = await collect(() => build().validationCode(isPhoneCheck: true, isEmailCheck: false));
      expect(states.last, isA<MeEditRequestCodeFailedState>());
    });

    test('resendToken reenvia quando está editando', () async {
      dados2fa = _FakeGetDados2fa(sms: [CodeDataContact(key: 'k', value: '1')]);
      final controller = build()..originalMe = testMe();
      var states = await collect(controller.resendToken);
      expect(states, isEmpty);
      bloc.add(MeEditLoadedEvent(me: testMe()));
      await Future<void>.delayed(Duration.zero);
      states = await collect(controller.resendToken);
      expect(states.first, isA<MeEditPhoneChangedState>());
      expect(states.last, isA<MeEditValidateCodeState>());
    });
  });

  test('logOutEvent desliga o fcm e encerra a sessão', () async {
    final states = await collect(build().logOutEvent);
    expect(states.map((s) => s.runtimeType), [MeLoadingState, MeUnauthenticatedState]);
    expect(disableFcm.calls, 1);
    expect(sessionBloc.logoutCalls, hasLength(1));
    expect(authStore.logouts, 1);
  });

  test('deleteMe', () async {
    var states = await collect(() => build().deleteMe(testMe()));
    expect(states.map((s) => s.runtimeType), [MeEditLoadingState, MeDeleteAccountSuccessState]);
    deleteAccount = _FakeDeleteAccount(fail: true);
    states = await collect(() => build().deleteMe(testMe()));
    expect(states.last, isA<MeDeleteAccountFailedState>());
    expect(disableFcm.calls, 2);
  });

  test('setRequiredFields', () {
    final controller = build()..setRequiredFields(phone: true, email: false);
    expect(controller.phoneRequired, isTrue);
    expect(controller.emailRequired, isFalse);
    expect(TestEnvironment().name, 'test');
  });
}
