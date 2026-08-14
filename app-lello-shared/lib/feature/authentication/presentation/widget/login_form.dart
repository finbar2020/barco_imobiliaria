part of shared_features;

class LoginForm extends StatefulWidget {
  final AuthenticationStore store;
  final AppOriginEnum appOriginEnum;

  LoginForm({
    required this.store,
    required this.appOriginEnum,
  });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final passwordNode = FocusNode();

  bool _isObscure = true;

  @override
  Widget build(BuildContext rcontext) {
    final theme = Theme.of(context);
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      bloc: widget.store.bloc,
      listener: (context, state) {
        if (state is AuthenticatedState) {
          TextInput.finishAutofillContext(shouldSave: true);
          Navigator.of(context).pushNamedAndRemoveUntil(
              SharedApplicationRoute.home, (_) => false);
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            TextInput.finishAutofillContext(shouldSave: false);
            return true;
          },
          child: Form(
            key: _formKey,
            child: DismissKeyboard(
              child: AutofillGroup(
                onDisposeAction: AutofillContextAction.cancel,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                        widget.appOriginEnum == AppOriginEnum.employee
                            ? getString(context, "email")
                            : "${getString(context, "email")}/${getString(
                            context, "cnpj")}",
                        style: LelloTextStyles.bodyBold(theme)),
                    SizedBox(height: Dimens.spacingSmall),
                    TextFormField(
                      inputFormatters: [cpfOrCnpjFormatter()],
                      autofillHints: [AutofillHints.username],
                      enabled: !(state is AuthenticatingState),
                      initialValue: widget.store.credentials.username,
                      keyboardType: TextInputType.number,
                      onSaved: (val) {
                        widget.store.credentials.username = val ?? "";
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(passwordNode);
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: getString(context, "type_email_cnpj"),
                      ),
                    ),
                    if (widget.appOriginEnum == AppOriginEnum.employee)
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, SharedApplicationRoute.loginTablet);
                        },
                        child: Container(
                          padding:
                          EdgeInsets.symmetric(vertical: Dimens.spacing),
                          child: Text(
                              getString(
                                  context, "login_form_register_fixed_point"),
                              style: LelloTextStyles.bodyBold(theme)),
                        ),
                      ),
                    SizedBox(height: Dimens.spacingMedium),
                    Text(getString(context, "password"),
                        style: LelloTextStyles.bodyBold(theme)),
                    SizedBox(height: Dimens.spacingSmall),
                    TextFormField(
                      obscureText: _isObscure,
                      autofillHints: [AutofillHints.password],
                      enabled: !(state is AuthenticatingState),
                      focusNode: passwordNode,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      onSaved: (val) {
                        widget.store.credentials.password = val ?? "";
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final form = _formKey.currentState;
                        if (form!.validate()) {
                          form.save();
                          widget.store.authenticate();
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: getString(context, "type_password"),
                        suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: LelloTheme.palleteOf(theme).grey(),
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            }),
                      ),
                    ),
                    SizedBox(height: Dimens.spacingMedium),
                    (state is AuthenticatingState)
                        ? Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    )
                        : (state is AuthenticationFailedState)
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildLoginButton(theme),
                        SizedBox(height: Dimens.spacing),
                        Text(
                          FailureMessage.get(context, state.error) ??
                              "",
                          style: LelloTextStyles.error(theme),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: Dimens.spacing),
                        if (widget.appOriginEnum ==
                            AppOriginEnum.owner)
                          InkWell(
                            onTap: () {
                              String message = getString(
                                  context, "resolva_facil_message");
                              Launch.whatsApp(context, "551127977585",
                                  message: message);
                            },
                            child: Container(
                              height: Dimens.spacingLarge,
                              child: Text(
                                getString(context,
                                    "send_message_resolva_facil"),
                                style: LelloTextStyles.error(theme),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    )
                        : _buildLoginButton(theme),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginButton(ThemeData theme) {
    return PrimaryButton(
      text: getString(context, "login"),
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
        final form = _formKey.currentState;
        if (form!.validate()) {
          form.save();
          widget.store.authenticate();
        }
      },
      buttonColor: theme.primaryColor,
    );
  }
}
