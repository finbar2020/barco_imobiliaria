import 'dart:async';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_bloc.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_state.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/me/presentation/pages/me_delete_account_error.dart';
import 'package:colaborador/feature/me/presentation/pages/me_delete_account_success.dart';
import 'package:colaborador/feature/me/presentation/pages/me_page.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_edit_phone.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_edit.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_edit_password.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_page/me_profile_widget.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart' hide isNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeMeBloc extends Fake implements MeBloc {
  _FakeMeBloc(this._state);

  MeState _state;
  bool reverted = false;
  bool reloaded = false;
  final _controller = StreamController<MeState>.broadcast();

  @override
  MeState get state => _state;

  @override
  Stream<MeState> get stream => _controller.stream;

  @override
  void revertEdit() => reverted = true;

  @override
  void beginLoad(bool forceUpdate) => reloaded = true;

  void emitir(MeState state) {
    _state = state;
    _controller.add(state);
  }

  Future<void> fechar() => _controller.close();
}

class _FakeAuthenticationStore extends Fake implements AuthenticationStore {
  @override
  Map<String, String>? getCustomHeader() => null;

  @override
  String getRefreshToken() => 'refresh-token';

  @override
  String getExpirationDate() => '2026-01-01';
}

class _FakeSessionBloc extends Fake implements SessionBloc {
  @override
  String getBaseUrl() => 'http://localhost';
}

late AuthenticationBloc _authenticationBloc;

Future<_FakeMeBloc> _installContainer(MeState state) async {
  SharedPreferences.setMockInitialValues({});
  PackageInfo.setMockInitialValues(
    appName: 'colaborador',
    packageName: 'br.com.lello.colaborador',
    version: '9.9.9',
    buildNumber: '1',
    buildSignature: '',
  );

  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  final bloc = _FakeMeBloc(state);
  _authenticationBloc = AuthenticationBloc();

  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(_FakeSessionBloc());
  locator.registerSingleton<AuthenticationStore>(_FakeAuthenticationStore());
  locator.registerSingleton<MeBloc>(bloc);
  locator.registerSingleton<AuthenticationBloc>(_authenticationBloc);
  locator.registerFactory<Validator>(() => ValidatorImpl());
  return bloc;
}

Future<void> _pumpPage(WidgetTester tester) => pumpApp(
      tester,
      const MePage(),
      localized: true,
      wrapInScaffold: false,
      shrinkWrap: false,
      settle: false,
      surface: const Size(420, 1000),
    );

/// Monta a página dentro de um `Navigator` com as rotas que os listeners usam.
Future<void> _pumpPageComRotas(WidgetTester tester) => pumpApp(
      tester,
      Navigator(
        onGenerateRoute: (settings) {
          if (settings.name == ApplicationRoute.meSuccess) {
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => const SizedBox(key: Key('me-success')),
            );
          }
          if (settings.name == SharedApplicationRoute.login) {
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => const SizedBox(key: Key('login')),
            );
          }
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => const MePage(),
          );
        },
      ),
      localized: true,
      wrapInScaffold: false,
      shrinkWrap: false,
      settle: false,
      surface: const Size(420, 1000),
    );

Me _me() => testMe()..cpf = '12345678901';

void main() {
  tearDown(() async {
    await _authenticationBloc.close();
    await resetTestApplicationContainer();
  });

  group('MePage', () {
    testWidgets('estado carregado mostra o perfil', (tester) async {
      await _installContainer(MeLoadedState(_me()));
      await _pumpPage(tester);
      await tester.pump();

      expect(find.byType(MeProfileWidget), findsOneWidget);
      expect(find.text('profile_title'), findsOneWidget);
    });

    testWidgets('estado de carregamento mostra o indicador', (tester) async {
      await _installContainer(const MeLoadingState());
      await _pumpPage(tester);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(MeProfileWidget), findsNothing);
    });

    testWidgets('estado de edição mostra o formulário de dados',
        (tester) async {
      await _installContainer(MeEditState(_me()));
      await _pumpPage(tester);
      await tester.pump();

      expect(find.byType(MeEdit), findsOneWidget);
      expect(find.byType(MeProfileWidget), findsNothing);
    });

    testWidgets('estado de troca de senha mostra o formulário de senha',
        (tester) async {
      await _installContainer(MeEditPasswordState(_me(), 'old', 'new'));
      await _pumpPage(tester);
      await tester.pump();

      expect(find.byType(MeEditPassword), findsOneWidget);
      expect(find.byType(MeEdit), findsNothing);
    });

    testWidgets('salvando edição mostra o indicador', (tester) async {
      await _installContainer(MeEditLoadingState(_me()));
      await _pumpPage(tester);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('falha na edição mostra a mensagem de erro', (tester) async {
      await _installContainer(
        MeEditFailedState(_me(), KnownFailure('400', 'fail')),
      );
      await _pumpPage(tester);
      await tester.pump();

      expect(find.text('pendency_load_failed'), findsOneWidget);
    });

    testWidgets('voltar durante a edição desfaz em vez de sair',
        (tester) async {
      final bloc = await _installContainer(MeEditState(_me()));
      await _pumpPage(tester);
      await tester.pump();

      final willPop = tester.widget<WillPopScope>(find.byType(WillPopScope).first);
      expect(await willPop.onWillPop!(), isFalse);
      expect(bloc.reverted, isTrue);
    });

    testWidgets('mudança de telefone abre a folha de confirmação',
        (tester) async {
      final bloc = await _installContainer(MeEditState(_me()));
      addTearDown(bloc.fechar);
      await _pumpPageComRotas(tester);
      await tester.pump();

      bloc.emitir(MeEditPhoneChangedState(me: _me(), isPhone: true));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(MeEditPhoneInfo), findsOneWidget);
    });

    testWidgets('edição salva leva para a tela de sucesso', (tester) async {
      final bloc = await _installContainer(MeEditState(_me()));
      addTearDown(bloc.fechar);
      await _pumpPageComRotas(tester);
      await tester.pump();

      bloc.emitir(MeEditSucceededState(_me()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byKey(const Key('me-success')), findsOneWidget);
    });

    testWidgets('exclusão de conta bem sucedida abre a confirmação',
        (tester) async {
      final bloc = await _installContainer(MeLoadedState(_me()));
      addTearDown(bloc.fechar);
      await _pumpPageComRotas(tester);
      await tester.pump();

      bloc.emitir(MeDeleteAccountSuccessState(_me()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(MeDeleteAccountSuccessPage), findsOneWidget);
    });

    testWidgets('falha ao excluir a conta abre a tela de erro', (tester) async {
      final bloc = await _installContainer(MeLoadedState(_me()));
      addTearDown(bloc.fechar);
      await _pumpPageComRotas(tester);
      await tester.pump();

      bloc.emitir(MeDeleteAccountFailedState(_me()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(MeDeleteAccountErrorPage), findsOneWidget);
    });

    testWidgets('perder a autenticação volta para o login', (tester) async {
      final bloc = await _installContainer(MeLoadedState(_me()));
      addTearDown(bloc.fechar);
      await _pumpPageComRotas(tester);
      await tester.pump();

      _authenticationBloc.add(UnauthenticateEvent());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byKey(const Key('login')), findsOneWidget);
    });

    testWidgets('voltar fora da edição libera a saída', (tester) async {
      final bloc = await _installContainer(MeLoadedState(_me()));
      await _pumpPage(tester);
      await tester.pump();

      final willPop = tester.widget<WillPopScope>(find.byType(WillPopScope).first);
      expect(await willPop.onWillPop!(), isTrue);
      expect(bloc.reverted, isFalse);
    });
  });
}
