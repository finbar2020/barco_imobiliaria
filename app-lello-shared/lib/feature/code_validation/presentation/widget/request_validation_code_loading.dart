part of shared_features;

class RequestValidationCodeLoading extends StatelessWidget {
  final CodeValidationSource? source;

  const RequestValidationCodeLoading({Key? key, this.source}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String title = _getTitle(context);
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        SizedBox(height: Dimens.spacingLarge),
        Text(title, style: LelloTextStyles.title(theme)),
        SizedBox(height: Dimens.spacingSmall),
        Text(getString(context, "please_wait"),
            style: LelloTextStyles.subBody(theme)),
      ],
    ));
  }

  String _getTitle(BuildContext context) {
    if (source != null) {
      switch (source!) {
        case CodeValidationSource.phone:
          return getString(context, "registration_sending_sms");
        case CodeValidationSource.email:
          return getString(context, "registration_sending_email");
        case CodeValidationSource.biometria:
          return "";
      }
    } else {
      return "";
    }
  }
}
