import 'package:essentials/extension/navigator_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('pushNamedAndPopUntil remove rotas até o predicado ser verdadeiro',
      (tester) async {
    final observer = RecordingNavigatorObserver();
    await pumpApp(tester, const Text('home'), navigatorObserver: observer);
    final context = tester.element(find.text('home'));

    Navigator.pushNamed(context, '/a');
    await tester.pumpAndSettle();
    Navigator.pushNamed(context, '/b');
    await tester.pumpAndSettle();
    expect(findRoute('/b'), findsOneWidget);

    final ctxB = tester.element(findRoute('/b'));
    pushNamedAndPopUntil(ctxB, '/c', (route) => route.settings.name == '/a',
        arguments: 'arg');
    await tester.pumpAndSettle();

    expect(findRoute('/c'), findsOneWidget);
    expect(observer.pushedNames, ['/', '/a', '/b', '/c']);
    // /b foi removida; /a continua na pilha abaixo de /c.
    Navigator.pop(tester.element(findRoute('/c')));
    await tester.pumpAndSettle();
    expect(findRoute('/a'), findsOneWidget);
  });

  testWidgets('predicado nunca verdadeiro remove tudo', (tester) async {
    await pumpApp(tester, const Text('home'));
    final context = tester.element(find.text('home'));
    Navigator.pushNamed(context, '/a');
    await tester.pumpAndSettle();
    pushNamedAndPopUntil(
        tester.element(findRoute('/a')), '/c', (route) => false);
    await tester.pumpAndSettle();
    expect(findRoute('/c'), findsOneWidget);
    expect(Navigator.of(tester.element(findRoute('/c'))).canPop(), isFalse);
  });
}
