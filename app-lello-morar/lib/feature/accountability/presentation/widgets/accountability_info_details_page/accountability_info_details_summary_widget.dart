import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_grouped.dart';

class AccountabilityInfoDetailsSummaryWidget extends StatelessWidget {
  final AccountabilityGrouped accountabilityGrouped;

  const AccountabilityInfoDetailsSummaryWidget({
    Key? key,
    required this.accountabilityGrouped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: Dimens.spacing, horizontal: Dimens.spacingMedium),
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
          Text(
            accountabilityGrouped.description,
            style: LelloTextStyles.titleSmallBold(theme),
          ),
          SizedBox(height: Dimens.spacingSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: _buildComponent(
                  context,
                  "${getString(context, 'accountability_expenses')}:",
                  accountabilityGrouped.debits,
                ),
              ),
              SizedBox(height: Dimens.spacingSmall),
              Expanded(
                child: _buildComponent(
                  context,
                  "${getString(context, 'accountability_income')}:",
                  accountabilityGrouped.credits,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComponent(BuildContext context, String title, double value) {
    ThemeData theme = Theme.of(context);
    final formatCurrency = NumberFormat.currency(symbol: "R\$");
    return Row(
      children: [
        Container(
          child: Text(
            title,
            style: LelloTextStyles.bodyBold(theme),
          ),
        ),
        SizedBox(width: Dimens.spacingXSmall),
        Expanded(
          child: Container(
            child: Text(
              "${formatCurrency.format(value)}",
              style: LelloTextStyles.body(theme),
            ),
          ),
        ),
      ],
    );
  }
}
