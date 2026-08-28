import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:colaborador/feature/documents/presentation/benefits/widget/benefits_list_view_widget.dart';
import 'package:colaborador/feature/documents/presentation/pay_stub/widget/pay_stub_list_view_widget.dart';
import 'package:colaborador/feature/documents/presentation/vacation/widget/vacation_list_view_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

DocumentInfo _document({
  required int month,
  required String name,
  DocumentTypeEnum type = DocumentTypeEnum.payStub,
}) =>
    DocumentInfo(
      name: name,
      type: type,
      documentProcessingDate: DateTime(2026, month, 5),
    );

String _monthLabel(int month) {
  final label = DateFormat('MMMM').format(DateTime(2000, month));
  return label.substring(0, 1).toUpperCase() + label.substring(1).toLowerCase();
}

Future<List<String>> _pumpList(WidgetTester tester, Widget child) async {
  final routes = <String>[];
  await pumpApp(
    tester,
    Navigator(
      onGenerateRoute: (settings) {
        routes.add(settings.name ?? '');
        return MaterialPageRoute(
          builder: (_) => settings.name == ApplicationRoute.documentFilePage
              ? const SizedBox()
              : child,
        );
      },
    ),
    localized: true,
    shrinkWrap: false,
    settle: false,
    surface: const Size(500, 900),
  );
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  return routes;
}

void main() {
  tearDown(resetTestApplicationContainer);

  final documents = [
    _document(month: 1, name: 'jan.pdf'),
    _document(month: 1, name: 'jan-2.pdf'),
    _document(month: 2, name: 'fev.pdf'),
  ];

  group('PayStubListViewWidget', () {
    testWidgets('agrupa holerites por mês', (tester) async {
      await _pumpList(
        tester,
        PayStubListViewWidget(documentsInfo: documents),
      );

      expect(find.text(_monthLabel(1)), findsOneWidget);
      expect(find.text(_monthLabel(2)), findsOneWidget);
    });

    testWidgets('abre o holerite selecionado', (tester) async {
      final routes = await _pumpList(
        tester,
        PayStubListViewWidget(documentsInfo: documents),
      );

      await tester.tap(find.text(_monthLabel(1)));
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      await tester.tap(find.text('pay_stub_page_list_tile_name 1').first);
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(routes, contains(ApplicationRoute.documentFilePage));
    });
  });

  group('BenefitsListViewWidget', () {
    testWidgets('agrupa comprovantes de benefícios por mês', (tester) async {
      await _pumpList(
        tester,
        BenefitsListViewWidget(documentsInfo: documents),
      );

      expect(find.text(_monthLabel(1)), findsOneWidget);
      expect(find.text(_monthLabel(2)), findsOneWidget);
    });
  });

  group('VacationListViewWidget', () {
    testWidgets('agrupa recibos de férias por ano', (tester) async {
      await _pumpList(
        tester,
        VacationListViewWidget(
          documentsInfo: [
            ...documents,
            DocumentInfo(
              name: '2025.pdf',
              type: DocumentTypeEnum.vacationReceipt,
              documentProcessingDate: DateTime(2025, 7, 1),
            ),
          ],
        ),
      );

      expect(find.text('2026'), findsOneWidget);
      expect(find.text('2025'), findsOneWidget);
    });

    testWidgets('lista vazia não renderiza seções', (tester) async {
      await _pumpList(
        tester,
        const VacationListViewWidget(documentsInfo: []),
      );

      expect(find.text('2026'), findsNothing);
      expect(find.text('2025'), findsNothing);
    });
  });
}
