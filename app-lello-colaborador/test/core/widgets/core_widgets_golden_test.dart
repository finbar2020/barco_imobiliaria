import 'package:colaborador/core/widgets/custom_app_bar.dart';
import 'package:colaborador/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('LoadingWidget mostra CircularProgressIndicator', (tester) async {
    await pumpApp(
      tester,
      const LoadingWidget(message: 'Carregando'),
      localized: true,
      settle: false,
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Carregando'), findsOneWidget);
    expect(find.text('please_wait'), findsOneWidget);
  });

  testWidgets('golden — CustomAppBar', (tester) async {
    await pumpApp(
      tester,
      const Scaffold(
        appBar: CustomAppBar(title: 'profile'),
        body: SizedBox.shrink(),
      ),
      wrapInScaffold: false,
      localized: true,
      surface: const Size(400, 140),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/custom_app_bar.png'),
    );
  });
}
