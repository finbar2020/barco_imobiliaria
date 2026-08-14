import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';

class PaymentTwoDifferentCnpjErrorBottomSheet extends StatelessWidget {
  final Function() onSendToFinance;
  final Function() onReturnToPayment;

  const PaymentTwoDifferentCnpjErrorBottomSheet({
    super.key,
    required this.onSendToFinance,
    required this.onReturnToPayment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 200, // Define diretamente a altura.
            child: Lottie.asset(
              "assets/two_different_cnpj.json",
              fit: BoxFit.scaleDown,
            ),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Text(
            getString(context, "payments_different_cnpj_error_title"),
            style: theme.textTheme.headlineLarge
                ?.copyWith(color: theme.primaryColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Dimens.spacingMedium),
          Text(
            getString(context, "payments_different_cnpj_error_subtitle"),
            style: theme.textTheme.bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Dimens.spacingMedium),
          PrimaryButton(
            onPressed: onSendToFinance,
            text: getString(
                context, "payments_dialog_error_financial_team_button"),
            buttonColor: theme.primaryColor,
          ),
          SizedBox(height: Dimens.spacingMedium),
          InvertedPrimaryButton(
            onPressed: onReturnToPayment,
            text: getString(context, "payments_dialog_error_back_button"),
            buttonColor: theme.primaryColor,
          ),
        ],
      ),
    );
  }
}
