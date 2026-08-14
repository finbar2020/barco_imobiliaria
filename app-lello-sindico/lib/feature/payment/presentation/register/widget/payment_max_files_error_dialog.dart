import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';

class PaymentMaxFilesErrorDialog extends StatelessWidget {
  final Function() onTryAgain;
  const PaymentMaxFilesErrorDialog({super.key, required this.onTryAgain});

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
            SvgPicture.asset(
              "assets/max_files_reached.svg",
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getString(context, "payments_max_files_reached"),
              style: theme.textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Dimens.spacingMedium),
            PrimaryButton(
                onPressed: onTryAgain,
                text: getString(context, "try_again"),
                buttonColor: theme.primaryColor),
          ],
        ),
      ),
    );
  }
}
