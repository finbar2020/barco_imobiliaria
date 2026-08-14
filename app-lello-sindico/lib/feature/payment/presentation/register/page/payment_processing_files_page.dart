import 'dart:ui' as ui;
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/payment/domain/entity/payment_screens.dart';
import 'package:lottie/lottie.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/payment/presentation/register/controllers/payment_registration_controller.dart';
import 'package:lello/feature/payment/presentation/widget/payment_exit_proccess_dialog.dart';

class PaymentProcessingFilesPage extends StatefulWidget {
  const PaymentProcessingFilesPage({super.key});

  @override
  State<PaymentProcessingFilesPage> createState() =>
      _PaymentProcessingFilesPageState();
}

class _PaymentProcessingFilesPageState extends State<PaymentProcessingFilesPage>
    with WidgetsBindingObserver {
  final controller =
      ApplicationContainer.instance().resolve<PaymentRegistrationController>();

  @override
  initState() {
    super.initState();
    controller.sendDocuments(context);
  }

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
    return BlocBuilder(
      bloc: controller.bloc,
      builder: (context, state) {
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
                          context, PaymentScreens.paymentProcessingFilesPage);
                    },
                    onCancel: () {
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  child: Lottie.asset(
                    "assets/processing_documents_animation.json",
                    fit: BoxFit.scaleDown,
                    delegates: LottieDelegates(values: [
                      ValueDelegate.colorFilter(
                        ['casa', '**'],
                        value: ColorFilter.mode(
                            theme.primaryColor, ui.BlendMode.src),
                      ),
                      ValueDelegate.colorFilter(
                        ['telhado', '**'],
                        value: ColorFilter.mode(
                            theme.colorScheme.secondary, ui.BlendMode.src),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  getString(context, "payments_processing_your_file"),
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  getString(context, "payments_processing_wait"),
                  style: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
