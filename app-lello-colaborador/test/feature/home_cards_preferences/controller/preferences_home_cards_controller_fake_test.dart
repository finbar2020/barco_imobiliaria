import 'dart:convert';

import 'package:colaborador/feature/home/domain/entity/home_item_enum.dart';
import 'package:colaborador/feature/home_cards_preferences/bloc/preferences_home_cards_bloc.dart';
import 'package:colaborador/feature/home_cards_preferences/bloc/preferences_home_cards_state.dart';
import 'package:colaborador/feature/home_cards_preferences/controller/preferences_home_cards_controller.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/pump_app.dart';

class _SessionBlocFake extends Fake implements SessionBloc {
  @override
  SessionState get state => SessionLoadedState(
        session: testSession(),
        isTabletSession: false,
      );

  @override
  Stream<SessionState> get stream => const Stream.empty();

  @override
  Session? get getSession => testSession();

  @override
  bool checkRback(String rbac) => true;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PreferencesHomeCardsController', () {
    test('checkShowOnboarding e checkFavoritesCard', () {
      final bloc = PreferencesHomeCardsBloc();
      addTearDown(bloc.close);
      final controller = PreferencesHomeCardsController(
        bloc: bloc,
        sessionBloc: _SessionBlocFake(),
      );

      expect(controller.checkShowOnboarding(null), isTrue);
      expect(
        controller.checkShowOnboarding(json.encode({'onboarding': true})),
        isFalse,
      );

      controller.checkFavoritesCard(
        json.encode({'favorites': [HomeItemEnum.proof.titleKey]}),
      );
      expect(controller.favorites, contains(HomeItemEnum.proof));
    });

    testWidgets('getCards carrega favoritos salvos', (tester) async {
      SharedPreferences.setMockInitialValues({
        'PREFERENCES_HOME_CARDS_EMPLOYEE': json.encode({
          'favorites': [HomeItemEnum.proof.titleKey],
        }),
        'PREFERENCES_HOME_CARDS_ONBOARDING_EMPLOYEE':
            json.encode({'onboarding': true}),
      });

      final bloc = PreferencesHomeCardsBloc();
      addTearDown(bloc.close);
      final controller = PreferencesHomeCardsController(
        bloc: bloc,
        sessionBloc: _SessionBlocFake(),
      );

      late BuildContext context;
      await pumpApp(
        tester,
        Builder(
          builder: (ctx) {
            context = ctx;
            return const SizedBox.shrink();
          },
        ),
        localized: true,
      );
      await controller.getCards(context);

      final state = await bloc.stream.firstWhere(
        (s) => s is PreferencesHomeCardsLoadedState,
      ) as PreferencesHomeCardsLoadedState;

      expect(state.favorites, contains(HomeItemEnum.proof));
      expect(state.cards, isNotEmpty);
    });

    testWidgets('onTap alterna favoritos até o limite', (tester) async {
      final bloc = PreferencesHomeCardsBloc();
      addTearDown(bloc.close);
      final controller = PreferencesHomeCardsController(
        bloc: bloc,
        sessionBloc: _SessionBlocFake(),
      );

      await pumpApp(
        tester,
        Builder(
          builder: (context) {
            controller.cards = [
              HomeItemEnum.proof,
              HomeItemEnum.benefits,
              HomeItemEnum.discounts,
            ];
            controller.onTap(0);
            controller.onTap(1);
            return const SizedBox.shrink();
          },
        ),
        localized: true,
      );

      expect(controller.favorites, hasLength(2));
      controller.onTap(0);
      expect(controller.favorites, hasLength(1));
    });

