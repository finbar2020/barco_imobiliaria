import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class AgreementOptionsPaymentBottomSheet extends StatelessWidget {
  const AgreementOptionsPaymentBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: IconButton(
                icon: Icon(Icons.keyboard_arrow_down),
                color: LelloTheme.palleteOf(theme).grey(),
                onPressed: () {
                  Navigator.pop(context);
                },
              )),
              Text(
                getString(context, 'payment_options'),
                style: LelloTextStyles.titleSmallBold(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).hubText(),
                ),
              ),
              SizedBox(height: Dimens.spacing),
              Text(getString(context, "agreements_payment_options_subtitle"),
                  style: LelloTextStyles.subtitle(theme)),
              SizedBox(height: Dimens.spacing),
              Text(
                getString(context, "agreements_billet_bank"),
                style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).hubText(),
                ),
              ),
              SizedBox(height: Dimens.spacingSmall),
              Text(getString(context, "agreements_billet_bank_description"),
                  style: LelloTextStyles.subtitle(theme)),
              SizedBox(height: Dimens.spacing),
              Text(
                getString(context, "agreements_creditcard_bank"),
                style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).hubText(),
                ),
              ),
              SizedBox(height: Dimens.spacingSmall),
              Text(getString(context, "agreements_creditcard_bank_description"),
                  style: LelloTextStyles.subtitle(theme)),
              Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: Container(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      side: BorderSide(
                          width: 1, color: LelloTheme.palleteOf(theme).text()),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 23.0),
                      child: Text(
                        getString(context, "agreements_ok_understood_button"),
                        style: LelloTextStyles.button(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).text(),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              SizedBox(height: Dimens.spacing),
            ],
          ),
        ),
      ),
    );
  }
}
