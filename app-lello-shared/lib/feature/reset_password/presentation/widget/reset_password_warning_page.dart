part of shared_features;

class ResetPasswordWarningPage extends StatelessWidget {
  final SharedApplicationContainer appContainer;
  ResetPasswordWarningPage({required this.appContainer});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ResetPasswordController resetPasswordController =
        ModalRoute.of(context)!.settings.arguments as ResetPasswordController;
    final ResetPasswordState state =
        resetPasswordController.resetPasswordBloc.state;
    Widget? message;
    if (state is ResetPasswordMyUserFailedState) {
      message = _buildUnknownFailure(theme, context);
      if (state.error is RegistrationUserNotFoundFailure) {
        message = _buildCpfNotFound(theme, context);
      }
    }
    if (state is ResetPasswordMyUserNoPhoneFailedState) {
      message = _buildPhoneNotFound(theme, context);
    }
    if (state is ResetPasswordMyUserNotRegisteredFailedState) {
      message = _buildNotRegistered(theme, context);
    }

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
                  message != null ? message : Container(),
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
                            context,
                            state is ResetPasswordMyUserNotRegisteredFailedState
                                ? "sign_up"
                                : "registration_lello_warning_cta_primary"),
                        onPressed: () async {
                          state is ResetPasswordMyUserNotRegisteredFailedState
                              ? goToRegister(context, resetPasswordController)
                              : resetPasswordController.previousStep(
                                  currentStep: PasswordResetStep.me,
                                );
                          Navigator.pop(context);
                        }),
                  ),
                  SizedBox(height: Dimens.spacing),
                  SecondaryButton(
                      text: getString(
                          context, "registration_lello_warning_cta_secondary"),
                      onPressed: () async {
                        resetPasswordController.previousStep(
                          currentStep: PasswordResetStep.cpf,
                        );
                        Navigator.pop(context);
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCpfNotFound(ThemeData theme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(getString(context, "registration_lello_warning_title"),
            textAlign: TextAlign.center,
            style:
                LelloTextStyles.headline(theme)!.copyWith(color: Colors.white)),
        SizedBox(height: Dimens.spacingMedium),
        Text(getString(context, "registration_lello_warning_subtitle"),
            textAlign: TextAlign.center,
            style:
                LelloTextStyles.subtitle(theme)!.copyWith(color: Colors.white)),
      ],
    );
  }

  Widget _buildPhoneNotFound(ThemeData theme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(getString(context, "registration_failed_title"),
            textAlign: TextAlign.center,
            style:
                LelloTextStyles.headline(theme)!.copyWith(color: Colors.white)),
        SizedBox(height: Dimens.spacingMedium),
        Text(getString(context, "registration_failed_phone_not_fount"),
            textAlign: TextAlign.center,
            style:
                LelloTextStyles.subtitle(theme)!.copyWith(color: Colors.white)),
      ],
    );
  }

  Widget _buildNotRegistered(ThemeData theme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(getString(context, "registration_failed_not_registered_title"),
            textAlign: TextAlign.center,
            style:
                LelloTextStyles.headline(theme)!.copyWith(color: Colors.white)),
        SizedBox(height: Dimens.spacingMedium),
        Text(getString(context, "registration_failed_not_registered"),
            textAlign: TextAlign.center,
            style:
                LelloTextStyles.subtitle(theme)!.copyWith(color: Colors.white)),
      ],
    );
  }

  Widget _buildCpfAlreadyRegistered(ThemeData theme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(getString(context, "registration_lello_warning_registered_title"),
            textAlign: TextAlign.center,
            style:
                LelloTextStyles.headline(theme)!.copyWith(color: Colors.white)),
        SizedBox(height: Dimens.spacingMedium),
        Text(
            getString(
                context, "registration_lello_warning_registered_subtitle"),
            textAlign: TextAlign.center,
            style:
                LelloTextStyles.subtitle(theme)!.copyWith(color: Colors.white)),
      ],
    );
  }

  Widget _buildUnknownFailure(ThemeData theme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(getString(context, "registration_failed_title"),
            textAlign: TextAlign.center,
            style:
                LelloTextStyles.headline(theme)!.copyWith(color: Colors.white)),
        SizedBox(height: Dimens.spacingMedium),
        Text(getString(context, "error_unknown"),
            textAlign: TextAlign.center,
            style:
                LelloTextStyles.subtitle(theme)!.copyWith(color: Colors.white)),
      ],
    );
  }

  goToRegister(BuildContext context,
      ResetPasswordController resetPasswordController) async {
    resetPasswordController.previousStep(
      currentStep: PasswordResetStep.cpf,
    );
    Navigator.pop(context);
    Navigator.pushNamed(context, SharedApplicationRoute.registration,
        arguments: appContainer);
  }
}
