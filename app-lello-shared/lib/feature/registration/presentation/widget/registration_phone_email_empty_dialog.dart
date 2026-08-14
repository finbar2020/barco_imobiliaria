part of shared_features;

class RegistrationPhoneEmailEmptyDialog extends StatelessWidget {
  const RegistrationPhoneEmailEmptyDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final email = FlavorConfig.config.supportEmail;
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/ic_attention.svg",
              color: LelloTheme.palleteOf(theme).grey(),
              height: 40.0,
              width: 40.0,
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              "${getString(context, 'attention')}!",
              style: LelloTextStyles.subtitleBold(theme)
                  ?.copyWith(color: LelloTheme.palleteOf(theme).textOpaque()),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getString(
                  context, "registration_phone_email_empty_dialog_description"),
              style: LelloTextStyles.subtitle(theme)
                  ?.copyWith(color: LelloTheme.palleteOf(theme).textOpaque()),
            ),
            SizedBox(height: Dimens.spacingSmall),
            Text(
              getString(context,
                  "registration_phone_email_empty_dialog_contact_prefix"),
              style: LelloTextStyles.subtitle(theme)
                  ?.copyWith(color: LelloTheme.palleteOf(theme).textOpaque()),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Dimens.spacingXSmall),
            InkWell(
              onTap: () {
                Launch.urlUri(context, Uri(scheme: 'mailto', path: email));
              },
              child: Text(
                email,
                style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).primary(),
                  decoration: TextDecoration.underline,
                  decorationColor: LelloTheme.palleteOf(theme).primary(),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            PrimaryButton(
              text: getString(
                  context, "registration_phone_email_empty_dialog_confirm"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
