part of shared_features;

class RegistrationUseTerms extends StatelessWidget {
  RegistrationUseTerms({Key? key}) : super(key: key);
  final WebViewController controller = WebViewController();

  final _autoFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_autoFocusNode);
    final theme = Theme.of(context);
    final _formKey = GlobalKey<FormState>();
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.loadRequest(
        Uri.parse('https://www.lellocondominios.com.br/termos-de-uso/'));
    return Theme(
        data: theme,
        child: Scaffold(
          appBar: PrimaryAppBar(
              theme: theme,
              title: getString(context, "registration_use_terms_title")),
          body: Container(
              // padding: EdgeInsets.only(
              //     left: Dimens.spacingMedium,
              //     right: Dimens.spacingMedium,
              //     top: Dimens.spacingMedium),
              child: WillPopScope(
            onWillPop: () async {
              Navigator.pop(context);
              return true;
            },
            child: WebViewWidget(
              controller: controller,
              key: _formKey,
            ),
          )),
        ));
  }
}
