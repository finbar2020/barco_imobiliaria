import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:morar/feature/accountability/domain/entity/accountability.dart';

class AccountabilityPeriodSummaryWidget extends StatelessWidget {
  final Accountability accountability;

  const AccountabilityPeriodSummaryWidget({
    Key? key,
    required this.accountability,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(symbol: "R\$");
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      decoration: BoxDecoration(
        color: LelloTheme.palleteOf(theme).separator(),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildComponent(
                context,
                getString(context, "accountability_initial_balance"),
                accountability.initialBalance ?? 0.0,
              ),
              _buildComponent(
                context,
                getString(context, "accountability_total_expenses"),
                accountability.totalExpenses ?? 0.0,
              ),
              _buildComponent(
                context,
                getString(context, "accountability_total_income"),
                accountability.totalIncome ?? 0.0,
              ),
            ],
          ),
          SizedBox(height: Dimens.spacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getString(context, "accountability_balance"),
                style: LelloTextStyles.bodyBold(theme),
              ),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
                  child: Container(
                    height: 1.0,
                    color: LelloTheme.palleteOf(theme).hubText(),
                  ),
                ),
              ),
              Text(
                "${formatCurrency.format(accountability.balance)}",
                style: LelloTextStyles.body(theme),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column _buildComponent(BuildContext context, String title, double value) {
    ThemeData theme = Theme.of(context);
    final formatCurrency = NumberFormat.currency(symbol: "R\$");
    return Column(
      children: [
        Container(
          width: 90,
          child: Text(
            title,
            style: LelloTextStyles.bodyBold(theme),
          ),
        ),
        SizedBox(height: Dimens.spacingXSmall),
        Container(
          width: 90.0,
          child: Text(
            "${formatCurrency.format(value)}",
            style: value < 0
                ? LelloTextStyles.body(theme)?.copyWith(
                    color: theme.primaryColor,
                  )
                : LelloTextStyles.body(theme),
          ),
        ),
      ],
    );
  }
}
