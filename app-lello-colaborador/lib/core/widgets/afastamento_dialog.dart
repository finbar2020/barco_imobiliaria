import 'package:flutter/material.dart';

import 'package:essentials/essentials.dart';

class AfastamentoDialog extends StatelessWidget {
  final String workLeaveDescription;

  const AfastamentoDialog({
    Key? key,
    required this.workLeaveDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    return Dialog(
      child: SizedBox(
        width: size.width * 0.8,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SvgPicture.asset("assets/ic_billet_alert.svg"),
              ),
              SizedBox(height: Dimens.spacing),
              Text(
                getString(context, "digital_point_sync_dialog_title"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).textLight(),
                ),
              ),
              SizedBox(height: Dimens.spacing),
              Text(
                "${getString(context, "digital_point_unauthorized_dialog_message")} $workLeaveDescription",
                style: LelloTextStyles.subtitle(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).textLight(),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Dimens.spacing),
              Text(
                getString(context, "digital_point_unauthorized_away_message"),
                style: LelloTextStyles.subtitle(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).textLight(),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Dimens.spacing),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(Dimens.spacing),
                  child: Text(
                    getString(context, "ok"),
                    style: LelloTextStyles.subBody(theme)?.copyWith(
                      color: LelloTheme.palleteOf(theme).primary(),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Launch.whatsApp(
                    context,
                    "551127977586",
                    message: getString(
                      context,
                      "whats_app_away_request_message",
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(Dimens.spacing),
                  child: Text(
                    getString(
                      context,
                      "digital_point_sync_dialog_failed_away_talk",
                    ),
                    style: LelloTextStyles.subBody(theme),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
