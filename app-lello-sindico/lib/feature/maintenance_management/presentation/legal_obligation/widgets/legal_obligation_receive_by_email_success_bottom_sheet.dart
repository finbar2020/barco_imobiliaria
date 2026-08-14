import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class LegalObligationReceiveByEmailSuccessBottomSheet {
  const LegalObligationReceiveByEmailSuccessBottomSheet._();

  static Future<void> show(BuildContext context) {
    return GenericSuccessBottomSheet.show<void>(
      context,
      message: getString(
        context,
        'legal_obligation_technical_inspection_email_success_message',
      ),
    );
  }
}
