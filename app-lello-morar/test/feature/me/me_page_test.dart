import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/me/presentation/bloc/me_state.dart';
import 'package:morar/feature/me/presentation/pages/me_delete_account_error.dart';
import 'package:morar/feature/me/presentation/pages/me_delete_account_success.dart';
import 'package:morar/feature/me/presentation/pages/me_page.dart';
import 'package:morar/feature/me/presentation/widgets/me_edit.dart';
import 'package:morar/feature/me/presentation/widgets/me_edit_password.dart';
import 'package:morar/feature/me/presentation/widgets/me_edit_phone.dart';
import 'package:morar/feature/me/presentation/widgets/me_last_update_info.dart';
import 'package:morar/feature/me/presentation/widgets/me_page/me_profile_buttons_widget.dart';
import 'package:morar/feature/me/presentation/widgets/me_page/me_profile_info_widget.dart';
import 'package:morar/feature/me/presentation/widgets/me_page/me_profile_picture_widget.dart';
import 'package:morar/feature/me/presentation/widgets/me_page/me_profile_widget.dart';
import 'package:shared_features/shared_features.dart'
    show
        AccessToken,
        AuthenticatedState,
        CodeRequest,
        CodeValidation,
        CodeValidationPage,
        SharedApplicationRoute,
        UnauthenticatedState;

import '../../helpers/fixtures.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'me_page_helpers.dart';

const _launcherKey = Key('launcher-push');

