part of shared_features;

class RegistrationMeWidget extends StatefulWidget {
  final RegistrationStore store;
  final SharedApplicationContainer appContainer;
  final Validator validator;
  final bool isGeneric;
  final AppOriginEnum? appOriginEnum;

  RegistrationMeWidget({
    Key? key,
    required this.store,
    required this.validator,
    required this.appContainer,
    this.isGeneric = false,
    this.appOriginEnum,
  }) : super(key: key);

  @override
  _RegistrationMeState createState() => _RegistrationMeState();
}

class _RegistrationMeState extends State<RegistrationMeWidget> {
  var loading = false;

  @override
  Widget build(BuildContext context) {
    final bloc = widget.store.bloc;
    if (!loading) {
      // widget.store.requestMyUser();

      setState(() {
        loading = true;
      });
    }

    var theme = Theme.of(context);
    if (widget.isGeneric) {
      theme = LelloTheme.viverDefaultTheme;
    } else if (widget.appOriginEnum == AppOriginEnum.employee) {
      theme = LelloTheme.carimbeira;
    } else {
      theme = LelloTheme.lelloDefaultTheme;
    }
    return BlocBuilder(
      bloc: bloc,
      builder: (context, state) {
        if (state is RegistrationRequestMyUserLoadingState) {
          return Padding(
            padding: EdgeInsets.all(Dimens.spacing),
            child: Center(
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
              ),
            ),
          );
        }
        if (state is RegistrationCodeRequestLoadingState) {
          return RequestValidationCodeLoading(
            source: widget.store.source == CodeValidationSource.phone
                ? CodeValidationSource.phone
                : CodeValidationSource.email,
          );
        }
        if (state is RegistrationCodeRequestSucceededState) {
          return BlocProvider(
            create: (context) =>
                widget.appContainer.resolve<ResetPasswordBloc>(),
            child: CodeValidationPage(
              codeRequest: state.codeRequest,
              appContainer: widget.appContainer,
              isGeneric: widget.isGeneric,
              appOriginEnum: widget.appOriginEnum,
              digits: 6,
              onSuccess: (validation) {
                widget.store.codeValidationId = validation!.id;
                widget.store.token = validation.token;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  widget.store.pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                });
              },
              onRestart: () {
                widget.store.requestCode();
              },
            ),
          );
        }
        if (state is RegistrationRequestMyUserSucceededState &&
            (state.codeData.smsContacts.isNotEmpty ||
                state.codeData.emailContacts.isNotEmpty)) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(getString(context, "registration_lello_user_title"),
                        style: LelloTextStyles.title(theme)),
                    SizedBox(height: Dimens.spacingSmall),
                    Text(
                        getString(
                            context, "registration_lello_user_description"),
                        style: LelloTextStyles.subtitle(theme)),
                  ],
                ),
                SizedBox(height: Dimens.spacingMedium),
                if (state.codeData.emailContacts.isEmpty)
                  Container()
                else
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                            getString(
                                context, "registration_lello_user_email_title"),
                            style: LelloTextStyles.bodyBold(theme)),
                        ListView.builder(
                          itemBuilder: (_, int index) {
                            var email = state.codeData.emailContacts[index];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: CustomRadioListTile<CodeDataContact>(
                                    title: email.value,
                                    onChanged: (CodeDataContact? value) {
                                      setState(
                                        () {
                                          widget.store.email = value?.value;
                                          widget.store.emailOrPhoneSelected =
                                              value;
                                          widget.store.source =
                                              CodeValidationSource.email;
                                        },
                                      );
                                    },
                                    groupValue:
                                        widget.store.emailOrPhoneSelected,
                                    value: email,
                                  ),
                                )
                              ],
                            );
                          },
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.codeData.emailContacts.length,
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: Dimens.spacingSmall),
                if (state.codeData.smsContacts.isEmpty)
                  Container()
                else
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                            getString(
                                context, "registration_lello_user_phone_title"),
                            style: LelloTextStyles.bodyBold(theme)),
                        ListView.builder(
                          itemBuilder: (_, int index) {
                            var phone = state.codeData.smsContacts[index];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: CustomRadioListTile<CodeDataContact>(
                                    title: phone.value,
                                    onChanged: (CodeDataContact? value) {
                                      setState(
                                        () {
                                          widget.store.phone = value?.value;
                                          widget.store.emailOrPhoneSelected =
                                              value;
                                          widget.store.source =
                                              CodeValidationSource.phone;
                                        },
                                      );
                                    },
                                    groupValue:
                                        widget.store.emailOrPhoneSelected,
                                    value: phone,
                                  ),
                                )
                              ],
                            );
                          },
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.codeData.smsContacts.length,
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: Dimens.spacingMedium),
                PrimaryButton(
                  text: getString(context, "next"),
                  buttonColor: theme.primaryColor,
                  onPressed: widget.store.requestCode,
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
