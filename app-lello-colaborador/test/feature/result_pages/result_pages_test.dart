import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/digital_point/presentation/page/face_register_success_page.dart';
import 'package:colaborador/feature/digital_point/presentation/page/face_request_success_page.dart';
import 'package:colaborador/feature/employee_referral/presentation/pages/employee_referral_error_page.dart';
import 'package:colaborador/feature/employee_referral/presentation/pages/employee_referral_success_page.dart';
import 'package:colaborador/feature/manual_timesheet/presentation/page/manual_timesheet_register_error_page.dart';
import 'package:colaborador/feature/manual_timesheet/presentation/page/manual_timesheet_register_success_page.dart';
import 'package:colaborador/feature/sick_note/presentation/page/sick_note_register_error_page.dart';
import 'package:colaborador/feature/sick_note/presentation/page/sick_note_register_success_page.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_bloc.dart';
import 'package:colaborador/feature/me/presentation/pages/me_delete_account_error.dart';
import 'package:colaborador/feature/me/presentation/pages/me_delete_account_success.dart';
import 'package:colaborador/feature/me/presentation/pages/me_edit_success.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/test_application_container.dart';

class _FakeMeBloc extends Fake implements MeBloc {
  bool loggedOut = false;

  @override
  void beginLogOut() => loggedOut = true;
}

class _FakeSessionBloc extends Fake implements SessionBloc {
  bool loggedOut = false;

  @override
  FirebaseRemoteConfig? get remoteConfig => null;
  bool sessionReloaded = false;

  @override
  void logout({Failure? error, bool? restartApp}) => loggedOut = true;

  @override
  void beginLoadSession({bool onLogin = false, bool onlyLocal = false}) =>
      sessionReloaded = true;

  @override
  Stream<SessionState> get stream => const Stream.empty();
}

class _FakeAuthenticationStore extends Fake implements AuthenticationStore {
  bool loggedOut = false;

  @override
  Future<void> logout() async => loggedOut = true;
}

late _FakeSessionBloc _sessionBloc;
late _FakeAuthenticationStore _authStore;

Future<void> _installContainer() async {
  SharedPreferences.setMockInitialValues({});
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  _sessionBloc = _FakeSessionBloc();
  _authStore = _FakeAuthenticationStore();
  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(_sessionBloc);
  locator.registerSingleton<AuthenticationStore>(_authStore);
}

class _PopObserver extends NavigatorObserver {
  int pops = 0;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pops++;
    super.didPop(route, previousRoute);
  }
}

Future<_PopObserver> _pumpPage(
  WidgetTester tester,
  Widget page, {
  Object? args,
}) async {
  final observer = _PopObserver();
  await pumpApp(
    tester,
    // Algumas telas de resultado leem o SessionBloc via BlocProvider.of.
    BlocProvider<SessionBloc>.value(
      value: _sessionBloc,
      child: Navigator(
        observers: [observer],
        onGenerateRoute: (settings) => MaterialPageRoute(
          settings: RouteSettings(name: settings.name, arguments: args),
          builder: (_) => page,
        ),
      ),
    ),
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    settle: false,
    surface: const Size(420, 800),
  );
  await tester.pump();
  return observer;
}

