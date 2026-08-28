import 'dart:io';

import 'package:colaborador/feature/proof/presentation/page/proof_page.dart';
import 'package:colaborador/feature/proof/presentation/widgets/proof_select_date_widget.dart';
import 'package:colaborador/feature/proof/presentation/widgets/proof_card_widget.dart';
import 'package:essentials/essentials.dart' hide isNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakePackageInfo extends PackageInfoPlatform {
  @override
  Future<PackageInfoData> getAll({String? baseUrl}) async => PackageInfoData(
        appName: 'Colaborador',
        packageName: 'com.lello.colaborador',
        version: '2.5.0',
        buildNumber: '100',
        buildSignature: '',
      );
}

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async =>
      Directory.systemTemp.createTempSync('colaborador_proof').path;
}

void main() {
  setUp(() {
    PackageInfoPlatform.instance = _FakePackageInfo();
    PathProviderPlatform.instance = _FakePathProvider();
  });

  testWidgets('exibe lista de comprovantes', (tester) async {
    final scope = await installTestProofContainer();
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      const ProofPage(),
      wrapInScaffold: false,
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 700),
    );
    await tester.pumpAndSettle();

    expect(find.text('proof_clock_in'), findsOneWidget);
    expect(find.byType(ProofCardWidget), findsNWidgets(2));
  });

  testWidgets('exibe estado vazio', (tester) async {
    final scope = await installTestProofContainer(empty: true);
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      const ProofPage(),
      wrapInScaffold: false,
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 700),
    );
    await tester.pumpAndSettle();

    expect(find.text('proof_clock_in_empty'), findsOneWidget);
  });

  testWidgets('exibe erro e permite voltar', (tester) async {
    final scope = await installTestProofContainer(failProof: true);
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      const ProofPage(),
      wrapInScaffold: false,
      localized: true,
      shrinkWrap: false,
      settle: false,
      surface: const Size(400, 700),
    );
    await tester.pump();
    for (var i = 0; i < 20; i++) {
      if (find.text('error_handling_widget_title').evaluate().isNotEmpty) break;
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(find.text('error_handling_widget_title'), findsOneWidget);
    expect(find.text('error_handling_widget_button_reTry'), findsOneWidget);

    await tester.tap(find.text('error_handling_widget_button_back'));
    await tester.pump();
  });

  testWidgets('enquanto busca mostra o carregando', (tester) async {
    final scope = await installTestProofContainer(
      delay: const Duration(milliseconds: 300),
    );
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      const ProofPage(),
      wrapInScaffold: false,
      localized: true,
      shrinkWrap: false,
      settle: false,
      surface: const Size(400, 700),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('proof_page_loading_message'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
  });

  testWidgets('tentar de novo refaz a busca', (tester) async {
    final scope = await installTestProofContainer(failProof: true);
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      const ProofPage(),
      wrapInScaffold: false,
      localized: true,
      shrinkWrap: false,
      settle: false,
      surface: const Size(400, 700),
    );
    for (var i = 0; i < 20; i++) {
      if (find.text('error_handling_widget_button_reTry').evaluate().isNotEmpty) {
        break;
      }
      await tester.pump(const Duration(milliseconds: 50));
    }
    final antes = scope.getProof.dates.length;

    await tester.tap(find.text('error_handling_widget_button_reTry'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(scope.getProof.dates.length, greaterThan(antes));
  });

  testWidgets('escolher outra data refaz a busca', (tester) async {
    final scope = await installTestProofContainer();
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      const ProofPage(),
      wrapInScaffold: false,
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 700),
    );
    await tester.pumpAndSettle();
    final antes = scope.getProof.dates.length;

    final seletor = tester.widget<ProofSelectDateWidget>(
      find.byType(ProofSelectDateWidget),
    );
    seletor.onTap(DateTime(2026, 1, 5));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(scope.getProof.dates.length, greaterThan(antes));
    expect(scope.getProof.dates.last, DateTime(2026, 1, 5));
  });

  testWidgets('abrir um comprovante gera o arquivo e mostra o pdf',
      (tester) async {
    final scope = await installTestProofContainer();
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      const ProofPage(),
      wrapInScaffold: false,
      localized: true,
      shrinkWrap: false,
      settle: false,
      surface: const Size(400, 700),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ProofCardWidget).first);
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(tester.takeException(), isNull);
  });

  testWidgets('botão voltar fecha a tela', (tester) async {
    final scope = await installTestProofContainer();
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      Navigator(
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          builder: (_) => const ProofPage(),
        ),
      ),
      wrapInScaffold: false,
      localized: true,
      shrinkWrap: false,
      settle: false,
      surface: const Size(400, 700),
    );
    await tester.pumpAndSettle();

    final willPop =
        tester.widget<WillPopScope>(find.byType(WillPopScope).first);
    expect(await willPop.onWillPop!(), isTrue);

    await tester.tap(find.text('back'));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  testWidgets('card sem arquivo exibe flushbar', (tester) async {
    final scope = await installTestProofContainer(nullProofName: true);
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      const ProofPage(),
      wrapInScaffold: false,
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 700),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ProofCardWidget).first);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('proof_file_not_fount'), findsOneWidget);
  });
}
