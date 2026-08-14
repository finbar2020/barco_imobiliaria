import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class LegalObligationPartnerRenewalFailureModal extends StatelessWidget {
  const LegalObligationPartnerRenewalFailureModal({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LegalObligationPartnerRenewalFailureModal(),
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
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: palette.primary(),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            Text(
              getString(
                context,
                'legal_obligation_partner_renewal_failure_message',
              ),
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                color: palette.text(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                theme: theme,
                buttonColor: palette.primary(),
                onPressed: () => Navigator.of(context).pop(),
                text: getString(context, 'close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
