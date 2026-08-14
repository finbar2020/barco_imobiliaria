import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class SendAccessRenewRequestSuccessPage extends StatelessWidget {
  const SendAccessRenewRequestSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
          title: 'Solicitações pendentes',
          theme: theme,
        ),
        body: Padding(
          padding: EdgeInsets.all(Dimens.spacingLarge),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.check_circle,
                  size: 92,
                  color: LelloTheme.palleteOf(theme).success(),
                ),
                SizedBox(height: Dimens.spacingLarge),
                Text(
                  getString(context, "send_access_renew_request_success_title"),
                  textAlign: TextAlign.center,
                  style:
                      LelloTextStyles.headline(theme)?.copyWith(fontSize: 32),
                ),
                SizedBox(height: Dimens.spacingMedium),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: LelloTextStyles.titleSmallBold(theme)
                        ?.copyWith(color: LelloTheme.palleteOf(theme).grey()),
                    children: [
                      TextSpan(
                          text: getString(context, "send_access_renew_request_success_description_part1")),
                      TextSpan(
                          text: getString(context, "send_access_renew_request_success_description_part2"),
                          style: LelloTextStyles.titleSmallBold(theme)
                              ?.copyWith(
                                  color:
                                      LelloTheme.palleteOf(theme).primary())),
                      TextSpan(text: getString(context, "send_access_renew_request_success_description_part3")),
                      TextSpan(
                          text: getString(context, "send_access_renew_request_success_description_part4"),
                          style: LelloTextStyles.titleSmallBold(theme)
                              ?.copyWith(
                                  color:
                                      LelloTheme.palleteOf(theme).primary())),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            height: 54.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: LelloTheme.palleteOf(theme).primary(),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                getString(context, "close"),
                style: LelloTextStyles.button(theme),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
