import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/navigation/application_route.dart';

class PaymentSendFinancialDepartmentSuccessPage extends StatelessWidget {
  const PaymentSendFinancialDepartmentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
          iconColor: theme.primaryColor,
          theme: theme,
          title: getString(context, "register_payment_title"),
          onBackArrowPressed: () {
            Navigator.of(context)
                .popUntil(ModalRoute.withName(ApplicationRoute.payment));
          },
        ),
        body: Padding(
          padding: EdgeInsets.all(Dimens.spacingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 92),
                      SizedBox(height: Dimens.spacingLarge),
                      Text(
                        getString(
                          context,
                          "payments_send_financial_success_page_title",
                        ),
                        textAlign: TextAlign.center,
                        style: LelloTextStyles.headline(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).primary(),
                        ),
                      ),
                      SizedBox(height: Dimens.spacingLarge),
                      Text(
                        getString(
                          context,
                          "payments_send_financial_success_page_sub_title",
                        ),
                        textAlign: TextAlign.center,
                        style: LelloTextStyles.bodyBold(theme),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Dimens.spacingLarge),
              PrimaryButton(
                buttonColor: theme.colorScheme.secondary,
                text: getString(
                    context, "payments_send_financial_success_page_send_again"),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      ApplicationRoute.paymentSendDocuments,
                      ModalRoute.withName(ApplicationRoute.payment));
                },
              ),
              SizedBox(height: Dimens.spacingMedium),
              SecondaryButton(
                text: getString(context, "back"),
                onPressed: () {
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(ApplicationRoute.payment));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
