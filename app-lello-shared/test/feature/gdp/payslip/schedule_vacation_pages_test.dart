// Páginas de agendamento de férias que vivem na pasta payslip (cópias das
// páginas de vacation, com o botão "salvar" sem ação).
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull, Address;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/page/schedule_vacation_page.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/page/schedule_vacation_suceeded_page.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/schedule_vacation/schedule_vacation.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_bloc.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_state.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../../helpers/pump_app.dart';
import 'payslip_test_helpers.dart';

class _FakeScheduleVacation extends Fake implements ScheduleVacation {}

void main() {
  late PayslipEnv env;
  late RecordingNavigatorObserver observer;

  setUp(() {
    env = PayslipEnv();
    observer = RecordingNavigatorObserver();
  });

  group('ScheduleVacationPage (payslip)', () {
    late ScheduleVacationBloc bloc;

    Future<void> pumpSchedule(WidgetTester tester, {bool pushed = false}) async {
      bloc = ScheduleVacationBloc(
          scheduleVacation: _FakeScheduleVacation(),
          sessionBloc: env.session,
          appOriginEnum: AppOriginEnum.manager);
      final container = env.container()..register<ScheduleVacationBloc>(bloc);
      final page = ScheduleVacationPage(appContainer: container);
      final vacation = Vacation(employee: employee(name: 'Ana'), reference: 'R1');
      if (pushed) {
        await pumpPushed(tester, page, arguments: vacation, observer: observer);
      } else {
        await pumpPage(tester, page, arguments: vacation, observer: observer);
      }
    }

    testWidgets('mostra o funcionário, os campos e os botões', (tester) async {
      await pumpSchedule(tester);

      expect(find.text('gdp_vacation_schedule_page_title'), findsOneWidget);
      expect(find.text('gdp_vacation_schedule_employee'), findsOneWidget);
      expect(find.text('Ana'), findsOneWidget);
      expect(find.text('gdp_vacation_schedule_vacation_time'), findsOneWidget);
      expect(find.text('gdp_vacation_schedule_vacation_period'), findsOneWidget);
      expect(find.text('Defina a quantidade de periodos'), findsNWidgets(2));
      expect(find.text('gdp_vacation_schedule_save'), findsOneWidget);
      expect(find.text('gdp_vacation_schedule_cancel'), findsOneWidget);

      await expectLater(find.byType(ScheduleVacationPage),
          matchesGoldenFile('goldens/schedule_vacation_page_payslip.png'));
    });

    testWidgets('digitar nos campos atualiza o estado; salvar não faz nada',
        (tester) async {
      await pumpSchedule(tester);

      await tester.enterText(find.byType(TextFormField).at(0), '2');
      await tester.enterText(find.byType(TextFormField).at(1), '30');
      await tester.pump();
      expect(find.text('2'), findsOneWidget);
      expect(find.text('30'), findsOneWidget);

      // Pendência (não corrigido): o botão "salvar" está com a chamada ao bloc
      // comentada, e a chamada comentada
      // (`createScheduledVacation(reference, employeeId, period, days)`) não
      // bate com a API atual do bloc
      // (`createScheduledVacation(employeeId, VacationCreated)`). A tela não
      // coleta as datas de início, o abono nem a antecipação do 13º, então não
      // há como montar o `VacationCreated` sem inventar comportamento.
      await tester.tap(find.text('gdp_vacation_schedule_save'));
      await tester.pumpAndSettle();
      expect(bloc.state, isA<ScheduleVacationLoadedState>());
      expect(bloc.state.data, isNull);
      expect(observer.pushedNames.last, pageRouteName);
      expect(observer.pushedNames, hasLength(2));
    });

    testWidgets('cancelar volta para a tela anterior', (tester) async {
      await pumpSchedule(tester, pushed: true);
      await tester.tap(find.text('gdp_vacation_schedule_cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(ScheduleVacationPage), findsNothing);
      expect(find.byKey(const Key('host')), findsOneWidget);
    });

    testWidgets('quando o agendamento conclui navega para a tela de sucesso',
        (tester) async {
      await pumpSchedule(tester);
      final vacation = Vacation(employee: employee(name: 'Ana'));

      // ignore: invalid_use_of_visible_for_testing_member
      bloc.emit(ScheduleVacationLoadedState(vacation, 'C1'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last,
          SharedApplicationRoute.gdpScheduleVacationSucceeded);
      expect(observer.pushed.last.settings.arguments, isA<Vacation>());
      expect(findRoute(SharedApplicationRoute.gdpScheduleVacationSucceeded),
          findsOneWidget);
    });
  });

  group('ScheduleVacationSucceededPage (payslip)', () {
    testWidgets('mostra a mensagem e fechar volta para a home', (tester) async {
      await pumpPage(tester, ScheduleVacationSucceededPage(), observer: observer);

      expect(find.text('gdp_vacation_schedule_success_title'), findsOneWidget);
      expect(find.text('close'), findsOneWidget);
      await expectLater(find.byType(ScheduleVacationSucceededPage),
          matchesGoldenFile('goldens/schedule_vacation_succeeded_page_payslip.png'));

      await tester.tap(find.text('close'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, SharedApplicationRoute.home);
      expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
      expect(find.byType(ScheduleVacationSucceededPage), findsNothing);
    });
  });
}
