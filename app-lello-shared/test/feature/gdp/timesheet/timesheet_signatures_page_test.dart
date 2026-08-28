import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_type_enum.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_signatures/timesheet_signatures_bloc.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_signatures/timesheet_signatures_state.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/page/timesheet_signatures.dart';
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
  final primeiroDia = DateTime(hoje.year, hoje.month, 1);

  String cap(String s) => s[0].toUpperCase() + s.substring(1);
  String mes(DateTime d) => DateFormat(DateFormat.MONTH, 'pt_BR').format(d);

  setUpAll(() async {
    await setUpFakeFirebase();
    await initializeDateFormatting('pt_BR');
  });

  setUp(() {
    stack = TimesheetStack();
    observer = RecordingNavigatorObserver();
    container = TestSharedContainer()
      ..registerLazy<TimesheetSignaturesBloc>(
          () => stack.signaturesBloc(session: session));
  });

  tearDown(() => container.reset());

  TimesheetSignaturesBloc bloc() => container.resolve<TimesheetSignaturesBloc>();

  TimesheetFilter filtro({DateTime? dobTo}) => TimesheetFilter(
      type: TimesheetTypeEnum.events, dobFrom: primeiroDia, dobTo: dobTo);

  Future<void> pump(WidgetTester tester, TimesheetFilter args) =>
      pumpPage(tester, TimesheetSignaturesPage(appContainer: container),
          observer: observer, arguments: args);

  testWidgets('lista as assinaturas, seleciona e mostra o total selecionado',
      (tester) async {
    stack.happyPath();
    await pump(tester, filtro(dobTo: hoje));

    expect(find.text('gdp_timesheet_appBar'), findsOneWidget);
    expect(find.text('gdp_timesheet_signature_title'), findsOneWidget);
    expect(find.text('gdp_timesheet_month_selected'), findsOneWidget);
    expect(find.text(cap(mes(hoje))), findsOneWidget);
    expect(find.text('Maria Silva'), findsOneWidget);
    expect(find.text('Porteiro'), findsNWidgets(2));
    expect(find.text('Joao Souza'), findsOneWidget);
    expect(find.text('gdp_timesheet_signature_button'), findsOneWidget);
    expect(find.text('gdp_timesheet_signature_number_selected'), findsNothing);
    expect(stack.http.requests.single.url.path, '/timesheet/signatures/C1');
    expect(EimesheetSignaturesPageArgs(bloc()).timesheetSignaturesBloc,
        same(bloc()));

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    expect(find.text('gdp_timesheet_signature_number_selected'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(bloc().state.listSign.single.id, 1);

    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/timesheet_signatures_selected.png'));

    await tester.tap(find.byType(Checkbox).last);
    await tester.pumpAndSettle();
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
    expect(bloc().state.listSign.single.id, 2);
  });

  testWidgets('sem seleção o botão não abre o diálogo', (tester) async {
    stack.happyPath();
    await pump(tester, filtro(dobTo: hoje));
    await tester.tap(find.text('gdp_timesheet_signature_button'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('confirmar a assinatura assina e vai para a tela de sucesso',
      (tester) async {
    stack.happyPath();
    await pump(tester, filtro(dobTo: hoje));
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('gdp_timesheet_signature_button'));
    await tester.pumpAndSettle();
    expect(find.text('gdp_timesheet_signature_alert_warning'), findsOneWidget);
    final rich = tester.widget<RichText>(find.byWidgetPredicate((w) =>
        w is RichText &&
        w.text.toPlainText().startsWith('gdp_timesheet_signature_alert_confirm')));
    expect(
        rich.text.toPlainText(),
        'gdp_timesheet_signature_alert_confirm'
        '1gdp_timesheet_signature_alert_mirror'
        'gdp_timesheet_signature_alert_period'
        '${mes(hoje)}/${hoje.year}?');

    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/timesheet_signatures_dialog.png'));

    await tester.tap(find.text('cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(stack.http.requests.where((r) => r.method == 'PUT'), isEmpty);

    await tester.tap(find.text('gdp_timesheet_signature_button'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('confirm'));
    await tester.pumpAndSettle();

    final put = stack.http.requests.firstWhere((r) => r.method == 'PUT');
    expect(put.url.path, '/timesheet/signatures/C1');
    expect(put.body, contains('"id":1'));
    expect(observer.pushedNames.last,
        SharedApplicationRoute.gdpTimesheetSignSuccess);
    expect(findRoute(SharedApplicationRoute.gdpTimesheetSignSuccess),
        findsOneWidget);
    expect(find.byType(TimesheetSignaturesPage), findsNothing);
  });

  testWidgets('falha ao assinar mostra o erro acima do botão', (tester) async {
    stack.happyPath();
    stack.http.on('PUT', '/timesheet/signatures/C1', status: 500);
    await pump(tester, filtro(dobTo: hoje));
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('gdp_timesheet_signature_button'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('confirm'));
    await tester.pumpAndSettle();

    expect(bloc().state, isA<TimesheetSignFailedState>());
    expect(find.text('gdp_timesheet_error'), findsOneWidget);
    expect(find.text('gdp_timesheet_signature_button'), findsOneWidget);
  });

  testWidgets('erro ao carregar mostra a mensagem na lista', (tester) async {
    stack.http.failAll();
    await pump(tester, filtro(dobTo: hoje));
    expect(find.text('gdp_timesheet_error'), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsNothing);
  });

  testWidgets('sem assinaturas mostra vazio', (tester) async {
    stack.happyPath();
    stack.http.on('GET', '/timesheet/signatures/C1', body: []);
    await pump(tester, filtro(dobTo: hoje));
    expect(find.text('gdp_timesheet_empty'), findsOneWidget);
  });

  testWidgets('assinando mostra o indicador no lugar do botão', (tester) async {
    stack.happyPath();
    await pump(tester, filtro(dobTo: hoje));
    final b = bloc();
    // ignore: invalid_use_of_visible_for_testing_member
    b.emit(TimesheetSigningState(
        b.state.signatures, b.state.listSign, b.state.query!, 'C1', null));
    await tester.pump();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('gdp_timesheet_signature_button'), findsNothing);
    expect(find.byType(CheckboxListTile), findsNWidgets(2));
  });

  testWidgets('carregando mostra o indicador', (tester) async {
    stack.happyPath();
    await pump(tester, filtro(dobTo: hoje));
    final b = bloc();
    // ignore: invalid_use_of_visible_for_testing_member
    b.emit(TimesheetSignaturesLoadingState(
        b.state.signatures, b.state.listSign, b.state.query, 'C1', null));
    await tester.pump();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsNothing);
  });

  testWidgets('seletor de mês troca o período e recarrega', (tester) async {
    stack.happyPath();
    await pump(tester, filtro(dobTo: hoje));

    await tester.tap(find.text(cap(mes(hoje))));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    final loc = MaterialLocalizations.of(tester.element(find.byType(Dialog)));
    await tester.tap(find.text(loc.cancelButtonLabel));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
    expect(stack.http.requests.length, 1);

    await tester.tap(find.text(cap(mes(hoje))));
    await tester.pumpAndSettle();
    await tester.tap(find.text(loc.okButtonLabel));
    await tester.pumpAndSettle();
    /// Corrigido: a recarga programática (`refreshKey.show()` disparada pelo
    /// listener) não faz o `onRefresh` do RefreshIndicator pedir outra
    /// recarga, então a troca de mês faz uma única requisição.
    expect(stack.http.requests.length, 2);
    expect(bloc().state.query!.dobTo, primeiroDia);
    expect(bloc().state.query!.dobFrom, primeiroDia);
    expect(stack.http.requests.last.url.queryParameters['dob_to'],
        startsWith(isoDia(primeiroDia).substring(0, 10)));
  });

  testWidgets('sem mês no filtro mostra o texto de selecionar e abre o picker em hoje',
      (tester) async {
    stack.happyPath();
    // Textos curtos: com as chaves longas o seletor estoura na horizontal.
    await pumpPage(tester, TimesheetSignaturesPage(appContainer: container),
        observer: observer,
        arguments: filtro(),
        locOverrides: const {
          'gdp_timesheet_month_selected': 'Mês:',
          'gdp_timesheet_select': 'Selecione',
        });
    expect(find.text('Selecione'), findsOneWidget);
    await tester.tap(find.text('Selecione'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text(DateFormat.y('pt_BR').format(hoje)), findsWidgets);
  });

  testWidgets('puxar para atualizar recarrega e rolar dispara o listener',
      (tester) async {
    stack.happyPath();
    stack.http.on('GET', '/timesheet/signatures/C1', body: [
      for (var i = 0; i < 25; i++)
        signatureJson(id: i, employee: employeeJson(id: 'E$i', name: 'Func $i')),
    ]);
    await pump(tester, filtro(dobTo: hoje));
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
}
