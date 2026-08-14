import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class RegisterInstallmentsNewSupplierBottomSheet extends StatelessWidget {
  final Function() onButtonPressed;
  const RegisterInstallmentsNewSupplierBottomSheet(
      {super.key, required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(getString(context, "payments_team_register_notice"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.body(theme)!.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                )),
            SizedBox(height: Dimens.spacingXSmall),
            Text(getString(context, "payments_future_classification_notice"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                  color: theme.colorScheme.primary,
                  fontSize: 20,
                )),
            SizedBox(height: Dimens.spacing),
            Text(getString(context, "payments_continue_button_prompt"),
                style: LelloTextStyles.subtitleBold(theme)),
            SizedBox(height: Dimens.spacing),
            PrimaryButton(
                onPressed: () {
                  onButtonPressed();
                  Navigator.of(context).pop(true);
                },
                text: getString(context, "payments_send_without_account"))
          ],
        ),
      ),
    );
  }
}
