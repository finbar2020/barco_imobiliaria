import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/payment/domain/entity/payment_data.dart';
import 'package:lello/feature/payment/domain/entity/payment_screens.dart';
import 'package:lello/feature/payment/domain/entity/process_files_response.dart';
import 'package:lello/feature/payment/presentation/register_form/bloc/register_form_page_bloc.dart';
import 'package:lello/feature/payment/presentation/register_form/bloc/register_form_page_event.dart';
import 'package:lello/feature/payment/presentation/register_form/bloc/register_form_page_state.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/01_register_data/register_form_data.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/02_register_installments/page/register_installments_first_payment_bottom_sheet%20copy.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/02_register_installments/page/register_installments_new_supplier_bottom_sheet.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/02_register_installments/page/register_installments_page.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/02_register_installments/page/register_installments_recomendation_bottom_sheet.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/03_register_ledger_account/register_ledger_account.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/04_send_payment/page/send_payment_data_page.dart';
import 'package:lello/feature/payment/presentation/register_form/page/widgets/step_indicator.dart';
import 'package:lello/feature/payment/presentation/widget/payment_exit_proccess_dialog.dart';
import 'package:lello/feature/payment/presentation/widget/payment_no_ledger_account_dialog.dart';

import '../controllers/register_form_page_controller.dart';

enum stepEnum {
  registerData,
  registerInstallments,
  registerLedgerAccount,
  sendPayment
}

class RegisterFormPage extends StatefulWidget {
  final ProcessFilesResponseEntity data;
  final bool autofill;
  const RegisterFormPage({
    super.key,
    required this.data,
    required this.autofill,
  });

  @override
  State<RegisterFormPage> createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage>
    with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final RegisterFormPageController controller =
      ApplicationContainer.instance().resolve();
  var lastPageIndex = 3;

