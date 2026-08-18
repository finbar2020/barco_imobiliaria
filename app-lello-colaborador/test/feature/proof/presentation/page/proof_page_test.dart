import 'package:colaborador/feature/proof/presentation/page/proof_page.dart';
import 'package:colaborador/feature/proof/presentation/widgets/proof_card_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';

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

void main() {
  setUp(() {
    PackageInfoPlatform.instance = _FakePackageInfo();
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
      if (find.text('proof_page_error_message').evaluate().isNotEmpty) break;
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(find.text('proof_page_error_message'), findsOneWidget);
    await tester.tap(find.text('back'));
    await tester.pump();
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
