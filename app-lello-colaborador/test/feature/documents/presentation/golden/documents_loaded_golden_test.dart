import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:colaborador/feature/documents/presentation/benefits/widget/benefits_loaded_widget.dart';
import 'package:colaborador/feature/documents/presentation/pay_stub/widget/pay_stub_loaded_widget.dart';
import 'package:colaborador/feature/documents/presentation/vacation/widget/vacation_loaded_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

DocumentInfo _doc({required DateTime date}) => DocumentInfo(
      name: 'doc.pdf',
      type: DocumentTypeEnum.payStub,
      documentProcessingDate: date,
    );

void main() {
  testWidgets('golden — benefits vazio', (tester) async {
    await pumpApp(
      tester,
      const SizedBox(
        height: 500,
        child: BenefitsLoadedWidget(documentsInfo: []),
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 500),
    );
    expect(find.text('benefits_page_empty'), findsOneWidget);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/benefits_empty.png'),
    );
  });

  testWidgets('golden — benefits com documentos', (tester) async {
    await pumpApp(
      tester,
      SizedBox(
        height: 600,
        child: BenefitsLoadedWidget(
          documentsInfo: [
            _doc(date: DateTime(2026, 1, 10)),
            _doc(date: DateTime(2025, 6, 1)),
          ],
        ),
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 600),
    );
    expect(find.text('benefits_page_select_year'), findsOneWidget);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/benefits_loaded.png'),
    );
  });

  testWidgets('golden — holerite vazio', (tester) async {
    await pumpApp(
      tester,
      const SizedBox(
        height: 500,
        child: PayStubLoadedWidget(documentsInfo: []),
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 500),
    );
    expect(find.text('pay_stub_page_empty'), findsOneWidget);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/pay_stub_empty.png'),
    );
  });

  testWidgets('golden — holerite com documentos', (tester) async {
    await pumpApp(
      tester,
      SizedBox(
        height: 600,
        child: PayStubLoadedWidget(
          documentsInfo: [
            _doc(date: DateTime(2026, 2, 1)),
          ],
        ),
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 600),
    );
    expect(find.text('pay_stub_page_select_year'), findsOneWidget);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/pay_stub_loaded.png'),
    );
  });

  testWidgets('golden — férias vazio', (tester) async {
    await pumpApp(
      tester,
      SizedBox(
        height: 500,
        child: VacationLoadedWidget(documentsInfo: const []),
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 500),
    );
    expect(find.text('vacation_page_empty'), findsOneWidget);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/vacation_empty.png'),
    );
  });

  testWidgets('golden — férias com documentos', (tester) async {
    await pumpApp(
      tester,
      SizedBox(
        height: 600,
        child: VacationLoadedWidget(
          documentsInfo: [
            _doc(date: DateTime(2026, 3, 1)),
          ],
        ),
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 600),
    );
    expect(find.text('2026'), findsOneWidget);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/vacation_loaded.png'),
    );
  });
}
