import 'package:essentials/ui/widget/gesture/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('tocar fora do campo remove o foco', (tester) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await pumpApp(
      tester,
      DismissKeyboard(
        child: Column(
          children: [
            TextField(focusNode: focus),
            const SizedBox(height: 200, child: Text('área livre')),
          ],
        ),
      ),
      shrinkWrap: false,
    );
    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(focus.hasFocus, isTrue);

    await tester.tap(find.text('área livre'));
    await tester.pump();
    expect(focus.hasFocus, isFalse);
  });

  testWidgets('sem foco em campo nenhum, tocar não faz nada', (tester) async {
    await pumpApp(
      tester,
      const DismissKeyboard(child: SizedBox(height: 100, child: Text('x'))),
    );
    await tester.tap(find.text('x'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byType(GestureDetector), findsWidgets);
  });

  testWidgets('escopo com foco primário não é desfocado', (tester) async {
    final scopeNode = FocusScopeNode();
    addTearDown(scopeNode.dispose);
    await pumpApp(
      tester,
      FocusScope(
        node: scopeNode,
        child: const DismissKeyboard(
            child: SizedBox(height: 100, child: Text('x'))),
      ),
    );
    scopeNode.requestFocus();
    await tester.pump();
    expect(scopeNode.hasPrimaryFocus, isTrue);
    await tester.tap(find.text('x'));
    await tester.pump();
    expect(scopeNode.hasPrimaryFocus, isTrue);
  });
}
