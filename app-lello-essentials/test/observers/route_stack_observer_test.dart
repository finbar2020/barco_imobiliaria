import 'package:essentials/observers/route_stack_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

Route<dynamic> _rota(String? nome) => PageRouteBuilder<dynamic>(
      settings: RouteSettings(name: nome),
      pageBuilder: (_, __, ___) => const SizedBox(),
    );

void main() {
  group('unitário', () {
    test('didPush adiciona o nome ou RouteWithoutName', () {
      final obs = RouteStackObserver();
      obs.didPush(_rota('/a'), null);
      obs.didPush(_rota(null), null);
      expect(obs.routeStack, ['/a', 'RouteWithoutName']);
    });

    test('didPop remove o topo com ou sem rota anterior nomeada', () {
      final obs = RouteStackObserver();
      obs.didPush(_rota('/a'), null);
      obs.didPush(_rota('/b'), null);
      obs.didPop(_rota('/b'), _rota('/a'));
      expect(obs.routeStack, ['/a']);
      obs.didPop(_rota('/a'), null);
      expect(obs.routeStack, isEmpty);
    });

    test('didPop com pilha vazia não lança', () {
      final obs = RouteStackObserver();
      obs.didPop(_rota('/a'), _rota(null));
      expect(obs.routeStack, isEmpty);
    });

    test('didRemove remove pelo nome ou o topo', () {
      final obs = RouteStackObserver();
      obs.didPush(_rota('/a'), null);
      obs.didPush(_rota('/b'), null);
      obs.didPush(_rota('/c'), null);
      obs.didRemove(_rota('/b'), null);
      expect(obs.routeStack, ['/a', '/c']);
      obs.didRemove(_rota(null), null);
      expect(obs.routeStack, ['/a']);
      obs.didRemove(_rota(null), null);
      obs.didRemove(_rota(null), null); // pilha vazia: erro capturado
      expect(obs.routeStack, isEmpty);
    });

    test('didReplace troca o topo, inclusive com pilha vazia', () {
      final obs = RouteStackObserver();
      obs.didReplace(newRoute: _rota('/a'), oldRoute: null);
      expect(obs.routeStack, ['/a']);
      obs.didReplace(newRoute: _rota('/b'), oldRoute: _rota('/a'));
      expect(obs.routeStack, ['/b']);
      obs.didReplace(newRoute: _rota(null), oldRoute: _rota('/b'));
      expect(obs.routeStack, ['RouteWithoutName']);
      final vazio = RouteStackObserver();
      vazio.didReplace(newRoute: null, oldRoute: null);
      expect(vazio.routeStack, ['RouteWithoutName']);
    });
  });

  testWidgets('integração com o Navigator', (tester) async {
    final obs = RouteStackObserver();
    await pumpApp(tester, const Text('home'), navigatorObserver: obs);
    expect(obs.routeStack, ['/']);
    final context = tester.element(find.text('home'));
    Navigator.pushNamed(context, '/a');
    await tester.pumpAndSettle();
    Navigator.pushReplacementNamed(tester.element(findRoute('/a')), '/b');
    await tester.pumpAndSettle();
    expect(obs.routeStack, ['/', '/b']);
    Navigator.pop(tester.element(findRoute('/b')));
    await tester.pumpAndSettle();
    expect(obs.routeStack, ['/']);
  });
}
