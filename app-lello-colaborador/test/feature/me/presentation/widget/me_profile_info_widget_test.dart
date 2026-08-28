import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_page/me_profile_info_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _ProductionEnvironment extends Environment {
  _ProductionEnvironment()
      : super(
          name: 'prod',
          isProduction: true,
          apiUrl: 'http://localhost',
        );
}

class _FakeAuthenticationStore extends Fake implements AuthenticationStore {
  @override
  String getRefreshToken() => 'refresh-token';

  @override
  String getExpirationDate() => '2026-01-01';
}

Future<void> _installContainer({bool production = false}) async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  locator.registerSingleton<Environment>(
    production ? _ProductionEnvironment() : TestEnvironment(),
  );
  locator.registerSingleton<AuthenticationStore>(_FakeAuthenticationStore());
}

Me _me({
  String cpf = '12345678901',
  String email = 'ana@lello.com',
  String phone = '(11)98765-4321',
}) =>
    testMe()
      ..cpf = cpf
      ..email = email
      ..phone = phone;

Future<void> _pump(WidgetTester tester, Me me) => pumpApp(
      tester,
      MeProfileInfoWidget(me: me),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 900),
    );

void main() {
  tearDown(resetTestApplicationContainer);

  group('MeProfileInfoWidget', () {
    testWidgets('exibe documento, email, telefone e senha mascarada',
        (tester) async {
      await _installContainer();
      await _pump(tester, _me());

      expect(find.text('me_cpf_title'), findsOneWidget);
      expect(find.text('123.456.789-01'), findsOneWidget);
      expect(find.text('profile_update_email'), findsOneWidget);
      expect(find.text('ana@lello.com'), findsOneWidget);
      expect(find.text('phone'), findsOneWidget);
      expect(find.text('(11)98765-4321'), findsOneWidget);
      expect(find.text('******'), findsOneWidget);
    });

    testWidgets('usa rótulo de cnpj para documento de empresa', (tester) async {
      await _installContainer();
      await _pump(tester, _me(cpf: '12.345.678/0001-90'));

      expect(find.text('cnpj'), findsOneWidget);
      expect(find.text('me_cpf_title'), findsNothing);
    });

    testWidgets('exibe "não informado" para campos vazios', (tester) async {
      await _installContainer();
      await _pump(tester, _me(email: '', phone: ''));

      expect(find.text('not_informed'), findsNWidgets(2));
    });

    testWidgets('mostra dados de suporte fora de produção', (tester) async {
      await _installContainer();
      await _pump(tester, _me());

      expect(find.text('Token Firebase'), findsOneWidget);
      expect(find.text('refresh-token'), findsOneWidget);
      expect(find.text('2026-01-01'), findsOneWidget);
    });

    testWidgets('esconde dados de suporte em produção', (tester) async {
      await _installContainer(production: true);
      await _pump(tester, _me());

      expect(find.text('Token Firebase'), findsNothing);
      expect(find.text('Firebase Installation ID'), findsNothing);
      expect(find.text('refresh-token'), findsNothing);
      expect(find.text('me_cpf_title'), findsOneWidget);
    });
  });
}
