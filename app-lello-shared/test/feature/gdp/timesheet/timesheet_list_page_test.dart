import 'dart:async';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_type_enum.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_list/timesheet_list_bloc.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_list/timesheet_list_event.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_list/timesheet_list_state.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/page/timesheet_list.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../../helpers/firebase_mocks.dart';
import '../../../helpers/pump_app.dart';
import '../../../helpers/test_container.dart';
import 'timesheet_test_helpers.dart';

void main() {
  late TimesheetStack stack;
  late TestSharedContainer container;
  late RecordingNavigatorObserver observer;
  final session = FakeSharedSession();
  final ontem = hoje.subtract(const Duration(days: 1));
  final primeiroDia = DateTime(hoje.year, hoje.month, 1);

  String cap(String s) => s[0].toUpperCase() + s.substring(1);
  String mes(DateTime d) => cap(DateFormat(DateFormat.MONTH, 'pt_BR').format(d));
  String dia(DateTime d) =>
      DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_BR').format(d);

  /// Textos reais (curtos) do dropdown: com as chaves longas o `trailing`
  /// ocupa toda a largura da linha e esmaga título e subtítulo.
  const locEmp = {
    'gdp_timesheet_event_option_allowance_value': 'ABONO',
    'gdp_timesheet_event_option_discount_value': 'DESCONTO',
    'gdp_timesheet_event_option_allowance_action': 'Abonar',
    'gdp_timesheet_event_option_discount_action': 'Descontar',
    'gdp_timesheet_event_option_allowance_text': 'Abonado',
    'gdp_timesheet_event_option_discount_text': 'Descontado',
    'gdp_timesheet_select': 'Selecione',
  };

  setUpAll(() async {
    await setUpFakeFirebase();
    await initializeDateFormatting('pt_BR');
  });

  setUp(() {
    stack = TimesheetStack();
    observer = RecordingNavigatorObserver();
    container = TestSharedContainer()
      ..registerLazy<TimesheetListBloc>(() => stack.listBloc(session: session));
  });

  tearDown(() => container.reset());

  TimesheetListBloc bloc() => container.resolve<TimesheetListBloc>();

  TimesheetFilter filtro(TimesheetTypeEnum type, {String? name}) =>
      TimesheetFilter(type: type, name: name, dobFrom: hoje, dobTo: hoje);

  Future<void> pump(WidgetTester tester, TimesheetFilter args,
          {Map<String, String> loc = const {}}) =>
      pumpPage(tester, TimesheetListPage(appContainer: container),
          observer: observer, arguments: args, locOverrides: loc);

  group('tipo padrão (presentes)', () {
    testWidgets('lista agrupada por dia, abre o funcionário e tem golden',
        (tester) async {
      stack.happyPath(timesheets: [
        timesheetJson(),
        timesheetJson(
            employee: employeeJson(id: 'E2', name: 'Joao Souza', role: 'ZELADOR'),
            time: []),
        timesheetJson(date: ontem),
      ]);
      await pump(tester, filtro(TimesheetTypeEnum.present));

      expect(find.text('gdp_timesheet_appBar'), findsOneWidget);
      expect(find.text('Gdp_timesheet_type_present'), findsOneWidget);
      expect(find.text('gdp_timesheet_label_today'), findsOneWidget);
      expect(find.text(dia(ontem)), findsOneWidget);
      expect(find.text('Maria Silva'), findsNWidgets(2));
      expect(find.text('Porteiro\n08:00-12:00-13:00-17:00'), findsNWidgets(2));
      expect(find.text('Zelador\ngdp_timesheet_event_time_unmarked'),
          findsOneWidget);
      expect(stack.http.requests.single.url.queryParameters['type'], 'present');

      await expectLater(find.byType(MaterialApp),
          matchesGoldenFile('goldens/timesheet_list_present.png'));

      await tester.tap(find.text('Joao Souza'));
      await tester.pumpAndSettle();
      expect(observer.pushedNames.last, SharedApplicationRoute.gdpTimesheetList);
      final args = observer.pushed.last.settings.arguments as TimesheetFilter;
      expect(args.type, TimesheetTypeEnum.employee);
      expect(args.name, 'Joao Souza');
      expect(args.dobFrom, hoje);
    });

    testWidgets('lista vazia mostra a mensagem', (tester) async {
      stack.happyPath(timesheets: []);
      await pump(tester, filtro(TimesheetTypeEnum.present));
      expect(find.text('Não encontramos nenhuma ocorrência.'), findsOneWidget);
    });

    testWidgets('erro mostra a mensagem de erro', (tester) async {
      stack.http.failAll();
      await pump(tester, filtro(TimesheetTypeEnum.present));
      expect(find.text('gdp_timesheet_error'), findsOneWidget);
      expect(bloc().state, isA<TimesheetListLoadFailedState>());
    });

    testWidgets('estado pós-inserção com lista vazia mostra vazio', (tester) async {
      stack.happyPath();
      await pump(tester, filtro(TimesheetTypeEnum.present));
      final b = bloc();
      expect(TimesheetListPageArgs(b).timesheetListBloc, same(b));
      // ignore: invalid_use_of_visible_for_testing_member
      b.emit(TimesheetInsertedState(
          [], const TimesheetListLoadEvent(), b.state.query!, 'C1', hoje, true));
      await tester.pumpAndSettle();
      expect(find.text('gdp_timesheet_empty'), findsOneWidget);
      expect(find.text('Gdp_timesheet_type_present'), findsOneWidget);
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
    });

    testWidgets('carregando mostra o indicador', (tester) async {
      stack.happyPath();
      await pump(tester, filtro(TimesheetTypeEnum.present));
      final b = bloc();
      // ignore: invalid_use_of_visible_for_testing_member
      b.emit(TimesheetListLoadingState(b.state.list, null, b.state.query, 'C1', hoje));
      await tester.pump();
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('puxar para atualizar recarrega e rolar dispara o listener',
        (tester) async {
      stack.happyPath(timesheets: [
        for (var i = 0; i < 25; i++)
          timesheetJson(employee: employeeJson(id: 'E$i', name: 'Func $i')),
      ]);
      await pump(tester, filtro(TimesheetTypeEnum.present));
      expect(find.text('Func 0'), findsOneWidget);

      await tester.drag(find.byType(ListView), const Offset(0, -800));
      await tester.pumpAndSettle();
      expect(find.text('Func 0'), findsNothing);
      await tester.drag(find.byType(ListView), const Offset(0, 800));
      await tester.pumpAndSettle();

      final antes = stack.http.requests.length;
      await tester.fling(find.byType(ListView), const Offset(0, 300), 1000);
      await tester.pumpAndSettle();
      expect(stack.http.requests.length, greaterThan(antes));
    });
  });

  group('tipo ocorrências (events)', () {
    testWidgets('mostra o seletor de mês, os eventos e troca o período',
        (tester) async {
      stack.happyPath(timesheets: [
        timesheetJson(events: ['Falta sem justificativa', 'Atraso']),
        timesheetJson(time: [], events: null, date: ontem),
      ]);
      await pump(tester, filtro(TimesheetTypeEnum.events));

      expect(find.text('Gdp_timesheet_type_events'), findsOneWidget);
      expect(find.text('gdp_timesheet_select'), findsOneWidget);
      expect(find.text(mes(primeiroDia)), findsOneWidget);
      expect(find.text('08:00-12:00-13:00-17:00\nFalta sem justificativa - Atraso'),
          findsOneWidget);
      expect(find.text('gdp_timesheet_event_time_unmarked\n-'), findsOneWidget);

      await expectLater(find.byType(MaterialApp),
          matchesGoldenFile('goldens/timesheet_list_events.png'));

      // cancelar não recarrega
      await tester.tap(find.text(mes(primeiroDia)));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
      final loc = MaterialLocalizations.of(tester.element(find.byType(Dialog)));
      await tester.tap(find.text(loc.cancelButtonLabel));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
      expect(stack.http.requests.length, 1);

      // confirmar recarrega com o mês escolhido
      await tester.tap(find.text(mes(primeiroDia)));
      await tester.pumpAndSettle();
      await tester.tap(find.text(loc.okButtonLabel));
      await tester.pumpAndSettle();
      /// Corrigido: a recarga programática (`refreshKey.show()` disparada pelo
      /// listener) não faz o `onRefresh` do RefreshIndicator pedir outra
      /// recarga, então a troca de mês faz uma única requisição.
      expect(stack.http.requests.length, 2);
      expect(bloc().state.query!.dobTo, primeiroDia);
      expect(bloc().state.query!.dobFrom, primeiroDia);

      await tester.tap(find.text('Maria Silva').first);
      await tester.pumpAndSettle();
      final args = observer.pushed.last.settings.arguments as TimesheetFilter;
      expect(args.type, TimesheetTypeEnum.employee);
      expect(args.name, 'Maria Silva');
      expect(args.dobTo, primeiroDia);
    });

    testWidgets('sem fechamento do mês mostra o texto de selecionar',
        (tester) async {
      stack.happyPath(timesheets: [
        {...timesheetJson(events: ['x']), 'month_closing': null},
      ]);
      await pump(tester, filtro(TimesheetTypeEnum.events));
      expect(find.text('gdp_timesheet_select'), findsNWidgets(2));
      await tester.tap(find.text('gdp_timesheet_select').last);
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });
  });

  group('tipo funcionário (employee)', () {
    testWidgets('mostra os dados do funcionário e a ocorrência com dropdown',
        (tester) async {
      stack.happyPath(timesheets: [
        timesheetJson(events: ['Falta sem justificativa']),
        timesheetJson(
            date: ontem, events: null, time: [], eventControl: eventJson()),
      ]);
      await pump(tester, filtro(TimesheetTypeEnum.employee, name: 'Maria Silva'), loc: locEmp);

      expect(find.text('Gdp_timesheet_type_employee'), findsOneWidget);
      expect(find.text('gdp_timesheet_employee_name'), findsOneWidget);
      expect(find.text('Maria Silva'), findsOneWidget);
      expect(find.text('gdp_timesheet_employee_occupation'), findsOneWidget);
      expect(find.text('PORTEIRO'), findsOneWidget);
      expect(find.text('gdp_timesheet_selected'), findsOneWidget);
      expect(find.text(mes(primeiroDia)), findsOneWidget);
      expect(find.text('Falta sem justificativa'), findsOneWidget);
      expect(find.text('gdp_timesheet_event_empty'), findsOneWidget);
      expect(find.text('gdp_timesheet_event_time_unmarked'), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsNWidgets(2));
      expect(stack.http.requests.single.url.queryParameters['name'],
          'Maria Silva');

      await expectLater(find.byType(MaterialApp),
          matchesGoldenFile('goldens/timesheet_list_employee.png'));
    });

    testWidgets('sem funcionário e sem fechamento mostra traços',
        (tester) async {
      stack.happyPath(timesheets: [
        {...timesheetJson(events: ['x']), 'employee': null, 'month_closing': null},
      ]);
      await pump(tester, filtro(TimesheetTypeEnum.employee), loc: locEmp);
      expect(find.text('-'), findsNWidgets(3));
    });

    testWidgets('ocorrência não editável avisa ao tocar (hoje válido)',
        (tester) async {
      stack.happyPath(timesheets: [
        timesheetJson(events: ['Atraso justificado']),
      ]);
      await pump(tester, filtro(TimesheetTypeEnum.employee), loc: locEmp);
      final dropdown = tester.widget<DropdownButton<String>>(
          find.byType(DropdownButton<String>));
      expect(dropdown.onChanged, isNull);
      expect(dropdown.value, 'DESCONTO');
      expect(find.text('Descontar'), findsOneWidget);

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      expect(find.text('gdp_timesheet_flushbar_unavailable'), findsOneWidget);
      expect(find.text('gdp_timesheet_flushbar_unavailable_reason'),
          findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      expect(find.text('gdp_timesheet_flushbar_unavailable'), findsNothing);
    });

    testWidgets('período sem o dia de hoje bloqueia a edição com outro motivo',
        (tester) async {
      stack.happyPath(timesheets: [
        timesheetJson(
            date: ontem,
            events: ['Falta sem justificativa'],
            eventControl: eventJson(typeEvent: 'ABONO')),
      ]);
      await pump(tester, filtro(TimesheetTypeEnum.employee), loc: locEmp);
      expect(find.text('Abonar'), findsOneWidget);
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      expect(find.text('gdp_timesheet_flushbar_invalid_period_reason'),
          findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    });

    /// Corrigido: `_allowEdit` agora faz `return false` quando o período não é
    /// válido e checa `eventControl?.typeEvent == "ABONO"` antes de liberar a
    /// edição, então uma ocorrência já abonada não é mais editável.
    testWidgets('ocorrência já abonada não é editável', (tester) async {
      stack.happyPath(timesheets: [
        timesheetJson(
            events: ['Saida antecipada sem justificativa'],
            eventControl: eventJson(typeEvent: 'ABONO')),
      ]);
      await pump(tester, filtro(TimesheetTypeEnum.employee), loc: locEmp);
      final dropdown = tester.widget<DropdownButton<String>>(
          find.byType(DropdownButton<String>));
      expect(dropdown.onChanged, isNull);
      expect(dropdown.value, 'ABONO');
    });

    testWidgets('escolher desconto avisa que já está selecionado',
        (tester) async {
      stack.happyPath(timesheets: [
        timesheetJson(events: ['Falta sem justificativa']),
      ]);
      await pump(tester, filtro(TimesheetTypeEnum.employee), loc: locEmp);
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Descontar').last);
      await tester.pumpAndSettle();
      expect(find.text('gdp_timesheet_flushbar_already_selected'),
          findsOneWidget);
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
    });

    /// Corrigido: confirmar o abono chama `bloc.insertEvent`, que agora usa o
    /// próprio evento recebido em vez de `state.event!`, então a ocorrência é
    /// enviada mesmo no fluxo normal (sem estado emitido à mão).
    testWidgets('confirmar abono no fluxo normal envia a ocorrência',
        (tester) async {
      stack.happyPath(timesheets: [
        timesheetJson(events: ['Falta sem justificativa']),
      ]);
      final erros = <Object>[];
      final args = filtro(TimesheetTypeEnum.employee);
      late TimesheetListBloc guardado;
      runZonedGuarded(() {
        guardado = stack.listBloc(session: session)..state.query = args;
      }, (e, _) => erros.add(e));
      container.register<TimesheetListBloc>(guardado);
      await pump(tester, args, loc: locEmp);
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Abonar').last);
      await tester.pumpAndSettle();
      expect(find.text('gdp_timesheet_signature_alert_warning'), findsOneWidget);
      expect(find.text('gdp_timesheet_event_alert_warning'), findsOneWidget);

      await tester.tap(find.text('cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(stack.http.requests.where((r) => r.method == 'POST'), isEmpty);

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Abonar').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('yes'));
      await tester.pumpAndSettle();
      expect(erros, isEmpty);
      final post = stack.http.requests.firstWhere((r) => r.method == 'POST');
      expect(post.url.path, '/timesheet/event/C1');
      expect(post.body, contains('"type_event":"ABONO"'));
      expect(bloc().state, isA<TimesheetListLoadedState>());
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
    });

    testWidgets('com estado que tem evento o abono é enviado e avisa o sucesso',
        (tester) async {
      stack.happyPath(timesheets: [
        timesheetJson(events: ['Falta sem justificativa']),
      ]);
      await pump(tester, filtro(TimesheetTypeEnum.employee), loc: locEmp);
      final b = bloc();
      // ignore: invalid_use_of_visible_for_testing_member
      b.emit(TimesheetListLoadedState(b.state.list,
          const TimesheetListLoadEvent(), b.state.query, 'C1', hoje, false));
      await tester.pump();

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Abonar').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('yes'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('gdp_timesheet_flushbar_event_insert_success'),
          findsOneWidget);
      final post = stack.http.requests.firstWhere((r) => r.method == 'POST');
      expect(post.url.path, '/timesheet/event/C1');
      expect(post.body, contains('"type_event":"ABONO"'));
      expect(post.body, contains('"registration_number":"E1"'));
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
      expect(b.state, isA<TimesheetListLoadedState>());
    });

    testWidgets('inserindo mostra o indicador na linha da data', (tester) async {
      stack.happyPath(timesheets: [
        timesheetJson(events: ['Falta sem justificativa']),
        timesheetJson(date: ontem, events: ['Atraso sem justificativa']),
      ]);
      await pump(tester, filtro(TimesheetTypeEnum.employee), loc: locEmp);
      final b = bloc();
      // ignore: invalid_use_of_visible_for_testing_member
      b.emit(TimesheetInsertingState(b.state.list,
          const TimesheetListLoadEvent(), b.state.query!, 'C1', hoje, hoje));
      await tester.pump();
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);
    });

    testWidgets('falha ao inserir mostra o aviso de erro', (tester) async {
      stack.happyPath(timesheets: [
        timesheetJson(events: ['Falta sem justificativa']),
      ]);
      await pump(tester, filtro(TimesheetTypeEnum.employee), loc: locEmp);
      final b = bloc();
      // ignore: invalid_use_of_visible_for_testing_member
      b.emit(TimesheetInsertFailedState(b.state.list,
          const TimesheetListLoadEvent(), b.state.query!, 'C1', hoje,
          UnknownFailure('x')));
      await tester.pumpAndSettle();
      expect(find.text('gdp_timesheet_flushbar_event_insert_error'),
          findsOneWidget);
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
    });
  });
}
