import 'package:colaborador/core/analytics/analytics_log_events.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/navigation/application_rbac.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/home/presentation/page/home_navigation_page.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/notification_icon.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/whatsapp_icon.dart';
import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/page/timesheet_page.dart';
import 'package:colaborador/lello_app.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/core/circuit_breaker/models/circuit_item_rule.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_page.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';
import 'package:shared_features/shared_features.dart';

class HomeUserInfoWidget extends StatelessWidget {
  final Me me;
  final String reference;
  final NotificationController notificationController;
  final CircuitBreakerController circuitBreakerController;
  const HomeUserInfoWidget({
    super.key,
    required this.me,
    required this.reference,
    required this.notificationController,
    required this.circuitBreakerController,
  });

  @override
  Widget build(BuildContext context) {
    final SessionBloc sessionBloc =
        ApplicationContainer.instance().resolve<SessionBloc>();
    ThemeData theme = Theme.of(context);
    return StreamBuilder<List<CircuitItemRule>>(
        stream: circuitBreakerController.ruleStream.stream,
        builder: (context, snapshot) {
          return Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(Dimens.spacingSmall),
                  child: Text(
                    "${getString(context, 'home_page_hi')}, ${me.firstNameFormatted}!",
                    style: LelloTextStyles.titleSmall(theme),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(name: "/notifications"),
                        builder: (context) => NotificationListPage(
                          closeOverlay: () {},
                          dialogBloc: null,
                          notificationController: notificationController,
                          homeBloc: null,
                          configurationPage:
                              ApplicationRoute.preferencesNotification,
                          HomeNavigationPage: const HomeNavigationPage(),
                          appOriginEnum: AppOriginEnum.employee,
                          sessionBloc: sessionBloc,
                          applicationContainer: ApplicationContainer.instance(),
                          onTap: (notification) {
                            if (notification.redirectPath != null) {
                              switchRedirect(
                                  notification.redirectPath!,
                                  context,
                                  notification.redirectId,
                                  sessionBloc);
                            }
                          },
                        ),
                      ),
                    );
                  },
                  child: NotificationIcon(
                      notificationListBloc: notificationController.bloc),
                ),
              ),
              if (sessionBloc.checkRback(ApplicationRbacEnum.colaboradorChat
                      .toFormattedString()) &&
                  circuitBreakerController.checkVisible(
                      applicationRbac: ApplicationRbacEnum.colaboradorChat
                          .toFormattedString(),
                      reference: reference))
                Expanded(
                  flex: 1,
                  child: CircuitBreakerWidget(
                    appContainer: ApplicationContainer.instance(),
                    reference: reference,
                    applicationRbac:
                        ApplicationRbacEnum.colaboradorChat.toFormattedString(),
                    rbacEnabled: sessionBloc.checkRback(ApplicationRbacEnum
                        .colaboradorChat
                        .toFormattedString()),
                    child: GestureDetector(
                      onTap: () {
                        Launch.whatsApp(
                          context,
                          FlavorConfig.config.supportColaboradorWhatsAppNumber,
                          message:
                              getString(context, "whats_app_default_message"),
                        );
                        EmployeeAnalyticsLogEvents.logEvent(
                          event: AnalyticsEventsEmployee.homeWhatsAppAcessar(),
                          referenceValue: reference.toString(),
                        );
                      },
                      child: const WhatsappIcon(),
                    ),
                  ),
                )
            ],
          );
        });
  }

  void switchRedirect(String notificationCase, BuildContext context,
      String? redirectId, SessionBloc sessionBloc) {
    String? newRote;

    FeaturesRoutesEnum? routesEnum =
        stringToEnum(FeaturesRoutesEnum.values, notificationCase);

    dynamic args;

    if (routesEnum != null) {
      switch (routesEnum) {
        case FeaturesRoutesEnum.ESPELHO_PONTO:
          if (!(sessionBloc.checkRback(
            ApplicationRbacEnum.colaboradorPontodigitalEspelhoPonto
                .toFormattedString(),
          ))) break;
          args = TimesheetPageArgs(period: redirectId);
          newRote = ApplicationRoute.timesheet;
          break;
        //Comodidades
        case FeaturesRoutesEnum.COMODIDADES:
        case FeaturesRoutesEnum.COMODIDADES_CATEGORIA:
        case FeaturesRoutesEnum.COMODIDADES_PARCEIRO:
          newRote = SharedApplicationRoute.comfort;
          args = ComfortPageArgs(
            appOriginEnum: AppOriginEnum.employee,
            reference: sessionBloc.getSession?.condominiumReference ?? "",
            accessRouteOrigin: ComfortPageOriginEnum.inAppNotification,
            route: routesEnum,
            comfortNotificationContext: redirectId,
          );
          break;
        default:
      }
    } else {
      if (LelloApp.routes.keys.any((element) => element == notificationCase)) {
        newRote = notificationCase;
      }
    }
    if (newRote != null) {
      Navigator.popUntil(
          context, ModalRoute.withName(SharedApplicationRoute.home));
      Navigator.of(context).pushNamed(newRote, arguments: args);
    }
  }
}
