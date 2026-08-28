import 'dart:convert';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/home/domain/entity/home_item_enum.dart';
import 'package:morar/feature/home/presentation/bloc/home_bloc.dart';
import 'package:morar/feature/preferences/presentation/pages/home_cards/bloc/preferences_home_cards_state.dart';
import 'package:morar/feature/preferences/presentation/pages/home_cards/controller/preferences_home_cards_controller.dart';
import 'package:morar/feature/preferences/presentation/pages/home_cards/pages/preferences_home_cards_onboarding_page.dart';
import 'package:morar/feature/preferences/presentation/pages/home_cards/pages/preferences_home_cards_page.dart';
import 'package:morar/feature/preferences/presentation/pages/home_cards/widgets/preferences_home_cards_widget.dart';
import 'package:morar/feature/preferences/presentation/pages/home_cards/widgets/preferences_scroll_indicator.dart';
import 'package:shared_features/shared_features.dart' show SharedApplicationRoute;

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'preferences_page_helpers.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;
  late FakeHomeBloc homeBloc;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    homeBloc = FakeHomeBloc();
    await harness.override<HomeBloc>(homeBloc);
  });

  final routes = <String, WidgetBuilder>{
    ApplicationRoute.preferencesHome: (_) => const PreferencesHomeCardsPage(),
  };

  PreferencesHomeCardsController controller() =>
      harness.resolve<PreferencesHomeCardsController>();

  /// Corrigido: o builder da lista não agenda mais um `addPostFrameCallback`
  /// com `setState` a cada build (loop de rebuild por frame), e o bloc copia
  /// as listas ao emitir o estado carregado (o controller as altera in place
  /// e o Equatable via o estado igual). Com isso `pumpAndSettle` termina.
  Future<void> settle(WidgetTester tester) => tester.pumpAndSettle();

  /// Simula um usuário que já viu o onboarding, com [favorites] salvos.
  void seedPreferences({List<String>? favorites, bool onboarding = true}) {
    SharedPreferences.setMockInitialValues({
      if (onboarding) onboardingKey: jsonEncode({'onboarding': true}),
      if (favorites != null) favoritesKey: jsonEncode({'favorites': favorites}),
    });
  }

  Finder card(String text) => find.byWidgetPredicate(
      (w) => w is PreferencesHomeCardWidget && w.text == text,
      description: 'card $text');
  bool favorite(WidgetTester tester, String text) =>
      tester.widget<PreferencesHomeCardWidget>(card(text)).isFavorite;
  Future<void> tapCard(WidgetTester tester, String text) async {
    await tester.ensureVisible(card(text));
    await tester.pump();
    await tester.tap(card(text));
    await settle(tester);
  }
  VoidCallback? saveButton(WidgetTester tester) =>
      tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed;

  testWidgets('primeiro acesso abre o onboarding e o botão carrega os cards',
      (tester) async {
    seedPreferences(onboarding: false);

    await pumpPage(
      tester, settle: false,
      RouteLauncher(route: ApplicationRoute.preferencesHome),
      routes: routes,
      observer: observer,
      surface: const Size(400, 900),
    );
    await settle(tester);

    expect(find.byType(PreferencesHomeCardsOnboardingPage), findsOneWidget);
    expect(find.text('preferences_cards_onboarding_title'), findsOneWidget);
    expect(find.text('preferences_cards_onboarding_subtitle'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(onboardingKey), jsonEncode({'onboarding': true}));
    await expectLater(
      find.byType(PreferencesHomeCardsOnboardingPage),
      matchesGoldenFile('goldens/preferences_home_cards_onboarding_page.png'),
    );

    await tester.tap(find.text('preferences_cards_onboarding_btn'));
    await settle(tester);

    expect(find.byType(PreferencesHomeCardsOnboardingPage), findsNothing);
    expect(find.byType(PreferencesHomeCardsPage), findsOneWidget);
    expect(find.byType(PreferencesHomeCardWidget), findsWidgets);
    expect(controller().favorites, isEmpty);
  });

  testWidgets('voltar do onboarding retorna para a home', (tester) async {
    seedPreferences(onboarding: false);

    await pumpPage(
      tester, settle: false,
      RouteLauncher(route: ApplicationRoute.preferencesHome),
      routes: routes,
      observer: observer,
      surface: const Size(400, 900),
    );
    await settle(tester);
    expect(find.byType(PreferencesHomeCardsOnboardingPage), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await settle(tester);

    expect(find.byType(PreferencesHomeCardsOnboardingPage), findsNothing);
    expect(find.byType(PreferencesHomeCardsPage), findsNothing);
    expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
  });

  testWidgets('lista os cards com os favoritos salvos primeiro', (tester) async {
    seedPreferences(favorites: ['reserves', 'documents']);

    await pumpPage(tester, settle: false, const PreferencesHomeCardsPage(),
        surface: const Size(400, 900));
    await settle(tester);
    await settle(tester);

    expect(find.text('preferences_cards_tile'), findsOneWidget);
    expect(find.text('preferences_cards_home_title'), findsOneWidget);
    expect(find.text('preferences_cards_home_rule'), findsOneWidget);
    final cards = controller().cards;
    expect(cards.length, greaterThan(4));
    // Horta depende do remote config: fora da lista.
    expect(cards, isNot(contains(HomeItemEnum.horta)));
    expect(cards.take(2), [HomeItemEnum.reserves, HomeItemEnum.documents]);
    // Depois dos favoritos vêm os prioritários e então a ordem alfabética.
    expect(cards[2], HomeItemEnum.comfort);
    expect(cards[3], HomeItemEnum.agreements);
    expect(cards[4], HomeItemEnum.billets);
    final names = cards.skip(5).map((c) => c.text().toUpperCase()).toList();
    expect(names, [...names]..sort());
    expect(controller().favorites, [HomeItemEnum.reserves, HomeItemEnum.documents]);
    expect(favorite(tester, 'reserves'), isTrue);
    expect(favorite(tester, 'comfort'), isFalse);
    // Com menos de 4 favoritos o salvar fica desabilitado.
    expect(saveButton(tester), isNull);
    await expectLater(
      find.byType(PreferencesHomeCardsPage),
      matchesGoldenFile('goldens/preferences_home_cards_page.png'),
    );
  });

  testWidgets('favoritos vazios não marcam nada', (tester) async {
    seedPreferences(favorites: []);

    await pumpPage(tester, settle: false, const PreferencesHomeCardsPage(),
        surface: const Size(400, 900));
    await settle(tester);
    await settle(tester);

    expect(controller().favorites, isEmpty);
    expect(saveButton(tester), isNull);
  });

  testWidgets('tocar nos cards marca até 6 favoritos e salvar volta para a home',
      (tester) async {
    seedPreferences(favorites: ['reserves']);

    await pumpPage(
      tester, settle: false,
      RouteLauncher(route: ApplicationRoute.preferencesHome),
      routes: routes,
      observer: observer,
      surface: const Size(400, 900),
    );
    await settle(tester);

    // Desmarcar o favorito salvo e marcar outros.
    await tapCard(tester, 'reserves');
    expect(controller().favorites, isEmpty);
    expect(favorite(tester, 'reserves'), isFalse);

    for (final text in ['comfort', 'agreements', 'income_control_billets']) {
      await tapCard(tester, text);
    }
    expect(controller().favorites, hasLength(3));
    expect(saveButton(tester), isNull);

    await tapCard(tester, 'reserves');
    expect(controller().favorites, hasLength(4));
    expect(saveButton(tester), isNotNull);

    await tapCard(tester, 'documents');
    await tapCard(tester, 'cnd');
    expect(controller().favorites, hasLength(6));
    // O sétimo é ignorado; desmarcar um favorito continua permitido.
    await tapCard(tester, 'tdb');
    expect(controller().favorites, hasLength(6));
    expect(favorite(tester, 'tdb'), isFalse);
    await tapCard(tester, 'cnd');
    expect(controller().favorites, hasLength(5));

    await tester.tap(find.text('save'));
    await settle(tester);

    final prefs = await SharedPreferences.getInstance();
    expect(jsonDecode(prefs.getString(favoritesKey)!), {
      'favorites': [
        'comfort',
        'agreements',
        'income_control_billets',
        'reserves',
        'documents',
      ],
    });
    expect(homeBloc.getCardsCalls, 1);
    expect(find.byType(PreferencesHomeCardsPage), findsNothing);
    expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
    // dispose() limpa as listas do controller.
    expect(controller().cards, isEmpty);
    expect(controller().favorites, isEmpty);
  });

  testWidgets('erro mostra o widget de erro; retry recarrega e voltar fecha',
      (tester) async {
    seedPreferences(favorites: ['reserves']);

    await pumpPage(
      tester, settle: false,
      RouteLauncher(route: ApplicationRoute.preferencesHome),
      routes: routes,
      observer: observer,
      surface: const Size(400, 900),
    );
    await settle(tester);
    await emitState(tester, controller().bloc, const PreferencesHomeCardsFailedState(),
        settle: false);
    await settle(tester);

    expect(find.byType(ErrorHandlingWidget), findsOneWidget);
    expect(find.byType(PreferencesHomeCardWidget), findsNothing);
    expect(saveButton(tester), isNotNull);

    await tester.tap(find.text('error_handling_widget_button_reTry').first);
    await settle(tester);
    expect(find.byType(ErrorHandlingWidget), findsNothing);
    expect(find.byType(PreferencesHomeCardWidget), findsWidgets);

    await emitState(tester, controller().bloc, const PreferencesHomeCardsFailedState(),
        settle: false);
    await settle(tester);
    await tester.tap(find.text('back_to_the_previous_page'));
    await settle(tester);
    expect(find.byType(PreferencesHomeCardsPage), findsNothing);
    expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
  });

  testWidgets('loading mostra o indicador', (tester) async {
    seedPreferences(favorites: ['reserves']);
    await pumpPage(tester, settle: false, const PreferencesHomeCardsPage(),
        surface: const Size(400, 900));
    await settle(tester);
    await settle(tester);

    await emitState(tester, controller().bloc,
        const PreferencesHomeCardsLoadingState(),
        settle: false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('preferences_cards_home_rule'), findsNothing);
  });

  testWidgets('PreferencesHomeCardWidget mostra a estrela conforme favorito',
      (tester) async {
    var taps = 0;
    await pumpApp(
      tester,
      Wrap(children: [
        PreferencesHomeCardWidget(
          imagePath: 'assets/ic_documents.svg',
          text: 'documents',
          sessionBloc: harness.sessionBloc,
          isFavorite: true,
          onTap: () => taps++,
        ),
        PreferencesHomeCardWidget(
          imagePath: 'assets/ic_documents.svg',
          text: 'reserves',
          sessionBloc: harness.sessionBloc,
          isFavorite: false,
          onTap: () => taps++,
        ),
      ]),
      localized: true,
      shrinkWrap: false,
    );

    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.byIcon(Icons.star_border_outlined), findsOneWidget);
    expect(find.text('documents'), findsOneWidget);
    await tester.tap(find.text('reserves'));
    expect(taps, 1);
  });

  testWidgets('PreferencesScrollIndicator anima as setas em loop',
      (tester) async {
    await pumpApp(tester, PreferencesScrollIndicator(), settle: false);

    final painter = () => tester
        .widget<CustomPaint>(find.byType(CustomPaint).last)
        .painter as ArrowPainter;
    expect(painter().value, 0);
    await tester.pump(const Duration(milliseconds: 200));
    expect(painter().value, inInclusiveRange(1, 32));
    await tester.pump(const Duration(milliseconds: 300));
    expect(painter().value, inInclusiveRange(34, 65));
    await tester.pump(const Duration(milliseconds: 300));
    expect(painter().value, greaterThan(66));
    // Ao completar, repete do começo.
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump(const Duration(milliseconds: 100));
    expect(painter().value, lessThan(50));
    expect(ArrowPainter(value: 1).shouldRepaint(ArrowPainter(value: 2)), isTrue);
    expect(ArrowPainter(value: 1).shouldRepaint(ArrowPainter(value: 1)), isFalse);

    await tester.pumpWidget(const SizedBox());
  });
}
