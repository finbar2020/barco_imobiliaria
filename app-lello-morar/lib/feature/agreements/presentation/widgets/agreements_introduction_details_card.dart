import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class IntroductionDetailsCard extends StatelessWidget {
  const IntroductionDetailsCard({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(Dimens.spacingMedium, Dimens.spacingMedium,
          Dimens.spacingMedium, Dimens.spacingMedium),
      width: double.infinity,
      color: LelloTheme.palleteOf(theme).separator(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.35),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "101 - JOSE ANTONIO DE SOUZA",
                // agreement.unitAndNameDescription,
                style: LelloTextStyles.subtitle(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              SizedBox(height: Dimens.spacing),
              _buildComponent(
                  title: getString(context, "agreements_payment_method"),
                  subtitle: "Boleto"
                  // getString(context, agreement.getPaymentTypeKey) ?? ""),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildComponent({required String title, required String subtitle}) {
    return Row(
      children: [
        Flexible(
          child: Text(
            "$title ",
            style: LelloTextStyles.bodyBold(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).text(),
            ),
          ),
        ),
        SizedBox(height: Dimens.spacing),
        Flexible(
          child: Text(
            subtitle,
            style: LelloTextStyles.subtitle(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).text(),
            ),
          ),
        ),
      ],
    );
  }
}
