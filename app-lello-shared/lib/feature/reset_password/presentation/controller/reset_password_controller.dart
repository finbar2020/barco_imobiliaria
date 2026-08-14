part of shared_features;

class ResetPasswordController {
  final ResetPasswordBloc resetPasswordBloc;
  final RequestValidationCode requestValidationCodeUseCase;
  final ResetPassword resetPasswordUseCase;
  final ResetPassword2fa resetPassword2fa;
  final GetMyUser myUserUseCase;
  final AuthenticationStore loginStore;
  final GetDados2fa getDados2faUseCase;
  final Request2fa request2faUseCase;
  final Validate2fa validate2faUseCase;
  final int? idEmpresa;
  late final String appSignature;

  ResetPasswordController({
    required this.resetPasswordBloc,
    required this.requestValidationCodeUseCase,
    required this.resetPasswordUseCase,
    required this.resetPassword2fa,
    required this.myUserUseCase,
    required this.loginStore,
    required this.getDados2faUseCase,
    required this.request2faUseCase,
    required this.validate2faUseCase,
    this.idEmpresa,
  }) {
    SmsAutoFill().getAppSignature.then((signature) {
      appSignature = signature;
    });
  }

  static const int CODE_LENGTH = 6;
  static final RegExp digitsOnly = RegExp(r'[^0-9]');
  static final stepOrder = [
    PasswordResetStep.cpf,
    PasswordResetStep.me,
    PasswordResetStep.password,
  ];
  Future<void> beginTakeMyUser({required String cpf}) async {
    final currentState = resetPasswordBloc.state;
    resetPasswordBloc.add(
      ResetPasswordMyUserLoadingEvent(
          cpf: cpf, reset: currentState.reset, step: currentState.step),
    );

    var onlyNum = cpf.replaceAll(RegExp(r'[^\d ]'), "");

    final result = await getDados2faUseCase.call(
      CodeDataParam(cpf: onlyNum, idEmpresa: idEmpresa ?? FlavorConfig.config.idEmpresa),
    );

    result.fold(
        (err) => resetPasswordBloc.add(
              ResetPasswordMyUserFailedEvent(
                  reset: currentState.reset,
                  step: currentState.step,
                  cpf: cpf,
                  error: err),
            ), (res) {
      if (res.smsContacts.isEmpty && res.emailContacts.isEmpty) {
        return resetPasswordBloc.add(
          ResetPasswordMyUserNoPhoneFailedEvent(
              reset: currentState.reset,
              step: currentState.step,
              cpf: cpf,
              error: null),
        );
      }

      if (res.registered == false) {
        return resetPasswordBloc.add(
          ResetPasswordMyUserNotRegisteredFailedEvent(
              reset: currentState.reset,
              step: currentState.step,
              cpf: cpf,
              error: null),
        );
      }

      return resetPasswordBloc.add(
        ResetPasswordMyUserSucceededEvent(
            codeData: res,
            selectedValue: "",
            type: null,
            reset: currentState.reset,
            step: currentState.step,
            cpf: cpf),
      );
    });
  }

  Future<void> beginResetPassword(
      {required AppOriginEnum appOriginEnum}) async {
    final reset = resetPasswordBloc.state.reset;
    final step = resetPasswordBloc.state.step;
    final validation =
        resetPasswordBloc.state is ResetPasswordCodeValidatedState
            ? (resetPasswordBloc.state as ResetPasswordCodeValidatedState)
                .validation
            : null;
    resetPasswordBloc.add(
      ResetPasswordResettingPasswordEvent(
          reset: reset,
          step: step,
          cpf: resetPasswordBloc.state.cpf,
          validation: validation),
    );

    final result = await resetPassword2fa.call(ResetPassword2faParams(
        cpf: reset.cpf, password: reset.password, token: reset.token));

    result.fold(
        (err) => resetPasswordBloc.add(
              ResetPasswordFailedEvent(
                  error: err,
                  reset: reset,
                  step: step,
                  cpf: resetPasswordBloc.state.cpf,
                  validation: validation),
            ), (res) {
      logEventBasedOnAppOrigin(appOriginEnum: appOriginEnum);
      resetPasswordBloc.add(
        ResetPasswordSucceededEvent(
            reset: res,
            step: step,
            cpf: resetPasswordBloc.state.cpf,
            validation: validation),
      );
    });
  }

