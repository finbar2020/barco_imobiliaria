import 'dart:async';

import 'package:colaborador/core/app_connectivity/app_connectivity.dart';
import 'package:colaborador/core/bloc/inactivity/inactivity_cubit.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/condo_info.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/condominium_code_info.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/bloc/authentication_tablet_bloc.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/bloc/authentication_tablet_state.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/page/login_tablet_page.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_fill_condo_code_widget.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_loaded_widget.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeSessionBloc extends Fake implements SessionBloc {
  @override
  String getBaseUrl() => 'http://localhost';

  @override
  bool showButtonNoAuthPointList(String reference) => false;
}

class _FakeConnectivity extends Fake implements AppConnectivity {
  @override
  Future<bool> checkConnectivity() async => true;
}

class _FakeAuthenticationStore extends Fake implements AuthenticationStore {
  _FakeAuthenticationStore(this.bloc);

  @override
  final AuthenticationBloc bloc;

  @override
  Map<String, String>? getCustomHeader() => null;
}

class _FakeInactivityCubit extends Fake implements InactivityCubit {
  @override
  void start() {}
}

class _FakeTabletBloc extends Fake implements AuthenticationTabletBloc {
  _FakeTabletBloc(this._state);

  final AuthenticationTabletState _state;
  final _controller = StreamController<AuthenticationTabletState>.broadcast();
  final requestedCodes = <String>[];

  @override
  AuthenticationTabletState get state => _state;

  @override
  Stream<AuthenticationTabletState> get stream => _controller.stream;

  @override
  void getInfoByCondoCode(String condoCode) => requestedCodes.add(condoCode);

  @override
  Future<void> close() async {}

  Future<void> dispose() => _controller.close();
}

late _FakeTabletBloc _bloc;
late AuthenticationBloc _authenticationBloc;

final _condoInfo = CondominiumCodeInfo(
  condoCode: 'ABC123',
  condominium: CondoInfo(
    reference: 'R1',
    name: 'torre lello',
    picturehash: '',
    status: 'active',
    ref: 'R1',
  ),
  employees: const [],
);

Future<void> _install(AuthenticationTabletState state) async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  _bloc = _FakeTabletBloc(state);
  _authenticationBloc = AuthenticationBloc();

  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(_FakeSessionBloc());
  locator.registerSingleton<AppConnectivity>(_FakeConnectivity());
  locator.registerSingleton<AuthenticationTabletBloc>(_bloc);
  locator.registerSingleton<InactivityCubit>(_FakeInactivityCubit());
  locator.registerSingleton<AuthenticationStore>(
    _FakeAuthenticationStore(_authenticationBloc),
  );
}

Future<void> _pumpPage(WidgetTester tester, {Object? args}) async {
  await pumpApp(
    tester,
    Navigator(
      onGenerateRoute: (settings) => MaterialPageRoute(
        settings: RouteSettings(name: settings.name, arguments: args),
        builder: (_) => const LoginTabletPage(),
      ),
    ),
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    settle: false,
    surface: const Size(700, 1000),
  );
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  tearDown(() async {
    await _bloc.dispose();
    await _authenticationBloc.close();
    await resetTestApplicationContainer();
  });

  group('LoginTabletPage', () {
    testWidgets('começa pedindo o código do condomínio', (tester) async {
      await _install(const AuthenticationTabletInitialState());
      await _pumpPage(tester);

      expect(find.byType(LoginTabletFillCondoCodeWidget), findsOneWidget);
      expect(find.byType(LoginTabletLoadedWidget), findsNothing);
    });

    testWidgets('buscando o condomínio bloqueia a tela e mostra o loading',
        (tester) async {
      await _install(const AuthenticationTabletLoadingState());
      await _pumpPage(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        tester
            .widgetList<IgnorePointer>(find.byType(IgnorePointer))
            .any((w) => w.ignoring),
        isTrue,
      );
    });

    testWidgets('falha marca o campo de código', (tester) async {
      await _install(const AuthenticationTabletFailedState());
      await _pumpPage(tester);

      final field = tester.widget<LoginTabletFillCondoCodeWidget>(
        find.byType(LoginTabletFillCondoCodeWidget),
      );
      expect(field.isFailure, isTrue);
    });

    testWidgets('condomínio carregado abre o fluxo do tablet', (tester) async {
      await _install(AuthenticationTabletLoadedState(_condoInfo));
      await _pumpPage(tester);

      expect(find.byType(LoginTabletLoadedWidget), findsOneWidget);
      expect(find.byType(LoginTabletFillCondoCodeWidget), findsNothing);
    });

    testWidgets('código recebido por argumento já dispara a busca',
        (tester) async {
      await _install(const AuthenticationTabletInitialState());
      await _pumpPage(tester, args: 'ABC123');

      expect(_bloc.requestedCodes, ['ABC123']);
    });
  });
}
