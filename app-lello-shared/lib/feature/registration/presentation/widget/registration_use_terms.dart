part of shared_features;

class RegistrationUseTerms extends StatefulWidget {
  RegistrationUseTerms({Key? key}) : super(key: key);

  final WebViewController controller = WebViewController();

  @override
  _RegistrationUseTermsState createState() => _RegistrationUseTermsState();
}

class _RegistrationUseTermsState extends State<RegistrationUseTerms> {
  final _autoFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // A configuração da WebView é feita uma única vez: no `build` ela era
    // refeita a cada reconstrução, recarregando a página.
    widget.controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    widget.controller.loadRequest(
        Uri.parse('https://www.lellocondominios.com.br/termos-de-uso/'));
  }

  @override
  void dispose() {
    _autoFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_autoFocusNode);
    final theme = Theme.of(context);
    return Theme(
        data: theme,
        child: Scaffold(
          appBar: PrimaryAppBar(
              theme: theme,
              title: getString(context, "registration_use_terms_title")),
          body: Container(
              child: WillPopScope(
            onWillPop: () async {
              Navigator.pop(context);
              return true;
            },
            child: WebViewWidget(
              controller: widget.controller,
              key: _formKey,
            ),
          )),
        ));
  }
}
