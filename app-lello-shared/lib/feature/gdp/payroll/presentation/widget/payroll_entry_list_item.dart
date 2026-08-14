import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_features/feature/gdp/payroll/domain/entity/payroll_entry.dart';

class PayrollEntryListItem extends StatelessWidget {
  final formatCurrency = NumberFormat.currency(symbol: "R\$");

  final PayrollEntry entry;

  PayrollEntryListItem({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: Text(getString(context, "gdp_id"),
              style: LelloTextStyles.bodyBold(theme)),
          subtitle:
              Text(entry.id ?? "-", style: LelloTextStyles.subBody(theme)),
        ),
        ListTile(
          title: Text(getString(context, "payroll_description"),
              style: LelloTextStyles.bodyBold(theme)),
          subtitle:
              Text(entry.title ?? "-", style: LelloTextStyles.subBody(theme)),
        ),
        ListTile(
          title: Text(getString(context, "payroll_value"),
              style: LelloTextStyles.bodyBold(theme)),
          subtitle: Text(
              entry.value != null ? formatCurrency.format(entry.value) : "-",
              style: LelloTextStyles.subBody(theme)),
        ),
      ],
    ));
  }
}
