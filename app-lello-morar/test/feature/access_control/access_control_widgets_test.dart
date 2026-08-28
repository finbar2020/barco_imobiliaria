import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_state.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_store.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_cpf_dialog.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_day_selector_widget.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_delete_visit_dialog.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_delete_visitant_dialog.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_on_boarding_page.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_visitant_card.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'access_control_test_helpers.dart';

void main() {
  group('AccessControlVisitantCard', () {
    testWidgets('mostra nome, tipo de autorização e firma (golden)', (tester) async {
      var taps = 0;
      await pumpApp(
        tester,
        Column(
          children: [
            AccessControlVisitantCard(
              model: gest(),
              authorization: auth(type: 'PHONE'),
              onTap: () => taps++,
            ),
            const SizedBox(height: 8),
            AccessControlVisitantCard(
              model: gest(type: 'SERVICE', name: 'Pedro', business: 'Elétrica SA'),
              authorization: auth(type: 'ACESSO_GRANTED'),
              onTap: () {},
            ),
            const SizedBox(height: 8),
            AccessControlVisitantCard(
              model: AccessControl(type: 'SERVICE'),
              authorization: auth(type: 'PONTUAL'),
              onTap: () {},
            ),
          ],
        ),
        localized: true,
      );

      expect(find.text('Carlos Souza'), findsOneWidget);
      expect(find.text('access_control_phone'), findsOneWidget);
      expect(find.text('Recorrente'), findsOneWidget);
      expect(find.text('Elétrica SA'), findsOneWidget);
      expect(find.text('Pontual'), findsOneWidget);
      expect(find.text('access_control_provider'), findsOneWidget);

      await tester.tap(find.text('Carlos Souza'));
      expect(taps, 1);

      await expectLater(
        findGoldenSurface(),
        matchesGoldenFile('goldens/access_control_visitant_card.png'),
      );
    });
  });

  group('AccessControlOnBoardingPage', () {
    testWidgets('marca o indicador da página atual', (tester) async {
      await pumpApp(
        tester,
        const SizedBox(
          height: 500,
          child: AccessControlOnBoardingPage(
            assetPath: 'assets/access_onboarding_2.svg',
            title: 'access_control_onboarding_title_2',
            subtitle: 'access_control_onboarding_subtitle_2',
            currentPage: 1,
          ),
        ),
        localized: true,
        shrinkWrap: false,
        surface: const Size(400, 600),
      );
      expect(find.text('access_control_onboarding_title_2'), findsOneWidget);
      expect(find.text('access_control_onboarding_subtitle_2'), findsOneWidget);
      final indicators = tester.widgetList<AnimatedContainer>(find.byType(AnimatedContainer)).toList();
      expect(indicators, hasLength(3));
      final colors = indicators
          .map((i) => (i.decoration as BoxDecoration).color)
          .toList();
      expect(colors[1], isNot(colors[0]));
      expect(colors[0], colors[2]);
    });
  });

  group('diálogos', () {
    Future<void> pumpDialog(WidgetTester tester, Widget Function(BuildContext) builder) async {
      await pumpApp(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showDialog(context: context, builder: builder),
            child: const Text('abrir'),
          ),
        ),
        localized: true,
      );
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
    }

    testWidgets('AccessControlCpfDialog visitante: cancelar fecha, "vamos lá" chama onTap',
        (tester) async {
      final session = FakeSessionBloc();
      var taps = 0;
      await pumpDialog(
        tester,
        (_) => AccessControlCpfDialog(sessionBloc: session, isVisitant: true, onTap: () => taps++),
      );
      expect(find.text('access_control_cpf_visitant_title'), findsOneWidget);
      expect(find.text('access_control_cpf_visitant_subtitle'), findsOneWidget);

      await tester.tap(find.text('VAMOS LÁ'));
      await tester.pump();
      expect(taps, 1);

      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlCpfDialog), findsNothing);
    });

    testWidgets('AccessControlCpfDialog prestador', (tester) async {
      await pumpDialog(
        tester,
        (_) => AccessControlCpfDialog(sessionBloc: FakeSessionBloc(), isVisitant: false, onTap: () {}),
      );
      expect(find.text('access_control_cpf_provider_title'), findsOneWidget);
      expect(find.text('access_control_cpf_provider_subtitle'), findsOneWidget);
    });

    testWidgets('AccessControlDeleteVisitDialog', (tester) async {
      var taps = 0;
      await pumpDialog(
        tester,
        (_) => AccessControlDeleteVisitDialog(sessionBloc: FakeSessionBloc(), onTap: () => taps++),
      );
      expect(find.text('access_control_delete_visit'), findsOneWidget);
      expect(find.text('access_control_deleted_visit_confirm'), findsOneWidget);
      await tester.tap(find.text('EXCLUDE'));
      expect(taps, 1);
      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlDeleteVisitDialog), findsNothing);
    });

    testWidgets('AccessControlDeleteVisitantDialog visitante e prestador', (tester) async {
      var taps = 0;
      await pumpDialog(
        tester,
        (_) => AccessControlDeleteVisitantDialog(
            sessionBloc: FakeSessionBloc(), isVisitant: true, onTap: () => taps++),
      );
      expect(find.text('access_control_delete_visitor'), findsOneWidget);
      expect(find.text('access_control_deleted_confirm'), findsOneWidget);
      await tester.tap(find.text('EXCLUDE'));
      expect(taps, 1);
      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlDeleteVisitantDialog), findsNothing);

      await tester.pumpWidget(const SizedBox());
      await pumpDialog(
        tester,
        (_) => AccessControlDeleteVisitantDialog(
            sessionBloc: FakeSessionBloc(), isVisitant: false, onTap: () {}),
      );
      expect(find.text('access_control_delete_provider'), findsOneWidget);
      expect(find.text('access_control_deleted_confirm_provider'), findsOneWidget);
    });
  });

  group('DaySelector', () {
    late PageHarness harness;
    setUp(() async {
      harness = await installPageHarness();
    });

    testWidgets('alterna os dias e respeita os ignorados', (tester) async {
      final store = harness.resolve<AccessControlStore>();
      final state = setEditState(store, visitant: gest(), model: auth());

      await pumpApp(
        tester,
        DaySelector(
          accessControlStore: store,
          ignore: const [true, false, false, false, false, false, false],
        ),
      );

      expect(find.text('D'), findsOneWidget);
      expect(find.text('S'), findsNWidgets(3));
      expect(find.text('Q'), findsNWidgets(2));
      expect(state.model.choices, everyElement(isFalse));

      await tester.tap(find.text('T'));
      await tester.pump();
      expect(state.model.choices[2], isTrue);

      await tester.tap(find.text('T'));
      await tester.pump();
      expect(state.model.choices[2], isFalse);

      // domingo está ignorado
      await tester.tap(find.text('D'), warnIfMissed: false);
      await tester.pump();
      expect(state.model.choices[0], isFalse);
    });

    testWidgets('fora do estado de edição não renderiza nada', (tester) async {
      final store = harness.resolve<AccessControlStore>();
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      store.bloc.emit(const AccessControlLoadedState(visitants: [], providers: []));
      await pumpApp(
        tester,
        DaySelector(accessControlStore: store, ignore: const [false, false, false, false, false, false, false]),
      );
      expect(find.text('D'), findsNothing);
    });
  });
}
