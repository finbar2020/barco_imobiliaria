import 'package:essentials/essentials.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_page.dart';
import 'package:morar/feature/accountability/presentation/page/accountability_page.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_page.dart';
import 'package:morar/feature/billets/presentation/pages/billets_page.dart';
import 'package:morar/feature/digital_meeting/presentation/page/digital_meeting_page.dart';
import 'package:morar/feature/documents/integration/documents_routing.dart';
import 'package:morar/feature/ia_bella/domain/entity/bella_message_entity.dart';
import 'package:morar/feature/insurance/presentation/pages/insurance_page.dart';
import 'package:morar/feature/mailing/presentation/page/mailing_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_page.dart';
import 'package:morar/feature/reservation/presentation/page/reservation_page.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/sub_user/presentation/pages/sub_user_page.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';
import 'package:shared_features/shared_features.dart';

enum HomeRedirectAction {
  none,
  navigateRoute,
  openNotifications,
  openComoditiesTab,
}

class HomeRedirectResult {
  final HomeRedirectAction action;
  final String? route;
  final dynamic arguments;

  const HomeRedirectResult._({
    required this.action,
    this.route,
    this.arguments,
  });

  const HomeRedirectResult.none()
      : this._(
          action: HomeRedirectAction.none,
        );

  const HomeRedirectResult.navigateRoute({
    required String route,
    dynamic arguments,
  }) : this._(
          action: HomeRedirectAction.navigateRoute,
          route: route,
          arguments: arguments,
        );

  const HomeRedirectResult.openNotifications()
      : this._(
          action: HomeRedirectAction.openNotifications,
        );

  const HomeRedirectResult.openComoditiesTab()
      : this._(
          action: HomeRedirectAction.openComoditiesTab,
        );
}

class HomeNavigationRedirectResolver {
  final SessionBloc sessionBloc;
  final bool isGeneric;

  HomeNavigationRedirectResolver({
    required this.sessionBloc,
    required this.isGeneric,
  });

