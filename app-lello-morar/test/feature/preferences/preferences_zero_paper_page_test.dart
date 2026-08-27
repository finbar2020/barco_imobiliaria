import 'dart:convert';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/preferences/presentation/pages/zero_paper/bloc/preferences_zero_paper_state.dart';
import 'package:morar/feature/preferences/presentation/pages/zero_paper/controllers/preferences_zero_paper_controller.dart';
import 'package:morar/feature/preferences/presentation/pages/zero_paper/pages/preferences_zero_paper_page.dart';
import 'package:morar/feature/preferences/presentation/widget/preferences_checkbox.dart';
import 'package:morar/feature/preferences/presentation/widget/preferences_success_page.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';
import 'package:shared_features/shared_features.dart' show SharedApplicationRoute;

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'preferences_page_helpers.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
  });

  final routes = <String, WidgetBuilder>{
    ApplicationRoute.preferencesZeroPaper: (_) => const PreferencesZeroPaperPage(),
  };

  PreferencesZeroPaperController controller() =>
      harness.resolve<PreferencesZeroPaperController>();

  // Corrigido: as três colunas (rótulos / digital / impresso) usam Flexible,
  // então as chaves cruas (mais longas que o texto real) cabem em 400px.
  const loc = <String, String>{};

  void mockGet([Map<String, dynamic>? body]) =>
      harness.http.on('GET', zeroPaperPath, body: body ?? zeroPaperJson());

  /// Os 8 `PreferencesCheckBox` na ordem da árvore: 0-3 coluna digital
  /// (comunicados, atas, boletos, extratos), 4-7 coluna impresso.
  Finder box(int index) => find.byType(PreferencesCheckBox).at(index);
  bool checked(WidgetTester tester, int index) =>
      tester.widget<PreferencesCheckBox>(box(index)).checked;
  Future<void> tapBox(WidgetTester tester, int index) async {
    await tester.ensureVisible(box(index));
    await tester.tap(box(index));
    await tester.pumpAndSettle();
  }

  testWidgets('carrega as preferências e marca as caixas conforme a API',
      (tester) async {
    mockGet();

    await pumpPage(tester, locOverrides: loc, const PreferencesZeroPaperPage(),
        surface: const Size(400, 1000));

    expect(harness.http.requests.single.url.path, zeroPaperPath);
    expect(controller().bloc.state, isA<PreferencesZeroPaperLoadedState>());
    expect(find.text('Edifício Lello - 101'), findsOneWidget);
    expect(find.text('preferences_zero_paper_campaign'), findsOneWidget);
    expect(find.text('preferences_zero_paper_apply_all_units'), findsOneWidget);
    expect(find.byType(PreferencesCheckBox), findsNWidgets(8));
    // comunicados: digital; atas: impresso; boletos: ambos; extratos: nulo
    // (= ambos).
    expect([for (var i = 0; i < 8; i++) checked(tester, i)],
        [true, false, true, true, false, true, true, true]);
    await expectLater(
      find.byType(PreferencesZeroPaperPage),
      matchesGoldenFile('goldens/preferences_zero_paper_page.png'),
    );
  });

  testWidgets('não deixa desmarcar a única opção de cada linha', (tester) async {
    mockGet();
    await pumpPage(tester, locOverrides: loc, const PreferencesZeroPaperPage(),
        surface: const Size(400, 1000));

    // Comunicados só digital: tentar desmarcar digital não muda nada.
    await tapBox(tester, 0);
    expect(checked(tester, 0), isTrue);
    // Atas só impresso: idem para o impresso.
    await tapBox(tester, 5);
    expect(checked(tester, 5), isTrue);

    // Marcando o impresso de comunicados, o digital pode ser desmarcado.
    await tapBox(tester, 4);
    expect(checked(tester, 4), isTrue);
    await tapBox(tester, 0);
    expect(checked(tester, 0), isFalse);

    // Atas: marca digital e então desmarca o impresso.
    await tapBox(tester, 1);
    expect(checked(tester, 1), isTrue);
    await tapBox(tester, 5);
    expect(checked(tester, 5), isFalse);

    // Boletos (ambos): desmarca digital; o impresso passa a ser obrigatório.
    await tapBox(tester, 2);
    expect(checked(tester, 2), isFalse);
    await tapBox(tester, 6);
    expect(checked(tester, 6), isTrue);

    // Extratos (ambos): desmarca impresso; o digital passa a ser obrigatório.
    await tapBox(tester, 7);
    expect(checked(tester, 7), isFalse);
    await tapBox(tester, 3);
    expect(checked(tester, 3), isTrue);
  });

  testWidgets('salvar envia as escolhas e abre a tela de sucesso',
      (tester) async {
    mockGet();
    harness.http.on('PUT', zeroPaperPath, body: {});

    await pumpPage(tester, locOverrides: loc,
      RouteLauncher(route: ApplicationRoute.preferencesZeroPaper),
      routes: routes,
      observer: observer,
      surface: const Size(400, 1000),
    );

    // comunicados: ambos; atas: só digital; boletos: só impresso.
    await tapBox(tester, 4);
    await tapBox(tester, 1);
    await tapBox(tester, 5);
    await tapBox(tester, 2);
    await tester.ensureVisible(find.text('preferences_zero_paper_apply_all_units'));
    await tester.tap(find.text('preferences_zero_paper_apply_all_units'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('save'));
    await tester.tap(find.text('save'));
    await tester.pumpAndSettle();

    final put = harness.http.requests.lastWhere((r) => r.method == 'PUT');
    expect(put.url.path, zeroPaperPath);
    final body = jsonDecode(put.body) as Map<String, dynamic>;
    expect(body['zero_paper'], {
      'delivery_announcements': 'printed_digital',
      'delivery_acts': 'digital',
      'delivery_slips': 'printed',
      'delivery_statements': 'printed_digital',
      'all_units': true,
    });
    expect(controller().bloc.state, isA<PreferencesZeroPaperSuccessState>());
    expect(find.byType(PreferencesSuccessPage), findsOneWidget);
    expect(find.text('preferences_success'), findsOneWidget);
    expect(find.text('Edifício Lello - 101'), findsOneWidget);
    await expectLater(
      find.byType(PreferencesSuccessPage),
      matchesGoldenFile('goldens/preferences_success_page.png'),
    );

    await tester.tap(find.text('conclude'));
    await tester.pumpAndSettle();
    expect(find.byType(PreferencesSuccessPage), findsNothing);
    expect(find.byType(PreferencesZeroPaperPage), findsNothing);
    expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
  });

  testWidgets('"aplicar a todas as unidades" alterna a marcação',
      (tester) async {
    mockGet();
    harness.http.on('PUT', zeroPaperPath, body: {});
    await pumpPage(tester, locOverrides: loc, const PreferencesZeroPaperPage(),
        surface: const Size(400, 1000));

    final allUnits = find.text('preferences_zero_paper_apply_all_units');
    await tester.ensureVisible(allUnits);
    await tester.tap(allUnits);
    await tester.pumpAndSettle();
    await tester.tap(allUnits);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('save'));
    await tester.tap(find.text('save'));
    await tester.pumpAndSettle();

    final put = harness.http.requests.lastWhere((r) => r.method == 'PUT');
    expect(jsonDecode(put.body)['zero_paper']['all_units'], isFalse);
  });

  testWidgets('erro na busca mostra o widget de erro; retry recarrega',
      (tester) async {
    harness.http.failAll();

    await pumpPage(tester, locOverrides: loc, const PreferencesZeroPaperPage());
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);
    expect(find.text('back_to_the_previous_page'), findsOneWidget);

    mockGet();
    await tester.tap(find.text('error_handling_widget_button_reTry').first);
    await tester.pumpAndSettle();

    expect(find.byType(ErrorHandlingWidget), findsNothing);
    expect(find.byType(PreferencesCheckBox), findsNWidgets(8));
  });

  testWidgets('erro ao salvar mostra o erro e "voltar" fecha a tela',
      (tester) async {
    mockGet();
    harness.http.on('PUT', zeroPaperPath, status: 500, body: {'message': 'x'});

    await pumpPage(tester, locOverrides: loc,
      RouteLauncher(route: ApplicationRoute.preferencesZeroPaper),
      routes: routes,
      observer: observer,
      surface: const Size(400, 1000),
    );
    await tester.ensureVisible(find.text('save'));
    await tester.tap(find.text('save'));
    await tester.pumpAndSettle();

    expect(controller().bloc.state, isA<PreferencesZeroPaperFailureState>());
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);

    await tester.tap(find.text('back_to_the_previous_page'));
    await tester.pumpAndSettle();
    expect(find.byType(PreferencesZeroPaperPage), findsNothing);
    expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
  });

  testWidgets('sem condomínio na sessão vai direto para o erro',
      (tester) async {
    harness.sessionBloc.currentState = SessionLoadedState(Session());

    await pumpPage(tester, locOverrides: loc, const PreferencesZeroPaperPage());

    expect(harness.http.requests, isEmpty);
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);
  });

  testWidgets('loading mostra o indicador', (tester) async {
    mockGet();
    await pumpPage(tester, locOverrides: loc, const PreferencesZeroPaperPage());

    await emitState(tester, controller().bloc,
        const PreferencesZeroPaperLoadingState(),
        settle: false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('PreferencesCheckBox muda a cor conforme marcado', (tester) async {
    var taps = 0;
    await pumpApp(
      tester,
      Row(children: [
        PreferencesCheckBox(onTap: () => taps++, checked: true),
        PreferencesCheckBox(onTap: () => taps++, checked: false),
      ]),
    );

    final boxes = tester
        .widgetList<Container>(find.descendant(
            of: find.byType(PreferencesCheckBox),
            matching: find.byType(Container)))
        .map((c) => (c.decoration as BoxDecoration).color)
        .toList();
    expect(boxes.first, LelloTheme.light.primaryColor);
    expect(boxes.last, Colors.white);
    await tester.tap(find.byType(PreferencesCheckBox).first);
    await tester.tap(find.byType(PreferencesCheckBox).last);
    expect(taps, 2);
  });
}
