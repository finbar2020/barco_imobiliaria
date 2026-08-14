import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class PaymentRegistrationLoading extends StatelessWidget {
  const PaymentRegistrationLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircularProgressIndicator(),
            SizedBox(height: Dimens.spacingLarge),
            Text(getString(context, "register_payment_loading"),
                style: LelloTextStyles.title(theme)),
            SizedBox(height: Dimens.spacingSmall),
            Text(getString(context, "please_wait"),
                style: LelloTextStyles.subBody(theme)),
          ],
        ),
      ),
    );
  }
}