  HomeRedirectResult resolve(SharedApplicationRedirectRoute redirectRoute) {
    final FeaturesRoutesEnum? routesEnum =
        stringToEnum(FeaturesRoutesEnum.values, redirectRoute.rote);

    switch (routesEnum) {
      // Acordos
      case FeaturesRoutesEnum.ACORDO_APROVADO_AUTOMATICAMENTE:
      case FeaturesRoutesEnum.ACORDO_PAGAMENTO_PARCELA:
      case FeaturesRoutesEnum.ACORDO_BOLETO_DISPONIVEL:
      case FeaturesRoutesEnum.ACORDO_PROPOSTA_APROVADA:
      case FeaturesRoutesEnum.ACORDO_PROPOSTA_ENVIADA:
      case FeaturesRoutesEnum.ACORDO_PROPOSTA_RECUSADA:
      case FeaturesRoutesEnum.ACORDO_PARCELA:
      case FeaturesRoutesEnum.ACORDO_PROPOSTA:
      case FeaturesRoutesEnum.ACORDOS_COTA_2:
      case FeaturesRoutesEnum.ACORDOS_COTA_30:
      case FeaturesRoutesEnum.ACORDOS_COTA_58:
        if (_hasRbac(ApplicationRbac.morarAcordos) == false) {
          break;
        }
        return HomeRedirectResult.navigateRoute(
          route: ApplicationRoute.agreements,
          arguments: AgreementsPageArgs(
            agreementsNotificationContext: redirectRoute.objectId,
          ),
        );

      // Correspondencia
      case FeaturesRoutesEnum.CORRESPONDENCIAS_ENTRADA:
      case FeaturesRoutesEnum.CORRESPONDENCIAS_RETIRADA:
        if (_hasRbac(ApplicationRbac.morarCorrespondencias) == false) {
          break;
        }
        return HomeRedirectResult.navigateRoute(
          route: ApplicationRoute.mailing,
          arguments: MailingPageArgs(
            mailingNotificationContext: redirectRoute.objectId,
          ),
        );

      // Controle de acesso
      case FeaturesRoutesEnum.ENTRADA_AUTORIZACAO_VISITANTE_NOVO:
      case FeaturesRoutesEnum.ENTRADA_LIBERACAO:
        if (_hasRbac(ApplicationRbac.morarAutorizarEntrada) == false) {
          break;
        }
        return HomeRedirectResult.navigateRoute(
          route: ApplicationRoute.accessControl,
          arguments: AcessControlPageArgs(
            acessControlNotificationContext: redirectRoute.objectId,
            isGeneric: isGeneric,
          ),
        );

      // Novo usuario
      case FeaturesRoutesEnum.MORADORES_ACESSOU:
        if (_hasRbac(ApplicationRbac.morarMoradores) == false) {
          break;
        }
        return HomeRedirectResult.navigateRoute(
          route: ApplicationRoute.subUser,
          arguments: SubUserPageArgs(
            subUserNotificationContext: redirectRoute.objectId,
          ),
        );

      // Boletos
      case FeaturesRoutesEnum.BOLETOS:
        if (_hasRbac(ApplicationRbac.morarBoletos) == false) {
          break;
        }
        return HomeRedirectResult.navigateRoute(
          route: ApplicationRoute.billets,
          arguments: BilletsPageArgs(
            billetsNotificationContext: redirectRoute.objectId,
          ),
        );

      // Documentos
      case FeaturesRoutesEnum.DOCUMENTOS_CIRCULARES:
      case FeaturesRoutesEnum.DOCUMENTOS_EDITAIS:
      case FeaturesRoutesEnum.DOCUMENTOS_ATAS:
      case FeaturesRoutesEnum.DOCUMENTOS_ADVERTENCIAS:
      case FeaturesRoutesEnum.DOCUMENTOS_MULTAS:
        final documentCategoryRbac =
            routesEnum == FeaturesRoutesEnum.DOCUMENTOS_ATAS
                ? ApplicationRbac.morarDocumentosAtas
                : routesEnum == FeaturesRoutesEnum.DOCUMENTOS_EDITAIS
                    ? ApplicationRbac.morarDocumentosEditais
                    : routesEnum == FeaturesRoutesEnum.DOCUMENTOS_CIRCULARES
                        ? ApplicationRbac.morarDocumentosCirculares
                        : ApplicationRbac.morarDocumentosDiversos;
        if (_hasRbac(ApplicationRbac.morarDocumentos) == false ||
            _hasRbac(documentCategoryRbac) == false) {
          break;
        }
        return HomeRedirectResult.navigateRoute(
          route: ApplicationRoute.documents,
          arguments: DocumentsPageArgs(
            documentsNotificationContext: redirectRoute.objectId,
            type: routesEnum,
          ),
        );

      // PPC
      case FeaturesRoutesEnum.PPC_MES_FECHADO:
      case FeaturesRoutesEnum.PPC_DISPONIVEL:
        if (_hasRbac(ApplicationRbac.morarPpc) == false) {
          break;
        }
        return HomeRedirectResult.navigateRoute(
          route: ApplicationRoute.accountability,
          arguments: AccountabilityPageArgs(
            accountabilityNotificationContext: redirectRoute.objectId,
          ),
        );

      // Reservas
      case FeaturesRoutesEnum.RESERVA_MUDANCAS:
      case FeaturesRoutesEnum.RESERVA_AREA:
        if (_hasRbac(ApplicationRbac.morarReservas) == false) {
          break;
        }
        return HomeRedirectResult.navigateRoute(
          route: ApplicationRoute.reserve,
          arguments: ReservationPageArgs(
            reserveNotificationContext: redirectRoute.objectId,
          ),
        );

      // Assembleia
      case FeaturesRoutesEnum.ASSEMBLEIA:
        if (_hasRbac(ApplicationRbac.morarAssembleia) == false) {
          break;
        }
        return HomeRedirectResult.navigateRoute(
          route: ApplicationRoute.digitalMeeting,
          arguments: DigitalMeetingPageArgs(
            digitalMeetingNotificationContext: redirectRoute.objectId,
          ),
        );

      // Notificacoes nao lidas
      case FeaturesRoutesEnum.NOTIFICACOES_NAO_LIDAS:
        return const HomeRedirectResult.openNotifications();

      // Comodidades
      case FeaturesRoutesEnum.COMODIDADES:
      case FeaturesRoutesEnum.COMODIDADES_CATEGORIA:
      case FeaturesRoutesEnum.COMODIDADES_PARCEIRO:
        return const HomeRedirectResult.openComoditiesTab();

      // Ocorrencia
      case FeaturesRoutesEnum.OCORRENCIA_RESPOSTA:
      case FeaturesRoutesEnum.OCORRENCIA_NOVA:
        if (_hasRbac(ApplicationRbac.morarOcorrencias) == false) {
          break;
        }
        return HomeRedirectResult.navigateRoute(
          route: ApplicationRoute.reports,
          arguments: ReportsPageArgs(
            reportNotificationContext: redirectRoute.objectId,
          ),
        );

      // Seguro
      case FeaturesRoutesEnum.SEGUROS:
        if (_hasRbac(ApplicationRbac.morarSeguros) == false) {
          break;
        }
        return HomeRedirectResult.navigateRoute(
          route: ApplicationRoute.insurance,
          arguments: InsurancePageArgs(),
        );

      // Minha Conta
      case FeaturesRoutesEnum.MINHA_CONTA:
        if (_hasRbac(ApplicationRbac.morarPreferenciasMinhaConta) == false) {
          break;
        }
        return HomeRedirectResult.navigateRoute(
          route: ApplicationRoute.myPreferences,
          arguments: InsurancePageArgs(),
        );

      // Troca de Titularidade
      case FeaturesRoutesEnum.TROCA_TITULARIDADE:
        if (_hasRbac(ApplicationRbac.morarAlteracaoTitularidade) == false) {
          break;
        }
        return HomeRedirectResult.navigateRoute(
          route: ApplicationRoute.changeOwnership,
        );

      // Bella
      case FeaturesRoutesEnum.BELLA:
        if (_hasRbac(ApplicationRbac.morarIaBella) == false) {
          break;
        }
        return HomeRedirectResult.navigateRoute(
          route: ApplicationRoute.iaBella,
          arguments: redirectRoute.objectId?.isNotEmpty == true
              ? BellaMessageEntity(text: redirectRoute.objectId!, isUser: true)
              : null,
        );

      default:
        break;
    }

    return const HomeRedirectResult.none();
  }

  bool _hasRbac(String applicationRbac) {
    return sessionBloc.checkRback(applicationRbac);
  }
}
