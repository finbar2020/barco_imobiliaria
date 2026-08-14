import 'package:colaborador/core/widgets/custom_app_bar.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_point_flag_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class TimesheetInfoPage extends StatelessWidget {
  const TimesheetInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: const CustomAppBar(title: "timesheet_page_appbar"),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: Column(
            children: [
              const Icon(
                Icons.info_outline,
                color: Colors.grey,
                size: 80.0,
              ),
              SizedBox(height: Dimens.spacing),
              Text(
                getString(context, "timesheet_info_page_title"),
                style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).hubText(),
                ),
              ),
              SizedBox(height: Dimens.spacing),
              Text(
                getString(context, "timesheet_info_page_description"),
                style: LelloTextStyles.subtitle(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).hubText(),
                ),
              ),
              SizedBox(height: Dimens.spacing),
              Text(
                getString(context, "timesheet_info_page_description_bold"),
                style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).hubText(),
                ),
              ),
              SizedBox(height: Dimens.spacing),
              _buildText(context, TimesheetPointFlagEnum.inserted),
              _buildText(context, TimesheetPointFlagEnum.preInsert),
              _buildText(context, TimesheetPointFlagEnum.notInserted),
              SizedBox(height: Dimens.spacingLarge),
              PrimaryButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: getString(context, "back"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText(BuildContext context, TimesheetPointFlagEnum flag) {
    ThemeData theme = Theme.of(context);
    Color color = TimesheetPointFlag.color(context, flag);
    return Padding(
      padding: EdgeInsets.only(bottom: Dimens.spacingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 24.0,
            height: 24.0,
            alignment: Alignment.center,
            // padding: EdgeInsets.all(Dimens.spacingSmall),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                TimesheetPointFlag.symbol(flag),
                style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                  color: color,
                ),
              ),
            ),
          ),
          SizedBox(width: Dimens.spacingSmall),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: LelloTextStyles.subtitle(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).hubText(),
                ),
                children: [
                  TextSpan(
                    text:
                        "${getString(context, TimesheetPointFlag.titleKey(flag))}: ",
                    style: LelloTextStyles.subtitleBold(theme)
                        ?.copyWith(color: color),
                  ),
                  TextSpan(
                    text: getString(
                        context, TimesheetPointFlag.descriptionKey(flag)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