void main() {
  late PageHarness harness;
  late MeFakes fakes;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installPageHarness();
    fakes = await installMeFakes(harness);
    observer = RecordingNavigatorObserver();
  });

  Future<void> pumpMe(
    WidgetTester tester, {
    MePageArgs? args,
    bool isGeneric = false,
    Function(ThemeData)? changeTheme,
    bool pushed = false,
  }) async {
    final page = MePage(isGeneric: isGeneric, changeTheme: changeTheme);
    if (!pushed) {
      await pumpPage(tester, page,
          arguments: args, observer: observer, surface: const Size(500, 1600));
      return;
    }
    await pumpPage(
      tester,
      Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            key: _launcherKey,
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              settings: RouteSettings(name: '/me', arguments: args),
              builder: (_) => page,
            )),
            child: const Text('abrir'),
          ),
        ),
      ),
      observer: observer,
      surface: const Size(500, 1600),
    );
    await tester.tap(find.byKey(_launcherKey));
    await tester.pumpAndSettle();
  }

  Future<void> openEdit(WidgetTester tester) async {
    await tester.tap(find.text('edit'));
    await tester.pumpAndSettle();
    expect(find.byType(MeEdit), findsOneWidget);
  }

  /// O MaskTextInputFormatter descarta o primeiro dígito quando o texto é
  /// substituído de uma vez: limpa o campo antes de digitar o telefone.
  Future<void> enterPhone(WidgetTester tester, String phone) async {
    final field = find.byType(TextFormField).at(3);
    await tester.enterText(field, '');
    await tester.pumpAndSettle();
    await tester.enterText(field, phone);
    await tester.pumpAndSettle();
  }

  /// Frames sem `pumpAndSettle`: a página de código tem um Timer periódico.
  Future<void> pumpFrames(WidgetTester tester, [int n = 3]) async {
    for (var i = 0; i < n; i++) {
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    }
  }

  group('perfil', () {
    testWidgets('carrega o perfil pelo remoto e mostra os dados',
        (tester) async {
      await pumpMe(tester);

      expect(fakes.getMe.origins, [DataOrigin.local, DataOrigin.remote]);
      expect(harness.sessionBloc.updatedMes, hasLength(1));
      expect(find.byType(MeProfileWidget), findsOneWidget);
      expect(find.byType(MeProfilePictureWidget), findsOneWidget);
      expect(find.byType(MeProfileInfoWidget), findsOneWidget);
      expect(find.byType(MeProfileButtonsWidget), findsOneWidget);
      expect(find.byType(MeLastUpdateInfo), findsOneWidget);
      expect(find.text('profile_title'), findsOneWidget);
      expect(find.text('ana silva'), findsOneWidget);
      expect(find.text('me_cpf_title'), findsOneWidget);
      expect(find.text('123.456.789-01'), findsOneWidget);
      expect(find.text('ana@lello.com'), findsOneWidget);
      expect(find.text('11999998888'), findsOneWidget);
      expect(find.text('******'), findsOneWidget);
      expect(find.text('version'), findsOneWidget);
      // Ambiente de teste não é produção: tiles de depuração aparecem.
      expect(find.text('Token Firebase A/B'), findsOneWidget);
      expect(find.text('Token Firebase Push'), findsOneWidget);
      expect(find.text('Firebase Installation ID'), findsOneWidget);
      expect(find.text('Drop Sessao'), findsOneWidget);
      expect(find.text('Refresh Token'), findsNothing);
      expect(find.text('Cores do Tema'), findsNothing);
      expect(find.text('edit'), findsOneWidget);
      expect(find.text('delete_account'), findsOneWidget);
      expect(find.text('logout'), findsOneWidget);
    });

    testWidgets('usa o cache quando ele é recente', (tester) async {
      fakes.getMe.local = testMe(name: 'do cache', lastUpdatedAt: DateTime.now());

      await pumpMe(tester);

      expect(fakes.getMe.origins, [DataOrigin.local]);
      expect(find.text('do cache'), findsOneWidget);
      expect(fakes.controller.bloc.state, isA<MeLoadedCacheState>());
    });

    testWidgets('estado de loading mostra o indicador', (tester) async {
      await pumpMe(tester);

      await emitState(tester, fakes.controller.bloc,
          MeLoadingState(fakes.controller.bloc.state.me),
          settle: false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(MeProfileWidget), findsNothing);
    });

    testWidgets('falha ao carregar mostra o erro; retry recarrega e voltar fecha',
        (tester) async {
      fakes.getMe.remote = Rejection(UnknownFailure('x'));

      await pumpMe(tester, pushed: true);

      expect(fakes.controller.bloc.state, isA<MeLoadFailedState>());
      expect(find.byType(ErrorHandlingWidget), findsOneWidget);
      expect(find.text('logout'), findsOneWidget);

      fakes.getMe.remote = Success(testMe(name: 'carregou'));
      await tester.tap(find.text('error_handling_widget_button_reTry').first);
      await tester.pumpAndSettle();
      expect(find.text('carregou'), findsOneWidget);

      // Uma nova falha só mostra o erro se o usuário do estado for vazio.
      await emitState(tester, fakes.controller.bloc,
          MeLoadFailedState(Me.empty(), UnknownFailure('x')));
      expect(find.byType(ErrorHandlingWidget), findsOneWidget);
      await tester.tap(find.text('error_handling_widget_button_back').first);
      await tester.pumpAndSettle();
      expect(observer.popped, hasLength(1));
      expect(find.byType(MePage), findsNothing);
    });

    testWidgets('logout na tela de erro desliga o fcm e encerra a sessão',
        (tester) async {
      fakes.getMe.remote = Rejection(UnknownFailure('x'));
      await pumpMe(tester);

      await tester.tap(find.text('logout'));
      await tester.pumpAndSettle();

      expect(fakes.disableFcm.calls, 1);
      expect(harness.sessionBloc.logoutCalls, hasLength(1));
      expect(fakes.authStore.logouts, 1);
      expect(fakes.logMeOut.calls, 1);
      expect(fakes.controller.bloc.state, isA<MeUnauthenticatedState>());
    });

    testWidgets('logout no perfil carregado', (tester) async {
      await pumpMe(tester);

      await tester.tap(find.text('logout'));
      await tester.pumpAndSettle();

      expect(fakes.logMeOut.calls, 1);
      expect(fakes.controller.bloc.state, isA<MeUnauthenticatedState>());
    });

    testWidgets('sessão não autenticada navega para o login', (tester) async {
      final themes = <ThemeData>[];
      // O estado inicial já é UnauthenticatedState: autentica antes para a
      // troca de estado ser emitida.
      fakes.authBloc.emit(AuthenticatedState(accessToken: AccessToken()..accessToken = 'a'));
      await pumpMe(tester, isGeneric: true, changeTheme: themes.add);

      await emitState(tester, fakes.authBloc, const UnauthenticatedState());

      expect(observer.pushedNames.last, SharedApplicationRoute.login);
      expect(findRoute(SharedApplicationRoute.login), findsOneWidget);
      // `viverDefaultTheme` é um getter (instância nova a cada acesso).
      expect(themes.single.colorScheme.primary,
          LelloTheme.viverDefaultTheme.colorScheme.primary);
    });

    testWidgets('golden do perfil carregado', (tester) async {
      await pumpMe(tester);
      final controller = fakes.controller;

      // O MeProfileWidget sozinho (sem a data da app bar) é determinístico.
      await tester.pumpWidget(const SizedBox());
      await pumpPage(
        tester,
        Scaffold(
          body: SingleChildScrollView(
            child: BlocProvider.value(
              value: controller.bloc,
              child: const MeProfileWidget(),
            ),
          ),
        ),
        surface: const Size(500, 1500),
      );

      await expectLater(
        find.byType(MeProfileWidget),
        matchesGoldenFile('goldens/me_profile_widget.png'),
      );
    });
  });

  group('edição', () {
    testWidgets('editar abre o formulário e concluir salva o nome',
        (tester) async {
      await pumpMe(tester);
      await openEdit(tester);

      expect(find.text('me_cpf_title'), findsOneWidget);
      expect(find.text('12345678901'), findsOneWidget);
      expect(find.text('full_name'), findsOneWidget);
      expect(find.text('profile_update_email'), findsOneWidget);
      expect(find.text('registration_lello_user_phone_title'), findsOneWidget);
      expect(find.text('me_edit_password_title'), findsOneWidget);
      final fields = find.byType(TextFormField);
      expect(tester.widget<TextFormField>(fields.at(0)).initialValue, 'ana silva');
      expect(tester.widget<TextFormField>(fields.at(1)).initialValue, 'ana@lello.com');
      expect(tester.widget<TextFormField>(fields.at(2)).initialValue, '11');
      expect(tester.widget<TextFormField>(fields.at(3)).initialValue, '999998888');

      await expectLater(
        find.byType(MeEdit),
        matchesGoldenFile('goldens/me_edit.png'),
      );

      await tester.enterText(fields.at(0), 'Novo Nome');
      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();

      expect(fakes.saveMe.params!.me!.name, 'Novo Nome');
      expect(fakes.saveMe.params!.codeValidation, isNull);
      expect(observer.pushedNames.last, ApplicationRoute.meSuccess);
      expect(findRoute(ApplicationRoute.meSuccess), findsOneWidget);
      // Depois de salvar recarrega o perfil pelo remoto.
      expect(fakes.getMe.origins.last, DataOrigin.remote);
      expect(find.byType(MePage, skipOffstage: false), findsOneWidget);
    });

    testWidgets('com backAfterSave a página é substituída pelo sucesso',
        (tester) async {
      await pumpMe(tester, args: MePageArgs(backAfterSave: true));
      await openEdit(tester);

      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, ApplicationRoute.meSuccess);
      expect(find.byType(MePage, skipOffstage: false), findsNothing);
    });

    testWidgets('nome vazio não salva', (tester) async {
      await pumpMe(tester);
      await openEdit(tester);

      await tester.enterText(find.byType(TextFormField).at(0), '');
      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();

      expect(find.text('validation_required'), findsOneWidget);
      expect(fakes.saveMe.calls, isEmpty);
    });

    testWidgets('falha ao salvar mostra a mensagem de erro', (tester) async {
      fakes.saveMe.fail = true;
      await pumpMe(tester);
      await openEdit(tester);

      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();

      expect(fakes.controller.bloc.state, isA<MeEditFailedState>());
      expect(find.text('pendency_load_failed'), findsOneWidget);
    });

    testWidgets('autoEditMode entra direto na edição com os campos obrigatórios',
        (tester) async {
      await pumpMe(
        tester,
        args: MePageArgs(
            autoEditMode: true, phoneRequired: true, emailRequired: false),
      );

      expect(fakes.getMe.origins, [DataOrigin.remote]);
      expect(find.byType(MeEdit), findsOneWidget);
      expect(fakes.controller.phoneRequired, isTrue);
      expect(fakes.controller.emailRequired, isFalse);
    });

    testWidgets('voltar durante a edição reverte para o perfil',
        (tester) async {
      await pumpMe(tester, pushed: true);
      await openEdit(tester);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.byType(MePage), findsOneWidget);
      expect(find.byType(MeEdit), findsNothing);
      expect(find.byType(MeProfileWidget), findsOneWidget);
      expect(observer.popped, isEmpty);

      // Fora da edição o voltar fecha a página.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(observer.popped, hasLength(1));
    });

    testWidgets('voltar com backAfterSave fecha mesmo editando', (tester) async {
      await pumpMe(tester, pushed: true, args: MePageArgs(backAfterSave: true));
      await openEdit(tester);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(observer.popped, hasLength(1));
      expect(find.byType(MePage), findsNothing);
    });

    testWidgets('estado de loading da edição mostra o indicador',
        (tester) async {
      await pumpMe(tester);
      await openEdit(tester);

      await emitState(tester, fakes.controller.bloc,
          MeEditLoadingState(fakes.controller.bloc.state.me),
          settle: false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(MeEdit), findsNothing);
    });

    testWidgets('telefone alterado abre o aviso, pede o código e valida',
        (tester) async {
      await pumpMe(tester);
      await openEdit(tester);

      await enterPhone(tester, '988887777');
      expect(find.text('98888-7777'), findsOneWidget);
      expect(fakes.controller.bloc.state.me.phone, '(11)98888-7777');

      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();

      expect(fakes.controller.bloc.state, isA<MeEditPhoneChangedState>());
      expect(find.byType(MeEditPhoneInfo), findsOneWidget);
      expect(find.text('profile_change_phone_rationale'), findsOneWidget);
      expect(find.text('receive_code'), findsOneWidget);

      await tester.tap(find.text('receive_code'));
      await pumpFrames(tester);

      expect(fakes.controller.bloc.state, isA<MeEditValidateCodeState>());
      expect(fakes.request2fa.calls.single.id, 'k1');
      expect(find.byType(MeEditPhoneInfo), findsNothing);
      expect(find.byType(CodeValidationPage), findsOneWidget);
      final page = tester.widget<CodeValidationPage>(find.byType(CodeValidationPage));
      expect(page.digits, 6);

      // Reenviar volta a pedir o código.
      page.onRestart();
      await pumpFrames(tester);
      expect(fakes.request2fa.calls, hasLength(2));
      expect(find.byType(CodeValidationPage), findsOneWidget);

      // Código validado: salva com a validação e abre o sucesso.
      tester
          .widget<CodeValidationPage>(find.byType(CodeValidationPage))
          .onSuccess(CodeValidation(id: 'k1', code: '1234', token: 'tk'));
      await pumpFrames(tester);

      expect(fakes.saveMe.params!.codeValidation!.token, 'tk');
      expect(fakes.saveMe.params!.me!.phone, '(11)98888-7777');
      expect(observer.pushedNames.last, ApplicationRoute.meSuccess);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('cancelar o aviso de telefone fecha o aviso e mantém a edição',
        (tester) async {
      await pumpMe(tester);
      await openEdit(tester);
      await enterPhone(tester, '988887777');
      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();
      expect(find.byType(MeEditPhoneInfo), findsOneWidget);

      await tester.tap(find.text('cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(MeEditPhoneInfo), findsNothing);
      expect(find.byType(MeEdit), findsOneWidget);
    });

    testWidgets('falha ao buscar os dados do 2fa mostra o erro no aviso',
        (tester) async {
      fakes.dados2fa.fail = true;
      await pumpMe(tester);
      await openEdit(tester);
      await enterPhone(tester, '988887777');
      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('receive_code'));
      await tester.pumpAndSettle();

      expect(fakes.controller.bloc.state, isA<MeEditRequestCodeFailedState>());
      expect(find.byType(MeEditPhoneInfo), findsOneWidget);
      expect(find.text('request_validation_code_failed'), findsOneWidget);
    });

    /// Corrigido: o listener da `MePage` exclui `MeEditNoContactAvailableState`
    /// (que herda de `MeEditPhoneChangedState`) da condição que abre o bottom
    /// sheet, então o aviso já aberto apenas passa a exibir a mensagem de
    /// contato vazio, sem empilhar um segundo aviso.
    testWidgets('sem contato disponível mostra o aviso de contato vazio uma vez',
        (tester) async {
      fakes.dados2fa.sms = [];
      await pumpMe(tester);
      await openEdit(tester);
      await enterPhone(tester, '988887777');
      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('receive_code'));
      await tester.pumpAndSettle();

      expect(fakes.controller.bloc.state, isA<MeEditNoContactAvailableState>());
      expect(find.byType(MeEditPhoneInfo), findsOneWidget);
      expect(find.text('registration_phone_email_empty_dialog_description'),
          findsOneWidget);
    });

    testWidgets('email alterado abre o aviso de email', (tester) async {
      await pumpMe(tester);
      await openEdit(tester);

      await tester.enterText(find.byType(TextFormField).at(1), 'nova@lello.com');
      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();

      expect(fakes.controller.bloc.state, isA<MeEditEmailChangedState>());
      final info = tester.widget<MeEditPhoneInfo>(find.byType(MeEditPhoneInfo));
      expect(info.isEmailCheck, isTrue);
      expect(info.isPhoneCheck, isFalse);
      expect(find.byIcon(Icons.mail_lock), findsOneWidget);
      expect(find.text('profile_change_email_rationale'), findsOneWidget);

      await tester.tap(find.text('receive_code'));
      await pumpFrames(tester);
      expect(fakes.request2fa.calls.single.id, 'e1');
      expect(find.byType(CodeValidationPage), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('email inválido não salva', (tester) async {
      await pumpMe(tester);
      await openEdit(tester);

      await tester.enterText(find.byType(TextFormField).at(1), 'invalido');
      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();

      expect(find.text('validation_invalid_email'), findsOneWidget);
      expect(fakes.saveMe.calls, isEmpty);
    });

    testWidgets('validação de código com token usa 4 dígitos', (tester) async {
      await pumpMe(tester);
      await openEdit(tester);

      // Abre o aviso de telefone: o listener do estado de validação fecha
      // o bottom sheet com `pop`.
      await emitState(tester, fakes.controller.bloc,
          MeEditPhoneChangedState(fakes.controller.bloc.state.me));
      expect(find.byType(MeEditPhoneInfo), findsOneWidget);

      await emitState(
        tester,
        fakes.controller.bloc,
        MeEditValidateCodeState(
          fakes.controller.bloc.state.me,
          CodeRequest(
            source: CodeValidationSource.phone,
            origin: CodeValidationOrigin.changeNumber,
            value: '11999998888',
            token: 't',
          ),
        ),
        settle: false,
      );
      await pumpFrames(tester, 1);

      final page = tester.widget<CodeValidationPage>(find.byType(CodeValidationPage));
      expect(page.digits, 4);
      await tester.pumpWidget(const SizedBox());
    });
  });

  group('senha', () {
    Future<void> openPassword(WidgetTester tester) async {
      await pumpMe(tester);
      await openEdit(tester);
      await tester.tap(find.text('me_edit_password_title'));
      await tester.pumpAndSettle();
      expect(fakes.controller.bloc.state, isA<MeEditPasswordState>());
      expect(find.byType(MeEditPassword), findsOneWidget);
    }

    testWidgets('mostra o formulário e alterna a visibilidade das senhas',
        (tester) async {
      await openPassword(tester);

      expect(find.text('email/cnpj'), findsOneWidget);
      expect(find.text('origin_password'), findsOneWidget);
      expect(find.text('new_password'), findsOneWidget);
      expect(find.text('new_password_confirm'), findsOneWidget);
      expect(find.text('save'), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNWidgets(3));

      for (var i = 0; i < 3; i++) {
        await tester.tap(find.byIcon(Icons.visibility_off).first);
        await tester.pumpAndSettle();
      }
      expect(find.byIcon(Icons.visibility), findsNWidgets(3));
      expect(find.byIcon(Icons.visibility_off), findsNothing);
    });

    testWidgets('senhas vazias ou diferentes não salvam', (tester) async {
      await openPassword(tester);

      await tester.tap(find.text('save'));
      await tester.pumpAndSettle();
      expect(find.text('validation_required'), findsNWidgets(3));
      expect(fakes.updatePassword.params, isNull);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(1), 'antiga');
      await tester.enterText(fields.at(2), 'nova1');
      await tester.enterText(fields.at(3), 'nova2');
      await tester.tap(find.text('save'));
      await tester.pumpAndSettle();
      expect(fakes.updatePassword.params, isNull);
    });

    /// Corrigido: `MeEditPassword.save` chama
    /// `beginEditSavePassword(originPassword!, newPassword!)`, respeitando a
    /// assinatura `(originPassword, password)`: a senha atual vai como
    /// `originPassword` e a nova como `password`.
    testWidgets('senhas iguais salvam na ordem certa e abrem o sucesso',
        (tester) async {
      await openPassword(tester);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(1), 'antiga');
      await tester.enterText(fields.at(2), 'nova1');
      await tester.enterText(fields.at(3), 'nova1');
      await tester.tap(find.text('save'));
      await tester.pumpAndSettle();

      final params = fakes.updatePassword.params!;
      expect(params.cpf, '12345678901');
      expect(params.originPassword, 'antiga');
      expect(params.password, 'nova1');
      expect(observer.pushedNames.last, ApplicationRoute.meSuccess);
    });

    testWidgets('falha ao trocar a senha mostra o erro', (tester) async {
      fakes.updatePassword.fail = true;
      await openPassword(tester);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(1), 'antiga');
      await tester.enterText(fields.at(2), 'nova1');
      await tester.enterText(fields.at(3), 'nova1');
      await tester.tap(find.text('save'));
      await tester.pumpAndSettle();

      expect(fakes.controller.bloc.state, isA<MeEditPasswordFailedState>());
      expect(find.text('income_control_error'), findsOneWidget);
      expect(find.text('save'), findsOneWidget);
    });

    testWidgets('loading da senha esconde o botão salvar', (tester) async {
      await openPassword(tester);

      await emitState(tester, fakes.controller.bloc,
          MeEditPasswordLoadingState(fakes.controller.bloc.state.me, 'a', 'b'),
          settle: false);
      await tester.pump();

      expect(find.text('save'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('voltar na troca de senha reverte para o perfil',
        (tester) async {
      await openPassword(tester);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.byType(MeEditPassword), findsNothing);
      expect(find.byType(MeProfileWidget), findsOneWidget);
    });
  });

  group('excluir conta', () {
    Future<void> confirmDelete(WidgetTester tester) async {
      await tester.tap(find.text('delete_account'));
      await tester.pumpAndSettle();
      expect(find.text('delete_account_dialog_title'), findsOneWidget);
      await tester.tap(find.text('EXCLUDE'));
      await tester.pumpAndSettle();
    }

    testWidgets('cancelar no diálogo não exclui', (tester) async {
      await pumpMe(tester);

      await tester.tap(find.text('delete_account'));
      await tester.pumpAndSettle();
      expect(find.text('delete_account_dialog_subtitle'), findsOneWidget);
      expect(find.text('delete_account_dialog_subtitle_complement'), findsOneWidget);

      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();

      expect(find.text('delete_account_dialog_title'), findsNothing);
      expect(fakes.deleteAccount.calls, 0);
    });

    testWidgets('excluir com sucesso abre a página de sucesso e concluir sai',
        (tester) async {
      await pumpMe(tester);

      await confirmDelete(tester);

      expect(fakes.disableFcm.calls, 1);
      expect(fakes.deleteAccount.calls, 1);
      expect(fakes.controller.bloc.state, isA<MeDeleteAccountSuccessState>());
      expect(find.byType(MeDeleteAccountSuccessPage), findsOneWidget);
      expect(find.text('Conta excluída com sucesso.'), findsOneWidget);

      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();

      expect(find.byType(MeDeleteAccountSuccessPage), findsNothing);
      expect(fakes.logMeOut.calls, 1);
      expect(harness.sessionBloc.logoutCalls, hasLength(2));
      expect(fakes.authStore.logouts, 2);
    });

    testWidgets('voltar na página de sucesso da exclusão também encerra a sessão',
        (tester) async {
      await pumpMe(tester);
      await confirmDelete(tester);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.byType(MeDeleteAccountSuccessPage), findsNothing);
      expect(fakes.logMeOut.calls, 1);
    });

    testWidgets('falha ao excluir abre a página de erro e tentar de novo volta',
        (tester) async {
      fakes.deleteAccount.fail = true;
      await pumpMe(tester);

      await confirmDelete(tester);

      expect(fakes.controller.bloc.state, isA<MeDeleteAccountFailedState>());
      expect(find.byType(MeDeleteAccountErrorPage), findsOneWidget);
      expect(find.text('error_unknown'), findsOneWidget);

      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();

      expect(find.byType(MeDeleteAccountErrorPage), findsNothing);
      expect(find.byType(MePage), findsOneWidget);
    });
  });

  group('foto de perfil', () {
    Future<void> openSheet(WidgetTester tester) async {
      await tester.tap(find.byType(MeProfilePictureWidget));
      await tester.pumpAndSettle();
      expect(find.text('camera'), findsOneWidget);
      expect(find.text('gallery'), findsOneWidget);
    }

    testWidgets('cancelar a escolha da imagem não envia nada', (tester) async {
      await pumpMe(tester);
      await openSheet(tester);

      await tester.tap(find.text('camera'));
      await tester.pumpAndSettle();

      expect(fakes.picker.sources, [ImageSource.camera]);
      expect(fakes.upload.files, isEmpty);
      expect(find.text('camera'), findsNothing);
    });

    testWidgets('cancelar o recorte não envia nada', (tester) async {
      fakes.picker.path = '/tmp/foto.jpg';
      await pumpMe(tester);
      await openSheet(tester);

      await tester.tap(find.text('gallery'));
      await tester.pumpAndSettle();

      expect(fakes.picker.sources, [ImageSource.gallery]);
      expect(fakes.cropper.cropped, ['/tmp/foto.jpg']);
      expect(fakes.upload.files, isEmpty);
    });

    testWidgets('foto recortada é enviada e o perfil é salvo', (tester) async {
      fakes.picker.path = '/tmp/foto.jpg';
      fakes.cropper.path = '/tmp/foto_cortada.jpg';
      await pumpMe(tester);
      await openSheet(tester);

      await tester.tap(find.text('camera'));
      await tester.pumpAndSettle();
      expect(fakes.upload.files.single.path, '/tmp/foto_cortada.jpg');
      expect(fakes.controller.bloc.state, isA<MeUploadProfileSucceededState>());
      expect(harness.sessionBloc.updatedMes, hasLength(2));

      // O controller espera 2s antes de salvar o perfil.
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(fakes.saveMe.calls, hasLength(1));
      expect(observer.pushedNames.last, ApplicationRoute.meSuccess);
    });

    testWidgets('falha no envio da foto volta para o perfil', (tester) async {
      fakes.picker.path = '/tmp/foto.jpg';
      fakes.cropper.path = '/tmp/foto_cortada.jpg';
      fakes.upload.fail = true;
      await pumpMe(tester);
      await openSheet(tester);

      await tester.tap(find.text('gallery'));
      await tester.pumpAndSettle();

      expect(fakes.controller.bloc.state, isA<MeUploadProfileFailedState>());
      expect(find.byType(MeProfileWidget), findsOneWidget);
    });

    testWidgets('o formulário de edição também permite trocar a foto',
        (tester) async {
      await pumpMe(tester);
      await openEdit(tester);

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      expect(find.text('camera'), findsOneWidget);
      await tester.tap(find.text('gallery'));
      await tester.pumpAndSettle();
      expect(fakes.picker.sources, [ImageSource.gallery]);

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('camera'));
      await tester.pumpAndSettle();
      expect(fakes.picker.sources, [ImageSource.gallery, ImageSource.camera]);
    });
  });

  group('tiles de depuração', () {
    testWidgets('copiam os tokens e derrubam a sessão', (tester) async {
      await pumpMe(tester);

      final copyButtons = find.byIcon(Icons.copy);
      expect(copyButtons, findsNWidgets(3));
      for (var i = 0; i < 3; i++) {
        await tester.tap(copyButtons.at(i));
        await tester.pumpAndSettle();
      }
      expect(fakes.installationsCalls, contains('FirebaseInstallations#getToken'));
      expect(fakes.installationsCalls, contains('FirebaseInstallations#getId'));

      await tester.tap(find.byIcon(Icons.error));
      await tester.pumpAndSettle();
      expect(harness.sessionBloc.logoutCalls, hasLength(1));
    });

    testWidgets('autenticado mostra o refresh token', (tester) async {
      fakes.authBloc.emit(AuthenticatedState(
          accessToken: AccessToken()
            ..accessToken = 'a'
            ..refreshToken = 'r'));
      await pumpMe(tester);

      expect(find.text('Refresh Token'), findsOneWidget);
      expect(find.text('refresh-token'), findsOneWidget);
      expect(find.text('01/01/2030'), findsOneWidget);
      expect(find.byIcon(Icons.copy), findsNWidgets(4));
      await tester.tap(find.byIcon(Icons.copy).last);
      await tester.pumpAndSettle();
    });
  });
}
