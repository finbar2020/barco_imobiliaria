part of shared_features;

class ResetPasswordNewPassword extends StatefulWidget {
  final ResetPasswordController resetPasswordController;
  final Validator? validator;
  final AppOriginEnum appOriginEnum;

  ResetPasswordNewPassword({
    Key? key,
    required this.resetPasswordController,
    this.validator,
    required this.appOriginEnum,
  }) : super(key: key);
  @override
  _ResetPasswordNewPasswordState createState() =>
      _ResetPasswordNewPasswordState();
}

class _ResetPasswordNewPasswordState extends State<ResetPasswordNewPassword> {
  final _autoFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var focused = false;
  String? password;
  String? confirmation;
  String? error;
  bool _isObscure = true;
  bool _isObscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //ResetPasswordBloc bloc = BlocProvider.of(context);
    widget.validator?.context = context;

    if (!focused) {
      FocusScope.of(context).requestFocus(_autoFocusNode);
      focused = true;
    }

    // `BlocConsumer` (e não `BlocListener`) para que a troca do botão pelo
    // indicador de carregamento reaja ao estado sem depender de um rebuild
    // externo.
    return BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
      bloc: widget.resetPasswordController.resetPasswordBloc,
      listener: (context, state) {
        if (state is ResetPasswordFailedState) {
          handleError(state);
        }
        if (state is ResetPasswordSucceededState) {
          TextInput.finishAutofillContext(shouldSave: true);
        }
      },
      builder: (context, state) => SingleChildScrollView(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Form(
          key: _formKey,
          child: AutofillGroup(
            onDisposeAction: AutofillContextAction.cancel,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(getString(context, "registration_password_title"),
                    style: LelloTextStyles.title(theme)),
                SizedBox(height: Dimens.spacingLarge),
                Text(
                    "${getString(context, "email")}/${getString(context, "cnpj")}",
                    style: LelloTextStyles.bodyBold(theme)),
                SizedBox(height: Dimens.spacingSmall),
                TextFormField(
                  inputFormatters: [cpfOrCnpjFormatter()],
                  autofillHints: [AutofillHints.username],
                  enabled: false,
                  initialValue: widget
                      .resetPasswordController.resetPasswordBloc.state.cpf,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(height: Dimens.spacing),
                Text(getString(context, "password"),
                    style: LelloTextStyles.bodyBold(theme)),
                SizedBox(height: Dimens.spacingSmall),
                TextFormField(
                  focusNode: _autoFocusNode,
                  enableSuggestions: false,
                  autofillHints: [AutofillHints.newPassword],
                  validator: widget.validator?.validatePassword,
                  obscureText: _isObscure,
                  initialValue: widget.resetPasswordController.resetPasswordBloc
                      .state.reset.password,
                  keyboardType: TextInputType.visiblePassword,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  onSaved: (value) => password = value,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: getString(context, "type_password"),
                      suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          })),
                ),
                SizedBox(height: Dimens.spacing),
                Text(getString(context, "confirm_password"),
                    style: LelloTextStyles.bodyBold(theme)),
                SizedBox(height: Dimens.spacingSmall),
                TextFormField(
                  enableSuggestions: false,
                  autofillHints: [AutofillHints.newPassword],
                  obscureText: _isObscureConfirm,
                  validator: widget.validator?.validatePassword,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  onSaved: (value) => confirmation = value,
                  onFieldSubmitted: (_) => next(widget.resetPasswordController),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: getString(context, "type_password"),
                      suffixIcon: IconButton(
                          icon: Icon(_isObscureConfirm
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isObscureConfirm = !_isObscureConfirm;
                            });
                          })),
                ),
                SizedBox(height: Dimens.spacing),
                Visibility(
                    visible: error?.isNotEmpty == true,
                    child: Text(error ?? "",
                        textAlign: TextAlign.center,
                        style: LelloTextStyles.error(theme))),
                SizedBox(height: Dimens.spacing),
                Visibility(
                    visible: !(state is ResetPasswordResettingPasswordState),
                    child: PrimaryButton(
                        text: getString(context, "finish"),
                        buttonColor: theme.primaryColor,
                        onPressed: () {
                          next(widget.resetPasswordController);
                        }),
                    replacement: Center(
                      child: CircularProgressIndicator(),
                    )),
                SizedBox(height: Dimens.spacingLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void next(ResetPasswordController resetPasswordController) async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      if (password == confirmation) {
        _updateError(
          getString(context, ""),
        );
        resetPasswordController.resetPasswordBloc.state.reset.password =
            password;
        await resetPasswordController.beginResetPassword(
            appOriginEnum: widget.appOriginEnum);
      } else {
        _updateError(
            getString(context, "validation_invalid_password_confirmation"));
      }
    }
  }

  void handleError(ResetPasswordFailedState state) {
    _updateError(
        "Não foi possível resetar sua senha. Por favor tente novamente mais tarde");
  }

  void _updateError(String err) {
    setState(() {
      error = err;
    });
  }
}
