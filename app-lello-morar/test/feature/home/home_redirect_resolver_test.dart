import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_page.dart';
import 'package:morar/feature/accountability/presentation/page/accountability_page.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_page.dart';
import 'package:morar/feature/billets/presentation/pages/billets_page.dart';
import 'package:morar/feature/digital_meeting/presentation/page/digital_meeting_page.dart';
import 'package:morar/feature/documents/integration/documents_routing.dart';
import 'package:morar/feature/home/presentation/controllers/home_navigation_redirect_resolver.dart';
import 'package:morar/feature/ia_bella/domain/entity/bella_message_entity.dart';
import 'package:morar/feature/insurance/presentation/pages/insurance_page.dart';
import 'package:morar/feature/mailing/presentation/page/mailing_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_page.dart';
import 'package:morar/feature/reservation/presentation/page/reservation_page.dart';
import 'package:morar/feature/sub_user/presentation/pages/sub_user_page.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/fixtures.dart';

SharedApplicationRedirectRoute _route(FeaturesRoutesEnum route, {String? objectId = 'obj'}) =>
    SharedApplicationRedirectRoute(
      rote: enumToString(route)!,
      context: 'ctx',
      notificationId: 'n1',
      objectId: objectId,
    );

void main() {
  late FakeSessionBloc sessionBloc;
  late HomeNavigationRedirectResolver resolver;

  setUp(() {
    sessionBloc = FakeSessionBloc();
    resolver = HomeNavigationRedirectResolver(sessionBloc: sessionBloc, isGeneric: true);
  });

  test('rotas com rbac liberado navegam com argumentos', () {
    final cases = <FeaturesRoutesEnum, (String, Type)>{
      FeaturesRoutesEnum.ACORDO_PROPOSTA: (ApplicationRoute.agreements, AgreementsPageArgs),
      FeaturesRoutesEnum.ACORDOS_COTA_58: (ApplicationRoute.agreements, AgreementsPageArgs),
      FeaturesRoutesEnum.CORRESPONDENCIAS_ENTRADA: (ApplicationRoute.mailing, MailingPageArgs),
      FeaturesRoutesEnum.ENTRADA_LIBERACAO: (ApplicationRoute.accessControl, AcessControlPageArgs),
      FeaturesRoutesEnum.MORADORES_ACESSOU: (ApplicationRoute.subUser, SubUserPageArgs),
      FeaturesRoutesEnum.BOLETOS: (ApplicationRoute.billets, BilletsPageArgs),
      FeaturesRoutesEnum.DOCUMENTOS_ATAS: (ApplicationRoute.documents, DocumentsPageArgs),
      FeaturesRoutesEnum.DOCUMENTOS_EDITAIS: (ApplicationRoute.documents, DocumentsPageArgs),
      FeaturesRoutesEnum.DOCUMENTOS_CIRCULARES: (ApplicationRoute.documents, DocumentsPageArgs),
      FeaturesRoutesEnum.DOCUMENTOS_MULTAS: (ApplicationRoute.documents, DocumentsPageArgs),
      FeaturesRoutesEnum.PPC_DISPONIVEL: (ApplicationRoute.accountability, AccountabilityPageArgs),
      FeaturesRoutesEnum.RESERVA_AREA: (ApplicationRoute.reserve, ReservationPageArgs),
      FeaturesRoutesEnum.ASSEMBLEIA: (ApplicationRoute.digitalMeeting, DigitalMeetingPageArgs),
      FeaturesRoutesEnum.OCORRENCIA_NOVA: (ApplicationRoute.reports, ReportsPageArgs),
      FeaturesRoutesEnum.SEGUROS: (ApplicationRoute.insurance, InsurancePageArgs),
      FeaturesRoutesEnum.MINHA_CONTA: (ApplicationRoute.myPreferences, InsurancePageArgs),
      FeaturesRoutesEnum.BELLA: (ApplicationRoute.iaBella, BellaMessageEntity),
    };
    cases.forEach((route, expected) {
      final result = resolver.resolve(_route(route));
      expect(result.action, HomeRedirectAction.navigateRoute, reason: '$route');
      expect(result.route, expected.$1, reason: '$route');
      expect(result.arguments.runtimeType, expected.$2, reason: '$route');
    });

    final ownership = resolver.resolve(_route(FeaturesRoutesEnum.TROCA_TITULARIDADE));
    expect(ownership.route, ApplicationRoute.changeOwnership);
    expect(ownership.arguments, isNull);

    final access = resolver.resolve(_route(FeaturesRoutesEnum.ENTRADA_LIBERACAO));
    expect((access.arguments as AcessControlPageArgs).isGeneric, isTrue);
    final docs = resolver.resolve(_route(FeaturesRoutesEnum.DOCUMENTOS_ATAS));
    expect((docs.arguments as DocumentsPageArgs).type, FeaturesRoutesEnum.DOCUMENTOS_ATAS);
    final bella = resolver.resolve(_route(FeaturesRoutesEnum.BELLA));
    expect((bella.arguments as BellaMessageEntity).text, 'obj');
    expect(resolver.resolve(_route(FeaturesRoutesEnum.BELLA, objectId: '')).arguments, isNull);
  });

  test('ações especiais', () {
    expect(resolver.resolve(_route(FeaturesRoutesEnum.NOTIFICACOES_NAO_LIDAS)).action,
        HomeRedirectAction.openNotifications);
    expect(resolver.resolve(_route(FeaturesRoutesEnum.COMODIDADES_PARCEIRO)).action,
        HomeRedirectAction.openComoditiesTab);
    expect(resolver.resolve(_route(FeaturesRoutesEnum.ESPELHO_PONTO)).action,
        HomeRedirectAction.none);
    final unknown = resolver.resolve(SharedApplicationRedirectRoute(
      rote: 'NAO_EXISTE',
      context: null,
      notificationId: null,
    ));
    expect(unknown.action, HomeRedirectAction.none);
    expect(unknown.route, isNull);
  });

  test('sem rbac nada acontece', () {
    sessionBloc.rbacAllowed = false;
    for (final route in [
      FeaturesRoutesEnum.ACORDO_PROPOSTA,
      FeaturesRoutesEnum.CORRESPONDENCIAS_RETIRADA,
      FeaturesRoutesEnum.ENTRADA_AUTORIZACAO_VISITANTE_NOVO,
      FeaturesRoutesEnum.MORADORES_ACESSOU,
      FeaturesRoutesEnum.BOLETOS,
      FeaturesRoutesEnum.DOCUMENTOS_ADVERTENCIAS,
      FeaturesRoutesEnum.PPC_MES_FECHADO,
      FeaturesRoutesEnum.RESERVA_MUDANCAS,
      FeaturesRoutesEnum.ASSEMBLEIA,
      FeaturesRoutesEnum.OCORRENCIA_RESPOSTA,
      FeaturesRoutesEnum.SEGUROS,
      FeaturesRoutesEnum.MINHA_CONTA,
      FeaturesRoutesEnum.TROCA_TITULARIDADE,
      FeaturesRoutesEnum.BELLA,
    ]) {
      expect(resolver.resolve(_route(route)).action, HomeRedirectAction.none,
          reason: '$route');
    }
    expect(sessionBloc.rbacChecked, contains(ApplicationRbac.morarAcordos));
  });

  test('documentos exigem o rbac da categoria', () {
    sessionBloc.allowedRbacs = {ApplicationRbac.morarDocumentos};
    expect(resolver.resolve(_route(FeaturesRoutesEnum.DOCUMENTOS_ATAS)).action,
        HomeRedirectAction.none);
    sessionBloc.allowedRbacs = {
      ApplicationRbac.morarDocumentos,
      ApplicationRbac.morarDocumentosDiversos,
    };
    expect(resolver.resolve(_route(FeaturesRoutesEnum.DOCUMENTOS_MULTAS)).action,
        HomeRedirectAction.navigateRoute);
    expect(resolver.resolve(_route(FeaturesRoutesEnum.DOCUMENTOS_EDITAIS)).action,
        HomeRedirectAction.none);
  });

  test('HomeRedirectResult', () {
    const none = HomeRedirectResult.none();
    expect(none.action, HomeRedirectAction.none);
    expect(none.route, isNull);
    const nav = HomeRedirectResult.navigateRoute(route: '/x', arguments: 1);
    expect(nav.arguments, 1);
    expect(const HomeRedirectResult.openNotifications().action,
        HomeRedirectAction.openNotifications);
  });
}
