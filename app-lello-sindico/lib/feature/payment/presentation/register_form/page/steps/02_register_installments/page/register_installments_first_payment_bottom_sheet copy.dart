import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

enum RegisterInstallmentsFirstPaymentBottomSheetResult {
  useAnotherClassification,
  sendWithoutLedgerAccount,
}

class RegisterInstallmentsFirstPaymentBottomSheet extends StatelessWidget {
  final Function() noLedgerAccountButton;
  final Function() differentClassificationButton;
  const RegisterInstallmentsFirstPaymentBottomSheet({
    required this.noLedgerAccountButton,
    required this.differentClassificationButton,
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
            Text(getString(context, "payments_first_payment_notice"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.body(theme)!.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                )),
            SizedBox(height: Dimens.spacing),
            Text(getString(context, "payments_classify_now_prompt"),
                style: LelloTextStyles.subtitleBold(theme)),
            SizedBox(height: Dimens.spacing),
            PrimaryButton(
                onPressed: () {
                  differentClassificationButton();
                  Navigator.of(context).pop(
                      RegisterInstallmentsFirstPaymentBottomSheetResult
                          .useAnotherClassification);
                },
                text: getString(context, "payments_choose_account")),
            SizedBox(height: Dimens.spacing),
            InvertedPrimaryButton(
                onPressed: () {
                  noLedgerAccountButton();
                  Navigator.of(context).pop(
                      RegisterInstallmentsFirstPaymentBottomSheetResult
                          .sendWithoutLedgerAccount);
                },
                text: getString(context, "payments_send_without_account")),
          ],
        ),
      ),
    );
  }
}
