import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

DocumentInfo _incomeDoc(int year) => DocumentInfo(
      name: 'ir_$year.pdf',
      type: DocumentTypeEnum.incomeReport,
      documentProcessingDate: DateTime(year, 3, 1),
    );

String _tileName(BuildContext context, DocumentInfo doc) {
  final intro = getString(context, 'income_report_list_tile_name');
  return '$intro ${doc.documentProcessingDate.year}';
}

void main() {
  testWidgets('golden — income report vazio', (tester) async {
    await pumpApp(
      tester,
      SizedBox(
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: Text('income_report_description'),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
                child: Text('income_report_empty'),
              ),
            ),
          ],
        ),
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 500),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/income_report_empty.png'),
    );
  });

  testWidgets('golden — income report com itens', (tester) async {
    final docs = [_incomeDoc(2025), _incomeDoc(2024)];
    await pumpApp(
      tester,
      SizedBox(
        height: 520,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: Text('income_report_description'),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: docs.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(Dimens.spacingMedium),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(_tileName(context, docs[index])),
                        ),
                        const Icon(Icons.keyboard_arrow_right, size: 32),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 520),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/income_report_loaded.png'),
    );
  });
}