    testWidgets('savePreferences persiste favoritos', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final bloc = PreferencesHomeCardsBloc();
      addTearDown(bloc.close);
      final controller = PreferencesHomeCardsController(
        bloc: bloc,
        sessionBloc: _SessionBlocFake(),
      );
      controller.favorites = [HomeItemEnum.proof];
      controller.cards = [HomeItemEnum.proof, HomeItemEnum.benefits];
      controller.preferences = await SharedPreferences.getInstance();

      late BuildContext context;
      await pumpApp(
        tester,
        Builder(
          builder: (ctx) {
            context = ctx;
            return const SizedBox.shrink();
          },
        ),
        localized: true,
      );
      await controller.savePreferences(context);

      final state = await bloc.stream.firstWhere(
        (s) => s is PreferencesHomeCardsLoadedState && s.success,
      );
      expect(state, isA<PreferencesHomeCardsLoadedState>());

      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('PREFERENCES_HOME_CARDS_EMPLOYEE');
      expect(raw, contains(HomeItemEnum.proof.titleKey));
    });

    testWidgets('saveOnboardingInfo persiste flag', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final bloc = PreferencesHomeCardsBloc();
      addTearDown(bloc.close);
      final controller = PreferencesHomeCardsController(
        bloc: bloc,
        sessionBloc: _SessionBlocFake(),
      );
      controller.preferences = await SharedPreferences.getInstance();

      late BuildContext context;
      await pumpApp(
        tester,
        Builder(
          builder: (ctx) {
            context = ctx;
            return const SizedBox.shrink();
          },
        ),
        localized: true,
      );
      await controller.saveOnboardingInfo(context);

      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('PREFERENCES_HOME_CARDS_ONBOARDING_EMPLOYEE');
      expect(raw, contains('onboarding'));
    });

    test('dispose limpa listas', () {
      final bloc = PreferencesHomeCardsBloc();
      addTearDown(bloc.close);
      final controller = PreferencesHomeCardsController(
        bloc: bloc,
        sessionBloc: _SessionBlocFake(),
      );
      controller.cards = [HomeItemEnum.proof];
      controller.favorites = [HomeItemEnum.benefits];
      controller.dispose();
      expect(controller.cards, isEmpty);
      expect(controller.favorites, isEmpty);
    });

    testWidgets('getCards exibe onboarding na primeira vez', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final bloc = PreferencesHomeCardsBloc();
      addTearDown(bloc.close);
      final controller = PreferencesHomeCardsController(
        bloc: bloc,
        sessionBloc: _SessionBlocFake(),
      );

      late BuildContext context;
      await pumpApp(
        tester,
        Builder(
          builder: (ctx) {
            context = ctx;
            return const SizedBox.shrink();
          },
        ),
        localized: true,
      );
      await controller.getCards(context);

      final state = await bloc.stream.firstWhere(
        (s) => s is PreferencesHomeCardsLoadedState,
      ) as PreferencesHomeCardsLoadedState;
      expect(state.showOnboarding, isTrue);
    });

    testWidgets('ordenedCardsList prioriza favoritos e descontos', (tester) async {
      final bloc = PreferencesHomeCardsBloc();
      addTearDown(bloc.close);
      final controller = PreferencesHomeCardsController(
        bloc: bloc,
        sessionBloc: _SessionBlocFake(),
      );
      controller.favorites = [HomeItemEnum.proof];

      await pumpApp(
        tester,
        Builder(
          builder: (context) {
            controller.ordenedCardsList(context);
            return const SizedBox.shrink();
          },
        ),
        localized: true,
      );

      expect(controller.cards.first, HomeItemEnum.proof);
      expect(controller.cards, contains(HomeItemEnum.discounts));
    });

    test('onTap respeita limite de seis favoritos', () {
      final bloc = PreferencesHomeCardsBloc();
      addTearDown(bloc.close);
      final controller = PreferencesHomeCardsController(
        bloc: bloc,
        sessionBloc: _SessionBlocFake(),
      );
      controller.cards = HomeItemEnum.values.take(8).toList();
      for (var i = 0; i < 6; i++) {
        controller.onTap(i);
      }
      expect(controller.favorites, hasLength(6));
      controller.onTap(6);
      expect(controller.favorites, hasLength(6));
      controller.onTap(0);
      expect(controller.favorites, hasLength(5));
    });

    test('checkFavoritesCard ignora json vazio', () {
      final bloc = PreferencesHomeCardsBloc();
      addTearDown(bloc.close);
      final controller = PreferencesHomeCardsController(
        bloc: bloc,
        sessionBloc: _SessionBlocFake(),
      );
      controller.checkFavoritesCard(json.encode({'favorites': []}));
      expect(controller.favorites, isEmpty);
    });
  });
}
