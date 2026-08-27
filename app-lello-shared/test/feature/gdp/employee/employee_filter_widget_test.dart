import 'package:essentials/essentials.dart' hide isNull, isNotNull, Address;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee_list_filter.dart';
import 'package:shared_features/feature/gdp/employee/presentation/widget/employee_filter_widget.dart';

import '../../../helpers/pump_app.dart';
import 'gdp_rest_test_helpers.dart';

void main() {
  late GdpEnv env;
  final fmt = DateFormat.yMd();
  final currency = NumberFormat.currency(symbol: 'R\$');

  setUp(() => env = GdpEnv());

  Future<void> pumpFilter(WidgetTester tester, EmployeeListFilter entity,
      {void Function(EmployeeListFilter)? onApply, VoidCallback? onClose}) {
    return pumpApp(
      tester,
      EmployeeFilterWidget(
          entity: entity,
          onApply: onApply,
          onClose: onClose,
          appContainer: env.container()),
      surface: const Size(400, 1500),
    );
  }

  Finder field(int index) => find.byType(TextFormField).at(index);

  final n = DateTime.now();
  final hoje = DateTime(n.year, n.month, n.day);

  testWidgets('preenche os campos com os valores do filtro', (tester) async {
    final entity = EmployeeListFilter(
        name: 'Ana',
        role: 'Porteiro',
        salaryFrom: 1000,
        salaryTo: 2000.5,
        dobFrom: DateTime(1990, 1, 2),
        dobTo: DateTime(1991, 3, 4))
      ..hiringDateFrom = DateTime(2020, 5, 6)
      ..hiringDateTo = DateTime(2021, 7, 8);
    await pumpFilter(tester, entity);

    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('Porteiro'), findsOneWidget);
    expect(find.text(currency.format(1000)), findsOneWidget);
    expect(find.text(currency.format(2000.5)), findsOneWidget);
    expect(find.text(fmt.format(DateTime(1990, 1, 2))), findsOneWidget);
    expect(find.text(fmt.format(DateTime(1991, 3, 4))), findsOneWidget);
    expect(find.text(fmt.format(DateTime(2020, 5, 6))), findsOneWidget);
    expect(find.text(fmt.format(DateTime(2021, 7, 8))), findsOneWidget);
    expect(find.text('Status'), findsOneWidget);
    expect(find.text('gdp_salary'), findsOneWidget);
    expect(find.text('payment_filter_from'), findsNWidgets(3));

    await expectLater(findGoldenSurface(),
        matchesGoldenFile('goldens/employee_filter_widget.png'));
  });

  testWidgets('buscar salva os campos no filtro e chama onApply',
      (tester) async {
    EmployeeListFilter? applied;
    final entity = EmployeeListFilter();
    await pumpFilter(tester, entity, onApply: (f) => applied = f);

    await tester.enterText(field(0), 'Ana');
    await tester.enterText(field(1), 'Zelador');
    await tester.enterText(field(2), '150000');
    await tester.enterText(field(3), '250050');
    await tester.pump();
    expect(find.text('R\$1,500.00'), findsOneWidget);

    // status pelo dropdown
    await tester.tap(find.byWidgetPredicate((w) => w is DropdownButtonFormField));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Demitido').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('search'));
    await tester.pumpAndSettle();

    expect(applied, same(entity));
    expect(entity.name, 'Ana');
    expect(entity.role, 'Zelador');
    expect(entity.salaryFrom, 1500.0);
    expect(entity.salaryTo, 2500.5);
    expect(entity.conditionName, 'Demitido');
    expect(entity.dobFrom, isNull);
    expect(entity.dobTo, isNull);
    expect(entity.hiringDateFrom, isNull);
    expect(entity.hiringDateTo, isNull);
    expect(find.text('filter_validation_error'), findsNothing);
  });

  testWidgets('data inválida mostra o erro de validação e não aplica',
      (tester) async {
    var applied = false;
    await pumpFilter(tester, EmployeeListFilter(), onApply: (_) => applied = true);

    await tester.enterText(field(4), '99/99/9999');
    await tester.tap(find.text('search'));
    await tester.pumpAndSettle();

    expect(applied, isFalse);
    expect(find.text('filter_validation_error'), findsOneWidget);
    expect(find.text('validation_invalid_date'), findsOneWidget);

    // corrigindo, o erro some
    await tester.enterText(field(4), '');
    await tester.tap(find.text('search'));
    await tester.pumpAndSettle();
    expect(applied, isTrue);
    expect(find.text('filter_validation_error'), findsNothing);
  });

  testWidgets('data digitada é convertida ao salvar', (tester) async {
    final entity = EmployeeListFilter();
    await pumpFilter(tester, entity, onApply: (_) {});
    // a máscara exige dois dígitos (##/##/####); o formato é M/d/yyyy
    await tester.enterText(field(5), '02/03/2001');
    await tester.tap(find.text('search'));
    await tester.pumpAndSettle();

    expect(entity.dobTo, DateTime(2001, 2, 3));
  });

  testWidgets('tocar nas datas de nascimento abre o calendário e preenche',
      (tester) async {
    final entity = EmployeeListFilter();
    await pumpFilter(tester, entity, onApply: (_) {});

    await tester.tap(field(4));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(entity.dobFrom, hoje);
    expect(
        (tester.widget(field(4)) as TextFormField).controller?.text, fmt.format(hoje));

    await tester.tap(field(5));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(entity.dobTo, hoje);
    expect(
        (tester.widget(field(5)) as TextFormField).controller?.text, fmt.format(hoje));

    await tester.tap(find.text('search'));
    await tester.pumpAndSettle();
    expect(entity.dobFrom, hoje);
    expect(entity.dobTo, hoje);
  });

  /// Defeito: os campos de data de admissão escrevem no controller trocado
  /// ("de" escreve em `toHiringDateController` e "até" em
  /// `fromHiringDateController`). O `build` re-sincroniza o campo certo a
  /// partir da entidade, então escolher "de" preenche os DOIS campos e, ao
  /// buscar, `hiringDateTo` também é salvo com a data de "de".
  testWidgets('datas de admissão preenchem também o campo trocado',
      (tester) async {
    final entity = EmployeeListFilter();
    await pumpFilter(tester, entity, onApply: (_) {});

    await tester.tap(field(6));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(entity.hiringDateFrom, hoje);
    expect(entity.hiringDateTo, isNull);
    expect((tester.widget(field(6)) as TextFormField).controller?.text,
        fmt.format(hoje));
    expect((tester.widget(field(7)) as TextFormField).controller?.text,
        fmt.format(hoje));

    await tester.tap(find.text('search'));
    await tester.pumpAndSettle();
    expect(entity.hiringDateFrom, hoje);
    expect(entity.hiringDateTo, hoje);

    // o campo "até" também escreve no "de"
    final ontem = hoje.subtract(const Duration(days: 1));
    entity
      ..hiringDateFrom = null
      ..hiringDateTo = null;
    await tester.enterText(field(6), '');
    await tester.enterText(field(7), '');
    await tester.tap(field(7));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(entity.hiringDateTo, hoje);
    expect(entity.hiringDateFrom, isNull);
    expect((tester.widget(field(6)) as TextFormField).controller?.text,
        fmt.format(hoje));
    expect(ontem.isBefore(hoje), isTrue);
  });

  testWidgets('enviar o campo pelo teclado passa o foco adiante',
      (tester) async {
    await pumpFilter(tester, EmployeeListFilter());
    await tester.tap(field(0));
    await tester.pump();
    expect(
        (tester.widget(field(0)) as TextFormField).initialValue, '');
    final first =
        tester.widget<EditableText>(find.byType(EditableText).at(0)).focusNode;
    expect(first.hasFocus, isTrue);
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pumpAndSettle();
    expect(first.hasFocus, isFalse);
    expect(FocusManager.instance.primaryFocus, isNotNull);
  });
}
