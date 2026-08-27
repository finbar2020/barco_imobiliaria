import 'dart:async';

import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../helpers/firebase_mocks.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/test_container.dart';
import 'expired_session_support.dart';

void main() {
  late TestSharedContainer container;
  late FakeLogout logout;
  late FakeClearData clearData;
  late int emptied;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    await setUpFakeFirebase();
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'Lello',
      packageName: 'br.com.lello.morar',
      version: '9.9.9',
      buildNumber: '1',
      buildSignature: '',
    );
    container = TestSharedContainer();
    logout = FakeLogout();
    clearData = FakeClearData();
    emptied = 0;
    observer = RecordingNavigatorObserver();
  });

  /// O bloc nasce dentro do `testWidgets` (fake async).
  ExpiredSessionBloc registerBloc() {
    final bloc = ExpiredSessionBloc(
      clearDataUseCase: clearData,
      logOutUseCase: logout,
      emptySessionState: () => emptied++,
    );
    container.register<ExpiredSessionBloc>(bloc);
    return bloc;
  }

  Future<void> pumpExpired(WidgetTester tester,
      {ExpiredSessionArguments? arguments, bool settle = true}) async {
    await pumpPage(
      tester,
      ExpiredSessionPage(
          appContainer: container, appOriginEnum: AppOriginEnum.owner),
      arguments: arguments,
      observer: observer,
      settle: settle,
    );
  }

  testWidgets('mostra o aviso de sessão expirada com a versão e volta à splash',
      (tester) async {
    registerBloc();
    await pumpExpired(tester,
        arguments: ExpiredSessionArguments(reason: 'expirou', cpf: '123'));

    expect(logout.calls, 1);
    expect(clearData.calls, 1);
    expect(emptied, 1);
    expect(find.text('expired_session_title'), findsOneWidget);
    expect(find.text('expired_session_subtitle'), findsOneWidget);
    expect(find.text('V9.9.9'), findsOneWidget);
    expect(find.text('expired_session_ok'), findsOneWidget);
    await expectLater(
      find.byType(ExpiredSessionPage),
      matchesGoldenFile('goldens/expired_session_page.png'),
    );

    await tester.tap(find.text('expired_session_ok'));
    await tester.pumpAndSettle();

    /// Defeito: `expired_session_page.dart:41-46` chama `beginLogOut` em
    /// `didChangeDependencies`, que roda de novo na transição de rota: o
    /// logout inteiro (logout + clearData + logs no Crashlytics) é refeito ao
    /// sair da tela. Por isso `emptied` chega a 3 (1 do logout inicial, 1 do
    /// toque e 1 do logout repetido) e `logout.calls` a 2.
    expect(emptied, 3);
    expect(logout.calls, 2);
    expect(clearData.calls, 2);
    expect(findRoute(SharedApplicationRoute.splash), findsOneWidget);
    expect(find.byType(ExpiredSessionPage), findsNothing);
  });

  testWidgets('enquanto desloga mostra o carregamento', (tester) async {
    registerBloc();
    final completer = Completer<Try<Nothing>>();
    logout.pending = completer;
    await pumpExpired(tester, settle: false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('please_wait'), findsOneWidget);

    completer.complete(Success(Nothing()));
    await tester.pumpAndSettle();

    expect(find.text('expired_session_title'), findsOneWidget);
  });

  testWidgets('estado vazio não desenha nada', (tester) async {
    final bloc = registerBloc();
    await pumpExpired(tester);
    // ignore: invalid_use_of_visible_for_testing_member
    bloc.emit(const ExpiredSessionEmptyState());
    await tester.pump();
    await tester.pump();

    expect(find.text('expired_session_title'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
