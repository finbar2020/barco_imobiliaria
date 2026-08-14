import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/table.dart' as table;
import 'package:morar/feature/insurance/data/model/insurance_premium_model.dart';
import 'package:morar/feature/insurance/data/model/insurance_table_model.dart';

class InsuranceTable extends StatelessWidget {
  final InsuranceTableModel model;
  final InsurancePremiumModel selectedPremium;
  const InsuranceTable({
    super.key,
    required this.model,
    required this.selectedPremium,
  });

  @override
  Widget build(BuildContext context) {
    final formatCurrency = new NumberFormat.currency(symbol: "R\$");
    ThemeData theme = Theme.of(context);
    return table.Table(children: [
      TableRow(children: [
        Container(
          height: 90.0,
          decoration: BoxDecoration(
              color: Color(0xFF5C0521),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0))),
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              'Prêmio Mensal',
              style: LelloTextStyles.body(theme)!
                  .copyWith(fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ),
        Container(
          height: 90.0,
          decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.only(topRight: Radius.circular(16.0))),
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              "${formatCurrency.format(selectedPremium.custo)}",
              style: LelloTextStyles.body(theme)!
                  .copyWith(fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ),
      ]),
      ...selectedPremium.valores.map((value) {
        String title = model.titulos[value.idTitulo] ?? "*";
        bool isEven = selectedPremium.valores.indexOf(value) % 2 == 0;
        bool isLast = selectedPremium.valores.indexOf(value) ==
            selectedPremium.valores.length - 1;
        if (isEven) {
          return buildEvenRow(theme, title, value.valor, last: isLast);
        } else {
          return buildPairRow(theme, title, value.valor, last: isLast);
        }
      }).toList(),
    ]);
  }

  TableRow buildEvenRow(ThemeData theme, String title, String value,
      {bool last = false}) {
    return TableRow(children: [
      Container(
        height: 120.0,
        decoration: BoxDecoration(
          color: Color(0xFFECECEC),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            title,
            style: LelloTextStyles.body(theme),
          ),
        ),
      ),
      Container(
        height: 120.0,
        decoration: BoxDecoration(
          color: Color(0xFFC81C47),
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(last ? 16.0 : 0.0)),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            value,
            style: LelloTextStyles.body(theme)!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ]);
  }

  TableRow buildPairRow(ThemeData theme, String title, String value,
      {bool last = false}) {
    return TableRow(children: [
      Container(
        height: 120.0,
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            title,
            style: LelloTextStyles.body(theme),
          ),
        ),
      ),
      Container(
        height: 120.0,
        decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(last ? 16.0 : 0.0))),
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            value,
            style: LelloTextStyles.body(theme)!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ]);
  }
}
