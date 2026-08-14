part of shared_features;

class ResetPasswordPage extends StatefulWidget {
  final AppOriginEnum appOriginEnum;

  ResetPasswordPage({
    required this.appOriginEnum,
  });

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  PackageInfo? packageInfo;

  @override
  Widget build(BuildContext context) {
    SharedApplicationContainer appContainer = ModalRoute.of(context)!
        .settings
        .arguments as SharedApplicationContainer;
    ResetPasswordController resetPasswordController =
        appContainer.resolve<ResetPasswordController>();
    ResetPasswordBloc resetPasswordBloc =
        resetPasswordController.resetPasswordBloc;
    Validator validator = appContainer.resolve<Validator>();

    var theme = Theme.of(context);
    if (_isGeneric()) {
      theme = LelloTheme.viverDefaultTheme;
    } else if (widget.appOriginEnum == AppOriginEnum.employee) {
      theme = LelloTheme.carimbeira;
    } else {
      theme = LelloTheme.lelloDefaultTheme;
    }

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
          theme: theme,
          title: getString(context, "forgot_password"),
        ),
        body: WillPopScope(
          onWillPop: () async {
            final step = resetPasswordController.resetPasswordBloc.state.step;
            return resetPasswordController.previousStep(currentStep: step);
          },
          child: BlocProvider.value(
            value: resetPasswordBloc,
            child: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
              listener: (context, state) {
                if (state is ResetPasswordSucceededState) {
                  Navigator.pushReplacementNamed(
                      context, SharedApplicationRoute.resetPasswordSuccess);
                }
                if (state is ResetPasswordMyUserFailedState ||
                    state is ResetPasswordMyUserNoPhoneFailedState ||
                    state is ResetPasswordMyUserNotRegisteredFailedState) {
                  Navigator.pushNamed(
                      context, SharedApplicationRoute.resetPasswordWarning,
                      arguments: resetPasswordController);
                }
              },
              builder: (context, state) {
                if (state is ResetPasswordRequestingCodeState) {
                  return Center(
                    child: RequestValidationCodeLoading(
                        source: state.reset.phone != ""
                            ? CodeValidationSource.phone
                            : CodeValidationSource.email),
                  );
                }

                if (state is ResetPasswordRequestCodeSucceededState) {
                  return Padding(
                    padding: EdgeInsets.all(Dimens.spacingMedium),
                    child: BlocProvider<CodeValidationBloc>(
                      create: (context) =>
                          appContainer.resolve<CodeValidationBloc>(),
                      child: CodeValidationPage(
                        codeRequest: state.codeRequest,
                        isGeneric: _isGeneric(),
                        digits: 6,
                        appOriginEnum: widget.appOriginEnum,
                        onSuccess: (validation) {
                          resetPasswordController.setValidation(
                              validation: validation!);
                        },
                        onRestart: () {
                          resetPasswordController.beginTakeMyUser(
                              cpf: state.cpf);
                        },
                        appContainer: appContainer,
                      ),
                    ),
                  );
                }

                if (state is ResetPasswordCodeValidatedState) {
                  return ResetPasswordNewPassword(
                    validator: validator,
                    appOriginEnum: widget.appOriginEnum,
                    resetPasswordController: resetPasswordController,
                  );
                }

                switch (state.step) {
                  case PasswordResetStep.cpf:
                    return PasswordResetCpf(
                      resetPasswordController: resetPasswordController,
                      validator: validator,
                    );
                  case PasswordResetStep.me:
                    return ResetPasswordMeWidget(
                      resetPasswordController: resetPasswordController,
                      validator: validator,
                      appContainer: appContainer,
                    );
                  case PasswordResetStep.password:
                    return ResetPasswordNewPassword(
                      resetPasswordController: resetPasswordController,
                      appOriginEnum: widget.appOriginEnum,
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  bool _isGeneric() {
    String packageName = _getPackageName();
    return packageName == SharedPreferencesKeys.genericSindico ||
        packageName == SharedPreferencesKeys.genericMorar ||
        packageName == SharedPreferencesKeys.iosGenericMorar ||
        packageName == SharedPreferencesKeys.iosGenericSindico;
  }

  String _getPackageName() {
    if (packageInfo != null)
      return packageInfo!.packageName;
    else {
      PackageInfo.fromPlatform().then((value) {
        setState(() {
          packageInfo = value;
        });
      });
      return "";
    }
  }
}
