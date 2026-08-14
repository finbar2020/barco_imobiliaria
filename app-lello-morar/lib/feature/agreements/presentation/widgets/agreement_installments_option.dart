import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_installment_credit.dart';

class AgreementInstallmentsOption extends StatelessWidget {
  final AgreementInstallmentCredit installment;
  const AgreementInstallmentsOption({
    Key? key,
    required this.installment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.light;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            "[${installment.installment}x] R\$ ${installment.installmentValue}",
            style: LelloTextStyles.subtitle(theme)),
        if (installment.creditTax != null)
          SizedBox(height: Dimens.spacingXSmall),
        if (installment.creditTax != null)
          Text(
            "${getString(context, "agreement_card_tax")}",
            style: LelloTextStyles.caption(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).textOpaque(),
            ),
          ),
        if (installment.tax != null) SizedBox(height: Dimens.spacingXSmall),
        if (installment.tax != null)
          Text(
            "${getString(context, "agreement_installment_tax")} ${installment.taxValue} (${installment.tax.toString().replaceAll(".", ",")}%)",
            style: LelloTextStyles.caption(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).textOpaque(),
            ),
          ),
        SizedBox(height: Dimens.spacingLarge),
      ],
    );
  }
}
