import 'package:essentials/essentials.dart';
import 'package:essentials/ui/dimens.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/payment/domain/entity/payment_screens.dart';
import 'package:lello/feature/payment/presentation/register/controllers/payment_registration_controller.dart';
import 'package:lello/feature/payment/presentation/send_financial_department/page/payment_send_financial_department_page.dart';
import 'package:lello/feature/payment/presentation/widget/payment_exit_proccess_dialog.dart';

class PaymentIllegibleDocumentPage extends StatefulWidget {
  const PaymentIllegibleDocumentPage({super.key});

  @override
  State<PaymentIllegibleDocumentPage> createState() =>
      _PaymentIllegibleDocumentPageState();
}

class _PaymentIllegibleDocumentPageState
    extends State<PaymentIllegibleDocumentPage> with WidgetsBindingObserver {
  final controller =
      ApplicationContainer.instance().resolve<PaymentRegistrationController>();

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (ModalRoute.of(context)?.isCurrent == false) return;
    switch (state) {
      case AppLifecycleState.detached:
        controller.sendPaymentAnalyticsTimerStop();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PrimaryAppBar(
        iconColor: theme.primaryColor,
        theme: theme,
        title: getString(context, "register_payment_title"),
        onBackArrowPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return PaymentExitProccessDialog(
                  onConfirm: () {
                    controller.dispose();
                    controller.navigateToPaymentMainAndClearStack(
                        context, PaymentScreens.paymentIllegibleDocumentPage);
                  },
                  onCancel: () {
                    Navigator.pop(context);
                  },
                );
              });
        },
      ),
      body: Container(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200, // Define diretamente a altura.
                child: Lottie.asset(
                  "assets/documents_illegible.json",
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: Dimens.spacingSmall),
              Text(
                getString(context, "payments_illegible_error_title"),
                style: theme.textTheme.headlineLarge!
                    .copyWith(color: LelloTheme.palleteOf(theme).grey()),
                textAlign: TextAlign.center,
              ),
              Text(
                getString(context, "payments_illegible_error_subtitle"),
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Dimens.spacingSmall),
              Text(
                getString(context, "payments_illegible_error_subtitle2"),
                style: theme.textTheme.titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Dimens.spacingMedium),
              PrimaryButton(
                onPressed: () {
                  controller.illegibleDocumentManualButtonAnalyticsLog();
                  controller.sendToPaymentForm(context, autofill: false);
                },
                text: getString(
                    context, "payments_illegible_error_manual_button"),
                buttonColor: theme.primaryColor,
              ),
              SizedBox(height: Dimens.spacingSmall),
              PrimaryButton(
                onPressed: () {
                  if (controller.tempProcessData == null) return;
                  controller.illegibleDocumentSendToFinanceButtonAnalyticsLog();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      ApplicationRoute.paymentSendFinancialDepartment,
                      ModalRoute.withName(ApplicationRoute.payment),
                      arguments: PaymentSendFinancialDepartmentPageArgs(
                          controller.tempProcessData!));
                },
                text: getString(
                    context, "payments_illegible_error_financial_team_button"),
                buttonColor: theme.secondaryHeaderColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
