import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class AccessManagementLinkDialog extends StatelessWidget {
  final VoidCallback sendLink;
  const AccessManagementLinkDialog({Key? key, required this.sendLink})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(getString(context, "residents_send_invite"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitleBold(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).textLight())),
            SizedBox(height: Dimens.spacing),
            Text(getString(context, "residents_dialog_link_title"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitle(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).textLight())),
            SizedBox(height: Dimens.spacing),
            Text(getString(context, "residents_dialog_link_subtitle"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitle(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).textLight())),
            SizedBox(height: Dimens.spacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(Dimens.spacing),
                    child: Text(
                      getString(context, "cancel").toUpperCase(),
                      style: LelloTextStyles.subBody(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).textLight(),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: sendLink,
                  child: Padding(
                    padding: EdgeInsets.all(Dimens.spacing),
                    child: Text(
                      getString(context, "residents_send_link"),
                      style: LelloTextStyles.subBody(theme)!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatPhoneToSecurityText(String? phone) {
    if (phone == null) return "-";
    return "(${phone.substring(0, 2)})${phone.substring(2, 4)}${"xxx"}-${"xxx"}${phone.substring(phone.length - 1)}";
  }
}
