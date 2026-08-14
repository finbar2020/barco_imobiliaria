import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class ResinDeleteBankAccountDialog extends StatelessWidget {
  final Function() confirmationFunction;
  const ResinDeleteBankAccountDialog({
    Key? key,
    required this.confirmationFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Dialog(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: Text(
                getString(context, "resin_delete_bank_account_confirmation"),
                style: LelloTextStyles.body(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
            ),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: Dimens.spacingSmall, horizontal: Dimens.spacingLarge),
      child: Column(
        children: [
          PrimaryButton(
            height: 32.0,
            onPressed: () {
              confirmationFunction();
              Navigator.pop(context);
            },
            text: getString(context, "resin_delete_bank_account_delete"),
          ),
          SizedBox(height: Dimens.spacingSmall),
          SecondaryButton(
            height: 32.0,
            onPressed: () {
              Navigator.pop(context);
            },
            buttonBorderColor: Colors.white,
            child: Text(getString(context, "back")),
          ),
        ],
      ),
    );
  }
}
