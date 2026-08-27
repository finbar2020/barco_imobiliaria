import 'package:essentials/ui/widget/button/primary_button.dart';
import 'package:essentials/ui/widget/dialogs/generic_success_bottom_sheet.dart';
import 'package:essentials/ui/widget/dialogs/success_status_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  Future<void> pumpAbridor(
    WidgetTester tester, {
    Widget? bottomActions,
    bool isDismissible = true,
    bool enableDrag = true,
    void Function(Object?)? onResult,
  }) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () async {
            final r = await GenericSuccessBottomSheet.show<String>(
              context,
              message: 'Mensagem do sheet',
              bottomActions: bottomActions,
              isDismissible: isDismissible,
              enableDrag: enableDrag,
            );
            onResult?.call(r);
          },
          child: const Text('abrir'),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
  }

  testWidgets('show abre o sheet com ícone, mensagem e botão fechar que faz pop',
      (tester) async {
    Object? resultado = 'não chamado';
    await pumpAbridor(tester, onResult: (r) => resultado = r);

    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.byType(GenericSuccessBottomSheet), findsOneWidget);
    expect(find.byType(SuccessStatusIcon), findsOneWidget);
    expect(find.text('Mensagem do sheet'), findsOneWidget);
    expect(find.text('close'), findsOneWidget);
    expect(find.byType(PrimaryButton), findsOneWidget);

    final sheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
    expect(sheet.backgroundColor, Colors.white);
    expect(sheet.enableDrag, isTrue);
    expect(sheet.shape, isA<RoundedRectangleBorder>());

    await tester.tap(find.text('close'));
    await tester.pumpAndSettle();
    expect(find.byType(GenericSuccessBottomSheet), findsNothing);
    expect(resultado, isNull, reason: 'fechar sem valor devolve null');
  });

  testWidgets('bottomActions substitui o botão padrão e pode devolver valor',
      (tester) async {
    Object? resultado;
    await pumpAbridor(
      tester,
      onResult: (r) => resultado = r,
      enableDrag: false,
      isDismissible: false,
      bottomActions: Builder(
        builder: (context) => TextButton(
          onPressed: () => Navigator.of(context).pop('ok'),
          child: const Text('Entendi'),
        ),
      ),
    );

    expect(find.text('close'), findsNothing);
    expect(find.byType(PrimaryButton), findsNothing);
    expect(find.text('Entendi'), findsOneWidget);
    expect(tester.widget<BottomSheet>(find.byType(BottomSheet)).enableDrag,
        isFalse);

    // Não dispensável: tocar fora não fecha.
    await tester.tapAt(const Offset(200, 20));
    await tester.pumpAndSettle();
    expect(find.text('Entendi'), findsOneWidget);

    await tester.tap(find.text('Entendi'));
    await tester.pumpAndSettle();
    expect(resultado, 'ok');
  });

  testWidgets('tocar fora fecha quando isDismissible', (tester) async {
    await pumpAbridor(tester);
    await tester.tapAt(const Offset(200, 20));
    await tester.pumpAndSettle();
    expect(find.byType(GenericSuccessBottomSheet), findsNothing);
  });

  testWidgets('golden', (tester) async {
    await pumpApp(
      tester,
      const GenericSuccessBottomSheet(message: 'Mensagem do sheet com duas linhas de texto'),
      locOverrides: const {'close': 'Fechar'},
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('../goldens/generic_success_bottom_sheet.png'),
    );
  });
}
