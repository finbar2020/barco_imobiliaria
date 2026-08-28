import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/registration/presentation/store/registration_store.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/pump_app.dart';
import '../code_validation/code_validation_support.dart';
import 'registration_support.dart';

void main() {
  late RegistrationHarness harness;
  late RegistrationStore store;
  late List<RegistrationState> states;

  setUp(() async {
    harness = await installRegistrationHarness();
    store = harness.buildStore();
    states = [];
    store.bloc.stream.listen(states.add);
  });

  Future<void> settle() async {
    for (var i = 0; i < 4; i++) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  group('passos', () {
    test('nextStep avança até a foto e para', () {
      expect(store.currentStep, RegistrationStep.cpf);
      store.nextStep();
      expect(store.currentStep, RegistrationStep.me);
      store.nextStep();
      expect(store.currentStep, RegistrationStep.password);
      store.nextStep();
      expect(store.currentStep, RegistrationStep.picture);
      store.nextStep();
      expect(store.currentStep, RegistrationStep.picture);
    });

    test('previousStep no cpf limpa a store e devolve true', () async {
      store
        ..cpf = cpfValido
        ..phone = '1'
        ..email = 'e'
        ..source = CodeValidationSource.email
        ..registeredError = true
        ..emailOrPhoneSelected = CodeDataContact(key: 'k', value: 'v');
      expect(store.previousStep(), isTrue);
      await settle();
      expect(store.cpf, isNull);
      expect(store.phone, isNull);
      expect(store.email, isNull);
      expect(store.source, isNull);
      expect(store.registeredError, isNull);
      expect(store.emailOrPhoneSelected, isNull);
      expect(store.currentStep, RegistrationStep.cpf);
      expect(states, [const RegistrationEmptyState()]);
    });

    testWidgets('previousStep volta uma página e devolve false', (tester) async {
      await pumpApp(
        tester,
        SizedBox(
          height: 200,
          child: PageView(
            controller: store.pageController,
            children: const [Text('um'), Text('dois')],
          ),
        ),
      );
      store.nextStep();
      store.pageController.jumpToPage(1);
      await tester.pumpAndSettle();
      expect(find.text('dois'), findsOneWidget);

      expect(store.previousStep(), isFalse);
      await tester.pumpAndSettle();
      expect(store.currentStep, RegistrationStep.cpf);
      expect(find.text('um'), findsOneWidget);
      expect(states, isEmpty);
    });
  });

  group('chooseImage', () {
    test('sem fonte limpa a foto', () async {
      store.profilePicture = harness.writeImage('a.png');
      await store.chooseImage();
      expect(store.profilePicture, isNull);
      expect(harness.picker.sources, isEmpty);
    });

    test('usuário cancela a galeria ou o recorte', () async {
      await store.chooseImage(source: ImageSource.gallery);
      expect(harness.picker.sources, [ImageSource.gallery]);
      expect(harness.cropper.cropped, isEmpty);
      expect(store.profilePicture, isNull);

      harness.picker.path = '/tmp/foto.png';
      await store.chooseImage(source: ImageSource.camera);
      expect(harness.cropper.cropped, ['/tmp/foto.png']);
      expect(store.profilePicture, isNull);
      expect(states, isEmpty);
    });

    test('foto recortada é guardada e o cadastro é enviado', () async {
      harness.mockRegistration();
      harness.picker.path = '/tmp/foto.png';
      harness.cropper.path = harness.writeImage('recorte.png').path;
      store
        ..cpf = cpfValido
        ..password = 'Senha1';
      await store.chooseImage(source: ImageSource.camera);
      await settle();

      expect(store.profilePicture!.path, endsWith('recorte.png'));
      expect(harness.requestedPaths, ['/registration']);
      expect(harness.upload.files.single!.path, endsWith('recorte.png'));
      expect(states.last, const RegistrationSucceededState());
    });
  });

  group('requestMyUser', () {
    test('sem cpf não faz nada', () async {
      await store.requestMyUser();
      expect(states, isEmpty);
      expect(harness.http.requests, isEmpty);
    });

    test('erro da API vira falha de busca', () async {
      harness.mockDados2fa(status: 500, body: apiFailureBody());
      store.cpf = cpfValido;
      await store.requestMyUser();
      await settle();

      expect(states.first,
          const RegistrationRequestMyUserLoadingState(loadingMessage: 'registration_lello_user_searching'));
      final failed = states.last as RegistrationRequestMyUserFailedState;
      expect(failed.error, isA<UnknownFailure>());
      expect(store.registeredError, isFalse);
      final url = harness.http.requests.single.url;
      expect(url.path, '/code_request/2fa/$cpfDigitos');
      expect(url.queryParameters['idEmpresa'], '1');
    });

    test('usuário já cadastrado', () async {
      harness.mockDados2fa(registered: true, sms: [contact('s', '1')]);
      store.cpf = cpfValido;
      await store.requestMyUser();
      await settle();
      expect((states.last as RegistrationRequestMyUserFailedState).error,
          isA<RegistrationUserAlreadyRegisteredFailure>());
      expect(store.registeredError, isTrue);
    });

    test('usuário sem e-mail nem telefone', () async {
      harness.mockDados2fa();
      store.cpf = cpfValido;
      await store.requestMyUser();
      await settle();
      expect((states.last as RegistrationRequestMyUserFailedState).error,
          isA<RegistrationPhoneAndEmailFoundFailure>());
    });

    test('sucesso emite os contatos e usa o idEmpresa da store', () async {
      harness.idEmpresa = 9;
      store = harness.buildStore();
      states = [];
      store.bloc.stream.listen(states.add);
      harness.mockDados2fa(
          emails: [contact('e1', 'a@b.com')], sms: [contact('s1', '119')]);
      store.cpf = cpfValido;
      await store.requestMyUser();
      await settle();

      final ok = states.last as RegistrationRequestMyUserSucceededState;
      expect(ok.codeData.emailContacts.single.key, 'e1');
      expect(ok.codeData.smsContacts.single.key, 's1');
      expect(ok.selectedValue, '');
      expect(ok.type, isNull);
      expect(store.name, '');
      expect(harness.http.requests.single.url.queryParameters['idEmpresa'], '9');
    });
  });

  group('requestCode', () {
    test('sem contato selecionado ou sem valores não faz nada', () async {
      store
        ..phone = ''
        ..email = '';
      await store.requestCode();
      store
        ..phone = '119'
        ..emailOrPhoneSelected = null;
      await store.requestCode();
      expect(states, isEmpty);
      expect(harness.http.requests, isEmpty);
    });

    test('sucesso emite o pedido de código por telefone', () async {
      harness.mockRequest2fa();
      store
        ..cpf = cpfValido
        ..phone = '11988887777'
        ..source = CodeValidationSource.phone
        ..emailOrPhoneSelected = CodeDataContact(key: 'K1', value: '119');
      await store.requestCode();
      await settle();

      expect(states.first,
          const RegistrationCodeRequestLoadingState());
      final ok = states.last as RegistrationCodeRequestSucceededState;
      expect(ok.codeRequest.source, CodeValidationSource.phone);
      expect(ok.codeRequest.origin, CodeValidationOrigin.registration);
      expect(ok.codeRequest.value, '11988887777');
      expect(ok.codeRequest.id, 'K1');
      expect(ok.codeRequest.cpf, cpfDigitos);
      expect(ok.codeRequest.token, '');
      // No flutter_test a plataforma padrão é Android: a assinatura vem do canal.
      expect(ok.codeRequest.appSignature, 'ASSINATURA');
      expect(store.appSignature, 'ASSINATURA');
      final url = harness.http.requests.single.url;
      expect(url.path, '/code_request/2fa/request');
      expect(url.queryParameters['hashToken'], 'K1');
    });

    test('falha emite erro e e-mail é usado como valor', () async {
      harness.mockRequest2fa(status: 500, body: apiFailureBody());
      store
        ..email = 'a@b.com'
        ..source = CodeValidationSource.email
        ..emailOrPhoneSelected = CodeDataContact(key: 'E1', value: 'a@b.com');
      await store.requestCode();
      await settle();
      expect((states.last as RegistrationCodeRequestFailedState).error,
          isA<UnknownFailure>());
    });
  });

  group('register', () {
    test('cadastro rejeitado emite falha', () async {
      store
        ..cpf = cpfValido
        ..password = '';
      await store.register();
      await settle();
      expect(states, [
        const RegistrationLoadingState(),
        isA<RegistrationFailedState>(),
      ]);
      expect((states.last as RegistrationFailedState).error,
          isA<RegistrationMissingRequiredDataFailure>());
      expect(harness.authenticate.calls, isEmpty);
    });

    test('erro da API emite falha', () async {
      harness.mockRegistration(
          status: 409,
          body: apiFailureBody(
              status: 409, failure: 'user_already_registerd_failure'));
      store
        ..cpf = cpfValido
        ..password = 'Senha1';
      await store.register();
      await settle();
      expect((states.last as RegistrationFailedState).error,
          isA<RegistrationUserAlreadyRegisteredFailure>());
    });

    test('falha ao autenticar emite RegistrationAuthFailed', () async {
      harness.mockRegistration();
      harness.authenticate.fail = true;
      store
        ..cpf = cpfValido
        ..password = 'Senha1';
      await store.register();
      await settle();
      // Os dois `RegistrationLoadingEvent` viram o mesmo estado (Equatable),
      // então o bloc só emite um loading.
      expect(states, [
        const RegistrationLoadingState(),
        isA<RegistrationAuthFailedState>(),
      ]);
      expect((states.last as RegistrationAuthFailedState).error,
          isA<RegistrationAuthFailure>());
      expect(harness.session.loads, 0);
    });

    test('sucesso sem foto autentica e carrega a sessão', () async {
      harness.mockRegistration();
      store
        ..cpf = cpfValido
        ..password = 'Senha1'
        ..name = 'Ana'
        ..email = 'a@b.com'
        ..phone = '119'
        ..token = 'tok'
        ..termsAndConditionsCheck = true;
      await store.register();
      await settle();

      expect(states.last, const RegistrationSucceededState());
      expect(harness.session.loads, 1);
      expect(harness.upload.files, isEmpty);
      final credentials = harness.authenticate.calls.single;
      expect(credentials.username, cpfDigitos);
      expect(credentials.password, 'Senha1');
      final body = harness.http.requests.single.body;
      expect(body, contains('"cpf":"$cpfValido"'));
      expect(body, contains('"terms_and_conditions_check":true'));
      expect(harness.http.requests.single.url.queryParameters['idEmpresa'], '1');
    });

    test('sucesso com foto envia a foto (mesmo se o upload falhar)', () async {
      harness.mockRegistration();
      harness.upload.fail = true;
      store
        ..cpf = cpfValido
        ..password = 'Senha1'
        ..profilePicture = harness.writeImage('p.png');
      await store.register();
      await settle();

      expect(states.map((s) => s.runtimeType).toList(), [
        RegistrationLoadingState,
        RegistrationSucceededState,
      ]);
      expect(harness.upload.files.single!.path, endsWith('p.png'));
      expect(harness.session.loads, 1);
    });
  });

  test('dispose limpa os campos e emite vazio', () async {
    store
      ..currentStep = RegistrationStep.picture
      ..registeredError = true
      ..cpf = '1'
      ..source = CodeValidationSource.phone
      ..phone = '2'
      ..email = '3'
      ..emailOrPhoneSelected = CodeDataContact(key: 'k', value: 'v');
    store.dispose();
    await settle();
    expect(store.currentStep, RegistrationStep.cpf);
    expect(store.registeredError, isNull);
    expect(store.cpf, isNull);
    expect(store.source, isNull);
    expect(store.phone, isNull);
    expect(store.email, isNull);
    expect(store.emailOrPhoneSelected, isNull);
    expect(states, [const RegistrationEmptyState()]);
  });
}
