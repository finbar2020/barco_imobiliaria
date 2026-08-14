part of shared_features;

class RegistrationUseTermsDialog extends StatefulWidget {
  final bool isGeneric;
  final String appName;

  /// URL customizada para visualizar os termos (substitui download)
  final String? customTermsUrl;

  /// Se true, mostra botão "Visualizar" em vez de "Baixar"
  final bool useViewButton;

  RegistrationUseTermsDialog({
    Key? key,
    this.isGeneric = false,
    this.appName = "",
    this.customTermsUrl,
    this.useViewButton = false,
  }) : super(key: key);

  @override
  _RegistrationUseTermsDialogState createState() =>
      _RegistrationUseTermsDialogState();
}

class _RegistrationUseTermsDialogState
    extends State<RegistrationUseTermsDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(getString(context, "registration_use_terms_subtitle"),
              style: LelloTextStyles.title(theme), textAlign: TextAlign.center),
          Column(
            children: [
              SizedBox(height: Dimens.spacingLarge),
              Text(
                  changeLelloForCompanyName(
                      context, "registration_use_terms_part_1"),
                  textAlign: TextAlign.center,
                  style:
                      LelloTextStyles.subBody(theme)?.copyWith(fontSize: 16)),
              SizedBox(height: Dimens.spacingXSmall),
              Text(
                changeLelloForCompanyName(
                    context, "registration_use_terms_part_2"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subBody(theme)?.copyWith(fontSize: 16),
              ),
              SizedBox(height: Dimens.spacingLarge),
              if (!widget.useViewButton) ...[
                Text(
                  getString(context, "registration_use_terms_download_text"),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subBody(theme)?.copyWith(fontSize: 16),
                ),
                SizedBox(height: Dimens.spacingLarge),
                SecondaryButton(
                  onPressed: this._shareUseTerms,
                  child: Container(
                    child: Text(
                      getString(context, "registration_use_terms_share"),
                      style: LelloTextStyles.button(theme)
                          ?.copyWith(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: Dimens.spacingSmall),
              ],
              SecondaryButton(
                onPressed: widget.useViewButton
                    ? _openTermsInBrowser
                    : _downloadUseTerms,
                child: Container(
                  child: Text(
                    getString(
                        context,
                        widget.useViewButton
                            ? "registration_use_terms_view"
                            : "registration_use_terms_download"),
                    style: LelloTextStyles.button(theme)
                        ?.copyWith(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: Dimens.spacingSmall),
              SecondaryButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Container(
                  child: Text(
                    getString(context, "cancel"),
                    style: LelloTextStyles.button(theme)
                        ?.copyWith(color: theme.colorScheme.error),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String changeLelloForCompanyName(BuildContext context, String text) {
    if (widget.isGeneric) {
      var textFormatted = getString(context, text);
      if (textFormatted.isNotEmpty && widget.appName.isNotEmpty) {
        return textFormatted.replaceAll("Lello", widget.appName);
      } else {
        return getString(context, text);
      }
    } else {
      return getString(context, text);
    }
  }

  void _shareUseTerms() async {
    if (await CheckPermissions.storage()) {
      final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.fetch();
      await remoteConfig.fetchAndActivate();
      var useTermsConfig = jsonDecode(
          remoteConfig.getString(CustomFirebaseRemoteConfig.useTerms));
      getFileFromUrl(useTermsConfig["link"], name: useTermsConfig["name"]).then(
        (value) {
          setState(() {
            final xFile = XFile(value.path);
            final box = context.findRenderObject() as RenderBox;
            final rect = box.localToGlobal(Offset.zero) & box.size;
            Share.shareXFiles([xFile], sharePositionOrigin: rect);
          });
        },
      );
    }
  }

  //TODO: Verificar download de termos de uso
  bool initialized = false;

  /// Abre os termos em um navegador (para URLs customizadas como Hubert)
  _openTermsInBrowser() async {
    Navigator.pop(context);
    if (widget.customTermsUrl != null) {
      final Uri url = Uri.parse(widget.customTermsUrl!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    }
  }

  _downloadUseTerms() async {
    if (await CheckPermissions.storage()) {
      final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
      //await remoteConfig.fetch();
      await remoteConfig.fetchAndActivate();
      var useTermsConfig = jsonDecode(
          remoteConfig.getString(CustomFirebaseRemoteConfig.useTerms));
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFScreen(
              url: useTermsConfig["link"],
              fileName: useTermsConfig["name"],
              useTerms: true,
              title: 'Termos de uso',
              canDownload: true),
        ),
      );

      getFileFromUrl(useTermsConfig["link"], name: useTermsConfig["name"])
          .then((value) {});
    }
  }

  Future<File> getFileFromUrl(String url, {name, path}) async {
    var fileName = 'AppLelloFile';
    if (name != null) {
      fileName = name;
    }
    try {
      var data = await http.get(Uri.parse(url));
      var bytes = data.bodyBytes;
      var dir = (await getApplicationDocumentsDirectory()).path;
      if (path != null) dir = path;
      File file = File("$dir/" + fileName);
      print(dir);
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }
}