  final PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    controller.setIsAutofill(widget.autofill);
    controller.setPaymentData(widget.data);
  }

  @override
  void dispose() {
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
    ThemeData theme = Theme.of(context);

    return Theme(
      data: theme,
      child:
          BlocConsumer<RegisterFormPageBloc, RegisterFormPageStepChangedState>(
        bloc: controller.bloc,
        listener: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            pageController.animateToPage(
              state.currentStep,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        builder: (context, state) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) {
                _handleBackPress(state, context);
              }
            },
            child: Scaffold(
              key: _scaffoldKey,
              appBar: PrimaryAppBar(
                title: getString(context, "register_payment_title"),
                theme: theme,
                iconColor: theme.primaryColor,
                onBackArrowPressed: () {
                  confirmPop(context, state);
                },
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimens.spacingSmall,
                        vertical: Dimens.spacing),
                    child: Column(
                      children: [
                        state.currentStep != 3
                            ? Center(
                                child: RegisterFormStepIndicator(
                                    currentStep: state.currentStep,
                                    totalSteps: state.totalSteps))
                            : const SizedBox.shrink(),
                        SizedBox(height: Dimens.spacing),
                        Expanded(
                          child: PageView(
                            controller: pageController,
                            //onPageChanged: onPageChanged,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              RegisterFormStepData(
                                step: 0,
                                controller: controller,
                                onChange: _checkStep,
                              ),
                              RegisterInstallments(
                                step: 1,
                                controller: controller,
                                onChange: _checkStep,
                              ),
                              RegisterLedgerAccount(
                                step: 2,
                                controller: controller,
                                onChange: _checkStep,
                              ),
                              SendPaymentDataPage(
                                step: 3,
                                controller: controller,
                                onChange: _checkStep,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimens.spacingSmall),
                        if (state.currentStep != 3)
                          _buildBottomButtonsRow(context, theme, state),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  VoidCallback? _handleBackPress(
      RegisterFormPageStepChangedState state, BuildContext context) {
    return () {
      FocusScope.of(context).unfocus();
      if (state.currentStep == 0) {
        confirmPop(context, state);
      } else {
        PaymentScreens tela = _getCurrentScreenByStep(state);
        controller.backStepAnalyticsLog(tela);
        controller.bloc
            .add(RegisterFormBlocPageStepChangedEvent(state.currentStep - 1));
      }
    };
  }

  Widget _buildBottomButtonsRow(BuildContext context, ThemeData theme,
      RegisterFormPageStepChangedState state) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: SecondaryButton(
            text: getString(context, "back"),
            onPressed: _handleBackPress(state, context),
          ),
        ),
        const Spacer(flex: 1),
        Flexible(
          flex: 1,
          child: PrimaryButton(
            buttonColor: theme.colorScheme.secondary,
            text: state.currentStep == 2
                ? getString(context, "send")
                : getString(context, "next"),
            onPressed: _handleNextButtonOnPressed(context, state),
          ),
        ),
      ],
    );
  }

  VoidCallback? _handleNextButtonOnPressed(
      BuildContext context, RegisterFormPageStepChangedState state) {
    if (state.currentStep == 2 ||
        state.stepCompletion[state.currentStep] == true) {
      return () {
        FocusScope.of(context).unfocus();

        switch (state.currentStep) {
          case 0:
            _nextPage(state);
            break;

          case 1:
            _handleStepOneLogic(context, state);
            break;

          case 2:
            _handleStepTwoLogic(context, state);
            break;

          case 3:
            _nextPage(state);
            break;

          default:
            break;
        }
      };
    }
    return null;
  }

  void _handleStepOneLogic(
      BuildContext context, RegisterFormPageStepChangedState state) {
    if (_isNewSupplier(state)) {
      _showNewSupplierBottomSheet(context, state);
    } else if (_hasSupplierRecommendation()) {
      _showRecommendationBottomSheet(context, state);
    } else {
      _showFirstPaymentBottomSheet(context, state);
    }
  }

  bool _isNewSupplier(RegisterFormPageStepChangedState state) {
    return state.formData.documentSupplier != null &&
        state.formData.idSupplier == null;
  }

  void _showNewSupplierBottomSheet(
      BuildContext context, RegisterFormPageStepChangedState state) {
    Modal.showBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (context) => RegisterInstallmentsNewSupplierBottomSheet(
        onButtonPressed: () {
          controller.sendWithNoLedgerAccountAnalyticsLog();
        },
      ),
    ).then((value) {
      if (value is bool && value) {
        _nextPage(state, lastStep: true);
      }
    });
  }

  bool _hasSupplierRecommendation() {
    return controller.supplier?.supplierLedgerAccounts?.recomendation != null;
  }

  void _showRecommendationBottomSheet(
      BuildContext context, RegisterFormPageStepChangedState state) {
    Modal.showBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (context) => RegisterInstallmentsRecomendationBottomSheet(
        differentClassificationButton: () {
          controller.sendWithDifferentClassificationAnalyticsLog();
        },
        noLedgerAccountButton: () {
          controller.modalSuggestionNoLedgerAccountAnalyticsLog();
        },
        sendPaymentButton: () {
          controller.modalSuggestionSendPaymentAnalyticsLog();
        },
        controller.supplier!.supplierLedgerAccounts!.recomendation!,
      ),
    ).then((value) {
      if (value is RegisterInstallmentsRecomendationBottomSheetResult) {
        _handleRecommendationResult(value, state);
      }
    });
  }

  void _handleRecommendationResult(
      RegisterInstallmentsRecomendationBottomSheetResult result,
      RegisterFormPageStepChangedState state) {
    switch (result) {
      case RegisterInstallmentsRecomendationBottomSheetResult.sendPayment:
        var recomendationId =
            controller.supplier?.supplierLedgerAccounts?.recomendation?.id;
        if (recomendationId != null) {
          controller.paymentData.ledgerAccount = recomendationId;
        }
        _nextPage(state, lastStep: true);
        break;

      case RegisterInstallmentsRecomendationBottomSheetResult
            .useAnotherClassification:
        _nextPage(state);
        break;

      case RegisterInstallmentsRecomendationBottomSheetResult
            .sendWithoutLedgerAccount:
        _nextPage(state, lastStep: true);
        break;
    }
  }

  void _showFirstPaymentBottomSheet(
      BuildContext context, RegisterFormPageStepChangedState state) {
    Modal.showBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (context) => RegisterInstallmentsFirstPaymentBottomSheet(
          differentClassificationButton: () {
        controller.sendWithDifferentClassificationAnalyticsLog();
      }, noLedgerAccountButton: () {
        controller.modalSuggestionNoLedgerAccountAnalyticsLog();
      }),
    ).then((value) {
      if (value is RegisterInstallmentsFirstPaymentBottomSheetResult) {
        _handleFirstPaymentResult(value, state);
      }
    });
  }

  void _handleFirstPaymentResult(
      RegisterInstallmentsFirstPaymentBottomSheetResult result,
      RegisterFormPageStepChangedState state) {
    switch (result) {
      case RegisterInstallmentsFirstPaymentBottomSheetResult
            .useAnotherClassification:
        _nextPage(state);
        break;

      case RegisterInstallmentsFirstPaymentBottomSheetResult
            .sendWithoutLedgerAccount:
        _nextPage(state, lastStep: true);
        break;
    }
  }

  void _handleStepTwoLogic(
      BuildContext context, RegisterFormPageStepChangedState state) {
    if (state.formData.ledgerAccount == null) {
      _showLedgerAccountDialog(context, state);
    } else {
      _nextPage(state);
    }
  }

  void _showLedgerAccountDialog(
      BuildContext context, RegisterFormPageStepChangedState state) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PaymentNoLedgerAccountDialog(
          onConfirm: () {
            _nextPage(state);
            Navigator.pop(context);
          },
          onCancel: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  PaymentScreens _getCurrentScreenByStep(
      RegisterFormPageStepChangedState state) {
    switch (state.currentStep) {
      case 0:
        return PaymentScreens.paymentFormFirstStep;
      case 1:
        return PaymentScreens.paymentFormSecondStep;
      case 2:
        return PaymentScreens.paymentFormThirdStep;
      default:
        return PaymentScreens.paymentMainPage;
    }
  }

  void _nextPage(RegisterFormPageStepChangedState state, {bool? lastStep}) {
    PaymentScreens tela = _getCurrentScreenByStep(state);
    if (lastStep == true) {
      controller.lastStepSendPaymentAnalyticsLog();
      controller.bloc.add(RegisterFormBlocPageStepChangedEvent(lastPageIndex));
    } else {
      controller.nextStepAnalyticsLog(tela);
      controller.bloc
          .add(RegisterFormBlocPageStepChangedEvent(state.currentStep + 1));
    }
  }

  void confirmPop(
      BuildContext context, RegisterFormPageStepChangedState state) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return PaymentExitProccessDialog(
            onConfirm: () {
              navigateToPaymentMainAndClearStack(context, state);
            },
            onCancel: () {
              Navigator.pop(context);
            },
          );
        });
  }

  void navigateToPaymentMainAndClearStack(
      BuildContext context, RegisterFormPageStepChangedState state) {
    PaymentScreens tela = _getCurrentScreenByStep(state);
    controller.sendPaymentAnalyticsTimerStop();
    controller.backArrowAnalyticsLog(tela);
    Navigator.of(context).pushNamedAndRemoveUntil(
        ApplicationRoute.payment, ModalRoute.withName(ApplicationRoute.home));
  }

  _checkStep(PaymentDataEntity paymentdata) {
    controller.bloc.add(RegisterFormBlocPageFieldChangedEvent(
        controller.bloc.state.currentStep, paymentdata));
  }
}
