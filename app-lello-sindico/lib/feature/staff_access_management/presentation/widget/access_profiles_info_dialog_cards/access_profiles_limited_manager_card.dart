import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class LimitedManagerCard extends StatefulWidget {
  const LimitedManagerCard({super.key});

  @override
  State<LimitedManagerCard> createState() => _LimitedManagerCardState();
}

class _LimitedManagerCardState extends State<LimitedManagerCard> {
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
            "staff_access_management_limited_service_building_manager",
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
            title: Text(
              getString(context, "balance"),
              style: LelloTextStyles.subtitle(theme),
            ),
            visualDensity: const VisualDensity(
              vertical: VisualDensity.minimumDensity,
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
              getString(context, "documents"),
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
          ListTile(
            leading: const Text('•'),
            dense: true,
            minLeadingWidth: 0,
            contentPadding: EdgeInsets.zero,
            visualDensity: const VisualDensity(
              vertical: VisualDensity.minimumDensity,
            ),
            title: Text(
              getString(context, "income_title"),
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
              getString(context, "lello_hub_default"),
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
              'Prestação de Contas (exceto aprovação)',
              style: LelloTextStyles.subtitle(theme),
            ),
          ),
        ],
      ),
    );
  }
}
