import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentRegistrationWarningUnknownProvider extends StatelessWidget {
  const PaymentRegistrationWarningUnknownProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).warning(),
        body: Padding(
          padding: EdgeInsets.all(Dimens.spacingLarge),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset("assets/ic_warning.svg",
                      width: 92, height: 92),
                  SizedBox(height: Dimens.spacingLarge),
                  Text(
                      getString(
                          context, "register_payment_unknown_provider_title"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.headline(theme)),
                  SizedBox(height: Dimens.spacingMedium),
                  Text(
                      getString(context,
                          "register_payment_unknown_provider_description"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitle(theme)),
                  SizedBox(height: Dimens.spacingXLarge),
                  Theme(
                    data: theme.copyWith(
                      textTheme: theme.textTheme.copyWith(
                          labelLarge: theme.textTheme.labelLarge
                              ?.copyWith(color: Colors.black)),
                    ),
                    child: PrimaryButton(
                      buttonColor: Colors.white,
                      text: getString(
                          context, "register_payment_unknown_provider_edit"),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  //bloc.ignoreWaning
                  // SizedBox(height: Dimens.spacing),
                  // SecondaryButton(text: getString(context, "cancel"),onPressed: bloc.cancelWarning)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
