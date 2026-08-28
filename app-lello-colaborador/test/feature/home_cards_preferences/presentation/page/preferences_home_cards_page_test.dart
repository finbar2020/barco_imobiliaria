import 'dart:convert';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/home_cards_preferences/bloc/preferences_home_cards_bloc.dart';
import 'package:colaborador/feature/home_cards_preferences/bloc/preferences_home_cards_state.dart';
import 'package:colaborador/feature/home_cards_preferences/controller/preferences_home_cards_controller.dart';
import 'package:colaborador/feature/home_cards_preferences/pages/preferences_home_cards_onboarding_page.dart';
import 'package:colaborador/feature/home_cards_preferences/pages/preferences_home_cards_page.dart';
import 'package:colaborador/feature/home_cards_preferences/widgets/preferences_home_cards_widget.dart';
import 'package:essentials/essentials.dart' hide isNotNull, isNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

late PreferencesHomeCardsBloc _bloc;

Future<PreferencesHomeCardsController> _install({
  bool onboardingDone = true,
}) async {
  final scope = await installTestApplicationContainer();
  addTearDown(scope.dispose);

  final cpf = scope.sessionBloc.getSession!.me.cpf;
  final key = 'PREFERENCES_HOME_CARDS_ONBOARDING_EMPLOYEE$cpf';
  // Escreve na store já mockada pelo container: um novo
  // setMockInitialValues derrubaria as leituras em andamento.
  final preferences = await SharedPreferences.getInstance();
  if (onboardingDone) {
    await preferences.setString(key, json.encode({'onboarding': true}));
  } else {
    await preferences.remove(key);
  }

  _bloc = PreferencesHomeCardsBloc();
  final controller = PreferencesHomeCardsController(
    bloc: _bloc,
    sessionBloc: scope.sessionBloc,
  );
  ApplicationContainer.instance()
      .locator
      .registerSingleton<PreferencesHomeCardsController>(controller);
  return controller;
}

Future<void> _pumpPage(WidgetTester tester) async {
  await pumpApp(
    tester,
    const PreferencesHomeCardsPage(),
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    settle: false,
    surface: const Size(500, 900),
  );
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  tearDown(resetTestApplicationContainer);

  group('PreferencesHomeCardsPage', () {
    testWidgets('exibe os cards disponíveis para favoritar', (tester) async {
      final controller = await _install();
      await _pumpPage(tester);

      expect(find.text('preferences_cards_tile'), findsOneWidget);
      expect(find.text('preferences_cards_home_title'), findsOneWidget);
      expect(
        find.byType(PreferencesHomeCardWidget),
        findsNWidgets(controller.cards.length),
      );
      expect(controller.cards, isNotEmpty);
    });

    testWidgets('exibe a regra de escolha quando há mais de 4 cards',
        (tester) async {
      final controller = await _install();
      await _pumpPage(tester);

      expect(controller.cards.length > 4, isTrue);
      expect(find.text('preferences_cards_home_rule'), findsOneWidget);
    });

    testWidgets('salvar fica bloqueado com menos de 4 favoritos',
        (tester) async {
      await _install();
      await _pumpPage(tester);

      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNull,
      );
    });

    testWidgets('salvar libera ao escolher 4 favoritos', (tester) async {
      final controller = await _install();
      await _pumpPage(tester);

      for (var i = 0; i < 4; i++) {
        controller.onTap(i);
        await tester.pump();
      }

      expect(controller.favorites.length, 4);
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNotNull,
      );
    });

    testWidgets('favoritar o mesmo card duas vezes desfaz a escolha',
        (tester) async {
      final controller = await _install();
      await _pumpPage(tester);

      controller.onTap(0);
      await tester.pump();
      expect(controller.favorites.length, 1);

      controller.onTap(0);
      await tester.pump();
      expect(controller.favorites, isEmpty);
    });

    testWidgets('tocar no card favorita pela interface', (tester) async {
      final controller = await _install();
      await _pumpPage(tester);

      await tester.tap(find.byType(PreferencesHomeCardWidget).first);
      await tester.pump();

      expect(controller.favorites, hasLength(1));
    });

    testWidgets('salvar com 4 favoritos chama o controller', (tester) async {
      final controller = await _install();
      await _pumpPage(tester);
      for (var i = 0; i < 4; i++) {
        controller.onTap(i);
      }
      await tester.pump();

      await tester.tap(find.text('save'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(tester.takeException(), isNull);
    });

    testWidgets('falha ao carregar mostra o erro com opção de tentar de novo',
        (tester) async {
      await _install();
      await _pumpPage(tester);

      _bloc.emit(PreferencesHomeCardsFailedState());
      await tester.pump();

      expect(find.text('error_handling_widget_title'), findsOneWidget);

      await tester.tap(find.text('error_handling_widget_button_reTry'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(tester.takeException(), isNull);
    });

    testWidgets('rolar a lista esconde o indicador de rolagem',
        (tester) async {
      await _install();
      await _pumpPage(tester);

      await tester.drag(find.byType(ListView).first, const Offset(0, -200));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(tester.takeException(), isNull);
    });

    testWidgets('primeira visita abre o onboarding', (tester) async {
      await _install(onboardingDone: false);
      await _pumpPage(tester);

      expect(find.byType(PreferencesHomeCardsOnboardingPage), findsOneWidget);
    });
  });
}
