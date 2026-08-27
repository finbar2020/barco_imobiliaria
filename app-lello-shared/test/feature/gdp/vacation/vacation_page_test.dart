import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/details/vacation_bloc.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/details/vacation_state.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_bloc.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/schedule_vacation_details_page.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/schedule_vacation_summary_page.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/vacation_page.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/widget/vacation_accordion_content.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/widget/vacation_schudeled_alert_dialog.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/widget/vacation_text_field_schudele.dart';
import 'package:shared_features/shared_features.dart';

import '../../../helpers/pump_app.dart';
import 'vacation_test_helpers.dart';

/// Superfície alta o bastante para o formulário inteiro caber sem rolagem.
const _tall = Size(480, 1700);

void main() {
  late VacationEnv env;
  late RecordingNavigatorObserver observer;
  late VacationGDPBloc vacationBloc;
  late ScheduleVacationBloc scheduleBloc;

  setUp(() {
    env = VacationEnv();
    observer = RecordingNavigatorObserver();
  });

  /// Monta a página dentro de um Navigator ANINHADO.
  ///
  /// Motivo: a página chama `ModalRoute.of(context)` no `build()`, então
  /// qualquer rota empurrada no mesmo Navigator (calendário, menus) muda
  /// `isCurrent`, reexecuta o `build()` e o `Accordion` recria as seções
  /// (usa `hashCode` como tag do controller -> chaves novas). O
  /// `showDatePicker` usa o Navigator raiz, logo com a página num Navigator
  /// aninhado o calendário não a reconstrói e o `setState` depois do
  /// `await` continua num State vivo (ver defeito no relatório).
  Future<void> pumpVacation(
    WidgetTester tester, {
    Object? arguments = const _DefaultEmployee(),
    Size surface = _tall,
    bool settle = true,
    Map<String, String> locOverrides = const {},
  }) async {
    vacationBloc = env.vacationBloc();
    scheduleBloc = env.scheduleBloc();
    final args = arguments is _DefaultEmployee ? employee() : arguments;
    final page = GDPVacationPage(
        appContainer:
            env.container(vacation: vacationBloc, schedule: scheduleBloc));
    await pumpPage(
      tester,
      Navigator(
        observers: [observer],
        initialRoute: vacationRouteName,
        onGenerateRoute: (settings) => MaterialPageRoute(
          settings: settings.name == vacationRouteName
              ? RouteSettings(name: vacationRouteName, arguments: args)
              : settings,
          builder: (_) => settings.name == vacationRouteName
              ? page
              : Scaffold(
                  key: Key('route:${settings.name}'),
                  body: Text('rota ${settings.name}')),
        ),
      ),
      surface: surface,
      settle: settle,
      locOverrides: locOverrides,
    );
  }

  /// As seções do accordion abrem por timers (200ms por seção).
  Future<void> settleAccordion(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  }

  // Ordem na tela: período aquisitivo, quantidade de períodos, dias por
  // período e antecipação do 13º.
  Finder dropdowns() =>
      find.byWidgetPredicate((w) => w is DropdownButtonFormField);
  Finder periodsCountDropdown() => dropdowns().at(1);
  Finder daysDropdown() => dropdowns().at(2);
  Finder allow13Dropdown() => dropdowns().at(3);

  Future<void> selectDropdown(
      WidgetTester tester, Finder dropdown, String item) async {
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text(item).last);
    await tester.pumpAndSettle();
    await settleAccordion(tester);
  }

  /// Defeito: as listas dos dropdowns de quantidade de períodos e de dias só
  /// são calculadas em `build()` do State, que NÃO é reexecutado quando o
  /// bloc emite `VacationGDPLoadedState` (só o BlocConsumer é reconstruído).
  /// Os dois dropdowns ficam desabilitados até algum `setState` — aqui
  /// forçamos trocando a antecipação do 13º.
  Future<void> enableForm(WidgetTester tester, {String yes = 'yes'}) async {
    await tester.tap(periodsCountDropdown());
    await tester.pumpAndSettle();
    expect(find.text('3'), findsNothing);
    await selectDropdown(tester, allow13Dropdown(), yes);
  }

  /// O dropdown do período aquisitivo não recebe `value:`, então só fica
  /// válido depois que o usuário escolhe o (único) item no menu.
  Future<void> selectAcquisitivePeriod(WidgetTester tester) async {
    final periodo =
        '${ddMMyyyy(hoje.subtract(const Duration(days: 365)))} a ${ddMMyyyy(hoje)} ';
    await selectDropdown(tester, dropdowns().at(0), periodo);
    expect(find.text(periodo), findsOneWidget);
  }

  Future<void> tapNext(WidgetTester tester) async {
    await tester.tap(find.text('next'));
    await tester.pumpAndSettle();
  }

  /// Toca no campo "início" do período [index] e confirma a data inicial
  /// sugerida pelo calendário.
  Future<void> pickStartDate(WidgetTester tester, int index) async {
    await tester.tap(find.byType(TextFormField).at(index * 2));
    await tester.pumpAndSettle();
    expect(find.text('OK'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
  }

  group('PeriodConfig', () {
    test('calcula fim e formata datas', () {
      final config = PeriodConfig(start: DateTime(2030, 1, 10), days: 30);
      expect(config.getEnd, DateTime(2030, 2, 8));
      expect(config.getStartFormatted, '10/01/2030');
      expect(config.getEndFormatted, '08/02/2030');
      expect(config.allowanceValue, 0);

      final semDias = PeriodConfig(start: DateTime(2030, 1, 10));
      expect(semDias.getEnd, DateTime(2030, 1, 10));

      final vazio = PeriodConfig();
      expect(vazio.getEnd, isNull);
      expect(vazio.getStartFormatted, '');
      expect(vazio.getEndFormatted, '');
    });
  });

  testWidgets('carrega e mostra cabeçalho e formulário editável',
      (tester) async {
    env.stubVacationSuccess();
    await pumpVacation(tester);

    expect(vacationBloc.state, isA<VacationGDPLoadedState>());
    expect(find.text('gdp_vacation_title'), findsOneWidget);
    expect(find.text('gdp_vacation_schedule_employee'), findsOneWidget);
    expect(find.text('Fulano de Tal'), findsOneWidget);
    expect(find.text('04/03/2020'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('gdp_vacation_select_acquisition_period_vacation'),
        findsOneWidget);
    expect(find.text('gdp_vacation_employee_vacation_set_number_periods'),
        findsNWidgets(2));
    expect(find.text('gdp_vacation_employee_allowance'), findsOneWidget);
    expect(find.text('gdp_vacation_salary_anticipation'), findsOneWidget);
    expect(find.text('next'), findsOneWidget);
    expect(find.text('cancel'), findsOneWidget);
    expect(find.byType(AccordionSectionContent), findsNothing);
    expect(find.byType(VacationTextFieldSchudele), findsNothing);
    expect(find.byType(VacationScheduledAlertDialog), findsNothing);
  });

  testWidgets('golden do formulário de férias', (tester) async {
    env.stubVacationSuccess(
        vacation: vacationJson(
            acquisitivePeriodStart: '01/01/2029',
            acquisitivePeriodEnd: '31/12/2029'));
    await pumpVacation(tester, surface: const Size(400, 800));
    await expectLater(find.byType(GDPVacationPage),
        matchesGoldenFile('goldens/vacation_page.png'));
  });

  testWidgets('estado de carregamento mostra o indicador', (tester) async {
    env.stubVacationSuccess();
    await pumpVacation(tester, settle: false);
    expect(find.byType(LoadingWidget), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(LoadingWidget), findsNothing);
  });

  testWidgets('sem funcionário nos argumentos não carrega nada',
      (tester) async {
    env.stubVacationSuccess();
    await pumpVacation(tester, arguments: null, settle: false);
    await tester.pump();
    expect(find.byType(LoadingWidget), findsOneWidget);
    expect(env.http.requests, isEmpty);
    expect(vacationBloc.pendingEmployeeId, isNull);
  });

  testWidgets('falha ao carregar mostra a mensagem de erro', (tester) async {
    env.stubVacationSuccess();
    env.http.on('GET', periodsPath, status: 500, body: {'title': 'x'});
    await pumpVacation(tester);
    expect(find.text('gdp_vacation_error'), findsOneWidget);
    expect(find.text('next'), findsNothing);
  });

  testWidgets('cancelar volta para a tela anterior', (tester) async {
    env.stubVacationSuccess();
    await pumpVacation(tester);
    await tester.tap(find.text('cancel'));
    await tester.pumpAndSettle();
    expect(observer.popped.single.settings.name, vacationRouteName);
    expect(findRoute('/'), findsOneWidget);
  });

  testWidgets('avançar sem preencher mostra a validação obrigatória',
      (tester) async {
    env.stubVacationSuccess();
    await pumpVacation(tester);

    await tapNext(tester);

    // Sem períodos configurados só os dropdowns são validados.
    expect(find.text('validation_required'), findsWidgets);
    expect(pushedRoutes(observer), isEmpty);
  });

  testWidgets('fluxo com 1 período: escolhe dias, data e avança ao resumo',
      (tester) async {
    final bloqueado = ddMMyyyy(hoje.add(const Duration(days: 2)));
    env.stubVacationSuccess(lockedDays: lockedDaysJson([bloqueado]));
    await pumpVacation(tester,
        locOverrides: const {'no': 'Não', 'yes': 'Sim'});
    await enableForm(tester, yes: 'Sim');
    // "Não" -> N.
    await selectDropdown(tester, allow13Dropdown(), 'Não');
    await selectAcquisitivePeriod(tester);

    await selectDropdown(tester, periodsCountDropdown(), '1');
    expect(find.byType(AccordionSectionContent), findsNothing);

    await selectDropdown(tester, daysDropdown(), '30d');
    expect(find.byType(AccordionSectionContent), findsOneWidget);
    expect(find.text('gdp_vacation_period'), findsOneWidget);
    // Defeito: a dica "selecione a data" nunca aparece (getStartFormatted
    // devolve "" em vez de null).
    expect(find.text('gdp_vacation_employee_select_start_date'), findsNothing);

    // Avançar sem data: validação do período.
    await tapNext(tester);
    expect(find.text('validation_required'), findsOneWidget);
    expect(pushedRoutes(observer), isEmpty);

    // Escolhe a data: hoje+2 está bloqueado, o calendário sugere hoje+3.
    await pickStartDate(tester, 0);
    final esperado = hoje.add(const Duration(days: 3));
    expect(find.text(ddMMyyyy(esperado)), findsOneWidget);
    expect(find.text(ddMMyyyy(esperado.add(const Duration(days: 29)))),
        findsOneWidget);
    expect(find.text('validation_required'), findsNothing);

    await tapNext(tester);

    expect(pushedRoutes(observer).last, SharedApplicationRoute.gdpVacationSummary);
    final args = observer.pushed
        .lastWhere((r) =>
            r.settings.name == SharedApplicationRoute.gdpVacationSummary)
        .settings
        .arguments as ScheduleVacationSummaryPageArgs;
    expect(args.scheduleVacationBloc, same(scheduleBloc));
    expect(args.periodConfig, hasLength(1));
    final config = args.periodConfig.single;
    expect(config.start, esperado);
    expect(config.days, 30);
    expect(config.allowanceValue, 0);
    expect(config.allow13Value, 'N');
    expect(config.formatedAllow13, 'Não');
    expect(config.employeeId, employeeId);
    expect(config.employeeRegistrationNumber, 'M123');
    expect(config.employeeCompany, 7);
    expect(config.admissionDate, '04/03/2020');
    expect(config.employeeName, 'Fulano');
    expect(config.periodAquisitive, contains(' a '));
    expect(findRoute(SharedApplicationRoute.gdpVacationSummary), findsOneWidget);
    await settleAccordion(tester);
  });

  testWidgets('fluxo com 2 períodos: abono, antecipação e ordem das datas',
      (tester) async {
    env.stubVacationSuccess();
    await pumpVacation(tester,
        locOverrides: const {'no': 'Não', 'yes': 'Sim'});
    await enableForm(tester, yes: 'Sim');
    await selectAcquisitivePeriod(tester);

    await selectDropdown(tester, periodsCountDropdown(), '2');
    await selectDropdown(tester, daysDropdown(), '10d - 10d');

    expect(find.byType(AccordionSectionContent), findsNWidgets(2));
    expect(find.text('1 - gdp_vacation_period'), findsOneWidget);
    expect(find.text('2 - gdp_vacation_period'), findsOneWidget);
    // 10 + 10 = 20 dias -> abono de 10.
    expect(find.text('10'), findsWidgets);

    // Antecipação do 13º: "Sim" -> S, "Não" -> N.
    await selectDropdown(tester, allow13Dropdown(), 'Sim');
    await selectDropdown(tester, allow13Dropdown(), 'Não');

    // Segundo período antes do primeiro: aviso.
    await tester.tap(find.byType(TextFormField).at(2));
    await tester.pumpAndSettle();
    expect(find.text('gdp_vacation_not_possible_assign_date'), findsOneWidget);
    expect(find.text('OK'), findsNothing);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    await pickStartDate(tester, 0);
    final inicio1 = hoje.add(const Duration(days: 2));
    expect(find.text(ddMMyyyy(inicio1)), findsOneWidget);

    await pickStartDate(tester, 1);
    final inicio2 = inicio1.add(const Duration(days: 10));
    expect(find.text(ddMMyyyy(inicio2)), findsOneWidget);

    // Reabre o primeiro período e escolhe um dia depois do segundo.
    await tester.tap(find.byType(TextFormField).at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();
    await tester.tap(find.text('27').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tapNext(tester);
    expect(find.text('gdp_vacation_date_selected_diff_Dates'), findsOneWidget);
    expect(pushedRoutes(observer), isEmpty);
    // Tocar no aviso o dispensa.
    await tester.tap(find.text('gdp_vacation_date_selected_diff_Dates'));
    await tester.pumpAndSettle();

    // Corrige o primeiro período (data sugerida) e avança.
    await pickStartDate(tester, 0);
    await tapNext(tester);
    await tester.pump(const Duration(seconds: 31));
    await tester.pumpAndSettle();

    expect(pushedRoutes(observer).last, SharedApplicationRoute.gdpVacationSummary);
    final args = observer.pushed
        .lastWhere((r) =>
            r.settings.name == SharedApplicationRoute.gdpVacationSummary)
        .settings
        .arguments as ScheduleVacationSummaryPageArgs;
    expect(args.periodConfig, hasLength(2));
    expect(args.periodConfig[0].days, 10);
    expect(args.periodConfig[1].days, 10);
    expect(args.periodConfig[0].start, inicio1);
    expect(args.periodConfig[1].start, inicio2);
    expect(args.periodConfig[0].allowanceValue, 10);
    expect(args.periodConfig[0].allow13Value, 'N');
    expect(args.periodConfig[0].formatedAllow13, 'Não');
    await settleAccordion(tester);
  });

  /// Defeito: a troca do dropdown "antecipação do 13º" compara o texto com os
  /// literais "No"/"Não"; em qualquer outro idioma a opção "não" vira "S".
  testWidgets('fluxo com 3 períodos e antecipação "yes"', (tester) async {
    env.stubVacationSuccess();
    // Três seções abertas precisam de uma superfície ainda mais alta.
    await pumpVacation(tester, surface: const Size(480, 2600));
    await enableForm(tester);
    await selectAcquisitivePeriod(tester);

    await selectDropdown(tester, periodsCountDropdown(), '3');
    await selectDropdown(tester, daysDropdown(), '10d - 10d - 10d');
    expect(find.byType(AccordionSectionContent), findsNWidgets(3));
    expect(find.text('3 - gdp_vacation_period'), findsOneWidget);

    await selectDropdown(tester, allow13Dropdown(), 'yes');
    // Com a localização de teste "no" não bate com "No"/"Não" -> "S".
    await selectDropdown(tester, allow13Dropdown(), 'no');

    // Terceiro período antes do segundo: aviso.
    await tester.tap(find.byType(TextFormField).at(4));
    await tester.pumpAndSettle();
    expect(find.text('gdp_vacation_not_possible_assign_date'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    await pickStartDate(tester, 0);
    await pickStartDate(tester, 1);
    await pickStartDate(tester, 2);

    await tapNext(tester);

    expect(pushedRoutes(observer).last, SharedApplicationRoute.gdpVacationSummary);
    final args = observer.pushed
        .lastWhere((r) =>
            r.settings.name == SharedApplicationRoute.gdpVacationSummary)
        .settings
        .arguments as ScheduleVacationSummaryPageArgs;
    expect(args.periodConfig, hasLength(3));
    final inicio1 = hoje.add(const Duration(days: 2));
    expect(args.periodConfig[0].start, inicio1);
    expect(args.periodConfig[1].start, inicio1.add(const Duration(days: 10)));
    expect(args.periodConfig[2].start, inicio1.add(const Duration(days: 20)));
    expect(args.periodConfig[0].allowanceValue, 0);
    expect(args.periodConfig[0].allow13Value, 'S');
    expect(args.periodConfig[0].formatedAllow13, 'yes');
    await settleAccordion(tester);
  });

  testWidgets('trocar a quantidade de períodos limpa as seções', (tester) async {
    env.stubVacationSuccess();
    await pumpVacation(tester);
    await enableForm(tester);

    await selectDropdown(tester, periodsCountDropdown(), '1');
    await selectDropdown(tester, daysDropdown(), '20d');
    expect(find.byType(AccordionSectionContent), findsOneWidget);
    // 20 dias em 1 período -> abono de 10.
    expect(find.text('10'), findsOneWidget);

    await selectDropdown(tester, periodsCountDropdown(), '2');
    expect(find.byType(AccordionSectionContent), findsNothing);
    expect(find.text('20d - 10d'), findsNothing);
    await tester.tap(daysDropdown());
    await tester.pumpAndSettle();
    expect(find.text('20d - 10d'), findsOneWidget);
    expect(find.text('15d - 15d'), findsOneWidget);
    await tester.tap(find.text('15d - 15d').last);
    await tester.pumpAndSettle();
    await settleAccordion(tester);
    expect(find.byType(AccordionSectionContent), findsNWidgets(2));
  });

  testWidgets('férias já agendadas: vai para os detalhes e avisa',
      (tester) async {
    env.stubVacationSuccess(
      vacation: vacationJson(
        vacationStartDate: '10/01/2030',
        vacationEndDate: '08/02/2030',
        advance13: 'S',
        scheduledDays: 30,
        salaryAllowance: 10,
        numbersUnitVacation: 1,
        scheduledVacations: [
          vacationJson(
              vacationStartDate: '10/01/2030',
              scheduledDays: 30,
              advance13: 'S',
              includeEmployee: false),
          vacationJson(
              vacationStartDate: '01/06/2030',
              scheduledDays: 10,
              advance13: 'N',
              includeEmployee: false),
        ],
      ),
    );
    await pumpVacation(tester);

    expect(pushedRoutes(observer), [SharedApplicationRoute.gdpVacationDetails]);
    expect(observer.popped.single.settings.name, vacationRouteName);
    final route = observer.pushed.firstWhere(
        (r) => r.settings.name == SharedApplicationRoute.gdpVacationDetails);
    final args = route.settings.arguments as ScheduleVacationDetailsPageArgs;
    expect(args.scheduleVacationBloc, same(scheduleBloc));
    expect(args.periodConfig, hasLength(2));
    expect(args.periodConfig[0].start, DateTime(2030, 1, 10));
    expect(args.periodConfig[0].days, 30);
    expect(args.periodConfig[0].allowanceValue, 30);
    expect(args.periodConfig[0].formatedAllow13, 'yes');
    expect(args.periodConfig[0].employeeName, 'Fulano de Tal');
    expect(args.periodConfig[0].periodAquisitive, contains(' a '));
    expect(args.periodConfig[1].start, DateTime(2030, 6, 1));
    expect(args.periodConfig[1].formatedAllow13, 'no');

    // O alerta de "já agendado" é aberto sobre a tela de detalhes.
    expect(find.byType(VacationScheduledAlertDialog), findsOneWidget);
    expect(find.text('gdp_vacation_scheduled_vacation_alert'), findsOneWidget);
    await tester.tap(find.text('CLOSE'));
    await tester.pumpAndSettle();
    expect(find.byType(VacationScheduledAlertDialog), findsNothing);
    expect(findRoute(SharedApplicationRoute.gdpVacationDetails), findsOneWidget);
  });

  // Defeito (não testável aqui): com férias agendadas
  // (`vacation_start_date` preenchido) mas sem a lista `scheduled_vacations`,
  // o listener faz `scheduledVacations!` e lança um erro de null dentro do
  // callback do bloc, derrubando a tela.
}

/// Marcador para usar o funcionário padrão como argumento.
class _DefaultEmployee {
  const _DefaultEmployee();
}
