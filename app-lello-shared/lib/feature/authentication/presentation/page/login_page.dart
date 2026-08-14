part of shared_features;

class LoginPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  final AppOriginEnum appOriginEnum;
  LoginPage({required this.appContainer, required this.appOriginEnum});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showedRegister = false;
  PackageInfo? packageInfo;
  Environment? env;

  @override
  void initState() {
    super.initState();
    env = widget.appContainer.resolve<Environment>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var settings = ModalRoute.of(context)?.settings;
      if (settings != null && settings.arguments != null) {
        final args =
            ModalRoute.of(context)!.settings.arguments as AuthArguments;
        if (args.goToRegister == true && showedRegister == false) {
          showedRegister = true;
          _signup(widget.appContainer);
        }
      }
      if (widget.appOriginEnum == AppOriginEnum.employee) {
        _checkCondoCode();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationStore store = widget.appContainer.resolve();

    ThemeData _theme = Theme.of(context);
    if (_isGeneric()) {
      _theme = LelloTheme.viverDefaultTheme;
    } else if (widget.appOriginEnum == AppOriginEnum.employee) {
      _theme = LelloTheme.carimbeira;
    } else {
      _theme = LelloTheme.lelloDefaultTheme;
    }

    // Show loading screen if navigating to registration
    var settings = ModalRoute.of(context)?.settings;
    if (settings != null && settings.arguments != null) {
      final args = settings.arguments as AuthArguments;
      if (args.goToRegister == true) {
        return Theme(
          data: _theme,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_theme.primaryColor),
              ),
            ),
          ),
        );
      }
    }

    return Theme(
        data: _theme,
        child: Scaffold(
          appBar:
              PrimaryAppBar(title: getString(context, "login"), theme: _theme),
          body: BlocProvider(
            create: (context) => store.bloc,
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(Dimens.spacingMedium),
                child: Column(
                  children: [
                    _appNameAndVersion(),
                    Text(getString(context, "login_title"),
                        style: LelloTextStyles.title(_theme)),
                    SizedBox(height: Dimens.spacingLarge),
                    LoginForm(
                      store: store,
                      appOriginEnum: widget.appOriginEnum,
                    ),
                    SizedBox(height: Dimens.spacingLarge),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            getString(context, "still_not_registered"),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                        TertiaryButton(
                            text: getString(context, "sign_up"),
                            style: store.bloc.state is AuthenticatingState
                                ? TextStyle(color: Colors.grey)
                                : TextStyle(color: _theme.primaryColor),
                            onPressed: () => {
                                  if (!(store.bloc.state
                                      is AuthenticatingState))
                                    _signup(widget.appContainer)
                                })
                      ],
                    ),
                    TertiaryButton(
                      text: getString(context, "forgot_password"),
                      style: store.bloc.state is AuthenticatingState
                          ? TextStyle(color: Colors.grey)
                          : TextStyle(color: _theme.primaryColor),
                      onPressed: () => {
                        if (!(store.bloc.state is AuthenticatingState))
                          _forgotPassword(widget.appContainer)
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _forgotPassword(SharedApplicationContainer arguments) {
    switch (widget.appOriginEnum) {
      case AppOriginEnum.manager:
        AnalyticsLogEvents.logEvent(
            event: AnalyticsEventsManager.esqueciSenhaAcessar(),
            referenceValue: "",
            unitValue: "",
            appOrigin: widget.appOriginEnum);
        break;
      case AppOriginEnum.owner:
        AnalyticsLogEvents.logEvent(
            event: AnalyticsEventsOwner.esqueciSenhaAcessar(),
            userId: "",
            referenceValue: "",
            unitValue: "",
            appOrigin: widget.appOriginEnum);
        break;
      case AppOriginEnum.employee:
        AnalyticsLogEvents.logEvent(
            event: AnalyticsEventsEmployee.esqueciSenhaAcessar(),
            referenceValue: "",
            unitValue: "",
            appOrigin: widget.appOriginEnum);
        break;
    }

    Navigator.pushNamed(context, SharedApplicationRoute.resetPassword,
        arguments: arguments);
  }

  void _signup(SharedApplicationContainer arguments) {
    Navigator.pushNamed(context, SharedApplicationRoute.registration,
        arguments: arguments);
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

  Future _checkCondoCode() async {
    if (widget.appOriginEnum != AppOriginEnum.employee) {
      return;
    }
    try {
      var condoCode = await TabletSessionUtils.getCondoCode();
      if (condoCode != null && condoCode.isNotEmpty) {
        Navigator.pushReplacementNamed(
            context, SharedApplicationRoute.loginTablet,
            arguments: condoCode);
      }
    } catch (ex) {}
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _appNameAndVersion() {
    return Container(
      alignment: Alignment.topRight,
      child: AppVersionAndNameWidget(appOrigin: widget.appOriginEnum, env: env),
    );
  }
}
