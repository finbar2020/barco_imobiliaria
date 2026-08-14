import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide BlendMode;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/accountability/presentation/list/page/accountability_page.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_page.dart';
import 'package:lello/feature/comfort/presentation/page/comodities_page.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/condominium/presentation/page/condominium_hub_page.dart';
import 'package:lello/feature/dashboard/presentation/page/dashboard_page.dart';
import 'package:lello/feature/gdp/presentation/page/gdp_main_page.dart';
import 'package:lello/feature/home/presentation/page/home_page.dart';

import 'package:lello/feature/lello/presentation/page/lello_hub_page.dart';
import 'package:lello/feature/payment/presentation/main_page/payment_main_page.dart';
import 'package:lello/feature/reports_book/presentation/pages/reports_page.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/space/presentation/page/space_menu_page.dart';
import 'package:lello/lello_app.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/core/circuit_breaker/enum/circuit_breaker_situation_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_page.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';
import 'package:shared_features/shared_features.dart';

enum HomeNavigationItemEnum {
  home,
  condominium,
  lello,
  comfort,
}

extension HomeNavigationItemExtension on HomeNavigationItemEnum {
  String get title {
    switch (this) {
      case HomeNavigationItemEnum.home:
        return "home";
      case HomeNavigationItemEnum.condominium:
        return "condominium_hub_title";
      case HomeNavigationItemEnum.lello:
        return "lello_hub_title";
      case HomeNavigationItemEnum.comfort:
        return "comfort";
    }
  }

  Widget activeIcon(
      NotificationListBloc notificationListBloc, Color primaryColor) {
    final colorFilter = ColorFilter.mode(primaryColor, BlendMode.srcIn);
    switch (this) {
      case HomeNavigationItemEnum.home:
        return SvgPicture.asset(
          "assets/ic_home_selected.svg",
          height: 30.0,
          width: 30.0,
          colorFilter: colorFilter,
        );
      case HomeNavigationItemEnum.condominium:
        return SvgPicture.asset(
          "assets/ic_condo_selected.svg",
          height: 30.0,
          width: 30.0,
          colorFilter: colorFilter,
        );
      case HomeNavigationItemEnum.lello:
        return SvgPicture.asset(
          "assets/ic_me_selected.svg",
          height: 30.0,
          width: 30.0,
          colorFilter: colorFilter,
        );
      case HomeNavigationItemEnum.comfort:
        return SvgPicture.asset(
          "assets/ic_comfort_selected.svg",
          height: 30.0,
          width: 30.0,
          colorFilter: colorFilter,
        );
    }
  }

  Widget icon(NotificationListBloc notificationListBloc) {
    switch (this) {
      case HomeNavigationItemEnum.home:
        return SvgPicture.asset(
          "assets/ic_home.svg",
          height: 30.0,
          width: 30.0,
        );
      case HomeNavigationItemEnum.condominium:
        return SvgPicture.asset(
          "assets/ic_condo.svg",
          height: 30.0,
          width: 30.0,
        );
      case HomeNavigationItemEnum.lello:
        return SvgPicture.asset(
          "assets/ic_me.svg",
          height: 30.0,
          width: 30.0,
        );
      case HomeNavigationItemEnum.comfort:
        return SvgPicture.asset(
          "assets/ic_comfort.svg",
          height: 30.0,
          width: 30.0,
        );
    }
  }

  Widget body(
    bool isGeneric,
    BuildContext context,
    SessionBloc sessionBloc,
    NotificationController notificationController,
    SharedApplicationRedirectRoute? redirectRote,
  ) {
    switch (this) {
      case HomeNavigationItemEnum.home:
        return DashboardPage(
          isGeneric: isGeneric,
        );
      case HomeNavigationItemEnum.condominium:
        return CondominiumHubPage(
          isGeneric: isGeneric,
        );
      case HomeNavigationItemEnum.lello:
        return LelloHubPage(
          isGeneric: isGeneric,
        );
      case HomeNavigationItemEnum.comfort:
        return ComoditiesPage(
          isGeneric: isGeneric,
        );
    }
  }

