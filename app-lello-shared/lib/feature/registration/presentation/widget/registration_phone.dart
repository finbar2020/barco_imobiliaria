part of shared_features;

class RegistrationPhone extends StatefulWidget {
  final void Function(String phone) callback;
  final String phone;
  final Validator validator;
  final AppOriginEnum? appOriginEnum;

  RegistrationPhone(
      {Key? key,
      required this.callback,
      required this.phone,
      required this.validator,
      this.appOriginEnum})
      : super(key: key);

  @override
  _RegistrationPhoneState createState() => _RegistrationPhoneState();
}

class _RegistrationPhoneState extends State<RegistrationPhone> {
  final _formKey = GlobalKey<FormState>();
  FocusNode phoneNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    widget.validator.context = context;
    FocusScope.of(context).requestFocus(phoneNode);

    return _buildPhoneForm();
  }

  Widget _buildPhoneForm() {
    var theme = Theme.of(context);
    if (widget.appOriginEnum == AppOriginEnum.employee) {
      theme = LelloTheme.carimbeira;
    }
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(getString(context, "registration_phone_title"),
                style: LelloTextStyles.title(theme)),
            SizedBox(height: Dimens.spacing),
            Text(getString(context, "registration_phone_description"),
                style: LelloTextStyles.subBody(theme)),
            SizedBox(height: Dimens.spacingLarge),
            Text(getString(context, "cellphone_number"),
                style: LelloTextStyles.bodyBold(theme)),
            SizedBox(height: Dimens.spacingSmall),
            Form(
                key: _formKey,
                child: PhoneFormField(
                  focusNode: phoneNode,
                  widgetValidator: widget.validator,
                  initialValue: widget.phone,
                  onSaved: (value) => widget.callback(value ?? ""),
                  onFieldSubmitted: (_) => next(),
                )),
            SizedBox(height: Dimens.spacingLarge),
            PrimaryButton(
              buttonColor: theme.primaryColor,
              text: getString(context, "next"),
              onPressed: next,
            )
          ]),
    );
  }

  void next() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
    }
  }
}
