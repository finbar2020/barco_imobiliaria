part of shared_features;

class RegistrationLelloUserWarningPageArgs {
  final RegistrationStore store;
  RegistrationLelloUserWarningPageArgs({required this.store});
}

class RegistrationLelloUserWarningPage extends StatelessWidget {
  final SharedApplicationContainer appContainer;
  final AppOriginEnum appOriginEnum;

  const RegistrationLelloUserWarningPage({
    Key? key,
    required this.appContainer,
    required this.appOriginEnum,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var arguments = ModalRoute.of(context)?.settings.arguments
        as RegistrationLelloUserWarningPageArgs;
    var store = arguments.store;

    return WillPopScope(
      onWillPop: () async {
        store.currentStep = RegistrationStep.cpf;
        store.cpf = null;
        store.dispose();
        // Substitui esta rota pela de login; a navegação já foi tratada aqui,
        // por isso não se aguarda a future (ela só completa quando o login for
        // fechado) e não se deixa o `pop` seguir adiante.
        Navigator.pushReplacementNamed(
          context,
          SharedApplicationRoute.login,
        );
        return false;
      },
      child: Theme(
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
                    BlocConsumer(
                      bloc: store.bloc,
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is RegistrationRequestMyUserFailedState) {
                          if (state.error
                              is RegistrationUserAlreadyRegisteredFailure) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                    getString(context,
                                        "registration_lello_warning_registered_title"),
                                    textAlign: TextAlign.center,
                                    style: LelloTextStyles.headline(theme)!
                                        .copyWith(color: Colors.white)),
                                SizedBox(height: Dimens.spacingMedium),
                                Text(
                                    getString(context,
                                        "registration_lello_warning_registered_subtitle"),
                                    textAlign: TextAlign.center,
                                    style: LelloTextStyles.subtitle(theme)!
                                        .copyWith(color: Colors.white)),
                              ],
                            );
                          }
                          if (state.error is RegistrationUserNotFoundFailure) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                    getString(context,
                                        "registration_lello_warning_title"),
                                    textAlign: TextAlign.center,
                                    style: LelloTextStyles.headline(theme)!
                                        .copyWith(color: Colors.white)),
                                SizedBox(height: Dimens.spacingMedium),
                                Text(
                                    getString(context,
                                        "registration_lello_warning_subtitle"),
                                    textAlign: TextAlign.center,
                                    style: LelloTextStyles.subtitle(theme)!
                                        .copyWith(color: Colors.white)),
                              ],
                            );
                          }
                          if (state.error
                              is RegistrationPhoneAndEmailFoundFailure) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                    getString(context,
                                        "registration_lello_warning_no_data_title"),
                                    style: LelloTextStyles.bodyBold(theme)!
                                        .copyWith(
                                            fontSize: 22,
                                            color: Colors.white)),
                                SizedBox(height: Dimens.spacingLarge),
                                Text(
                                    getString(context,
                                        "registration_lello_warning_no_data_1"),
                                    style: LelloTextStyles.body(theme)!
                                        .copyWith(color: Colors.white)),
                                SizedBox(height: Dimens.spacingLarge),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      "\u2022 ${getString(context, "registration_lello_warning_no_data_2")}",
                                      style: LelloTextStyles.body(theme)!
                                          .copyWith(color: Colors.white),
                                    ),
                                    InkWell(
                                        child: Text(
                                          getString(context,
                                              "registration_lello_warning_no_data_2_click"),
                                          style: LelloTextStyles.body(theme)!
                                              .copyWith(color: Colors.red),
                                        ),
                                        onTap: () {
                                          _openWebPortal(context);
                                        }),
                                  ],
                                ),
                                SizedBox(height: Dimens.spacingLarge),
                                Text(
                                    "\u2022 ${getString(context, "registration_lello_warning_no_data_3").replaceAll('{email}', FlavorConfig.config.supportEmail)}",
                                    style: LelloTextStyles.body(theme)!
                                        .copyWith(color: Colors.white)),
                                SizedBox(height: Dimens.spacingLarge),
                                Text(
                                    "\u2022 ${getString(context, "registration_lello_warning_no_data_4")}",
                                    style: LelloTextStyles.body(theme)!
                                        .copyWith(color: Colors.white)),
                                SizedBox(height: Dimens.spacingXLarge),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                      minWidth: double.infinity),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      _openWhatsapp(context);
                                    },
                                    child: Container(
                                      child: Text(
                                          getString(context,
                                              "registration_lello_warning_no_data_btn"),
                                          style: LelloTextStyles.button(theme)!
                                              .copyWith(color: Colors.black)),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          if (state.error is RegistrationLockedRolloutFailure) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                    getString(context,
                                        "registration_lello_warning_rollout_title"),
                                    style: LelloTextStyles.bodyBold(theme)!
                                        .copyWith(
                                            fontSize: 22,
                                            color: Colors.white)),
                                SizedBox(height: Dimens.spacingLarge),
                                Text(
                                    getString(context,
                                        "registration_lello_warning_rollout_text"),
                                    style: LelloTextStyles.body(theme)!
                                        .copyWith(color: Colors.white)),
                              ],
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                  getString(
                                      context, "registration_failed_title"),
                                  textAlign: TextAlign.center,
                                  style: LelloTextStyles.headline(theme)),
                              SizedBox(height: Dimens.spacingMedium),
                              Text(getString(context, "error_unknown"),
                                  textAlign: TextAlign.center,
                                  style: LelloTextStyles.subtitle(theme)),
                            ],
                          );
                        }
                        if (state is RegistrationAuthFailedState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                  getString(context,
                                      "registration_failed_auth_title"),
                                  textAlign: TextAlign.center,
                                  style: LelloTextStyles.headline(theme)!
                                      .copyWith(color: Colors.white)),
                              SizedBox(height: Dimens.spacingMedium),
                              Text(
                                  getString(context,
                                      "registration_failed_auth_message"),
                                  textAlign: TextAlign.center,
                                  style: LelloTextStyles.subtitle(theme)!
                                      .copyWith(color: Colors.white)),
                            ],
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                    SizedBox(height: Dimens.spacingXLarge),
                    Theme(
                      data: theme.copyWith(
                        textTheme: theme.textTheme.copyWith(
                          labelLarge: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      child: PrimaryButton(
                        buttonColor: Colors.white,
                        text: getString(
                            context, "registration_lello_warning_cta_primary"),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(height: Dimens.spacing),
                    SecondaryButton(
                      buttonBorderColor: Colors.white,
                      text: getString(
                          context, "registration_lello_warning_cta_secondary"),
                      onPressed: () {
                        store.dispose();
                        Navigator.pushNamedAndRemoveUntil<dynamic>(
                          context,
                          SharedApplicationRoute.login,
                          (route) => false,
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openWebPortal(BuildContext context) async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetch();
    await remoteConfig.fetchAndActivate();
    var useTermsConfig = jsonDecode(
        remoteConfig.getString(CustomFirebaseRemoteConfig.resolvaFacil));

    var url = useTermsConfig["link"];
    UrlLauncherNative.openUrl(url);
  }

  String get getSupportWhatsappNumber {
    switch (appOriginEnum) {
      case AppOriginEnum.owner:
        return FlavorConfig.config.supportMoradorWhatsAppNumber;
      case AppOriginEnum.employee:
        return FlavorConfig.config.supportColaboradorWhatsAppNumber;
      case AppOriginEnum.manager:
        return FlavorConfig.config.supportSindicoWhatsAppNumber;
    }
  }

  Future<void> _openWhatsapp(BuildContext context) async {
    String text = "Oi, pode me ajudar?";
    Launch.whatsApp(
      context,
      getSupportWhatsappNumber,
      message: text,
    );
  }
}
