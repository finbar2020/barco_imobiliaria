import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class LegalObligationPartnerRenewalConfirmationModal extends StatelessWidget {
  const LegalObligationPartnerRenewalConfirmationModal({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LegalObligationPartnerRenewalConfirmationModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              getString(
                context,
                'legal_obligation_partner_renewal_confirmation_title',
              ),
              textAlign: TextAlign.center,
              style: LelloTextStyles.body(theme)?.copyWith(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: palette.text(),
                fontWeight: FontWeight.w800,
                height: 1.5,
                letterSpacing: -0.352,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              getString(
                context,
                'legal_obligation_partner_renewal_confirmation_description',
              ),
              textAlign: TextAlign.center,
              style: LelloTextStyles.body(theme)?.copyWith(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: palette.text(),
                fontWeight: FontWeight.w600,
                height: 1.0,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                theme: theme,
                onPressed: () => Navigator.of(context).pop(true),
                text: getString(
                  context,
                  'legal_obligation_partner_renewal_confirmation_confirm',
                ),
                buttonColor: palette.primary(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: InvertedPrimaryButton(
                onPressed: () => Navigator.of(context).pop(false),
                text: getString(
                  context,
                  'legal_obligation_partner_renewal_confirmation_cancel',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
