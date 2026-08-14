import 'dart:developer';

import 'package:essentials/essentials.dart' hide BlendMode;
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';
import 'package:lello/feature/payment/domain/entity/pendency_approval_action.dart';
import 'package:lello/feature/payment/domain/entity/send_token_data.dart';
import 'package:lello/feature/payment/domain/entity/update_installment_status_enum.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/validation_method_bloc/validation_method_event.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/validation_method_bloc/validation_method_state.dart';
import 'package:lello/feature/payment/presentation/pendency/controller/payment_pendency_controller.dart';
import 'package:lello/feature/payment/presentation/pendency/page/check_token/check_token_page.dart';

class ValidationMethodPageArgs {
  final List<PaymentInstallmentInApprovalEntity> installments;
  final PendencyApprovalAction action;

  ValidationMethodPageArgs({required this.action, required this.installments});
}

class ValidationMethodPage extends StatefulWidget {
  const ValidationMethodPage({super.key});

  @override
  State<ValidationMethodPage> createState() => _ValidationMethodPageState();
}

class _ValidationMethodPageState extends State<ValidationMethodPage> {
  ValidationMethodPageArgs? args;
  bool isUpdatingInstallments = false;
  bool isAuthenticating = false;

  final controller =
      ApplicationContainer.instance().resolve<PaymentPendencyController>();
  final LocalAuthentication auth = LocalAuthentication();
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.validationMethodBloc.add(ValidationMethodEmptyEvent());
  }

  @override
  void dispose() {
    controller.validationStepReasonController.clear();
    controller.validateTokenSelectedOption = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    TextStyle? bodyTextStyle = LelloTextStyles.body(theme);
    args =
        ModalRoute.of(context)?.settings.arguments as ValidationMethodPageArgs?;
    return Theme(
        data: theme,
        child: Scaffold(
          appBar: PrimaryAppBar(
            iconColor: theme.primaryColor,
            theme: theme,
            title: "Etapa de validação",
            onBackArrowPressed: () async {
              final closePage = await _showDiscardChangesConfirmationDialog(
                context,
                theme,
              );

              if (closePage && context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: BlocConsumer(
                bloc: controller.validationMethodBloc,
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is ValidationMethodLoadingState &&
                      isUpdatingInstallments) {
                    return Center(
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
                                      theme.primaryColor, BlendMode.src),
                                ),
                                ValueDelegate.colorFilter(
                                  ['telhado', '**'],
                                  value: ColorFilter.mode(
                                      theme.colorScheme.secondary,
                                      BlendMode.src),
                                ),
                              ]),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            getString(context, "please_wait"),
                            style: theme.textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: args?.action !=
                                    PendencyApprovalAction.approve,
                                child: Form(
                                  key: _key,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        getString(context,
                                            'payment_choose_suspension_reason'),
                                        style: LelloTextStyles.bodyBold(theme),
                                      ),
                                      SizedBox(height: Dimens.spacing),
                                      PrimaryTextFormField(
                                        hint: getString(context,
                                            'payment_write_reason_here'),
                                        controller: controller
                                            .validationStepReasonController,
                                        maxLength: 200,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Campo obrigatório";
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            controller
                                                .validationStepReasonController
                                                .text = value;
                                          });
                                        },
                                      ),
                                      SizedBox(height: Dimens.spacing),
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                "Escolha qual será seu meio de verificação:",
                                style: args?.action !=
                                        PendencyApprovalAction.approve
                                    ? LelloTextStyles.bodyBold(theme)
                                    : LelloTextStyles.title(theme),
                              ),
                              SizedBox(height: Dimens.spacing),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RadioListTile<String>(
                                    title: Text(
                                      "Email: ${controller.maskedEmail()}",
                                      style: bodyTextStyle,
                                    ),
                                    value: "EMAIL",
                                    groupValue:
                                        controller.validateTokenSelectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        controller.validateTokenSelectedOption =
                                            value;
                                      });
                                    },
                                  ),
                                  if (controller.maskedPhone() != null) ...[
                                    RadioListTile<String>(
                                      title: Text(
                                        "Celular: ${controller.maskedPhone()}",
                                        style: bodyTextStyle,
                                      ),
                                      value: "SMS",
                                      groupValue: controller
                                          .validateTokenSelectedOption,
                                      onChanged: (value) {
                                        setState(() {
                                          controller
                                                  .validateTokenSelectedOption =
                                              value;
                                        });
                                      },
                                    ),
                                    RadioListTile<String>(
                                      title: Text(
                                        "WhatsApp: ${controller.maskedPhone()}",
                                        style: bodyTextStyle,
                                      ),
                                      value: "WHATSAPP",
                                      groupValue: controller
                                          .validateTokenSelectedOption,
                                      onChanged: (value) {
                                        setState(() {
                                          controller
                                                  .validateTokenSelectedOption =
                                              value;
                                        });
                                      },
                                    ),
                                  ],
                                  RadioListTile<String>(
                                    title: Text(
                                      getString(context, 'payment_biometrics'),
                                      style: bodyTextStyle,
                                    ),
                                    value: "APLICATIVO",
                                    groupValue:
                                        controller.validateTokenSelectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        controller.validateTokenSelectedOption =
                                            value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InvertedPrimaryButton(
                            width: 100,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            text: getString(context, 'payment_back'),
                          ),
                          PrimaryButton(
                            width: 100,
                            onPressed: _fieldsValidationByAction(
                                        args!.action) &&
                                    state is! ValidationMethodLoadingState
                                ? () async {
                                    switch (controller
                                        .validateTokenSelectedOption) {
                                      case "EMAIL":
                                      case "SMS":
                                      case "WHATSAPP":
                                        SendTokenData data =
                                            await controller.sendTokenByMethod(
                                          controller
                                              .validateTokenSelectedOption!,
                                        );
                                        if (data.id == null) {
                                          return;
                                        }
                                        Navigator.pushNamed(
                                          context,
                                          ApplicationRoute.paymentCheckToken,
                                          arguments: CheckTokenPageArgs(
                                              tokenId: data.id!,
                                              action: args!.action,
                                              method: controller
                                                  .validateTokenSelectedOption!,
                                              installments: args!.installments),
                                        );
                                        break;
                                      case "APLICATIVO":
                                        _authenticateUser(args!.action);
                                        break;
                                    }
                                  }
                                : null,
                            text: getString(context, 'payment_send'),
                            child: state is ValidationMethodLoadingState
                                ? const CircularProgressIndicator()
                                : null,
                          ),
                        ],
                      ),
                    ],
                  );
                }),
          ),
        ));
  }

  bool _fieldsValidationByAction(PendencyApprovalAction action) {
    if (action == PendencyApprovalAction.approve) {
      return controller.validateTokenSelectedOption != null;
    } else {
      return controller.validationStepReasonController.text.isNotEmpty &&
          controller.validateTokenSelectedOption != null;
    }
  }

  Future<void> _authenticateUser(PendencyApprovalAction action) async {
    if (isAuthenticating) return;
    setState(() {
      isAuthenticating = true;
    });
    try {
      Iterable<AuthMessages> authMessages = <AuthMessages>[
        IOSAuthMessages(
          cancelButton: getString(context, "spash_biometric_cancel"),
          localizedFallbackTitle:
              getString(context, "spash_biometric_fallback"),
        ),
        AndroidAuthMessages(
          cancelButton: getString(context, "spash_biometric_cancel"),
          signInHint: getString(context, "spash_biometric_hint"),
          signInTitle: getString(context, "spash_biometric_signin_title"),
        ),
      ];

      await auth.stopAuthentication();

      bool isAuthenticated = await auth.authenticate(
        localizedReason: getString(context, "spash_biometric"),
        authMessages: authMessages,
      );

      controller.validationMethodBloc.add(ValidationMethodLoadingEvent());
      setState(() {
        isUpdatingInstallments = true;
      });
      bool updateInstallments = await controller.inAppAuthUpdateInstallments(
        isUserApproved: isAuthenticated,
        status: _parseActionToUpdateInstallmentStatus(args!.action),
        installments: args!.installments,
      );

      if (!updateInstallments) {
        controller.validationMethodBloc.add(ValidationMethodFailureEvent());
      } else {
        controller.validationMethodBloc.add(ValidationMethodSuccessEvent());
      }
      setState(() {
        isUpdatingInstallments = false;
        isAuthenticating = false;
      });
      Navigator.pushNamed(context, ApplicationRoute.paymentCheckToken,
          arguments: CheckTokenPageArgs(
            action: args!.action,
            method: controller.validateTokenSelectedOption!,
            isAuthenticated: isAuthenticated,
            updateInstallmentsSuccess: updateInstallments,
            installments: args!.installments,
          ));
    } catch (e) {
      setState(() {
        isAuthenticating = false;
      });
    }
  }

  _parseActionToUpdateInstallmentStatus(
    PendencyApprovalAction action,
  ) {
    switch (action) {
      case PendencyApprovalAction.approve:
        return UpdateInstallmentStatus.approved;
      case PendencyApprovalAction.reject:
        return UpdateInstallmentStatus.canceled;
      case PendencyApprovalAction.suspend:
        return UpdateInstallmentStatus.suspended;
    }
  }

  Future _showDiscardChangesConfirmationDialog(
    BuildContext context,
    ThemeData theme,
  ) =>
      showDialog(
        context: context,
        builder: (ctx) => Center(
          child: Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Você não terminou o processo de aprovação.\nDeseja realmente sair?',
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.subtitleBold(theme),
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  PrimaryButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    text: 'Sim, sair',
                  ),
                  SizedBox(height: Dimens.spacing),
                  SecondaryButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    text: 'Não, voltar',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