  notificationDetailRedirect(
    SingleNotification notification,
    SessionBloc sessionBloc,
    BuildContext context,
    SharedApplicationRedirectRoute? redirectRote,
  ) {
    if (notification.canRedirect) {
      if (sessionBloc.state.session?.selectedCondominium?.notificationContext !=
          notification.reference) {
        Condominium? switchCondominium = sessionBloc
            .state.session?.me?.condominiums!
            .cast<Condominium?>()
            .firstWhere(
                (element) =>
                    element?.notificationContext == notification.reference,
                orElse: () => null);

        if (switchCondominium != null) {
          Navigator.of(context).pushReplacementNamed(
            SharedApplicationRoute.home,
            arguments: HomePageArgs(
              redirectRoute: SharedApplicationRedirectRoute(
                context: notification.reference!,
                rote: notification.redirectPath!,
                objectId: notification.redirectId,
                inApp: notification.inApp ?? false,
                notificationId: notification.id,
                uuidGroup: notification.uuidGroup ?? "",
              ),
            ),
          );
        } else {
          switchRedirect(
            SharedApplicationRedirectRoute(
              context: notification.reference!,
              rote: notification.redirectPath!,
              objectId: notification.redirectId,
              inApp: notification.inApp ?? false,
              notificationId: notification.id,
              uuidGroup: notification.uuidGroup ?? "",
            ),
            sessionBloc,
            context,
            redirectRote,
            notification,
          );
        }
      } else {
        switchRedirect(
          SharedApplicationRedirectRoute(
            context: notification.reference!,
            rote: notification.redirectPath!,
            objectId: notification.redirectId,
            inApp: notification.inApp ?? false,
            notificationId: notification.id,
            uuidGroup: notification.uuidGroup ?? "",
          ),
          sessionBloc,
          context,
          redirectRote,
          notification,
        );
      }
    }
  }