void main() {
  setUp(_installContainer);
  tearDown(resetTestApplicationContainer);

  group('MeDeleteAccountSuccessPage', () {
    testWidgets('confirma a exclusão da conta', (tester) async {
      final meBloc = _FakeMeBloc();
      await _pumpPage(tester, MeDeleteAccountSuccessPage(meBloc: meBloc));

      expect(find.text('Conta excluída com sucesso.'), findsOneWidget);
      expect(find.text('conclude'), findsOneWidget);
    });

    testWidgets('concluir encerra a sessão em todas as camadas',
        (tester) async {
      final meBloc = _FakeMeBloc();
      await _pumpPage(tester, MeDeleteAccountSuccessPage(meBloc: meBloc));

      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();

      expect(meBloc.loggedOut, isTrue);
      expect(_sessionBloc.loggedOut, isTrue);
      expect(_authStore.loggedOut, isTrue);
    });
  });

  group('MeDeleteAccountErrorPage', () {
    testWidgets('avisa a falha e permite tentar novamente', (tester) async {
      final observer = await _pumpPage(
        tester,
        const MeDeleteAccountErrorPage(),
      );

      expect(find.text('error_unknown'), findsOneWidget);

      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();

      expect(observer.pops, 1);
    });
  });

  group('EmployeeReferralSuccessPage', () {
    testWidgets('confirma a indicação enviada', (tester) async {
      final observer = await _pumpPage(
        tester,
        const EmployeeReferralSuccessPage(),
      );

      expect(find.text('ok'), findsOneWidget);

      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();

      expect(observer.pops, 1);
      expect(_sessionBloc.sessionReloaded, isTrue);
    });
  });

  group('EmployeeReferralErrorPage', () {
    testWidgets('explica a falha da indicação', (tester) async {
      final observer = await _pumpPage(
        tester,
        const EmployeeReferralErrorPage(),
      );

      expect(find.text('employee_referral_erro_title'), findsOneWidget);
      expect(find.text('employee_referral_erro_subtitle'), findsOneWidget);

      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();

      expect(observer.pops, 1);
    });
  });

  group('ManualTimeSheetRegisterErrorPage', () {
    testWidgets('explica a falha do ponto manual', (tester) async {
      final observer = await _pumpPage(
        tester,
        const ManualTimeSheetRegisterErrorPage(),
      );

      expect(
        find.text('manual_timesheet_register_error_title'),
        findsOneWidget,
      );
      expect(
        find.text('manual_timesheet_register_error_subtitle'),
        findsOneWidget,
      );

      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();

      expect(observer.pops, 1);
    });
  });

  group('FaceRegisterSuccessPage', () {
    testWidgets('registro online tem mensagem própria', (tester) async {
      await _pumpPage(
        tester,
        const FaceRegisterSuccessPage(),
        args: FaceRegisterSuccessPageArgs(isOnlineRegister: true),
      );

      expect(find.text('face_register_success_title_online'), findsOneWidget);
    });

    testWidgets('registro offline avisa que será sincronizado',
        (tester) async {
      final observer = await _pumpPage(
        tester,
        const FaceRegisterSuccessPage(),
        args: FaceRegisterSuccessPageArgs(isOnlineRegister: false),
      );

      expect(find.text('face_register_success_title_offline'), findsOneWidget);

      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();

      expect(observer.pops, 1);
      expect(_sessionBloc.sessionReloaded, isTrue);
    });
  });

  group('FaceRequestSuccessPage', () {
    testWidgets('confirma o envio do cadastro facial', (tester) async {
      final observer = await _pumpPage(
        tester,
        const FaceRequestSuccessPage(),
      );

      expect(find.text('face_request_success_title'), findsOneWidget);
      expect(find.text('face_request_success_subtitle'), findsOneWidget);

      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();

      expect(observer.pops, 1);
    });
  });

  group('SickNoteRegisterSuccessPage', () {
    testWidgets('confirma o envio do atestado e recarrega a sessão',
        (tester) async {
      final observer = await _pumpPage(
        tester,
        const SickNoteRegisterSuccessPage(),
      );

      expect(
        find.text('sick_note_register_success_title_online'),
        findsOneWidget,
      );

      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();

      expect(observer.pops, 1);
      expect(_sessionBloc.sessionReloaded, isTrue);
    });
  });

  group('SickNoteRegisterErrorPage', () {
    testWidgets('explica a falha do envio do atestado', (tester) async {
      final observer = await _pumpPage(
        tester,
        const SickNoteRegisterErrorPage(),
      );

      expect(find.text('sick_note_register_error_title'), findsOneWidget);
      expect(find.text('sick_note_register_error_subtitle'), findsOneWidget);

      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();

      expect(observer.pops, 1);
    });
  });

  group('ManualTimeSheetRegisterSuccessPage', () {
    testWidgets('confirma a solicitação e recarrega a sessão', (tester) async {
      final observer = await _pumpPage(
        tester,
        const ManualTimeSheetRegisterSuccessPage(),
      );

      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();

      expect(observer.pops, 1);
      expect(_sessionBloc.sessionReloaded, isTrue);
    });
  });

  group('MeEditSuccessPage', () {
    testWidgets('confirma a atualização do perfil', (tester) async {
      var confirms = 0;
      await _pumpPage(
        tester,
        const MeEditSuccessPage(),
        args: MeEditSuccessPageArgs(onConfirm: () => confirms++),
      );

      expect(find.text('profile_update_success'), findsOneWidget);
      expect(find.text('conclude'), findsOneWidget);

      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();

      expect(confirms, 1);
    });
  });
}
