import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/core/widget/hex_color.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';

import '../../helpers/pump_app.dart';

void main() {
  test('HexColor interpreta RGB e ARGB', () {
    expect(HexColor('C20332').value, HexColor('#FFC20332').value);
  });

  testWidgets('resident.access traduz o tipo de morador', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return Text(
            Resident(typeAccess: 'morar.proprietario').access(context) ?? '',
          );
        },
      ),
      localized: true,
      locOverrides: const {'residents_owner': 'Proprietário'},
    );
    expect(find.text('Proprietário'), findsOneWidget);
  });
}
