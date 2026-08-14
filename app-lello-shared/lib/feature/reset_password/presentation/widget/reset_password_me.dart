part of shared_features;

class ResetPasswordMeWidget extends StatefulWidget {
  final ResetPasswordController resetPasswordController;
  final Validator validator;
  final SharedApplicationContainer appContainer;

  ResetPasswordMeWidget({
    Key? key,
    required this.appContainer,
    required this.resetPasswordController,
    required this.validator,
  }) : super(key: key);

  @override
  _ResetPasswordMeState createState() => _ResetPasswordMeState();
}

class _ResetPasswordMeState extends State<ResetPasswordMeWidget> {
  late Future<dynamic>? _userDataFuture;
  bool _userDataFetched = false;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (!_userDataFetched) {
      await widget.resetPasswordController.beginTakeMyUser(
        cpf: widget.resetPasswordController.resetPasswordBloc.state.cpf,
      );
      setState(() {
        _userDataFetched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ResetPasswordBloc resetPasswordBloc =
        widget.resetPasswordController.resetPasswordBloc;

    final theme = Theme.of(context);
    return FutureBuilder(
        future: _userDataFuture,
        builder: (context, snapshot) {
          return BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
              bloc: resetPasswordBloc,
              builder: (context, state) {
                if (state is ResetPasswordMyUserLoadingState) {
                  return Padding(
                    padding: EdgeInsets.all(Dimens.spacing),
                    child: Center(
                      child: LoadingWidget(),
                    ),
                  );
                }
                if (state is ResetPasswordRequestingCodeState) {
                  return RequestValidationCodeLoading();
                }
                if (state is ResetPasswordRequestCodeSucceededState) {
                  return CodeValidationPage(
                    appContainer: widget.appContainer,
                    codeRequest: state.codeRequest,
                    digits: 6,
                    onSuccess: (validation) {
                      state.reset.codeValidationId = validation!.id;
                      widget.resetPasswordController
                          .nextStep(currentStep: PasswordResetStep.me);
                    },
                    onRestart: () {
                      widget.resetPasswordController
                          .beginTakeMyUser(cpf: state.cpf);
                    },
                  );
                }
                if (state is ResetPasswordMyUserSucceededState &&
                    (state.codeData.smsContacts.isNotEmpty ||
                        state.codeData.emailContacts.isNotEmpty)) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(Dimens.spacingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          getString(context, "registration_lello_user_title"),
                          style: LelloTextStyles.title(theme),
                        ),
                        SizedBox(height: Dimens.spacingSmall),
                        Text(
                          getString(
                              context, "registration_lello_user_description"),
                          style: LelloTextStyles.subtitle(theme),
                        ),
                        SizedBox(height: Dimens.spacingMedium),
                        if (state.codeData.emailContacts.isNotEmpty) ...[
                          Text(
                            getString(
                                context, "registration_lello_user_email_title"),
                            style: LelloTextStyles.bodyBold(theme),
                          ),
                          ListView.builder(
                            itemBuilder: (_, int index) {
                              var email = state.codeData.emailContacts[index];
                              String emailFormatted = email.value;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: CustomRadioListTile<String?>(
                                      title: emailFormatted,
                                      onChanged: (String? value) {
                                        setState(() {
                                          widget
                                              .resetPasswordController
                                              .resetPasswordBloc
                                              .state
                                              .reset
                                              .email = email.value;
                                          widget
                                              .resetPasswordController
                                              .resetPasswordBloc
                                              .state
                                              .reset
                                              .codeValidationId = email.key;
                                          widget
                                              .resetPasswordController
                                              .resetPasswordBloc
                                              .state
                                              .reset
                                              .phone = null;
                                          state.selectedValue = email.key;
                                          state.type =
                                              CodeValidationSource.email;
                                        });
                                      },
                                      groupValue: state.selectedValue,
                                      value: email.key,
                                    ),
                                  )
                                ],
                              );
                            },
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.codeData.emailContacts.length,
                          ),
                          SizedBox(height: Dimens.spacingSmall),
                        ],
                        if (state.codeData.smsContacts.isNotEmpty) ...[
                          Text(
                            getString(
                                context, "registration_lello_user_phone_title"),
                            style: LelloTextStyles.bodyBold(theme),
                          ),
                          ListView.builder(
                            itemBuilder: (_, int index) {
                              var phone = state.codeData.smsContacts[index];
                              String phoneFormatted = phone.value;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: CustomRadioListTile<String?>(
                                      title: phoneFormatted,
                                      onChanged: (String? value) {
                                        setState(() {
                                          widget
                                              .resetPasswordController
                                              .resetPasswordBloc
                                              .state
                                              .reset
                                              .phone = phone.value;
                                          widget
                                              .resetPasswordController
                                              .resetPasswordBloc
                                              .state
                                              .reset
                                              .codeValidationId = phone.key;
                                          widget
                                              .resetPasswordController
                                              .resetPasswordBloc
                                              .state
                                              .reset
                                              .email = null;
                                          state.selectedValue = phone.key;
                                          state.type =
                                              CodeValidationSource.phone;
                                        });
                                      },
                                      groupValue: state.selectedValue,
                                      value: phone.key,
                                    ),
                                  )
                                ],
                              );
                            },
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.codeData.smsContacts.length,
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                        ],
                        PrimaryButton(
                          text: getString(context, "next"),
                          buttonColor: theme.primaryColor,
                          onPressed: () {
                            next(state);
                          },
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              });
        });
  }

  void next(ResetPasswordMyUserSucceededState state) async {
    await widget.resetPasswordController.beginRequestCode();
  }
}
