part of shared_features;

class RegistrationLelloUserNoDataPage extends StatelessWidget {
  final AppOriginEnum appOriginEnum;
  const RegistrationLelloUserNoDataPage({
    Key? key,
    required this.appOriginEnum,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.light;
    final RegistrationBloc bloc =
        ModalRoute.of(context)!.settings.arguments as RegistrationBloc;
    return BlocBuilder<RegistrationBloc, RegistrationState>(
        bloc: bloc,
        builder: (context, state) {
          return Theme(
              data: theme,
              child: Scaffold(
                  appBar: PrimaryAppBar(
                      theme: theme, title: getString(context, "registration")),
                  body: Container(
                      padding: EdgeInsets.only(
                          left: Dimens.spacingSmall,
                          right: Dimens.spacingSmall,
                          top: Dimens.spacingMedium),
                      child: Padding(
                          padding: EdgeInsets.all(Dimens.spacingLarge),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Text(
                                        getString(context,
                                            "registration_lello_warning_no_data_title"),
                                        style: LelloTextStyles.bodyBold(theme)!
                                            .copyWith(fontSize: 22)),
                                    SizedBox(height: Dimens.spacingLarge),
                                    Text(
                                        getString(context,
                                            "registration_lello_warning_no_data_1"),
                                        style: LelloTextStyles.body(theme)!
                                            .copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400)),
                                    SizedBox(height: Dimens.spacingLarge),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text(
                                          "• ${getString(context, "registration_lello_warning_no_data_2")}",
                                          style: LelloTextStyles.body(theme)!
                                              .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                        ),
                                        InkWell(
                                            child: Text(
                                              getString(context,
                                                  "registration_lello_warning_no_data_2_click"),
                                              style: LelloTextStyles.body(
                                                      theme)!
                                                  .copyWith(
                                                      color: Colors.red,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      decoration: TextDecoration
                                                          .underline)
                                                  .copyWith(color: Colors.red),
                                            ),
                                            onTap: () {
                                              _openWebPortal(context);
                                            }),
                                      ],
                                    ),
                                    SizedBox(height: Dimens.spacingLarge),
                                    Text(
                                        "• ${getString(context, "registration_lello_warning_no_data_3").replaceAll('{email}', FlavorConfig.config.supportEmail)}",
                                        style: LelloTextStyles.body(theme)!
                                            .copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400)),
                                    SizedBox(height: Dimens.spacingLarge),
                                    Text(
                                        "• ${getString(context, "registration_lello_warning_no_data_4")}",
                                        style: LelloTextStyles.body(theme)!
                                            .copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400)),
                                    SizedBox(height: Dimens.spacingXLarge),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                          minWidth: double.infinity),
                                      child: OutlinedButton(
                                        onPressed: () {
                                          _openWhatsapp(context);
                                        },
                                        child: Container(
                                          child: Text(
                                              getString(context,
                                                  "registration_lello_warning_no_data_btn"),
                                              style:
                                                  LelloTextStyles.button(theme)!
                                                      .copyWith(
                                                          color: Colors.black)),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )))));
        });
  }

  Future<void> _openWebPortal(BuildContext context) async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetch();
    await remoteConfig.fetchAndActivate();
    var useTermsConfig = jsonDecode(
        remoteConfig.getString(CustomFirebaseRemoteConfig.resolvaFacil));

    var url = useTermsConfig["link"];
    UrlLauncherNative.openUrl(url);
  }

  String get getSupportWhatsappNumber {
    switch (appOriginEnum) {
      case AppOriginEnum.owner:
        return FlavorConfig.config.supportMoradorWhatsAppNumber;
      case AppOriginEnum.employee:
        return FlavorConfig.config.supportColaboradorWhatsAppNumber;
      case AppOriginEnum.manager:
        return FlavorConfig.config.supportSindicoWhatsAppNumber;
    }
  }

  Future<void> _openWhatsapp(BuildContext context) async {
    String text = "Oi, pode me ajudar?";
    Launch.whatsApp(
      context,
      getSupportWhatsappNumber,
      message: text,
    );
  }
}
