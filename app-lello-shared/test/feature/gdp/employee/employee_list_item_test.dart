import 'package:essentials/essentials.dart' hide isNull, isNotNull, Address;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/employee/presentation/widget/employee_list_item.dart';

import '../../../helpers/pump_app.dart';
import 'gdp_rest_test_helpers.dart';

void main() {
  testWidgets('mostra os dados do funcionário e chama onPressed ao tocar',
      (tester) async {
    Employee? pressed;
    await pumpApp(
      tester,
      EmployeeListItem(
          employee: employee(full: true), onPressed: (e) => pressed = e),
    );

    expect(find.text('gdp_id'), findsOneWidget);
    expect(find.text('E1'), findsOneWidget);
    expect(find.text('Fulano de Tal'), findsOneWidget);
    expect(find.text(DateFormat.yMd().format(DateTime(1990, 1, 2))),
        findsOneWidget);
    expect(find.text('Porteiro'), findsOneWidget);
    expect(find.text(DateFormat.yMd().format(DateTime(2020, 3, 4))),
        findsOneWidget);
    expect(find.text('ativo'), findsOneWidget);

    await tester.tap(find.byType(InkWell).first);
    expect(pressed?.id, 'E1');

    await expectLater(findGoldenSurface(),
        matchesGoldenFile('goldens/employee_list_item.png'));
  });

  testWidgets('sem funcionário mostra traços e tocar não quebra',
      (tester) async {
    await pumpApp(tester, EmployeeListItem());
    expect(find.text('-'), findsNWidgets(6));
    await tester.tap(find.byType(InkWell).first);
    expect(tester.takeException(), isNull);
  });
}
