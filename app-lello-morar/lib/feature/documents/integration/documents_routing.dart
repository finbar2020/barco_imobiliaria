import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/feature/documents/integration/morar_documents_menu_strategy.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/documents/presentation/controllers/documents_controller.dart';
import 'package:shared_features/feature/documents/presentation/page/documents_page.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';

/// Argumentos de deep-link para a página de documentos (notificação → tipo).
/// Mantido como contrato de entrada do app; resolvido em `initialType` /
/// `notificationContext` da página compartilhada.
class DocumentsPageArgs {
  String? documentsNotificationContext;
  FeaturesRoutesEnum? type;
  DocumentsPageArgs({this.documentsNotificationContext, this.type});
}

String? _typeForFeatureRoute(FeaturesRoutesEnum? type) {
  switch (type) {
    case FeaturesRoutesEnum.DOCUMENTOS_CIRCULARES:
      return "documents_circulars";
    case FeaturesRoutesEnum.DOCUMENTOS_EDITAIS:
      return "documents_notices";
    case FeaturesRoutesEnum.DOCUMENTOS_ATAS:
      return "documents_minutes";
    case FeaturesRoutesEnum.DOCUMENTOS_ADVERTENCIAS:
    case FeaturesRoutesEnum.DOCUMENTOS_MULTAS:
      return "documents_divers";
    default:
      return null;
  }
}

/// Constrói a página-menu compartilhada de documentos para o Morar, injetando
/// controller (DI), estratégia de menu com RBAC, subtítulo (condomínio +
/// unidade) e o deep-link resolvido dos argumentos de rota.
Widget buildMorarDocumentsPage(BuildContext context) {
  final args =
      ModalRoute.of(context)?.settings.arguments as DocumentsPageArgs?;
  final sessionBloc = BlocProvider.of<SessionBloc>(context);
  final controller =
      ApplicationContainer.instance().resolve<DocumentsController>();
  final session = sessionBloc.state.session;
  final subtitle =
      '${session?.condominium?.name ?? ''} - ${session?.unity?.title ?? ''}';

  return DocumentsPage(
    controller: controller,
    strategy: MorarDocumentsMenuStrategy(sessionBloc),
    subtitle: subtitle,
    initialType: _typeForFeatureRoute(args?.type),
    notificationContext: args?.documentsNotificationContext,
  );
}
