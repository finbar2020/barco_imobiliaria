import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_grouped_account.dart';
import 'package:morar/feature/accountability/presentation/widgets/accountability_info_details_page/accountability_info_details_entry_item_widget.dart';

class AccountabilityInfoDetailsEntryWidget extends StatelessWidget {
  final AccountabilityGroupedAccount accountabilityGroupedAccount;
  const AccountabilityInfoDetailsEntryWidget({
    Key? key,
    required this.accountabilityGroupedAccount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final formatCurrency = NumberFormat.currency(symbol: "R\$");
    return Container(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      color: LelloTheme.palleteOf(theme).background(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              Container(
                color: theme.primaryColor,
                width: 12,
                height: 12,
              ),
              SizedBox(width: Dimens.spacingSmall),
              Flexible(
                  child: Text(
                accountabilityGroupedAccount.description,
                style: LelloTextStyles.subtitleBold(theme),
              )),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: Dimens.spacingSmall),
            child: Row(
              children: [
                Expanded(
                  child: _buildComponentColumn(
                    context,
                    getString(context, "accountability_account"),
                    accountabilityGroupedAccount.account.toString(),
                  ),
                ),
                Expanded(
                  child: _buildComponentColumn(
                    context,
                    getString(context, "accountability_total_expenses"),
                    "${formatCurrency.format(accountabilityGroupedAccount.getTotalDebit)}",
                  ),
                ),
                Expanded(
                  child: _buildComponentColumn(
                    context,
                    getString(context, "accountability_total_income"),
                    "${formatCurrency.format(accountabilityGroupedAccount.getTotalCredit)}",
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimens.spacing),
          Divider(
            color: theme.primaryColor.withOpacity(0.4),
            thickness: 2,
            height: 0,
          ),
          ListView.separated(
            itemBuilder: (context, index) {
              return Container(
                child: AccountabilityInfoDetailsEntryItemWidget(
                    accountabilityGroupedAccountEntrie:
                        accountabilityGroupedAccount.entries[index]),
                color: LelloTheme.palleteOf(theme).greyCard(),
              );
            },
            itemCount: accountabilityGroupedAccount.entries.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) => Divider(
              color: LelloTheme.palleteOf(theme).separator(),
              endIndent: 20,
              indent: 20,
              height: 0,
              thickness: 2,
            ),
          ),
          Divider(
            color: theme.primaryColor.withOpacity(0.4),
            thickness: 2,
            height: 0,
          ),
        ],
      ),
    );
  }

  Column _buildComponentColumn(
      BuildContext context, String title, String description) {
    ThemeData theme = Theme.of(context);
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
            description,
            style: LelloTextStyles.body(theme),
          ),
        ),
      ],
    );
  }
}
