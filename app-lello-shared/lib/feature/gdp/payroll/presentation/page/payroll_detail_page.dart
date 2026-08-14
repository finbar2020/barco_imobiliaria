import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_features/feature/gdp/payroll/domain/entity/payroll.dart';
import 'package:shared_features/shared_features.dart';

class PayrollDetailPage extends StatefulWidget {
  @override
  _PayrollDetailPageState createState() => _PayrollDetailPageState();
}

class _PayrollDetailPageState extends State<PayrollDetailPage> {
  final monthFormat = DateFormat.yMMMM();
  final currencyFormat = new NumberFormat.currency(symbol: "R\$");

  Payroll? _payroll;

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.light;
    _payroll = ModalRoute.of(context)!.settings.arguments as Payroll?;
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
            theme: theme, title: getString(context, "gdp_payroll")),
        body: _buildBody(theme),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    return SingleChildScrollView(
      child: Column(children: [
        _buildHeader(theme),
        _buildContent(theme),
      ]),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      color: LelloTheme.palleteOf(theme).background(),
      child: Container(
        decoration: ShapeDecoration(
            color: LelloTheme.palleteOf(theme).separator(),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8)))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(getString(context, "payroll_information"),
                  style: LelloTextStyles.subBody(theme)),
              subtitle: Text(
                  _payroll?.period != null
                      ? monthFormat.format(_payroll!.period!)
                      : "-",
                  style: LelloTextStyles.bodyBold(theme)),
            ),
            ListTile(
              title: Text(getString(context, "payroll_type"),
                  style: LelloTextStyles.subBody(theme)),
              subtitle: Text(_payroll?.type ?? "-",
                  style: LelloTextStyles.bodyBold(theme)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: Dimens.spacing),
        ListTile(
          title: Text(getString(context, "payroll_summary"),
              style: LelloTextStyles.subtitleBold(theme)),
        ),
        ListTile(
          title: Text(getString(context, "payroll_total_value"),
              style: LelloTextStyles.bodyBold(theme)),
          subtitle: Text(currencyFormat.format(_payroll?.value ?? 0),
              style: LelloTextStyles.subBody(theme)),
        ),
        ListTile(
          title: Text(getString(context, "payroll_total_discounts"),
              style: LelloTextStyles.bodyBold(theme)),
          subtitle: Text(currencyFormat.format(_payroll?.discounts ?? 0),
              style: LelloTextStyles.subBody(theme)),
        ),
        ListTile(
          title: Text(getString(context, "payroll_total_balance"),
              style: LelloTextStyles.bodyBold(theme)),
          subtitle: Text(currencyFormat.format(_payroll?.balance ?? 0),
              style: LelloTextStyles.subBody(theme)),
        ),
        Padding(
            padding: EdgeInsets.all(Dimens.spacing),
            child: PrimaryButton(
              text: getString(context, "payroll_details"),
              onPressed: () {
                Navigator.of(context).pushNamed(
                    SharedApplicationRoute.gdppayrollEntry,
                    arguments: _payroll);
              },
            ))
      ],
    );
  }
}
