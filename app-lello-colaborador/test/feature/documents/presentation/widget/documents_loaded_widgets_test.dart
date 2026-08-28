import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:colaborador/feature/documents/presentation/benefits/widget/benefits_loaded_widget.dart';
import 'package:colaborador/feature/documents/presentation/pay_stub/widget/pay_stub_loaded_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

DocumentInfo _document({
  required int year,
  int month = 3,
  String? name,
}) =>
    DocumentInfo(
      name: name ?? 'doc-$year-$month.pdf',
      type: DocumentTypeEnum.payStub,
      documentProcessingDate: DateTime(year, month, 5),
    );

Future<void> _pump(WidgetTester tester, Widget child) async {
  await pumpApp(
    tester,
    Material(child: child),
    localized: true,
    shrinkWrap: false,
    settle: false,
    surface: const Size(500, 900),
  );
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  tearDown(resetTestApplicationContainer);

  final documents = [
    _document(year: 2026, month: 1),
    _document(year: 2026, month: 2),
    _document(year: 2025, month: 11),
  ];

  group('PayStubLoadedWidget', () {
    testWidgets('exibe o seletor de ano com os anos disponíveis',
        (tester) async {
      await _pump(tester, PayStubLoadedWidget(documentsInfo: documents));

      expect(find.text('pay_stub_page_description'), findsOneWidget);
      expect(find.text('pay_stub_page_select_year'), findsOneWidget);
      final dropdown = tester.widget<DropdownButtonFormField<String>>(
        find.byType(DropdownButtonFormField<String>),
      );
      expect(dropdown.initialValue, '2026');
    });

    testWidgets('lista vazia exibe a mensagem própria', (tester) async {
      await _pump(tester, const PayStubLoadedWidget(documentsInfo: []));

      expect(find.text('pay_stub_page_empty'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsNothing);
    });

    testWidgets('troca de ano filtra os holerites', (tester) async {
      await _pump(tester, PayStubLoadedWidget(documentsInfo: documents));

      // 2026 tem dois meses (uma seção por mês), 2025 tem apenas um.
      expect(find.text('pay_stub_page_list_tile_name 1'), findsNWidgets(2));

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      await tester.tap(find.text('2025').last);
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      final dropdown = tester.widget<DropdownButtonFormField<String>>(
        find.byType(DropdownButtonFormField<String>),
      );
      expect(dropdown.initialValue, '2025');
      expect(find.text('pay_stub_page_list_tile_name 1'), findsOneWidget);
    });
  });

  group('BenefitsLoadedWidget', () {
    testWidgets('exibe o seletor de ano dos benefícios', (tester) async {
      await _pump(tester, BenefitsLoadedWidget(documentsInfo: documents));

      expect(find.text('benefits_page_description'), findsOneWidget);
      expect(find.text('benefits_page_select_year'), findsOneWidget);
    });

    testWidgets('lista vazia exibe a mensagem própria', (tester) async {
      await _pump(tester, const BenefitsLoadedWidget(documentsInfo: []));

      expect(find.text('benefits_page_empty'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsNothing);
    });
  });
}
