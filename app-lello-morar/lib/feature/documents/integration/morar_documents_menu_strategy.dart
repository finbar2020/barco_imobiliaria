import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:shared_features/feature/documents/presentation/page/documents_menu_item.dart';
import 'package:shared_features/feature/documents/presentation/page/documents_menu_strategy.dart';

/// Estratégia de menu do Morar: gata cada categoria pelo RBAC do morador,
/// envolvendo o card no `CircuitBreakerWidget` (que esconde o item quando o
/// RBAC não está habilitado).
class MorarDocumentsMenuStrategy extends DocumentsMenuStrategy {
  final SessionBloc sessionBloc;

  MorarDocumentsMenuStrategy(this.sessionBloc);

  @override
  List<DocumentsMenuItem> get items => kDefaultDocumentsMenuItems;

  @override
  Widget wrapItem(BuildContext context, DocumentsMenuItem item, Widget card) {
    final rbac = _rbacFor(item.documentType);
    final reference =
        sessionBloc.state.session?.condominium?.reference?.toString() ?? "";
    return CircuitBreakerWidget(
      appContainer: ApplicationContainer.instance(),
      reference: reference,
      applicationRbac: rbac,
      rbacEnabled: sessionBloc.checkRback(rbac),
      child: card,
    );
  }

  String _rbacFor(String documentType) {
    switch (documentType) {
      case "documents_minutes":
        return ApplicationRbac.morarDocumentosAtas;
      case "documents_notices":
        return ApplicationRbac.morarDocumentosEditais;
      case "documents_divers":
        return ApplicationRbac.morarDocumentosDiversos;
      case "documents_circulars":
        return ApplicationRbac.morarDocumentosCirculares;
      default:
        return "";
    }
  }
}
