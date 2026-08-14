import 'dart:async';
import 'dart:developer';

import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_event.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide BlendMode;
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/payment/domain/entity/pendency_approval_action.dart';
import 'package:lello/feature/payment/domain/entity/send_token_data.dart';
import 'package:lello/feature/payment/domain/entity/update_installment_status_enum.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/check_token_bloc/check_token_event.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/check_token_bloc/check_token_state.dart';
import 'package:lello/feature/payment/presentation/pendency/controller/payment_pendency_controller.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/code_input_field.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/token_error_widget.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/token_success_widget.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../domain/entity/payment_installment_in_approval.dart';

class CheckTokenPageArgs {
  int? tokenId;
  final String method;
  final PendencyApprovalAction action;
  bool? isAuthenticated;
  bool? updateInstallmentsSuccess;
  List<PaymentInstallmentInApprovalEntity> installments;

  CheckTokenPageArgs({
    this.tokenId,
    required this.method,
    required this.action,
    this.isAuthenticated,
    this.updateInstallmentsSuccess,
    this.installments = const [],
  });
}

class CheckTokenPage extends StatefulWidget {
  const CheckTokenPage({super.key});

  @override
  State<CheckTokenPage> createState() => _CheckTokenPageState();
}

class _CheckTokenPageState extends State<CheckTokenPage> {
  CheckTokenPageArgs? args;
  bool _resendCodeEnabled = true;
  bool _isTokenValid = false;
  String _timerText = "01:00";
  int _remainingTime = 60;
  Timer? _timer;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final controller =
      ApplicationContainer.instance().resolve<PaymentPendencyController>();
  bool codeCompleted = false;
  String? code;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller.checkTokenBloc.add(CheckTokenInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    args = ModalRoute.of(context)?.settings.arguments as CheckTokenPageArgs?;
    return Theme(
        data: theme,
        child: Scaffold(
          key: scaffoldKey,
          appBar: PrimaryAppBar(
            iconColor: theme.primaryColor,
            theme: theme,
            title: getString(context, "payment_pendency_title"),
            onBackArrowPressed: () {
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  ApplicationRoute.paymentPendency,
                  ModalRoute.withName(
                    ApplicationRoute.payment,
                  ),
                );
              }
            },
          ),
          body: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              Navigator.of(context).pushNamedAndRemoveUntil(
                ApplicationRoute.paymentPendency,
                ModalRoute.withName(
                  ApplicationRoute.payment,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocConsumer(
                  bloc: controller.checkTokenBloc,
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is UpdateInstallmentsLoadingState) {
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
                    // Fluxo de biometria - precisa autenticar E ter sucesso no UpdateInstallments
                    if (args!.isAuthenticated != null &&
                        args!.updateInstallmentsSuccess != null) {
                      if (args!.isAuthenticated == true &&
                          args!.updateInstallmentsSuccess == true) {
                        _analyticsLogSuccess(args!.action);
                        return TokenSuccessWidget(
                          action: args!.action,
                          onClose: () {
                            if (context.mounted) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                ApplicationRoute.paymentPendency,
                                ModalRoute.withName(
                                  ApplicationRoute.payment,
                                ),
                              );
                            }
                          },
                        );
                      } else {
                        _analyticsLogError();
                        return TokenErrorWidget(
                          action: args!.action,
                          onClose: () {
                            if (context.mounted) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                ApplicationRoute.paymentPendency,
                                ModalRoute.withName(
                                  ApplicationRoute.payment,
                                ),
                              );
                            }
                          },
                        );
                      }
                    }
                    // Fluxo de token via email/SMS/WhatsApp (só executa se não for biometria)
                    if ((args!.isAuthenticated == null &&
                            args!.updateInstallmentsSuccess == null) &&
                        state is UpdateInstallmentsSuccessState) {
                      if (state.success == true) {
                        _analyticsLogSuccess(args!.action);
                        return TokenSuccessWidget(
                          action: args!.action,
                          onClose: () {
                            if (context.mounted) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                ApplicationRoute.paymentPendency,
                                ModalRoute.withName(
                                  ApplicationRoute.payment,
                                ),
                              );
                            }
                          },
                        );
                      } else {
                        _analyticsLogError();
                        return TokenErrorWidget(
                          action: args!.action,
                          onClose: () {
                            if (context.mounted) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                ApplicationRoute.paymentPendency,
                                ModalRoute.withName(
                                  ApplicationRoute.payment,
                                ),
                              );
                            }
                          },
                        );
                      }
                    }
                    if ((args!.isAuthenticated == null &&
                            args!.updateInstallmentsSuccess == null) &&
                        state is UpdateInstallmentsFailureState) {
                      _analyticsLogError();
                      return TokenErrorWidget(
                        action: args!.action,
                        onClose: () {
                          if (context.mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              ApplicationRoute.paymentPendency,
                              ModalRoute.withName(
                                ApplicationRoute.payment,
                              ),
                            );
                          }
                        },
                      );
                    }
                    return Column(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Código de verificação",
                                style: LelloTextStyles.title(theme),
                              ),
                              SizedBox(
                                height: Dimens.spacingSmall,
                              ),
                              Text(
                                '''O código foi enviado para "${_getMaskedUserInfoByMethod(args!.method)}".''',
                                style: LelloTextStyles.bodyBold(theme),
                              ),
                              SizedBox(
                                height: Dimens.spacing,
                              ),
                              Text(
                                "Insira o código:",
                                style: LelloTextStyles.bodyBold(theme),
                              ),
                              SizedBox(
                                height: Dimens.spacingSmall,
                              ),
                              CodeInputField(
                                fieldWidth: 80,
                                length: 4,
                                onCodeChanged: (code) {
                                  setState(() {
                                    codeCompleted =
                                        code.length == 4 ? true : false;
                                    this.code = code;
                                  });
                                },
                                onCodeCompleted: (code) async {
                                  setState(() {
                                    codeCompleted = true;
                                    this.code = code;
                                    FocusScope.of(context).unfocus();
                                  });
                                  _isTokenValid =
                                      await controller.onlyCheckToken(
                                          value: int.parse(code),
                                          tokenId: args!.tokenId!);
                                },
                              ),
                              SizedBox(
                                height: Dimens.spacing,
                              ),
                              Visibility(
                                  visible:
                                      _isCodeNotValid(state) && codeCompleted,
                                  child: Center(
                                      child: Text(
                                    'Código inválido',
                                    style: LelloTextStyles.bodyBold(theme)!
                                        .copyWith(
                                      color:
                                          LelloTheme.palleteOf(theme).error(),
                                    ),
                                  ))),
                              SizedBox(
                                height: Dimens.spacing,
                              ),
                              Center(
                                child: Text(
                                  "Verifique se o e-mail está na caixa de spam/arquivo morto/lixo eletrônico.",
                                  style:
                                      LelloTextStyles.bodyBold(theme)!.copyWith(
                                    color: LelloTheme.palleteOf(theme).grey(),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                height: Dimens.spacing,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        text: "Não recebeu o código?",
                                        style: LelloTextStyles.body(theme)),
                                  ),
                                  TextButton(
                                    onPressed:
                                        _resendCodeEnabled ? _resendCode : null,
                                    child: state is ResendTokenLoadingState
                                        ? const CircularProgressIndicator()
                                        : Text(
                                            _resendCodeEnabled
                                                ? getString(context,
                                                    'payment_send_again')
                                                : "${getString(context, 'payment_send_again')} ($_timerText)",
                                            style:
                                                LelloTextStyles.bodyBold(theme)!
                                                    .copyWith(
                                              color: _resendCodeEnabled
                                                  ? theme.primaryColor
                                                  : LelloTheme.palleteOf(theme)
                                                      .grey(),
                                            ),
                                          ),
                                  ),
                                ],
                              )
                            ],
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
                              text: "Voltar",
                            ),
                            PrimaryButton(
                              width: 100,
                              onPressed: codeCompleted == true &&
                                      !_isCodeNotValid(state)
                                  ? () async {
                                      await controller
                                          .checkTokenAndUpdateInstallments(
                                              value: int.parse(code!),
                                              tokenId: args!.tokenId!,
                                              channel: args!.method,
                                              isTokenValid: _isTokenValid,
                                              status:
                                                  _parseActionToUpdateInstallmentStatus(
                                                      args!.action),
                                              installments: args!.installments);
                                    }
                                  : null,
                              text: "Verificar",
                              child: state is UpdateInstallmentsLoadingState ||
                                      state is CheckTokenLoadingState
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ));
  }

  bool _isCodeNotValid(Object? state) {
    return state is CheckTokenFailureState ||
        (state is CheckTokenSuccessState && state.success == false);
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

  Future _resendCode() async {
    controller.checkTokenBloc.add(ResendTokenLoadingEvent());
    if (args == null) {
      controller.checkTokenBloc.add(
        ResendTokenFailureEvent(failure: "Args null"),
      );
      return;
    }
    SendTokenData newData = await controller.sendTokenByMethod(args!.method);
    if (newData.id == null) {
      controller.checkTokenBloc.add(
        ResendTokenFailureEvent(failure: "SendTokenData null"),
      );
      return;
    }
    controller.checkTokenBloc.add(
      ResendTokenSuccessEvent(id: newData.id!),
    );
    args?.tokenId = newData.id!;
    _startTimer();
  }

  _startTimer() {
    setState(() {
      _resendCodeEnabled = false;
      _remainingTime = 60;
      _updateTimerText();
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime == 0) {
        timer.cancel();
        setState(() {
          _resendCodeEnabled = true;
          _timerText = "00:00";
        });
      } else {
        setState(() {
          _remainingTime--;
          _updateTimerText();
        });
      }
    });
  }

  void _updateTimerText() {
    final minutes = (_remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');
    _timerText = "$minutes:$seconds";
  }

  _getMaskedUserInfoByMethod(String method) {
    switch (method) {
      case "EMAIL":
        return controller.maskedEmail();
      case "SMS":
        return controller.maskedPhone();
      case "WHATSAPP":
        return controller.maskedPhone();
      default:
        return null;
    }
  }

  Future<AccessToken?> _getAccessToken(GetToken getToken) async {
    final token = await getToken.call(GetTokenParams(role: null));
    return token.getOrElse(() => null);
  }

  Future<String> _getUserType(GetToken getToken) async {
    final token = await _getAccessToken(getToken);
    return token?.selectedRole ?? "";
  }

  _analyticsLogSuccess(
    PendencyApprovalAction action,
  ) async {
    final SessionBloc sessionBloc = BlocProvider.of(context);
    final GetToken getToken = ApplicationContainer.instance().resolve();
    String reference =
        sessionBloc.state.session!.selectedCondominium?.reference.toString() ??
            "";

    AnalyticsEvent event = action == PendencyApprovalAction.approve
        ? AnalyticsEventsManager.aprovacaoPendenteSucessoAprovar()
        : action == PendencyApprovalAction.reject
            ? AnalyticsEventsManager.aprovacaoPendenteSucessoRecusar()
            : AnalyticsEventsManager.aprovacaoPendenteSucessoSuspender();

    AnalyticsLogEvents.logEvent(
      event: event,
      userType: await _getUserType(getToken),
      referenceValue: reference,
      userId: sessionBloc.state.session?.me?.id ?? "",
      appOrigin: AppOriginEnum.manager,
    );
  }

  _analyticsLogError() async {
    final SessionBloc sessionBloc = BlocProvider.of(context);
    final GetToken getToken = ApplicationContainer.instance().resolve();
    String reference =
        sessionBloc.state.session!.selectedCondominium?.reference.toString() ??
            "";

    AnalyticsLogEvents.logEvent(
      event: AnalyticsEventsManager.aprovacaoPendenteErro(),
      userType: await _getUserType(getToken),
      referenceValue: reference,
      userId: sessionBloc.state.session?.me?.id ?? "",
      appOrigin: AppOriginEnum.manager,
    );
  }
}
