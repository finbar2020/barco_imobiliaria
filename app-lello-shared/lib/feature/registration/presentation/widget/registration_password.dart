part of shared_features;

class RegistrationPassword extends StatefulWidget {
  final RegistrationStore store;
  final Validator validator;
  final bool isGeneric;
  final AppOriginEnum? appOriginEnum;

  RegistrationPassword({
    Key? key,
    required this.store,
    required this.validator,
    this.isGeneric = false,
    this.appOriginEnum,
  }) : super(key: key);

  @override
  _RegistrationPasswordState createState() => _RegistrationPasswordState();
}

class _RegistrationPasswordState extends State<RegistrationPassword> {
  final _autoFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var focused = false;

  String? password;
  String? confirmation;
  String error = "";
  bool _isObscure = true;
  bool _isObscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    widget.validator.context = context;
    var theme = Theme.of(context);
    if (widget.isGeneric) {
      theme = LelloTheme.viverDefaultTheme;
    } else if (widget.appOriginEnum == AppOriginEnum.employee) {
      theme = LelloTheme.carimbeira;
    } else {
      theme = LelloTheme.lelloDefaultTheme;
    }
    if (!focused) {
      FocusScope.of(context).requestFocus(_autoFocusNode);
      focused = true;
    }

    return BlocConsumer<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationFailedState) {
          _updateError(state.error.error);
        }
      },
      bloc: widget.store.bloc,
      builder: (context, state) => Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(getString(context, "registration_password_title"),
                    style: LelloTextStyles.title(theme)),
                SizedBox(height: Dimens.spacingLarge),
                Text(getString(context, "password"),
                    style: LelloTextStyles.bodyBold(theme)),
                SizedBox(height: Dimens.spacingSmall),
                TextFormField(
                  focusNode: _autoFocusNode,
                  validator: widget.validator.validatePassword,
                  obscureText: _isObscure,
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
                        }),
                  ),
                ),
                SizedBox(height: Dimens.spacing),
                Text(getString(context, "confirm_password"),
                    style: LelloTextStyles.bodyBold(theme)),
                SizedBox(height: Dimens.spacingSmall),
                TextFormField(
                  obscureText: _isObscureConfirm,
                  validator: widget.validator.validatePassword,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  onSaved: (value) => confirmation = value,
                  onFieldSubmitted: (_) => next(),
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
                        }),
                  ),
                ),
                SizedBox(height: Dimens.spacingLarge),
                Visibility(
                    visible:
                        !(widget.store.bloc.state is RegistrationLoadingState),
                    child: PrimaryButton(
                        buttonColor: theme.primaryColor,
                        text: getString(context, "next"),
                        onPressed: next),
                    replacement: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(height: Dimens.spacingLarge),
                        Text(getString(context, "registration_sending_data"),
                            style: LelloTextStyles.title(theme)),
                        SizedBox(height: Dimens.spacingSmall),
                        Text(getString(context, "please_wait"),
                            style: LelloTextStyles.subBody(theme)),
                      ],
                    ))),
                SizedBox(height: Dimens.spacing),
                Visibility(
                  visible: error.length > 0,
                  child: Center(
                      child: Text(error,
                          style: LelloTextStyles.error(theme),
                          textAlign: TextAlign.center)),
                ),
              ]),
        ),
      ),
    );
  }

  void next() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();

      if (password != confirmation) {
        _updateError(
            getString(context, "validation_invalid_password_confirmation"));
      } else {
        _updateError("");
        widget.store.password = password;
        widget.store.nextStep();
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          widget.store.pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    }
  }

  void _updateError(String message) {
    setState(() {
      error = message;
    });
  }
}
