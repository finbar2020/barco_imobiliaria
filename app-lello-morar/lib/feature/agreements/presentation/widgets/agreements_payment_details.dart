import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class PaymentDetailsCard extends StatelessWidget {
  const PaymentDetailsCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(Dimens.spacingLarge, Dimens.spacing,
          Dimens.spacingLarge, Dimens.spacingLarge),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getString(context, "agreements_payments"),
            style: LelloTextStyles.bodyBold(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).text(),
            ),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Flexible(
            child: ListView.builder(
              itemCount: 2,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return _buildStatus(theme, index, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildStatus(ThemeData theme, int index, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimens.spacing),
      child: Row(
        children: [
          Container(
            height: 8.0,
            width: 8.0,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(1000.0)),
          ),
          SizedBox(
            width: Dimens.spacingSmall,
          ),
          Flexible(
            child: Text(
              "",
              // "${getString(context, 'agreements_installment') ?? ''} ${index + 1} - ${getString(context, installments[index].getStatusKey) ?? ''}",
              style: LelloTextStyles.body(theme)!.copyWith(
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
