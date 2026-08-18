import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/vox/domain/entity/document_request.dart';
import 'package:lello/feature/vox/domain/entity/recipient_type.dart';
import 'package:lello/feature/vox/presentation/request/widget/vox_review_step.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — revisão do comunicado', (tester) async {
    await pumpApp(
      tester,
      VoxReviewStep(
        plainText: true,
        request: DocumentRequest(
          content: 'Comunicado de assembleia na próxima terça-feira.',
          recipientType: RecipientType.all,
          value: '150,00',
        ),
      ),
      shrinkWrap: false,
      surface: const Size(400, 280),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/vox_review_step.png'),
    );
  });
}
