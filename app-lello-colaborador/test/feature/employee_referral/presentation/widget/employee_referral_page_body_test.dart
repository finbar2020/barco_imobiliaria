import 'dart:convert';
import 'dart:io';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/employee_referral/domain/entity/city.dart';
import 'package:colaborador/feature/employee_referral/domain/entity/employee_referral.dart';
import 'package:colaborador/feature/employee_referral/presentation/widgets/employee_referral_page_body_widget.dart';
import 'package:essentials/essentials.dart' hide isNotNull, isNull;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

const _pngBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAE'
    'hQGAhKmMIQAAAABJRU5ErkJggg==';

File _imageFile() {
  final file = File('${Directory.systemTemp.path}/colaborador_referral.png');
  file.writeAsBytesSync(base64Decode(_pngBase64));
  return file;
}

final _cities = [
  CityEntity(name: 'São Paulo', regions: const ['Zona Sul', 'Zona Norte']),
  CityEntity(name: 'Santos', regions: const []),
];

Future<void> _installContainer() async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  locator.registerSingleton<Environment>(TestEnvironment());
}

Future<int Function()> _pumpBody(
  WidgetTester tester,
  EmployeeReferralEntity referral,
) async {
  var sendCalls = 0;
  await pumpApp(
    tester,
    Material(
      child: SingleChildScrollView(
        child: EmployeeReferralPageBodyWidget(
          employeeReferral: referral,
          cities: _cities,
          fileMaxSizePermitted: 10,
          registerEmployeeReferral: () => sendCalls++,
        ),
      ),
    ),
    localized: true,
    shrinkWrap: false,
    // O formulário mantém uma animação em loop.
    settle: false,
    surface: const Size(500, 1200),
  );
  await tester.pump();
  return () => sendCalls;
}

void main() {
  setUp(_installContainer);
  tearDown(resetTestApplicationContainer);

  group('EmployeeReferralPageBodyWidget', () {
    testWidgets('exibe os campos da indicação', (tester) async {
      await _pumpBody(tester, EmployeeReferralEntity());

      expect(find.text('employee_referral_name'), findsOneWidget);
      expect(find.text('employee_referral_city'), findsOneWidget);
      expect(find.text('employee_referral_city_note'), findsOneWidget);
      expect(find.text('employee_referral_add_curriculum'), findsOneWidget);
      expect(find.text('send'), findsOneWidget);
    });

    testWidgets('sem dados o envio fica bloqueado', (tester) async {
      await _pumpBody(tester, EmployeeReferralEntity());

      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNull,
      );
    });

    testWidgets('com nome, cidade e currículo o envio é liberado',
        (tester) async {
      final file = _imageFile();
      addTearDown(() {
        if (file.existsSync()) file.deleteSync();
      });

      await _pumpBody(
        tester,
        EmployeeReferralEntity(
          description: 'Maria',
          city: 'Santos',
          file: file,
        ),
      );

      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNotNull,
      );
    });

    testWidgets('cidade com região exige a região escolhida', (tester) async {
      final file = _imageFile();
      addTearDown(() {
        if (file.existsSync()) file.deleteSync();
      });

      await _pumpBody(
        tester,
        EmployeeReferralEntity(
          description: 'Maria',
          city: 'São Paulo',
          file: file,
          hasRegion: true,
          regions: const ['Zona Sul', 'Zona Norte'],
        ),
      );

      expect(find.text('employee_referral_region'), findsOneWidget);
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNull,
      );
    });

    testWidgets('com a região escolhida o envio é liberado', (tester) async {
      final file = _imageFile();
      addTearDown(() {
        if (file.existsSync()) file.deleteSync();
      });
      final referral = EmployeeReferralEntity(
        description: 'Maria',
        city: 'São Paulo',
        region: 'Zona Sul',
        file: file,
        hasRegion: true,
        regions: const ['Zona Sul', 'Zona Norte'],
      );
      final sendCalls = await _pumpBody(tester, referral);

      await tester.ensureVisible(find.text('send'));
      await tester.pump();
      await tester.tap(find.text('send'));
      await tester.pump();

      expect(sendCalls(), 1);
    });

    testWidgets('escolher cidade com regiões habilita o campo de região',
        (tester) async {
      final referral = EmployeeReferralEntity();
      await _pumpBody(tester, referral);

      await tester.tap(find.byType(DropdownSearch<String>));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      await tester.tap(find.text('São Paulo').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(referral.city, 'São Paulo');
      expect(referral.hasRegion, isTrue);
      expect(referral.regions, ['Zona Sul', 'Zona Norte']);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    });

    testWidgets('cidade sem regiões limpa a região escolhida', (tester) async {
      final referral = EmployeeReferralEntity(
        city: 'São Paulo',
        hasRegion: true,
        region: 'Zona Sul',
        regions: const ['Zona Sul', 'Zona Norte'],
      );
      await _pumpBody(tester, referral);

      await tester.tap(find.byType(DropdownSearch<String>));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      await tester.tap(find.text('Santos').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(referral.city, 'Santos');
      expect(referral.hasRegion, isFalse);
      expect(referral.region, isNull);
      expect(referral.regions, isEmpty);
    });

    testWidgets('escolher a região atualiza a indicação', (tester) async {
      final referral = EmployeeReferralEntity(
        city: 'São Paulo',
        hasRegion: true,
        regions: const ['Zona Sul', 'Zona Norte'],
      );
      await _pumpBody(tester, referral);

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      await tester.tap(find.text('Zona Norte').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(referral.region, 'Zona Norte');
    });

    testWidgets('a animação do formulário fica em looping', (tester) async {
      await _pumpBody(tester, EmployeeReferralEntity());

      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(seconds: 1));
      }

      expect(tester.takeException(), isNull);
    });

    testWidgets('digitar o nome atualiza a indicação', (tester) async {
      final referral = EmployeeReferralEntity();
      await _pumpBody(tester, referral);

      await tester.enterText(find.byType(TextFormField).first, 'Maria');
      await tester.pump();

      expect(referral.description, 'Maria');
    });
  });
}
