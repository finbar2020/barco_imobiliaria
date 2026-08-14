import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:shared_features/feature/documents/presentation/page/documents_menu_item.dart';
import 'package:shared_features/feature/documents/presentation/page/documents_menu_strategy.dart';

/// Estratégia de menu do Síndico: gata cada categoria pelo RBAC por categoria
/// (`sindico.documentos.atas/editais/circulares/diversos`), envolvendo o card
/// no `CircuitBreakerWidget` — que esconde o item quando o RBAC não está
/// habilitado e aplica as regras de circuit breaker.
class SindicoDocumentsMenuStrategy extends DocumentsMenuStrategy {
  final SessionBloc sessionBloc;

  SindicoDocumentsMenuStrategy(this.sessionBloc);

  @override
  List<DocumentsMenuItem> get items => kDefaultDocumentsMenuItems;

  @override
  Widget wrapItem(BuildContext context, DocumentsMenuItem item, Widget card) {
    final rbac = _rbacFor(item.documentType);
    final reference = sessionBloc.state.session?.selectedCondominium?.reference
            .toString() ??
        "";
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
        return ApplicationRbac.sindicoDocumentosAtas;
      case "documents_notices":
        return ApplicationRbac.sindicoDocumentosEditais;
      case "documents_circulars":
        return ApplicationRbac.sindicoDocumentosCirculares;
      case "documents_divers":
        return ApplicationRbac.sindicoDocumentosDiversos;
      default:
        return "";
    }
  }
}
