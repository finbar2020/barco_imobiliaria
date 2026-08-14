part of shared_features;

class RegistrationFailurePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //var error = ModalRoute.of(context)!.settings.arguments;
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).primary(),
        body: Padding(
          padding: EdgeInsets.all(Dimens.spacingLarge),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset("assets/ic_error.svg", width: 92, height: 92),
                SizedBox(height: Dimens.spacingLarge),
                Text(getString(context, "registration_failed_title"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!
                        .copyWith(color: Colors.white)),
                SizedBox(height: Dimens.spacingXSmall),
                Text(getString(context, "registration_failed_error"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.subtitle(theme)!
                        .copyWith(color: Colors.white)),
                SizedBox(height: Dimens.spacingMedium),
                SecondaryButton(
                    buttonBorderColor: Colors.white,
                    text: getString(
                        context, "registration_lello_warning_cta_secondary"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigator.popAndPushNamed(context, ApplicationRoute.login);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
