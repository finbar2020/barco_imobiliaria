import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../helpers/pump_app.dart';

/// Lançamento do boleto: o widget só usa `description`, `valueFormatted` e
/// `value` (tipagem dinâmica).
class _Found {
  _Found({this.description, required this.valueFormatted, this.value});
  final String? description;
  final String valueFormatted;
  final double? value;
}

void main() {
  testWidgets('lista os lançamentos e soma o total', (tester) async {
    // `shrinkWrap: false`: o ListView interno dentro do IntrinsicHeight do
    // helper dispara a asserção de semântica do framework.
    await pumpApp(
      tester,
      shrinkWrap: false,
      BilletFoundsListWidget(founds: [
        _Found(description: 'Taxa condominial', valueFormatted: 'R\$ 1.200,50', value: 1200.5),
        _Found(description: 'Fundo de reserva', valueFormatted: 'R\$ 99,50', value: 99.5),
        _Found(description: null, valueFormatted: 'R\$ 0,00', value: null),
      ]),
    );

    expect(find.text('BILLET_FOUNDS_TITLE'), findsOneWidget);
    expect(find.text('billet_found'), findsOneWidget);
    expect(find.text('billet_detail_value'), findsOneWidget);
    expect(find.text('Taxa condominial'), findsOneWidget);
    expect(find.text('Fundo de reserva'), findsOneWidget);
    expect(find.text('R\$ 1.200,50'), findsOneWidget);
    expect(find.text('billet_detail_total'), findsOneWidget);
    expect(find.text('1,300.00'), findsOneWidget);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/billet_founds_list.png'),
    );
  });

  testWidgets('sem lançamentos o total é zero', (tester) async {
    await pumpApp(tester, BilletFoundsListWidget(founds: const []),
        shrinkWrap: false);

    expect(find.text('.00'), findsOneWidget);
  });
}
