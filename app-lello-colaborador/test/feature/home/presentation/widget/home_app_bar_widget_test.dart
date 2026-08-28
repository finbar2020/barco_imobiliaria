import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/home/presentation/widget/app_bar/home_app_bar_widget.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart' hide isNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeAuthenticationStore extends Fake implements AuthenticationStore {
  @override
  Map<String, String>? getCustomHeader() => null;
}

class _FakeSessionBloc extends Fake implements SessionBloc {
  @override
  String getBaseUrl() => 'http://localhost';
}

Future<void> _installContainer() async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(_FakeSessionBloc());
  locator.registerSingleton<AuthenticationStore>(_FakeAuthenticationStore());
}

Session _session() {
  final condo = testCondominium(jobPosition: 'porteiro noturno');
  return Session(me: testMe(condominiums: [condo]), condominium: condo);
}

void main() {
  setUp(_installContainer);
  tearDown(resetTestApplicationContainer);

  group('HomeAppBarWidget', () {
    testWidgets('exibe nome, cargo e turno do colaborador', (tester) async {
      await pumpApp(
        tester,
        HomeAppBarWidget(session: _session()),
        localized: true,
        shrinkWrap: false,
        surface: const Size(400, 200),
      );

      expect(find.text('Ana Silva'), findsOneWidget);
      expect(find.text('Porteiro noturno'), findsOneWidget);
      expect(find.text('diurno'), findsOneWidget);
    });

    testWidgets('aciona callback ao tocar na foto de perfil', (tester) async {
      var taps = 0;
      await pumpApp(
        tester,
        HomeAppBarWidget(session: _session(), onProfileTap: () => taps++),
        localized: true,
        shrinkWrap: false,
        surface: const Size(400, 200),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(taps, 1);
    });

    testWidgets('sem callback o toque na foto não quebra', (tester) async {
      await pumpApp(
        tester,
        HomeAppBarWidget(session: _session()),
        localized: true,
        shrinkWrap: false,
        surface: const Size(400, 200),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('HomeAppBar.show entrega altura mínima de 158', (tester) async {
      late Size preferredSize;
      await pumpApp(
        tester,
        Builder(
          builder: (context) {
            final appBar = HomeAppBar.show(context, _session(), null);
            preferredSize = appBar.preferredSize;
            return SizedBox(
              height: preferredSize.height,
              child: appBar.child,
            );
          },
        ),
        localized: true,
        shrinkWrap: false,
        surface: const Size(400, 300),
      );

      expect(preferredSize.height, 158.0);
      expect(find.text('Ana Silva'), findsOneWidget);
    });
  });
}
