import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_grouped_account_entrie.dart';

class AccountabilityInfoDetailsEntryItemWidget extends StatelessWidget {
  final AccountabilityGroupedAccountEntrie accountabilityGroupedAccountEntrie;
  const AccountabilityInfoDetailsEntryItemWidget({
    Key? key,
    required this.accountabilityGroupedAccountEntrie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(symbol: "R\$");
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Dimens.spacing, vertical: Dimens.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildComponentRow(
              context,
              "${getString(context, "accountability_date")}:",
              accountabilityGroupedAccountEntrie.dateFormatted),
          SizedBox(height: Dimens.spacing),
          _buildComponentColumn(
              context,
              getString(context, "accountability_description"),
              accountabilityGroupedAccountEntrie.history),
          SizedBox(height: Dimens.spacing),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: _buildComponentRow(
                    context,
                    "${getString(context, "accountability_expenses")}:",
                    currencyFormat
                        .format(accountabilityGroupedAccountEntrie.debit)),
              ),
              Flexible(
                child: _buildComponentRow(
                    context,
                    "${getString(context, "accountability_income")}:",
                    currencyFormat
                        .format(accountabilityGroupedAccountEntrie.credit)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComponentRow(
      BuildContext context, String title, String description) {
    ThemeData theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            title,
            style: LelloTextStyles.bodyBold(theme),
          ),
        ),
        SizedBox(width: Dimens.spacingXSmall),
        Flexible(
          child: Container(
            child: Text(
              description,
              style: LelloTextStyles.body(theme),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComponentColumn(
      BuildContext context, String title, String description) {
    ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            title,
            style: LelloTextStyles.bodyBold(theme),
          ),
        ),
        SizedBox(height: Dimens.spacingXSmall),
        Container(
          child: Text(
            description,
            style: LelloTextStyles.body(theme),
          ),
        ),
      ],
    );
  }
}
