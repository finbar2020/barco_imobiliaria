import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_filter_requests_status.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_requests_filter.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_subcategories.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/widgets/comfort_requests_filter.dart';

import '../../../helpers/pump_app.dart';
import 'comfort_requests_test_support.dart';

void main() {
  late RecordingNavigatorObserver observer;
  late List<ComfortRequestsFilter> searched;
  late ComfortRequestsFilter filter;

  setUp(() {
    observer = RecordingNavigatorObserver();
    searched = [];
    filter = ComfortRequestsFilter(
        status: ComfortFilterRequestStatus.all, subcategories: ComfortType.all);
  });

  /// Empurra o filtro como rota própria (o widget faz `Navigator.pop`).
  Future<void> pump(WidgetTester tester) async {
    await pumpPage(
      tester,
      PushHost(
        onOpen: (ctx) => Navigator.push(
          ctx,
          MaterialPageRoute(
            builder: (_) => Scaffold(
              body: ComfortRequestsFilterWidget(
                filter: filter,
                subcategories: [
                  ComfortSubcategories(comfortType: ComfortType.gym),
                  ComfortSubcategories(comfortType: null),
                ],
                onSearch: searched.add,
              ),
            ),
          ),
        ),
      ),
      observer: observer,
      surface: const Size(400, 900),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
  }

  // Os seletores de data são os InkWell com Padding(top: 16).
  final dateFields = find.byWidgetPredicate((w) =>
      w is InkWell &&
      w.child is Padding &&
      (w.child as Padding).padding == const EdgeInsets.only(top: 16.0));
  final startField = dateFields.at(0);
  final endField = dateFields.at(1);
  final subcategoriesDropdown = find.byType(DropdownButton<String>).first;
  final statusDropdown = find.byType(DropdownButton<String>).last;

  Future<void> confirmDatePicker(WidgetTester tester, {bool ok = true}) async {
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tap(find.text(ok ? 'OK' : 'Cancelar'));
    await tester.pumpAndSettle();
  }

  String fmt(DateTime d) => DateFormat.yMd().format(d);

  testWidgets('renderiza campos, opções e botões', (tester) async {
    await pump(tester);

    expect(find.text('filter'), findsOneWidget);
    expect(find.text('reports_choose_date'), findsOneWidget);
    expect(find.text('from'), findsOneWidget);
    expect(find.text('to'), findsOneWidget);
    expect(find.text('00/00/0000'), findsNWidgets(2));
    expect(find.text('comfort_request_filter_subcategories'), findsOneWidget);
    expect(find.text('comfort_request_filter_subcategories_all'), findsOneWidget);
    expect(find.text('comfort_request_filter_status'), findsOneWidget);
    expect(find.text('comfort_request_filter_status_all'), findsOneWidget);
    expect(find.text('find'), findsOneWidget);
    expect(find.text('comfort_request_filter_clear'), findsOneWidget);
    expect(find.text('comfort_request_filter_date_error'), findsNothing);
    await expectLater(find.byType(ComfortRequestsFilterWidget),
        matchesGoldenFile('goldens/comfort_requests_filter.png'));

    // As subcategorias incluem "todas", ginástica e "outros" para nulo.
    await tester.tap(subcategoriesDropdown);
    await tester.pumpAndSettle();
    expect(find.text('comfort_gym'), findsOneWidget);
    expect(find.text('comfort_others'), findsOneWidget);
    await tester.tap(find.text('comfort_gym').last);
    await tester.pumpAndSettle();
    expect(filter.subcategories, ComfortType.gym);
  });

  testWidgets('buscar sem mudanças não dispara a busca', (tester) async {
    await pump(tester);
    await tester.tap(find.text('find'));
    await tester.pumpAndSettle();
    expect(searched, isEmpty);
    expect(find.byType(ComfortRequestsFilterWidget), findsOneWidget);
  });

  testWidgets('status alterado dispara a busca e fecha', (tester) async {
    await pump(tester);
    for (final option in [
      'comfort_request_filter_status_sent',
      'comfort_request_filter_status_resent',
      'comfort_request_filter_status_canceled',
      'comfort_request_filter_status_all',
      'comfort_request_filter_status_canceled',
    ]) {
      await tester.tap(statusDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text(option).last);
      await tester.pumpAndSettle();
    }
    expect(filter.status, ComfortFilterRequestStatus.canceled);

    await tester.tap(find.text('find'));
    await tester.pumpAndSettle();
    expect(searched.single.status, ComfortFilterRequestStatus.canceled);
    expect(find.byType(ComfortRequestsFilterWidget), findsNothing);
    expect(observer.popped.whereType<MaterialPageRoute>(), hasLength(1));
  });

  testWidgets('período incompleto mostra erro e bloqueia a busca',
      (tester) async {
    await pump(tester);
    final today = DateTime.now();

    await tester.tap(startField);
    await tester.pumpAndSettle();
    await confirmDatePicker(tester);
    expect(filter.startDate, isNotNull);
    expect(find.text(fmt(today)), findsOneWidget);
    expect(find.text('comfort_request_filter_date_error'), findsOneWidget);

    await tester.tap(find.text('find'));
    await tester.pumpAndSettle();
    expect(searched, isEmpty);

    // Cancelar o seletor não altera nada.
    await tester.tap(endField);
    await tester.pumpAndSettle();
    await confirmDatePicker(tester, ok: false);
    expect(filter.endDate, isNull);

    await tester.tap(endField);
    await tester.pumpAndSettle();
    await confirmDatePicker(tester);
    expect(filter.endDate, isNotNull);
    expect(find.text('comfort_request_filter_date_error'), findsNothing);
    expect(find.text(fmt(today)), findsNWidgets(2));

    await tester.tap(find.text('find'));
    await tester.pumpAndSettle();
    expect(searched.single.startDate, isNotNull);
    expect(searched.single.endDate, isNotNull);
  });

  testWidgets('só data final mostra o erro do lado inicial', (tester) async {
    filter.endDate = DateTime.now().subtract(const Duration(days: 1));
    await pump(tester);
    expect(find.text('comfort_request_filter_date_error'), findsOneWidget);
    expect(find.text(fmt(filter.endDate!)), findsOneWidget);

    /// Defeito (não exercitado: a asserção derruba o teste): com data final
    /// no passado e sem data inicial, tocar na data inicial chama
    /// `showDatePicker(initialDate: hoje, lastDate: dataFinal)` e viola a
    /// asserção `initialDate <= lastDate` — a tela quebra.
    await tester.tap(find.text('find'));
    await tester.pumpAndSettle();
    expect(searched, isEmpty);
  });

  testWidgets('limpar zera todos os campos', (tester) async {
    filter
      ..status = ComfortFilterRequestStatus.resent
      ..subcategories = ComfortType.gym
      ..startDate = DateTime(2026, 1, 1)
      ..endDate = DateTime(2026, 1, 31);
    await pump(tester);
    expect(find.text('comfort_request_filter_status_resent'), findsOneWidget);
    expect(find.text('comfort_gym'), findsOneWidget);
    expect(find.text(fmt(DateTime(2026, 1, 1))), findsOneWidget);

    await tester.tap(find.text('comfort_request_filter_clear'));
    await tester.pumpAndSettle();

    expect(filter.status, ComfortFilterRequestStatus.all);
    expect(filter.subcategories, ComfortType.all);
    expect(filter.startDate, isNull);
    expect(filter.endDate, isNull);
    expect(find.text('00/00/0000'), findsNWidgets(2));

    // Limpar mudou o filtro em relação ao inicial: a busca é disparada.
    await tester.tap(find.text('find'));
    await tester.pumpAndSettle();
    expect(searched.single.status, ComfortFilterRequestStatus.all);
  });

  testWidgets('fechar e voltar restauram o filtro original', (tester) async {
    await pump(tester);
    await tester.tap(statusDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('comfort_request_filter_status_sent').last);
    await tester.pumpAndSettle();
    expect(filter.status, ComfortFilterRequestStatus.sended);

    await tester.tap(find.ancestor(
        of: svgAsset('assets/ic_close_white.svg'),
        matching: find.byType(IconButton)));
    await tester.pumpAndSettle();
    expect(filter.status, ComfortFilterRequestStatus.all);
    expect(find.byType(ComfortRequestsFilterWidget), findsNothing);
    expect(searched, isEmpty);

    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    await tester.tap(subcategoriesDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('comfort_gym').last);
    await tester.pumpAndSettle();
    expect(filter.subcategories, ComfortType.gym);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(filter.subcategories, ComfortType.all);
    expect(find.byType(ComfortRequestsFilterWidget), findsNothing);
  });
}
