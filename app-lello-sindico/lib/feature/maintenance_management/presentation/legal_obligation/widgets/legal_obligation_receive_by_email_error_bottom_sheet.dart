import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class LegalObligationReceiveByEmailErrorBottomSheet {
  const LegalObligationReceiveByEmailErrorBottomSheet._();

  static Future<void> show(BuildContext context) {
    return GenericErrorBottomSheet.show<void>(
      context,
      message: getString(
        context,
        'legal_obligation_technical_inspection_email_error_message',
      ),
    );
  }
}
