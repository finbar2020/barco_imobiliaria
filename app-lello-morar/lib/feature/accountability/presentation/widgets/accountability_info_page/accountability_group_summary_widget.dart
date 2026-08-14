import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_grouped.dart';
import 'package:morar/feature/accountability/presentation/page/accountability_info_details_page.dart';

class AccountabilityGroupSummaryWidget extends StatelessWidget {
  final AccountabilityGrouped accountabilityGrouped;

  const AccountabilityGroupSummaryWidget({
    Key? key,
    required this.accountabilityGrouped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                accountabilityGrouped.description,
                style: LelloTextStyles.subtitleBold(theme),
              ),
            ),
            SizedBox(width: Dimens.spacingSmall),
            Expanded(
              child: PrimaryButton(
                  text: getString(context, "accountability_details"),
                  height: Dimens.spacingMedium,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      ApplicationRoute.accountabilityInfoDetails,
                      arguments: AccountabilityInfoDetailsPageArgs(
                        accountabilityGrouped: accountabilityGrouped,
                      ),
                    );
                  }),
            ),
          ],
        ),
        SizedBox(height: Dimens.spacingSmall),
        Row(
          children: [
            Expanded(
              child: _buildComponent(
                context,
                getString(context, "accountability_expenses"),
                accountabilityGrouped.debits,
              ),
            ),
            SizedBox(width: Dimens.spacingSmall),
            Expanded(
              child: _buildComponent(
                context,
                getString(context, "accountability_income"),
                accountabilityGrouped.credits,
              ),
            )
          ],
        ),
        SizedBox(height: Dimens.spacingSmall),
      ],
    );
  }

  Column _buildComponent(BuildContext context, String title, double value) {
    ThemeData theme = Theme.of(context);
    final formatCurrency = NumberFormat.currency(symbol: "R\$");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
