part of shared_features;

class RegistrationCpf extends StatefulWidget {
  final RegistrationStore store;
  final bool isGeneric;
  final String appName;
  final Validator validator;
  final AppOriginEnum? appOriginEnum;
  
  /// Callback customizado para mostrar o modal de termos
  /// Se fornecido, substitui o comportamento padrão
  final Future Function(BuildContext)? customTermsModal;

  RegistrationCpf({
    Key? key,
    required this.store,
    required this.validator,
    this.isGeneric = false,
    this.appName = "",
    this.appOriginEnum,
    this.customTermsModal,
  }) : super(key: key);

  @override
  _RegistrationCpfState createState() => _RegistrationCpfState();
}

class _RegistrationCpfState extends State<RegistrationCpf> {
  final _formKey = GlobalKey<FormState>();

  final _autoFocusNode = FocusNode();

  bool checkedBox = false;

  Future _launchModal(BuildContext context) {
    // Usa callback customizado se fornecido, senão usa comportamento padrão
    if (widget.customTermsModal != null) {
      return widget.customTermsModal!(context);
    }
    
    return showDialog(
      context: context,
      builder: (context) => RegistrationUseTermsDialog(
        isGeneric: widget.isGeneric,
        appName: widget.appName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    if (widget.isGeneric) {
      theme = LelloTheme.viverDefaultTheme;
    } else if (widget.appOriginEnum == AppOriginEnum.employee) {
      theme = LelloTheme.carimbeira;
    } else {
      theme = LelloTheme.lelloDefaultTheme;
    }
    widget.validator.context = context;
    //FocusScope.of(context).requestFocus(_autoFocusNode);
    return BlocBuilder(
      bloc: widget.store.bloc,
      builder: (context, state) {
        widget.store.cpf =
            widget.store.cpf?.isNotEmpty == true ? widget.store.cpf : "";
        return DismissKeyboard(
          child: SingleChildScrollView(
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
                    initialValue: widget.store.cpf,
                    validator: widget.validator.validateCPForCNPJ,
                    inputFormatters: [cpfOrCnpjFormatter()],
                    keyboardType: TextInputType.number,
                    onSaved: (value) => widget.store.cpf = value,
                    onFieldSubmitted: (_) => next(),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: getString(context, "type_email_cnpj")),
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  Visibility(
                      visible: widget.store.registeredError == true,
                      child: Text(
                          getString(context,
                              "error_registration_user_already_registered"),
                          style: DefaultTextStyle.of(context).style.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.red[700]))),
                  SizedBox(height: Dimens.spacingLarge),
                  Row(
                    children: [
                      Checkbox(
                        activeColor: theme.primaryColor,
                        onChanged: (value) {
                          if (checkedBox) {
                            setState(() {
                              checkedBox = value!;
                            });
                          } else {
                            setState(() {
                              checkedBox = value!;
                            });
                          }
                          widget.store.termsAndConditionsCheck = checkedBox;
                        },
                        value: checkedBox,
                      ),
                      Expanded(
                        child: Wrap(
                          children: [
                            Text(
                              getString(
                                  context, "registration_continue_declare"),
                              style: DefaultTextStyle.of(context).style,
                            ),
                            InkWell(
                              child: Text(
                                getString(context,
                                    "registration_terms_use_privacy_policies"),
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[700]),
                              ),
                              onTap: () {
                                setState(() {
                                  _launchModal(context);
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.spacingLarge),
                  PrimaryButton(
                    text: getString(context, "next"),
                    onPressed: checkedBox ? next : null,
                    buttonColor: theme.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void next() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      widget.store.requestMyUser();
    }
  }
}
