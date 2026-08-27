import 'package:essentials/modal/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('showBottomSheet abre o conteúdo e devolve o valor do pop',
      (tester) async {
    await pumpApp(tester, const Text('home'));
    final context = tester.element(find.text('home'));
    final futuro = Modal.showBottomSheet<String>(
      context: context,
      builder: (ctx) => TextButton(
        onPressed: () => Navigator.pop(ctx, 'escolhido'),
        child: const Text('opcao'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('opcao'), findsOneWidget);
    final sheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
    final shape = sheet.shape as RoundedRectangleBorder;
    expect(shape.borderRadius,
        const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)));
    await tester.tap(find.text('opcao'));
    await tester.pumpAndSettle();
    expect(await futuro, 'escolhido');
    expect(find.text('opcao'), findsNothing);
  });

  testWidgets('parâmetros opcionais são repassados', (tester) async {
    await pumpApp(tester, const Text('home'));
    final context = tester.element(find.text('home'));
    final futuro = Modal.showBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.red,
      isDismissible: false,
      showDragHandle: true,
      radius: 20,
      builder: (_) => const SizedBox(height: 100, child: Text('conteudo')),
    );
    await tester.pumpAndSettle();
    final sheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
    expect(sheet.backgroundColor, Colors.red);
    expect(sheet.showDragHandle, isTrue);
    expect((sheet.shape as RoundedRectangleBorder).borderRadius,
        const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)));
    // Não é dispensável tocando fora.
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.text('conteudo'), findsOneWidget);
    Navigator.pop(tester.element(find.text('conteudo')));
    await tester.pumpAndSettle();
    expect(await futuro, isNull);
  });
}
