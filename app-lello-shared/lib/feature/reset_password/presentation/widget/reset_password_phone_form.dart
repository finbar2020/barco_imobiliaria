part of shared_features;

class ResetPasswordPhoneForm extends StatefulWidget {
  final ResetPasswordController resetPasswordController;
  final Validator validator;

  ResetPasswordPhoneForm({
    Key? key,
    required this.resetPasswordController,
    required this.validator,
  }) : super(key: key);

  @override
  _ResetPasswordPhoneFormState createState() => _ResetPasswordPhoneFormState();
}

class _ResetPasswordPhoneFormState extends State<ResetPasswordPhoneForm> {
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.validator.context = context;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              getString(context, "reset_password_title"),
              style: LelloTextStyles.title(theme),
            ),
            SizedBox(height: Dimens.spacingLarge),
            Text(
              getString(context, "registration_phone_title"),
              style: LelloTextStyles.title(theme),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getString(context, "registration_phone_description"),
              style: LelloTextStyles.subBody(theme),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getString(context, "cellphone_number"),
              style: LelloTextStyles.bodyBold(theme),
            ),
            SizedBox(height: Dimens.spacing),
            Form(
              key: _form,
              child: PhoneFormField(
                initialValue: widget.resetPasswordController.resetPasswordBloc
                        .state.reset.phone ??
                    "",
                validator: widget.validator.validateCellPhone,
                onSaved: (value) {
                  widget.resetPasswordController.setPhone(value ?? "");
                },
                onFieldSubmitted: (_) {
                  next();
                },
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            PrimaryButton(
              text: getString(context, "next"),
              onPressed: () => next(),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Visibility(
              visible: widget.resetPasswordController.resetPasswordBloc.state
                  is ResetPasswordRequestCodeFailedState,
              child: Center(
                child: Text(
                  getString(context, "request_validation_code_failed"),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.error(theme),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void next() async {
    final form = _form.currentState;
    if (form!.validate()) {
      form.save();
      await widget.resetPasswordController.beginRequestCode();
    }
  }
}
