import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_quote.dart';

class AgreementsQuoteDetails extends StatelessWidget {
  const AgreementsQuoteDetails({
    Key? key,
    required this.theme,
    required this.quote,
    required this.index,
  }) : super(key: key);

  final ThemeData theme;
  final AgreementQuote quote;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          Dimens.spacingMedium, Dimens.spacingMedium, Dimens.spacingMedium, 0),
      width: double.infinity,
      color: LelloTheme.palleteOf(theme).background(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${getString(context, "agreements_quote")} $index - ${quote.getDate}",
            style: LelloTextStyles.titleSmall(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).grey(),
            ),
          ),
          SizedBox(
            height: Dimens.spacingSmall,
          ),
          _buidComponent(
              title: getString(context, "agreements_original_value"),
              subtitle: quote.getOriginValue),
          _buidComponent(
              title: getString(context, "agreements_fines_charges"),
              subtitle: quote.getFinesValue),
          _buidComponent(
              title: getString(context, "agreements_total_value"),
              subtitle: quote.getTotalValue),
          SizedBox(
            height: Dimens.spacingSmall,
          ),
          Divider(height: 2),
        ],
      ),
    );
  }

  Widget _buidComponent({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Dimens.spacingSmall,
        ),
        Text(
          title.toUpperCase(),
          style: LelloTextStyles.body(theme)!.copyWith(
            color: LelloTheme.palleteOf(theme).grey(),
          ),
        ),
        SizedBox(
          height: Dimens.spacingXSmall,
        ),
        Text(
          subtitle,
          style: LelloTextStyles.body(theme)!.copyWith(
            color: LelloTheme.palleteOf(theme).text(),
          ),
        ),
        SizedBox(
          height: Dimens.spacingSmall,
        ),
      ],
    );
  }
}
