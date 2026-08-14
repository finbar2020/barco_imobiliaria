import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_grouped.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_grouped_account.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_grouped_account_entrie.dart';

class AccountabilityDetailGroupedArguments {
  AccountabilityGrouped entity;
  AccountabilityDetailGroupedArguments(this.entity);
}

class AccountabilityDetailsGroupedEntriesPage extends StatelessWidget {
  AccountabilityDetailsGroupedEntriesPage({Key? key}) : super(key: key);

  final formatCurrency = new NumberFormat.currency(symbol: "R\$");

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var arguments = ModalRoute.of(context)!.settings.arguments
        as AccountabilityDetailGroupedArguments;

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).background(),
        appBar: PrimaryAppBar(
            // iconColor: theme.primaryColor,
            title: getString(context, "accountability_title"),
            theme: theme),
        body: _buildBody(theme, context, arguments.entity),
      ),
    );
  }

  Widget _buildBody(
      ThemeData theme, BuildContext context, AccountabilityGrouped entity) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: LelloTheme.palleteOf(theme).background(),
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: Text(getString(context, "condominium_balance_detail_name"),
              style: LelloTextStyles.title(theme)),
        ),
        SizedBox(width: Dimens.spacing),
        _buildSummary(context, entity),
        Expanded(child: _buildAccountItens(context, entity))
      ],
    );
  }

  Widget _buildSummary(BuildContext context, AccountabilityGrouped entity) {
    ThemeData theme = Theme.of(context);
    return Container(
      color: LelloTheme.palleteOf(theme).background(),
      child: Container(
        decoration: ShapeDecoration(
            color: LelloTheme.palleteOf(theme).separator(),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    topLeft: Radius.circular(8)))),
        padding: EdgeInsets.symmetric(
            horizontal: Dimens.spacingMedium, vertical: Dimens.spacingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entity.description,
                style: LelloTextStyles.bodyBold(theme)!.copyWith(fontSize: 20)),
            SizedBox(height: Dimens.spacingSmall),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildTitleAndSubTitleSideBySide(
                          theme,
                          getString(context, "accountability_history_debit"),
                          formatCurrency.format(entity.debits),
                          padding: Dimens.spacingXSmall)
                    ],
                  ),
                ),
                SizedBox(width: Dimens.spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildTitleAndSubTitleSideBySide(
                          theme,
                          getString(context, "accountability_history_credit"),
                          formatCurrency.format(entity.credits),
                          padding: Dimens.spacingXSmall),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountItens(
      BuildContext context, AccountabilityGrouped entity) {
    ThemeData theme = Theme.of(context);
    return ListView.separated(
      itemBuilder: (context, index) {
        final item = entity.accounts[index];
        var mainColor = LelloTheme.palleteOf(theme).background();
        var subColor = LelloTheme.palleteOf(theme).greyCard();
        return Container(
          child: _buildAccountItem(context, item, subColor),
          color: mainColor,
        );
      },
      itemCount: entity.accounts.length,
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: LelloTheme.palleteOf(theme).separator(),
        thickness: 2,
        height: 0,
      ),
    );
  }

  Widget _buildAccountItem(BuildContext context,
      AccountabilityGroupedAccount entity, Color subColor) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                "${entity.description}",
                style: LelloTextStyles.subtitleBold(theme),
              )),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: Dimens.spacingXSmall),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(getString(context, "accountability_total_expenses"),
                          style: LelloTextStyles.bodyBold(theme)),
                      Text(formatCurrency.format(entity.getTotalDebit))
                    ],
                  ),
                ),
                SizedBox(width: Dimens.spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(getString(context, "accountability_total_income"),
                          style: LelloTextStyles.bodyBold(theme)),
                      Text(formatCurrency.format(entity.getTotalCredit))
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: Dimens.spacingSmall),
          Divider(
            color: theme.primaryColor.withOpacity(0.4),
            thickness: 2,
            height: 0,
          ),
          _buildAccountEntrieItens(context, entity, subColor),
          Divider(
            color: theme.primaryColor.withOpacity(0.4),
            thickness: 2,
            height: 0,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountEntrieItens(BuildContext context,
      AccountabilityGroupedAccount entity, Color subColor) {
    ThemeData theme = Theme.of(context);
    return ListView.separated(
      itemBuilder: (context, index) {
        final item = entity.entries[index];
        return Container(
          child: _buildAccountEntrieItem(context, entity, item),
          color: subColor,
        );
      },
      itemCount: entity.entries.length,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: LelloTheme.palleteOf(theme).separator(),
        endIndent: 20,
        indent: 20,
        height: 0,
        thickness: 2,
      ),
    );
  }

  Widget _buildAccountEntrieItem(
      BuildContext context,
      AccountabilityGroupedAccount pai,
      AccountabilityGroupedAccaountEntrie entity) {
    ThemeData theme = Theme.of(context);
    final currencyFormat = new NumberFormat.currency(symbol: "R\$");
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Dimens.spacingMedium, vertical: Dimens.spacingXSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleAndSubTitleSideBySide(
                  theme,
                  getString(context, "accountability_history_account"),
                  pai.account.toString()),
              SizedBox(
                width: Dimens.spacingLarge,
              ),
              _buildTitleAndSubTitleSideBySide(
                  theme,
                  getString(context, "accountability_history_date"),
                  entity.dateFormatted)
            ],
          ),
          _buildTitleAndSubTitle(
              theme,
              getString(context, "accountability_history_description"),
              entity.history),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleAndSubTitleSideBySide(
                  theme,
                  getString(context, "accountability_history_debit"),
                  currencyFormat.format(entity.debit)),
              SizedBox(
                width: Dimens.spacingLarge,
              ),
              _buildTitleAndSubTitleSideBySide(
                  theme,
                  getString(context, "accountability_history_credit"),
                  currencyFormat.format(entity.credit)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitleAndSubTitle(
      ThemeData theme, String title, String subTitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimens.spacingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: LelloTextStyles.bodyBold(theme)),
          SizedBox(
            height: Dimens.spacingSmall,
          ),
          Text(subTitle, style: LelloTextStyles.body(theme))
        ],
      ),
    );
  }

  Widget _buildTitleAndSubTitleSideBySide(
      ThemeData theme, String title, String subTitle,
      {double? padding}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding ?? Dimens.spacingSmall),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(text: "$title ", style: LelloTextStyles.bodyBold(theme)),
          TextSpan(text: subTitle, style: LelloTextStyles.body(theme))
        ]),
      ),
    );
  }
}
