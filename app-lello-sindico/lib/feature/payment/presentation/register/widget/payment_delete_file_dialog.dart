import 'package:essentials/ui/widget/button/inverted_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';

class PaymentDeleteFileDialog extends StatelessWidget {
  final Function() onConfirm;
  final Function() onCancel;
  const PaymentDeleteFileDialog(
      {super.key, required this.onConfirm, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              getString(context, "register_payment_exclude_file_confirmation"),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Dimens.spacingMedium),
            PrimaryButton(
                onPressed: onConfirm,
                text: getString(context, "yes"),
                buttonColor: theme.primaryColor),
            SizedBox(height: Dimens.spacingSmall),
            InvertedPrimaryButton(
              onPressed: onCancel,
              text: getString(context, "register_payment_cancel"),
              buttonColor: theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
