import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_menu_page.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';

class GdpPageArgs {
  String gdpNotificationContext;
  FeaturesRoutesEnum route;

  GdpPageArgs({
    required this.gdpNotificationContext,
    required this.route,
  });
}

// ignore: must_be_immutable
class GdpMainPage extends StatelessWidget {
  bool realizedRedirect = false;

  GdpMainPage({super.key});
  @override
  Widget build(BuildContext context) {
    SessionBloc sessionBloc = BlocProvider.of(context);
    CircuitBreakerController circuitBreakerController =
        ApplicationContainer.instance().resolve();
    String reference =
        sessionBloc.state.session?.selectedCondominium?.reference.toString() ??
            "";
    GdpPageArgs? args =
        ModalRoute.of(context)?.settings.arguments as GdpPageArgs?;
    if (args != null && !realizedRedirect) {
      realizedRedirect = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ManagerAnalyticsLogEvents.logEvent(
            event: AnalyticsEventsManager.pontoDigitalAcessar(),
            referenceValue: reference);
        Navigator.of(context).pushNamed(ApplicationRoute.gdpTimesheetMenu,
            arguments: TimesheetMenuPagePageArgs(
              gdpNotificationContext: args.gdpNotificationContext,
              route: args.route,
            ));
      });
    }
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
            iconColor: theme.primaryColor,
            theme: theme,
            title: getString(context, "lello_hub_employee")),
        body: _buildList(
            context, theme, reference, sessionBloc, circuitBreakerController),
      ),
    );
  }

  Widget _buildList(
      BuildContext context,
      ThemeData theme,
      String reference,
      SessionBloc sessionBloc,
      CircuitBreakerController circuitBreakerController) {
    return ListView(
      children: [
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoGdpResolvaFacil,
          rbacEnabled:
              sessionBloc.checkRback(ApplicationRbac.sindicoGdpResolvaFacil),
          child: Column(
            children: [
              _buildListItem(getString(context, "gdp_quick_fix"),
                  "assets/ic_quick_fix.svg", theme, onTap: () {
                Navigator.of(context).pushNamed(ApplicationRoute.gdpQuickFix);
              }),
              const Divider(),
            ],
          ),
        ),
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoGdpEquipe,
          rbacEnabled: sessionBloc.checkRback(ApplicationRbac.sindicoGdpEquipe),
          child: Column(
            children: [
              _buildListItem(
                  getString(context, "gdp_team"), "assets/ic_team.svg", theme,
                  onTap: () {
                Navigator.of(context)
                    .pushNamed(ApplicationRoute.gdpEmployeeList);
              }),
              const Divider(),
            ],
          ),
        ),
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoGdpFerias,
          rbacEnabled: sessionBloc.checkRback(ApplicationRbac.sindicoGdpFerias),
          child: Column(
            children: [
              _buildListItem(getString(context, "gdp_vacation"),
                  "assets/ic_vacation.svg", theme, onTap: () {
                ManagerAnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsManager.agendarFeriasAcessar(),
                    referenceValue: reference);
                Navigator.of(context)
                    .pushNamed(ApplicationRoute.gdpVacationEmployees);
              }),
              const Divider(),
            ],
          ),
        ),
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoGdpFolhaPagamento,
          rbacEnabled:
              sessionBloc.checkRback(ApplicationRbac.sindicoGdpFolhaPagamento),
          child: Column(
            children: [
              _buildListItem(getString(context, "gdp_payroll"),
                  "assets/ic_payroll.svg", theme, onTap: () {
                ManagerAnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsManager.folhaPgtoAcessar(),
                    referenceValue: reference);
                Navigator.of(context).pushNamed(ApplicationRoute.payroll);
              }),
              const Divider(),
            ],
          ),
        ),
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoGdpHolerite,
          rbacEnabled:
              sessionBloc.checkRback(ApplicationRbac.sindicoGdpHolerite),
          child: Column(
            children: [
              _buildListItem(getString(context, "gdp_payslip"),
                  "assets/ic_payslip.svg", theme, onTap: () {
                ManagerAnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsManager.holeriteAcessar(),
                    referenceValue: reference);

                Navigator.of(context)
                    .pushNamed(ApplicationRoute.gdpPayslipMonth);
              }),
              const Divider(),
            ],
          ),
        ),
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoGdpPontoDigital,
          rbacEnabled:
              sessionBloc.checkRback(ApplicationRbac.sindicoGdpPontoDigital),
          child: Column(
            children: [
              _buildListItem(getString(context, "gdp_timesheet"),
                  "assets/ic_timesheet.svg", theme, onTap: () {
                ManagerAnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsManager.pontoDigitalAcessar(),
                    referenceValue: reference);

                Navigator.of(context)
                    .pushNamed(ApplicationRoute.gdpTimesheetMenu);
              }),
              const Divider(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(String title, String asset, ThemeData theme,
      {VoidCallback? onTap}) {
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
          title: Text(title, style: LelloTextStyles.bodyBold(theme))),
    );
  }
}
