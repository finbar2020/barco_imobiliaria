part of shared_features;

class PasswordResetCpf extends StatefulWidget {
  final ResetPasswordController resetPasswordController;
  final Validator validator;

  PasswordResetCpf({
    Key? key,
    required this.resetPasswordController,
    required this.validator,
  }) : super(key: key);

  @override
  _PasswordResetCpfState createState() => _PasswordResetCpfState();
}

class _PasswordResetCpfState extends State<PasswordResetCpf> {
  final _formKey = GlobalKey<FormState>();

  final _autoFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    widget.validator.context = context;
    FocusScope.of(context).requestFocus(_autoFocusNode);
    return BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
        bloc: widget.resetPasswordController.resetPasswordBloc,
        builder: (context, state) {
          state.cpf = state.cpf;
          state.cpf = state.cpf.isNotEmpty
              ? state.cpf
              : widget.resetPasswordController.loginStore.credentials.username;
          return SingleChildScrollView(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(getString(context, "registration_document_title"),
                        style: LelloTextStyles.title(theme)),
                    SizedBox(height: Dimens.spacingLarge),
                    TextFormField(
                      focusNode: _autoFocusNode,
                      initialValue: state.cpf,
                      validator: widget.validator.validateCPForCNPJ,
                      inputFormatters: [cpfOrCnpjFormatter()],
                      keyboardType: TextInputType.number,
                      onSaved: (value) => state.cpf = value ?? "",
                      onFieldSubmitted: (_) => next(),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: getString(context, "type_email_cnpj"),
                      ),
                      onChanged: (value) => state.cpf = value,
                    ),
                    SizedBox(height: Dimens.spacingLarge),
                    PrimaryButton(
                      text: getString(context, "next"),
                      onPressed: next,
                      buttonColor: theme.primaryColor,
                    ),
                  ]),
            ),
          );
        });
  }

  void next() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      widget.resetPasswordController
          .nextStep(currentStep: PasswordResetStep.cpf);
    }
  }
}