  Future<void> beginRequestCode() async {
    final currentState = resetPasswordBloc.state;
    String? phone = currentState.reset.phone ?? "";
    String? email = currentState.reset.email ?? "";
    String? key = currentState.reset.codeValidationId ?? "";

    if (phone.isEmpty && email.isEmpty && key.isEmpty) return;
    currentState.reset.phone = phone;
    currentState.reset.email = email;
    currentState.reset.cpf = currentState.cpf;
    currentState.reset.codeValidationId = currentState.reset.codeValidationId;

    resetPasswordBloc.add(
      ResetPasswordRequestingCodeEvent(
          reset: currentState.reset,
          step: currentState.step,
          cpf: currentState.cpf),
    );

    final request = CodeRequest(
      origin: CodeValidationOrigin.forgotPassword,
      source: phone.isEmpty
          ? CodeValidationSource.email
          : CodeValidationSource.phone,
      value: phone.isEmpty ? email : phone,
      token: "",
      cpf: currentState.cpf.replaceAll(digitsOnly, ''),
      id: key,
    );

    final result = await request2faUseCase
        .call(Tequest2faParam(id: key, appSignature: appSignature));

    result.fold(
      (err) => resetPasswordBloc.add(
        ResetPasswordRequestCodeFailedEvent(
            reset: currentState.reset,
            step: currentState.step,
            cpf: currentState.cpf,
            error: err),
      ),
      (res) => resetPasswordBloc.add(
        ResetPasswordRequestCodeSucceededEvent(
            reset: currentState.reset,
            step: currentState.step,
            cpf: currentState.cpf,
            codeRequest: request),
      ),
    );
  }

  void setPhone(String phone) {
    resetPasswordBloc.state.reset.phone = phone;
  }

  bool revert() {
    if (resetPasswordBloc.state is ResetPasswordRequestPhoneState) {
      return true;
    }
    resetPasswordBloc.state.reset.password = null;
    resetPasswordBloc.state.reset.codeValidationId = null;

    resetPasswordBloc.add(
      ResetPasswordRevertEvent(
          reset: resetPasswordBloc.state.reset,
          step: resetPasswordBloc.state.step,
          cpf: resetPasswordBloc.state.cpf),
    );
    return false;
  }

  void setValidation({required CodeValidation validation}) {
    resetPasswordBloc.add(
      ResetPasswordCodeValidatedEvent(
          validation: validation,
          cpf: resetPasswordBloc.state.cpf,
          reset: resetPasswordBloc.state.reset,
          step: resetPasswordBloc.state.step),
    );
  }

  void nextStep({required PasswordResetStep currentStep}) {
    final index = stepOrder.indexOf(currentStep);
    if (index < stepOrder.length - 1) {
      resetPasswordBloc.add(
        PasswordResetChangeStepEvent(
            step: stepOrder[index + 1],
            reset: resetPasswordBloc.state.reset,
            cpf: resetPasswordBloc.state.cpf),
      );
    } else {
      resetPasswordBloc.add(
        PasswordResetEvent(),
      );
    }
  }

  bool previousStep({required PasswordResetStep currentStep}) {
    final index = stepOrder.indexOf(currentStep);
    if (index > 0) {
      resetPasswordBloc.add(
        PasswordResetChangeStepEvent(
            step: stepOrder[index - 1],
            reset: resetPasswordBloc.state.reset,
            cpf: resetPasswordBloc.state.cpf),
      );
      return false;
    }
    return true;
  }

  void logEventBasedOnAppOrigin({required AppOriginEnum appOriginEnum}) {
    switch (appOriginEnum) {
      case AppOriginEnum.manager:
        AnalyticsLogEvents.logEvent(
            event: AnalyticsEventsManager.esqueciSenhaFinalizado(),
            referenceValue: "",
            unitValue: "",
            appOrigin: appOriginEnum);
        break;
      case AppOriginEnum.owner:
        AnalyticsLogEvents.logEvent(
            event: AnalyticsEventsOwner.esqueciSenhaFinalizado(),
            userId: "",
            referenceValue: "",
            unitValue: "",
            appOrigin: appOriginEnum);
        break;
      case AppOriginEnum.employee:
        AnalyticsLogEvents.logEvent(
            event: AnalyticsEventsEmployee.esqueciSenhaFinalizado(),
            referenceValue: "",
            unitValue: "",
            appOrigin: appOriginEnum);
        break;
    }
  }

  void dispose() {}
}
