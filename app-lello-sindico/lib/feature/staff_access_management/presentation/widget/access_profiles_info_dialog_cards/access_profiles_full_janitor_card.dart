import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class FullJanitorCard extends StatefulWidget {
  const FullJanitorCard({super.key});

  @override
  State<FullJanitorCard> createState() => _FullJanitorCardState();
}

class _FullJanitorCardState extends State<FullJanitorCard> {
  bool isGerentePredialSelected = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ExpansionTile(
        trailing: isGerentePredialSelected
            ? Icon(
                Icons.arrow_drop_up,
                color: LelloTheme.palleteOf(theme).primary(),
                size: 30,
              )
            : Icon(
                Icons.arrow_drop_down,
                color: LelloTheme.palleteOf(theme).primary(),
                size: 30,
              ),
        childrenPadding: EdgeInsets.symmetric(
          horizontal: Dimens.spacingLarge,
          vertical: Dimens.spacing,
        ),
        title: Text(
          getString(
            context,
            "staff_access_management_full_service_janitor",
          ),
          style: LelloTextStyles.subtitleBold(theme)?.copyWith(
            color: LelloTheme.palleteOf(theme).primary(),
          ),
        ),
        onExpansionChanged: (value) {
          setState(() {
            isGerentePredialSelected = !isGerentePredialSelected;
          });
        },
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        expandedAlignment: Alignment.centerLeft,
        children: [
          ListTile(
            leading: const Text('•'),
            dense: true,
            minLeadingWidth: 0,
            contentPadding: EdgeInsets.zero,
            visualDensity: const VisualDensity(
              vertical: VisualDensity.minimumDensity,
            ),
            title: Text(
              getString(context, "income_monthly_billets"),
              style: LelloTextStyles.subtitle(theme),
            ),
          ),
          ListTile(
            leading: const Text('•'),
            dense: true,
            minLeadingWidth: 0,
            contentPadding: EdgeInsets.zero,
            visualDensity: const VisualDensity(
              vertical: VisualDensity.minimumDensity,
            ),
            title: Text(
              getString(context, "condominium_hub_manage_space"),
              style: LelloTextStyles.subtitle(theme),
            ),
          ),
          ListTile(
            leading: const Text('•'),
            dense: true,
            minLeadingWidth: 0,
            contentPadding: EdgeInsets.zero,
            visualDensity: const VisualDensity(
              vertical: VisualDensity.minimumDensity,
            ),
            title: Text(
              getString(context, "condominium_hub_units"),
              style: LelloTextStyles.subtitle(theme),
            ),
          ),
          ListTile(
            leading: const Text('•'),
            dense: true,
            minLeadingWidth: 0,
            contentPadding: EdgeInsets.zero,
            visualDensity: const VisualDensity(
              vertical: VisualDensity.minimumDensity,
            ),
            title: Text(
              getString(context, "condominium_hub_announcements"),
              style: LelloTextStyles.subtitle(theme),
            ),
          ),
          ListTile(
            leading: const Text('•'),
            dense: true,
            minLeadingWidth: 0,
            contentPadding: EdgeInsets.zero,
            visualDensity: const VisualDensity(
              vertical: VisualDensity.minimumDensity,
            ),
            title: Text(
              getString(context, "gdp_timesheet_type_events"),
              style: LelloTextStyles.subtitle(theme),
            ),
          ),
        ],
      ),
    );
  }
}
