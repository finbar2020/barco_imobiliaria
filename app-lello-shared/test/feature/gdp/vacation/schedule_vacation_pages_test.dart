import 'dart:convert';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_bloc.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_state.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/schedule_vacation_details_page.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/schedule_vacation_failure_page.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/schedule_vacation_page.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/schedule_vacation_suceeded_page.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/schedule_vacation_summary_page.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/vacation_page.dart';
import 'package:shared_features/shared_features.dart';

import '../../../helpers/firebase_mocks.dart';
import '../../../helpers/pump_app.dart';
import 'vacation_test_helpers.dart';

void main() {
  late VacationEnv env;
  late RecordingNavigatorObserver observer;
  late ScheduleVacationBloc bloc;

  setUpAll(() async {
    await setUpFakeFirebase();
  });

  setUp(() {
    env = VacationEnv();
    observer = RecordingNavigatorObserver();
  });

  group('ScheduleVacationSummaryPage', () {
    Future<void> pumpSummary(WidgetTester tester,
        {List<PeriodConfig>? configs,
        bool settle = true,
        Size surface = const Size(400, 900)}) async {
      bloc = env.scheduleBloc();
      await pumpPage(
        tester,
        ScheduleVacationSummaryPage(appContainer: env.container(schedule: bloc)),
        arguments: ScheduleVacationSummaryPageArgs(
            configs ?? [periodConfig()], bloc),
        observer: observer,
        settle: settle,
        surface: surface,
      );
    }

    testWidgets('mostra o resumo de um período', (tester) async {
      await pumpSummary(tester);

      expect(find.text('gdp_vacation_title'), findsOneWidget);
      expect(find.text('gdp_vacation_employee_code'), findsOneWidget);
      expect(find.text('M123'), findsOneWidget);
      expect(find.text('gdp_vacation_employee_name'), findsOneWidget);
      expect(find.text('Fulano de Tal'), findsOneWidget);
      expect(find.text('04/03/2020'), findsOneWidget);
      expect(find.text('01/01/2029 a 31/12/2029 '), findsOneWidget);
      expect(find.text('gdp_vacation_period'), findsOneWidget);
      expect(find.text('10/01/2030'), findsOneWidget);
      expect(find.text('08/02/2030'), findsOneWidget);
      expect(find.text('30'), findsOneWidget);
      expect(find.text('0.0'), findsOneWidget);
      expect(find.text('gdp_vacation_employee_superannuation'), findsOneWidget);
      expect(find.text('no'), findsOneWidget);
      expect(find.text('gdp_vacation_employee_schedule'), findsOneWidget);
    });

    testWidgets('golden do resumo', (tester) async {
      await pumpSummary(tester);
      await expectLater(find.byType(ScheduleVacationSummaryPage),
          matchesGoldenFile('goldens/schedule_vacation_summary_page.png'));
    });

    testWidgets('com três períodos numera as seções', (tester) async {
      await pumpSummary(tester, surface: const Size(400, 1400), configs: [
        periodConfig(days: 10),
        periodConfig(start: DateTime(2030, 3, 1), days: 10),
        periodConfig(start: DateTime(2030, 5, 1), days: 10),
      ]);
      expect(find.text('1 - gdp_vacation_period'), findsOneWidget);
      expect(find.text('2 - gdp_vacation_period'), findsOneWidget);
      expect(find.text('3 - gdp_vacation_period'), findsOneWidget);
      expect(find.text('01/03/2030'), findsOneWidget);
      expect(find.text('10/03/2030'), findsOneWidget);
    });

    testWidgets('confirmar no diálogo agenda as férias e vai ao sucesso',
        (tester) async {
      env.http.on('POST', createVacationPath, body: vacationCreatedJson());
      await pumpSummary(tester, configs: [
        periodConfig(allowance: 10, allow13: 'S', formatedAllow13: 'yes'),
        periodConfig(start: DateTime(2030, 3, 1), days: 10),
      ], surface: const Size(400, 1200));

      await tester.tap(find.text('gdp_vacation_employee_schedule'));
      await tester.pumpAndSettle();
      expect(find.text('chat_error_title!'), findsOneWidget);
      expect(find.text('gdp_vacation_confirm_message'), findsOneWidget);

      // Cancelar fecha o diálogo sem chamar a API.
      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();
      expect(find.text('gdp_vacation_confirm_message'), findsNothing);
      expect(env.http.requests, isEmpty);

      await tester.tap(find.text('gdp_vacation_employee_schedule'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONFIRM'));
      await tester.pumpAndSettle();

      expect(bloc.state, const ScheduleVacationLoadedState(null, condominiumId));
      final request = env.http.requests.single;
      // Corrigido: o id enviado na URL é o id do funcionário (antes ia a
      // matrícula); a matrícula continua no corpo.
      expect(request.url.path, createVacationPath);
      expect(request.url.path, contains('/employees/$employeeId/'));
      final body = jsonDecode(request.body);
      expect(body['employee_id'], employeeId);
      expect(body['company'], 7);
      expect(body['employee_registration_number'], 'M123');
      expect(body['salary_allowance'], 10);
      expect(body['advance13'], 'S');
      expect(body['numbers_unit_vacation'], 2);
      expect(body['vacation_scheduled_periods'], hasLength(2));
      expect(body['vacation_scheduled_periods'][0]['scheduled_days'], 30);
      expect(body['vacation_scheduled_periods'][0]['total_vacation'], 1);
      expect(body['vacation_scheduled_periods'][1]['total_vacation'], 2);
      expect(body['vacation_scheduled_periods'][1]['start_date'],
          startsWith('2030-03-01'));

      expect(observer.pushedNames.last,
          SharedApplicationRoute.gdpScheduleVacationSucceeded);
      expect(findRoute(SharedApplicationRoute.gdpScheduleVacationSucceeded),
          findsOneWidget);
    });

    testWidgets('falha da API vai para a tela de falha com o erro',
        (tester) async {
      env.http.on('POST', createVacationPath, status: 406, body: {
        'status': 406,
        'title': 'Conflito',
        'detail': 'Período já agendado',
      });
      await pumpSummary(tester);

      await tester.tap(find.text('gdp_vacation_employee_schedule'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONFIRM'));
      await tester.pumpAndSettle();

      expect(bloc.state, isA<ScheduleVacationLoadFailedState>());
      expect(observer.pushedNames.last,
          SharedApplicationRoute.gdpScheduleVacationFailure);
      final args = observer.pushed.last.settings.arguments
          as ScheduleVacationFailurePageArgs;
      expect(args.faliure, isA<KnownFailure>());
      expect(args.faliure.code, 'Conflito');
    });

    testWidgets('estado de carregamento mostra o indicador', (tester) async {
      await pumpSummary(tester);
      // ignore: invalid_use_of_visible_for_testing_member
      bloc.emit(const ScheduleVacationLoadingState(null, condominiumId));
      await tester.pump();
      await tester.pump();
      expect(find.byType(LoadingWidget), findsOneWidget);
      expect(find.text('gdp_vacation_employee_schedule'), findsNothing);
    });
  });

  group('ScheduleVacationDetailsPage', () {
    Future<void> pumpDetails(WidgetTester tester,
        {List<PeriodConfig>? configs}) async {
      bloc = env.scheduleBloc();
      await pumpPage(
        tester,
        ScheduleVacationDetailsPage(appContainer: env.container(schedule: bloc)),
        arguments: ScheduleVacationDetailsPageArgs(
            configs ?? [periodConfig(formatedAllow13: 'yes')], bloc),
        observer: observer,
        surface: const Size(400, 1000),
      );
    }

    testWidgets('mostra os detalhes e volta', (tester) async {
      await pumpDetails(tester);

      expect(find.text('M123'), findsOneWidget);
      expect(find.text('Fulano de Tal'), findsOneWidget);
      expect(find.text('gdp_vacation_period'), findsOneWidget);
      expect(find.text('10/01/2030'), findsOneWidget);
      expect(find.text('08/02/2030'), findsOneWidget);
      expect(find.text('yes'), findsOneWidget);
      expect(find.text('gdp_vacation_employee_schedule'), findsNothing);

      await tester.tap(find.text('back'));
      await tester.pumpAndSettle();
      expect(observer.popped, isNotEmpty);
    });

    testWidgets('golden dos detalhes com dois períodos', (tester) async {
      await pumpDetails(tester, configs: [
        periodConfig(days: 15),
        periodConfig(start: DateTime(2030, 7, 1), days: 15),
      ]);
      expect(find.text('1 - gdp_vacation_period'), findsOneWidget);
      expect(find.text('2 - gdp_vacation_period'), findsOneWidget);
      await expectLater(find.byType(ScheduleVacationDetailsPage),
          matchesGoldenFile('goldens/schedule_vacation_details_page.png'));
    });

    testWidgets('reage aos estados do bloc: sucesso, falha e carregando',
        (tester) async {
      await pumpDetails(tester);

      // ignore: invalid_use_of_visible_for_testing_member
      bloc.emit(const ScheduleVacationLoadingState(null, condominiumId));
      await tester.pump();
      await tester.pump();
      expect(find.byType(LoadingWidget), findsOneWidget);

      // ignore: invalid_use_of_visible_for_testing_member
      bloc.emit(const ScheduleVacationLoadedState(null, condominiumId));
      await tester.pumpAndSettle();
      expect(observer.pushedNames.last,
          SharedApplicationRoute.gdpScheduleVacationSucceeded);

      // ignore: invalid_use_of_visible_for_testing_member
      bloc.emit(ScheduleVacationLoadFailedState(
          null, condominiumId, UnknownFailure('x')));
      await tester.pumpAndSettle();
      expect(observer.pushedNames.last,
          SharedApplicationRoute.gdpScheduleVacationFailure);
      final args = observer.pushed.last.settings.arguments
          as ScheduleVacationFailurePageArgs;
      expect(args.faliure, isA<UnknownFailure>());
    });
  });

  group('ScheduleVacationSucceededPage', () {
    testWidgets('mostra o sucesso e fechar volta para a home', (tester) async {
      await pumpPage(tester, ScheduleVacationSucceededPage(), observer: observer);

      expect(find.text('gdp_vacation_schedule_success_title'), findsOneWidget);
      await expectLater(find.byType(ScheduleVacationSucceededPage),
          matchesGoldenFile('goldens/schedule_vacation_succeeded_page.png'));

      await tester.tap(find.text('close'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, SharedApplicationRoute.home);
      expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
      expect(find.byType(ScheduleVacationSucceededPage), findsNothing);
    });
  });

  group('ScheduleVacationFailurePage', () {
    testWidgets('KnownFailure mostra o detalhe da API e voltar faz pop',
        (tester) async {
      final failure = KnownFailure(
          'Conflito', ApiFailure()..detail = 'Período já agendado');
      await pumpPage(tester, ScheduleVacationFailurePage(),
          arguments: ScheduleVacationFailurePageArgs(faliure: failure),
          observer: observer);

      expect(find.text('gdp_vacation_registration_failed_title'), findsOneWidget);
      expect(find.text('Período já agendado'), findsOneWidget);
      expect(find.text('gdp_vacation_registration_failed_subtitle'),
          findsNothing);
      await expectLater(find.byType(ScheduleVacationFailurePage),
          matchesGoldenFile('goldens/schedule_vacation_failure_page.png'));

      await tester.tap(find.text('back'));
      await tester.pumpAndSettle();
      expect(observer.popped, isNotEmpty);
    });

    testWidgets('outras falhas mostram a mensagem padrão', (tester) async {
      await pumpPage(tester, ScheduleVacationFailurePage(),
          arguments:
              ScheduleVacationFailurePageArgs(faliure: UnknownFailure('x')));
      expect(find.text('gdp_vacation_registration_failed_subtitle'),
          findsOneWidget);

      // KnownFailure cujo erro não tem `detail` também cai no padrão.
      await pumpPage(tester, ScheduleVacationFailurePage(),
          arguments: ScheduleVacationFailurePageArgs(
              faliure: KnownFailure('c', ApiFailure())));
      expect(find.text('gdp_vacation_registration_failed_subtitle'),
          findsOneWidget);
    });
  });

  group('ScheduleVacationPage', () {
    late Vacation vacation;

    Future<void> pumpSchedule(WidgetTester tester) async {
      bloc = env.scheduleBloc();
      vacation = Vacation(
          reference: 'R1',
          employee: Employee()
            ..id = employeeId
            ..name = 'Fulano de Tal');
      await pumpPage(
        tester,
        ScheduleVacationPage(appContainer: env.container(schedule: bloc)),
        arguments: vacation,
        observer: observer,
      );
    }

    testWidgets('mostra o funcionário, aceita os campos e cancela',
        (tester) async {
      await pumpSchedule(tester);

      expect(find.text('gdp_vacation_schedule_page_title'), findsOneWidget);
      expect(find.text('gdp_vacation_schedule_employee'), findsOneWidget);
      expect(find.text('Fulano de Tal'), findsOneWidget);
      expect(find.text('gdp_vacation_schedule_vacation_time'), findsOneWidget);
      expect(find.text('gdp_vacation_schedule_vacation_period'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).at(0), '2');
      await tester.enterText(find.byType(TextFormField).at(1), '30');
      await tester.pump();

      // Salvar não faz nada (código comentado).
      await tester.tap(find.text('gdp_vacation_schedule_save'));
      await tester.pumpAndSettle();
      expect(env.http.requests, isEmpty);
      expect(pushedRoutes(observer), isEmpty);

      await tester.tap(find.text('gdp_vacation_schedule_cancel'));
      await tester.pumpAndSettle();
      expect(observer.popped, isNotEmpty);
    });

    testWidgets('golden da tela de agendamento', (tester) async {
      await pumpSchedule(tester);
      await expectLater(find.byType(ScheduleVacationPage),
          matchesGoldenFile('goldens/schedule_vacation_page.png'));
    });

    testWidgets('estado carregado navega para o sucesso com as férias',
        (tester) async {
      await pumpSchedule(tester);

      // ignore: invalid_use_of_visible_for_testing_member
      bloc.emit(const ScheduleVacationLoadedState(null, condominiumId));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last,
          SharedApplicationRoute.gdpScheduleVacationSucceeded);
      expect(observer.pushed.last.settings.arguments, same(vacation));
    });
  });
}
