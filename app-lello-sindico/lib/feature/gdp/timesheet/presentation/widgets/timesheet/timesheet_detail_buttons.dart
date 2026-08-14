import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class TimesheetDetailButtons extends StatelessWidget {
  final bool showNotifyButton;
  final bool isNotifyButton;
  final void Function() goToOccurrences;
  final void Function() getTimesheetReport;
  final void Function() put;
  const TimesheetDetailButtons({
    super.key,
    required this.showNotifyButton,
    required this.isNotifyButton,
    required this.goToOccurrences,
    required this.getTimesheetReport,
    required this.put,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          PrimaryButton(
              buttonColor: const Color(0xFF2F80ED),
              onPressed: goToOccurrences,
              text: getString(context, "gdp_timesheet_go_occurrence")),
          SizedBox(height: Dimens.spacing),
          showNotifyButton
              ? PrimaryButton(
                  onPressed: getTimesheetReport,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.file_download_outlined,
                            color: theme.primaryColor),
                        SizedBox(width: Dimens.spacingSmall),
                        Text(
                            getString(context, "gdp_timesheet_download_report"),
                            style: LelloTextStyles.button(theme)
                                ?.copyWith(color: Colors.white)),
                      ]),
                )
              : SecondaryButton(
                  buttonBorderColor: theme.primaryColor,
                  onPressed: getTimesheetReport,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.file_download_outlined,
                            color: theme.primaryColor),
                        SizedBox(width: Dimens.spacingSmall),
                        Text(
                            getString(context, "gdp_timesheet_download_report"),
                            style: LelloTextStyles.button(theme)
                                ?.copyWith(color: theme.primaryColor)),
                      ]),
                ),
          if (!showNotifyButton) SizedBox(height: Dimens.spacing),
          if (!showNotifyButton)
            PrimaryButton(
                onPressed: put,
                text: isNotifyButton
                    ? getString(context, "gdp_timesheet_notify")
                    : getString(context, "gdp_timesheet_signature_button")),
        ],
      ),
    );
  }
}
