import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_bloc.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_state.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_page/me_profile_buttons_widget.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_page/me_profile_info_widget.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_page/me_profile_picture_widget.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_page/me_profile_widget.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart' hide isNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeMeBloc extends Fake implements MeBloc {
  _FakeMeBloc(this._state);

  final MeState _state;

  bool editStarted = false;
  bool logoutStarted = false;
  Me? deleted;

  @override
  MeState get state => _state;

  @override
  Stream<MeState> get stream => Stream.value(_state);

  @override
  void beginEdit() => editStarted = true;

  @override
  void beginLogOut() => logoutStarted = true;

  @override
  Future<void> deleteAccount(Me me) async => deleted = me;
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

Future<void> _installContainer() async {
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
  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(_FakeSessionBloc());
  locator.registerSingleton<AuthenticationStore>(_FakeAuthenticationStore());
}

Future<_FakeMeBloc> _pumpProfile(WidgetTester tester, {Me? me}) async {
  final bloc = _FakeMeBloc(
    me == null ? const MeInitialState() : MeLoadedState(me),
  );
  await pumpApp(
    tester,
    BlocProvider<MeBloc>.value(
      value: bloc,
      child: const MeProfileWidget(),
    ),
    localized: true,
    shrinkWrap: false,
    // As chaves cruas estouram a linha de botões do diálogo de exclusão.
    locOverrides: const {
      'cancel': 'Cancelar',
      'comfort_disfavor_dialog_confirmation': 'Excluir',
      'delete_account_dialog_title': 'Excluir conta?',
      'delete_account_dialog_subtitle': 'Sub',
      'delete_account_dialog_subtitle_complement': 'Comp',
    },
    surface: const Size(420, 1000),
  );
  return bloc;
}

void main() {
  setUp(_installContainer);
  tearDown(resetTestApplicationContainer);

  group('MeProfileWidget', () {
    testWidgets('exibe perfil completo do colaborador', (tester) async {
      await _pumpProfile(tester, me: testMe()..cpf = '12345678901');

      expect(find.byType(MeProfilePictureWidget), findsOneWidget);
      expect(find.byType(MeProfileInfoWidget), findsOneWidget);
      expect(find.byType(MeProfileButtonsWidget), findsOneWidget);
      expect(find.text('ana silva'), findsOneWidget);
      expect(find.text('logout'), findsOneWidget);
      expect(find.text('V9.9.9'), findsOneWidget);
    });

    testWidgets('sem dados exibe aviso e apenas o logout', (tester) async {
      await _pumpProfile(tester);

      expect(find.text('unable_to_load'), findsOneWidget);
      expect(find.text('logout'), findsOneWidget);
      expect(find.byType(MeProfileButtonsWidget), findsNothing);
    });

    testWidgets('logout aciona o bloc', (tester) async {
      final bloc = await _pumpProfile(tester, me: testMe());

      await tester.tap(find.text('logout'));
      await tester.pump();

      expect(bloc.logoutStarted, isTrue);
    });

    testWidgets('editar aciona o bloc', (tester) async {
      final bloc = await _pumpProfile(tester, me: testMe());

      await tester.ensureVisible(find.text('edit'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('edit'));
      await tester.pump();

      expect(bloc.editStarted, isTrue);
    });

    testWidgets('excluir conta pede confirmação antes de chamar o bloc',
        (tester) async {
      final me = testMe();
      final bloc = await _pumpProfile(tester, me: me);

      await tester.ensureVisible(find.text('delete_account'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('delete_account'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Excluir conta?'), findsOneWidget);
      expect(bloc.deleted, isNull);
    });

    testWidgets('confirmar exclusão chama o bloc com o colaborador',
        (tester) async {
      final me = testMe();
      final bloc = await _pumpProfile(tester, me: me);

      await tester.ensureVisible(find.text('delete_account'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('delete_account'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('EXCLUIR'));
      await tester.pumpAndSettle();

      expect(bloc.deleted, same(me));
    });
  });
}
