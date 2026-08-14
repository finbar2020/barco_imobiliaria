part of shared_features;

class RegistrationPage extends StatefulWidget {
  final AppOriginEnum appOriginEnum;
  final SharedApplicationContainer appContainer;
  final Future Function(BuildContext)? customTermsModal;

  const RegistrationPage({
    Key? key,
    required this.appOriginEnum,
    required this.appContainer,
    this.customTermsModal,
  }) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  PackageInfo? packageInfo;
  late RegistrationStore store;

  @override
  void initState() {
    store = widget.appContainer.resolve<RegistrationStore>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final validator = widget.appContainer.resolve<Validator>();

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
          title: getString(context, "registration"),
          onBackArrowPressed: () {
            if (store.previousStep()) {
              Navigator.pushNamedAndRemoveUntil<dynamic>(
                context,
                SharedApplicationRoute.login,
                (route) => false,
              );
            }
          },
        ),
        body: Container(
          padding: EdgeInsets.only(
              left: Dimens.spacingMedium,
              right: Dimens.spacingMedium,
              top: Dimens.spacingMedium),
          child: WillPopScope(
            onWillPop: () async {
              return store.previousStep();
            },
            child: BlocConsumer(
              bloc: store.bloc,
              listener: (context, state) async {
                if (state is RegistrationRequestMyUserSucceededState) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    store.nextStep();
                    store.pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  });
                }
                if (state is RegistrationSucceededState) {
                  store.dispose();
                  Navigator.popAndPushNamed(
                      context, SharedApplicationRoute.registrationSuccess);
                }
                if (state is RegistrationRequestMyUserFailedState) {
                  if (state.error is RegistrationUserAlreadyRegisteredFailure) {
                    print("Já Registrado");
                  }
                  if (state.error is RegistrationPhoneAndEmailFoundFailure) {
                    store.dispose();
                    store.currentStep = RegistrationStep.cpf;
                    showDialog(
                      context: context,
                      builder: (context) => RegistrationPhoneEmailEmptyDialog(),
                    );
                  } else if (state.error is RegistrationUserNotFoundFailure) {
                    _showUserNotFoundDialog(context, theme);
                    return;
                  } else {
                    Navigator.pushNamed(
                      context,
                      SharedApplicationRoute.registrationWarning,
                      arguments:
                          RegistrationLelloUserWarningPageArgs(store: store),
                    );
                  }
                }
                if (state is RegistrationCodeRequestFailedState) {
                  store.dispose();
                  Navigator.pushNamed(
                      context, SharedApplicationRoute.registrationFailure,
                      arguments: state.error);
                }
                if (state is RegistrationFailedState) {
                  store.dispose();
                  Navigator.pushNamed(
                      context, SharedApplicationRoute.registrationFailure,
                      arguments: state.error);
                }
                if (state is RegistrationAuthFailedState) {
                  if (state.error is RegistrationUserNotFoundFailure &&
                      widget.appOriginEnum == AppOriginEnum.owner) {
                    _showUserNotFoundDialog(context, theme);
                    return;
                  }

                  Navigator.popAndPushNamed(
                    context,
                    SharedApplicationRoute.registrationWarning,
                    arguments:
                        RegistrationLelloUserWarningPageArgs(store: store),
                  );
                }
              },
              builder: (context, state) {
                final theme = Theme.of(context);
                if (state is RegistrationRequestMyUserLoadingState)
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(height: Dimens.spacingLarge),
                        Text(
                            getString(
                              context,
                              state.loadingMessage ??
                                  "registration_sending_data",
                            ),
                            style: LelloTextStyles.title(theme)),
                        SizedBox(height: Dimens.spacingSmall),
                        Text(getString(context, "please_wait"),
                            style: LelloTextStyles.subBody(theme)),
                      ],
                    ),
                  );

                if (state is RegistrationLoadingState)
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(height: Dimens.spacingLarge),
                        Text(
                            getString(
                              context,
                              "registration_sending_data",
                            ),
                            style: LelloTextStyles.title(theme)),
                        SizedBox(height: Dimens.spacingSmall),
                        Text(getString(context, "please_wait"),
                            style: LelloTextStyles.subBody(theme)),
                      ],
                    ),
                  );
                return PageView(
                  controller: store.pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    RegistrationCpf(
                      store: store,
                      validator: validator,
                      isGeneric: _isGeneric(),
                      appName: packageInfo?.appName ?? "",
                      appOriginEnum: widget.appOriginEnum,
                      customTermsModal: widget.customTermsModal,
                    ),
                    RegistrationMeWidget(
                      store: store,
                      appContainer: widget.appContainer,
                      validator: validator,
                      isGeneric: _isGeneric(),
                      appOriginEnum: widget.appOriginEnum,
                    ),
                    RegistrationPassword(
                      store: store,
                      validator: validator,
                      isGeneric: _isGeneric(),
                      appOriginEnum: widget.appOriginEnum,
                    ),
                    RegistrationPicture(
                      store: store,
                      validator: validator,
                      isGeneric: _isGeneric(),
                      appOriginEnum: widget.appOriginEnum,
                    ),
                  ],
                );
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

  Future _showUserNotFoundDialog(
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
                    'Não encontramos seu CPF',
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.titleBold(theme),
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  widget.appOriginEnum == AppOriginEnum.employee
                      ? SvgPicture.asset(
                          'assets/ic_persons.svg',
                          width: 50,
                        )
                      : widget.appOriginEnum == AppOriginEnum.manager
                          ? SvgPicture.asset(
                              'assets/ic_user_config.svg',
                              width: 50,
                            )
                          : Image.asset(
                              'assets/document.png',
                              width: 50,
                            ),
                  SizedBox(height: Dimens.spacingMedium),
                  if (widget.appOriginEnum == AppOriginEnum.employee) ...[
                    Text(
                      'Tente novamente ou verifique com o Síndico do seu Condomínio.',
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.body(theme),
                    ),
                  ] else if (widget.appOriginEnum == AppOriginEnum.manager) ...[
                    // Síndico
                    Text(
                      'Tente novamente ou verifique com o seu atendimento.',
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.body(theme),
                    ),
                  ] else ...[
                    Text(
                      'Se você é novo inquilino ou imobiliária',
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.bodyBold(theme),
                    ),
                    SizedBox(height: Dimens.spacing),
                    Text(
                      'Solicite seu cadastro para o proprietário do imóvel ou no portal Resolva Fácil em Minha Conta',
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.body(theme),
                    ),
                    SizedBox(height: Dimens.spacingMedium),
                    Image.asset(
                      'assets/key_chain.png',
                      width: 50,
                    ),
                    SizedBox(height: Dimens.spacingMedium),
                    Text(
                      'Se você é novo proprietário',
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.bodyBold(theme),
                    ),
                    SizedBox(height: Dimens.spacing),
                    Text(
                      'Solicite a troca de titularidade do imóvel, no portal Resolva Fácil em Alteração de titularidade',
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.body(theme),
                    ),
                  ],
                  SizedBox(height: Dimens.spacingMedium),
                  PrimaryButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    text: 'Entendi',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
