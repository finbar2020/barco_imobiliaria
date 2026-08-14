import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class HomeClockInRangeOutDialog extends StatelessWidget {
  final DigitalTimesheetStatusEnum registerPointStatusEnum;
  final bool isOnline;
  const HomeClockInRangeOutDialog({
    Key? key,
    required this.registerPointStatusEnum,
    this.isOnline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset("assets/ic_billet_alert.svg"),
            ),
            SizedBox(height: Dimens.spacing),
            Text("${getString(context, "attention")}!",
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitleBold(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).textLight())),
            SizedBox(height: Dimens.spacingLarge),
            Text(getString(context, "home_clock_in_range_out_dialog_subtitle"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitle(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).textLight())),
            SizedBox(height: Dimens.spacingLarge),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                getString(context, "home_page_register_point"),
                style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).primary(),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                getString(context, "cancel"),
                style: LelloTextStyles.subBody(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).hubText(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