  void switchRedirect(
    SharedApplicationRedirectRoute redirectRousdte,
    SessionBloc sessionBloc,
    BuildContext context,
    SharedApplicationRedirectRoute? redirectRote,
    SingleNotification notification,
  ) {
    //identifica e redireciona rota
    printInfo(info: redirectRousdte.toString());

    Object? newRote;
    Object? arguments;
    FeaturesRoutesEnum? routesEnum =
        stringToEnum(FeaturesRoutesEnum.values, redirectRousdte.rote);

    switch (routesEnum) {
      //Acordos
      case FeaturesRoutesEnum.ACORDO_APROVADO_AUTOMATICAMENTE:
      case FeaturesRoutesEnum.ACORDO_PROPOSTA:
        if (_canRedirect(
            applicationRbac: ApplicationRbac.sindicoAcordos,
            sessionBloc: sessionBloc)) {
          newRote = ApplicationRoute.agreements;
          arguments = AgreementsPageArgs(
              agreementsNotificationContext: redirectRousdte.objectId,
              route: routesEnum);
          break;
        }
        break;
      //Ocorrencia
      case FeaturesRoutesEnum.OCORRENCIA_RESPOSTA:
      case FeaturesRoutesEnum.OCORRENCIA_NOVA:
        if (_canRedirect(
            applicationRbac: ApplicationRbac.sindicoOcorrencias,
            sessionBloc: sessionBloc)) {
          newRote = ApplicationRoute.reportsBook;
          arguments = ReportsPageArgs(
              reportsNotificationContext: redirectRousdte.objectId);
          break;
        }
        break;
      //Despesas
      case FeaturesRoutesEnum.DESPESAS_APROVACAO:
      case FeaturesRoutesEnum.DESPESAS_PAGAMENTO_NOVO:
        if (_canRedirect(
            applicationRbac: ApplicationRbac.sindicoDespesas,
            sessionBloc: sessionBloc)) {
          newRote = ApplicationRoute.payment;
          arguments = PaymentMainPageArgs(
              paymentNotificationContext: redirectRousdte.objectId,
              route: routesEnum);
          break;
        }
        break;
      //PPC
      case FeaturesRoutesEnum.PPC_DISPONIVEL:
      case FeaturesRoutesEnum.PPC_MES_FECHADO:
        if (_canRedirect(
            applicationRbac: ApplicationRbac.sindicoPpc,
            sessionBloc: sessionBloc)) {
          newRote = ApplicationRoute.accountability;
          arguments = AccountabilityPageArgs(
              accountabilityNotificationContext: redirectRousdte.objectId);
          break;
        }
        break;
      //Reservas
      case FeaturesRoutesEnum.RESERVA_AREA:
      case FeaturesRoutesEnum.RESERVA_MUDANCAS:
        if (_canRedirect(
            applicationRbac: ApplicationRbac.sindicoReservas,
            sessionBloc: sessionBloc)) {
          newRote = ApplicationRoute.space;
          arguments = SpaceMenuPageArgs(
              reserveNotificationContext: redirectRousdte.objectId);
          break;
        }
        break;

      //Gestao tecnica operacional
      case FeaturesRoutesEnum.GESTAO_TECNICA:
        if (_canRedirect(
            applicationRbac: ApplicationRbac.sindicoGestaoDeManutencao,
            sessionBloc: sessionBloc)) {
          newRote = ApplicationRoute.maintenanceManagement;
          break;
        }
        break;

      //Comodidades
      case FeaturesRoutesEnum.COMODIDADES:
      case FeaturesRoutesEnum.COMODIDADES_CATEGORIA:
      case FeaturesRoutesEnum.COMODIDADES_PARCEIRO:
        if (_canRedirect(
            applicationRbac: ApplicationRbac.sindicoComodidades,
            sessionBloc: sessionBloc)) {
          newRote = ApplicationRoute.comodities;
          arguments = ComfortPageArgs(
            appOriginEnum: AppOriginEnum.manager,
            reference:
                sessionBloc.state.session?.selectedCondominium?.reference ?? "",
            accessRouteOrigin: ComfortPageOriginEnum.inAppNotification,
            route: routesEnum,
            comfortNotificationContext: redirectRousdte.objectId,
            checkFavorites: (_canRedirect(
                applicationRbac: ApplicationRbac.sindicoComodidadesFavoritos,
                sessionBloc: sessionBloc)),
            checkOffers: (_canRedirect(
                applicationRbac: ApplicationRbac.sindicoComodidadesOfertas,
                sessionBloc: sessionBloc)),
            checkRequest: (_canRedirect(
                applicationRbac: ApplicationRbac.sindicoComodidadesSolicitacoes,
                sessionBloc: sessionBloc)),
            checkYourCondo: (_canRedirect(
                applicationRbac:
                    ApplicationRbac.sindicoComodidadesSeuCondominio,
                sessionBloc: sessionBloc)),
          );
          break;
        }
        break;
      //InApp
      case FeaturesRoutesEnum.NOTIFICACOES_NAO_LIDAS:
        newRote = 3;
        break;
      case FeaturesRoutesEnum.PORTARIA_BLOQUEADA:
      case FeaturesRoutesEnum.PORTARIA_LIBERADA:
        break;
      case FeaturesRoutesEnum.ALERTA_FALTAS:
      case FeaturesRoutesEnum.ALERTA_HORAS_EXTRAS:
      case FeaturesRoutesEnum.ALERTA_HORAS_ATRASO:
      case FeaturesRoutesEnum.ALERTA_ASSINATURA_SINDICO:
      case FeaturesRoutesEnum.ALERTA_ASSINATURA_FUNCIONARIO:
        newRote = SharedApplicationRoute.gdp;
        arguments = GdpPageArgs(
          route: routesEnum!,
          gdpNotificationContext: redirectRousdte.objectId ?? "",
        );
      default:
        if (LelloApp.routes.keys
            .any((element) => element == redirectRousdte.rote)) {
          newRote = redirectRousdte.rote;
        }
    }
    if (newRote != null) {
      if (notification.canRedirect) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          newRote is String
              ? Navigator.pushNamed(context, newRote, arguments: arguments)
              : Navigator.of(context).pushReplacementNamed(
                  SharedApplicationRoute.home,
                  arguments: HomePageArgs(
                    redirectRoute: SharedApplicationRedirectRoute(
                      context: notification.reference!,
                      rote: notification.redirectPath!,
                      objectId: notification.redirectId,
                      inApp: notification.inApp ?? false,
                      notificationId: notification.id,
                      uuidGroup: notification.uuidGroup ?? "",
                    ),
                  ),
                );
        });
      }
    }
    //apaga rote antigo
    redirectRote?.didRedirect = true;
  }

  bool _canRedirect(
      {required String applicationRbac, required SessionBloc sessionBloc}) {
    CircuitBreakerController circuitBreakController =
        ApplicationContainer.instance().resolve();
    var itemRule = circuitBreakController.getRule(
        applicationRbac: applicationRbac,
        reference:
            sessionBloc.state.session?.selectedCondominium?.reference ?? "");
    if (itemRule?.situation == CircuitBreakerSituationEnum.hide ||
        !sessionBloc.checkRback(applicationRbac)) return false;
    return true;
  }
}
