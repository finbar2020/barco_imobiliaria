import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_features/shared_features.dart';

class GdpMainPageArgs {
  String reference;
  String? unit;
  AppOriginEnum appOriginEnum;

  GdpMainPageArgs({
    required this.appOriginEnum,
    required this.reference,
    this.unit,
  });
}

class GdpMainPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  final AppOriginEnum appOriginEnum;
  const GdpMainPage(
      {Key? key, required this.appContainer, required this.appOriginEnum})
      : super(key: key);
  @override
  State<GdpMainPage> createState() => _GdpMainPageState();
}

class _GdpMainPageState extends State<GdpMainPage> {
  final theme = LelloTheme.light;

  @override
  Widget build(BuildContext context) {
    GdpMainPageArgs args =
        ModalRoute.of(context)?.settings.arguments as GdpMainPageArgs;
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
            theme: theme, title: getString(context, "gdp_main_page_title")),
        body: _buildList(context, args),
      ),
    );
  }

  Widget _buildList(BuildContext context, GdpMainPageArgs args) {
    return ListView(
      children: [
        _buildListItem(
            getString(context, "gdp_quick_fix"), "assets/ic_gdp_quick_fix.svg",
            onTap: () {
          Navigator.of(context).pushNamed(SharedApplicationRoute.gdpQuickFix);
        }),
        Divider(),
        _buildListItem(getString(context, "gdp_team"), "assets/ic_gdp_team.svg",
            onTap: () {
          Navigator.of(context)
              .pushNamed(SharedApplicationRoute.gdpEmployeeList);
        }),
        Divider(),
        _buildListItem(
            getString(context, "gdp_vacation"), "assets/ic_gdp_vacation.svg",
            onTap: () {
          AnalyticsLogEvents.logEvent(
            event: args.appOriginEnum == AppOriginEnum.manager
                ? AnalyticsEventsManager.agendarFeriasAcessar()
                : AnalyticsEventsEmployee.agendarFeriasAcessar(),
            unitValue: args.unit,
            referenceValue: args.reference,
            appOrigin: args.appOriginEnum,
          );
          Navigator.of(context)
              .pushNamed(SharedApplicationRoute.gdpVacationEmployees);
        }),
        Divider(),
        _buildListItem(
            getString(context, "gdp_payroll"), "assets/ic_gdp_payroll.svg",
            onTap: () {
          AnalyticsLogEvents.logEvent(
            event: args.appOriginEnum == AppOriginEnum.manager
                ? AnalyticsEventsManager.folhaPgtoAcessar()
                : AnalyticsEventsEmployee.folhaPgtoAcessar(),
            unitValue: args.unit,
            referenceValue: args.reference,
            appOrigin: args.appOriginEnum,
          );
          Navigator.of(context).pushNamed(SharedApplicationRoute.gdppayroll);
        }),
        Divider(),
        _buildListItem(
            getString(context, "gdp_payslip"), "assets/ic_gdp_payslip.svg",
            onTap: () {
          AnalyticsLogEvents.logEvent(
            event: args.appOriginEnum == AppOriginEnum.manager
                ? AnalyticsEventsManager.holeriteAcessar()
                : AnalyticsEventsEmployee.holeriteAcessar(),
            unitValue: args.unit,
            referenceValue: args.reference,
            appOrigin: args.appOriginEnum,
          );
          Navigator.of(context)
              .pushNamed(SharedApplicationRoute.gdpPayslipMonth);
        }),
        Divider(),
        _buildListItem(
            getString(context, "gdp_timesheet"), "assets/ic_gdp_timesheet.svg",
            onTap: () {
          AnalyticsLogEvents.logEvent(
            event: args.appOriginEnum == AppOriginEnum.manager
                ? AnalyticsEventsManager.pontoDigitalAcessar()
                : AnalyticsEventsEmployee.pontoDigitalAcessar(),
            unitValue: args.unit,
            referenceValue: args.reference,
            appOrigin: args.appOriginEnum,
          );
          Navigator.of(context)
              .pushNamed(SharedApplicationRoute.gdpTimesheetMenu);
        }),
        Divider(),
      ],
    );
  }

  Widget _buildListItem(String title, String asset, {VoidCallback? onTap}) {
    return Opacity(
      opacity: onTap == null ? 0.5 : 1,
      child: ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.only(
              left: Dimens.spacingLarge,
              right: Dimens.spacingLarge,
              top: Dimens.spacingSmall,
              bottom: Dimens.spacingSmall),
          leading: SvgPicture.asset(asset, width: 24),
          title: Text(title, style: LelloTextStyles.bodyBold(theme)),
          trailing: Icon(Icons.arrow_forward_ios)),
    );
  }
}
