import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/payroll/domain/entity/payroll_entry.dart';
import 'package:lello/feature/payroll/presentation/widget/payroll_entry_list_item.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — item da folha de pagamento', (tester) async {
    await pumpApp(
      tester,
      PayrollEntryListItem(
        entry: PayrollEntry()
          ..id = '88'
          ..title = 'Hora extra'
          ..value = 250.5,
      ),
      localized: true,
      locOverrides: const {
        'gdp_id': 'Código',
        'payroll_description': 'Descrição',
        'payroll_value': 'Valor',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/payroll_entry_item.png'),
    );
  });
}
