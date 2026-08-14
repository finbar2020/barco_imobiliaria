import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/payment/domain/entity/ledger_account.dart';

enum RegisterInstallmentsRecomendationBottomSheetResult {
  sendPayment,
  useAnotherClassification,
  sendWithoutLedgerAccount,
}

class RegisterInstallmentsRecomendationBottomSheet extends StatelessWidget {
  final LedgerAccountEntity? ledgerAccountEntity;
  final Function() noLedgerAccountButton;
  final Function() differentClassificationButton;
  final Function() sendPaymentButton;
  const RegisterInstallmentsRecomendationBottomSheet(
    this.ledgerAccountEntity, {
    required this.noLedgerAccountButton,
    required this.differentClassificationButton,
    required this.sendPaymentButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(getString(context, "payments_last_payment_account_notice"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.body(theme)!.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                )),
            SizedBox(height: Dimens.spacingXSmall),
            Text("${ledgerAccountEntity?.id} - ${ledgerAccountEntity?.name}",
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                  color: theme.colorScheme.primary,
                  fontSize: 20,
                )),
            SizedBox(height: Dimens.spacing),
            Text(getString(context, "payments_proceed_question"),
                style: LelloTextStyles.subtitleBold(theme)),
            SizedBox(height: Dimens.spacing),
            PrimaryButton(
                onPressed: () {
                  sendPaymentButton();
                  Navigator.of(context).pop(
                      RegisterInstallmentsRecomendationBottomSheetResult
                          .sendPayment);
                },
                text: getString(context, "payments_confirm_send_payment")),
            SizedBox(height: Dimens.spacing),
            PrimaryButton(
                buttonColor: theme.colorScheme.secondary,
                onPressed: () {
                  differentClassificationButton();
                  Navigator.of(context).pop(
                      RegisterInstallmentsRecomendationBottomSheetResult
                          .useAnotherClassification);
                },
                text: getString(context, "payments_use_other_classification")),
            SizedBox(height: Dimens.spacing),
            InvertedPrimaryButton(
                onPressed: () {
                  noLedgerAccountButton();
                  Navigator.of(context).pop(
                      RegisterInstallmentsRecomendationBottomSheetResult
                          .sendWithoutLedgerAccount);
                },
                text: getString(context, "payments_send_without_account")),
          ],
        ),
      ),
    );
  }
}
