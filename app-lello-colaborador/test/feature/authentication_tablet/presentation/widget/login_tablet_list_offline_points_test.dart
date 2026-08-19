import 'dart:io';

import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_loaded_widget.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_list_offile_points_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

void main() {
  testWidgets('exibe loading inicial', (tester) async {
    // O atraso mantém o estado de loading visível: sem ele a busca resolve
    // antes do primeiro frame e o teste vira uma corrida.
    final scope = await installTestTabletAuth(
      delay: const Duration(milliseconds: 200),
    );
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      LoginTabletListOfflinePoints(
        condoRef: 'R1',
        changeStep: (_) {},
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 600),
      settle: false,
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();
  });

  testWidgets('exibe lista vazia', (tester) async {
    final scope = await installTestTabletAuth(empty: true);
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      LoginTabletListOfflinePoints(
        condoRef: 'R1',
        changeStep: (_) {},
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 600),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Não encontramos nenhum ponto pendente para envio.'),
      findsOneWidget,
    );
  });

  testWidgets('exibe falha e tenta novamente', (tester) async {
    final scope = await installTestTabletAuth(
      fail: true,
      delay: const Duration(milliseconds: 200),
    );
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      LoginTabletListOfflinePoints(
        condoRef: 'R1',
        changeStep: (_) {},
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 600),
      settle: false,
    );
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();

    expect(find.text('Falha ao buscar/enviar pontos.'), findsOneWidget);

    await tester.tap(find.text('Tentar novamente'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();
  });

  testWidgets('exibe pontos pendentes', (tester) async {
    final photo = File('${Directory.systemTemp.path}/colaborador_offline_photo.jpg');
    photo.writeAsBytesSync(List.filled(64, 1));
    addTearDown(() {
      if (photo.existsSync()) photo.deleteSync();
    });

    final scope = await installTestTabletAuth(
      points: [testPoint(photoPath: photo.path)],
    );
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      LoginTabletListOfflinePoints(
        condoRef: 'R1',
        changeStep: (_) {},
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 700),
    );
    await tester.pumpAndSettle();

    expect(find.text('Data'), findsOneWidget);
    expect(find.text('Status'), findsOneWidget);
    expect(find.text('Tipo de ponto'), findsOneWidget);
  });

  testWidgets('voltar altera step', (tester) async {
    final scope = await installTestTabletAuth(empty: true);
    addTearDown(scope.dispose);
    LoginTabletSteps? step;

    await pumpApp(
      tester,
      LoginTabletListOfflinePoints(
        condoRef: 'R1',
        changeStep: (s) => step = s,
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 600),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back_ios_rounded));
    await tester.pump();

    expect(step, LoginTabletSteps.condominiumName);
  });
}
