import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/vox/domain/entity/document_mode.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';
import 'package:lello/feature/vox/presentation/detail/bloc/vox_detail_bloc.dart';
import 'package:lello/feature/vox/presentation/detail/page/vox_detail_page.dart';
import 'package:lello/feature/vox/presentation/history/bloc/vox_history_bloc.dart';
import 'package:lello/feature/vox/presentation/history/page/vox_history_page.dart';
import 'package:lello/feature/vox/presentation/request/bloc/vox_request_bloc.dart';
import 'package:lello/feature/vox/presentation/request/page/vox_request_page.dart';

/// Monta as páginas do fluxo Vox já embrulhadas no `BlocProvider`, resolvendo os
/// use cases do DI. Centraliza a navegação por push (as sub-páginas não usam
/// rotas nomeadas — só as entradas warningsAndFines/announcementsMenu são).
class VoxNavigator {
  static T _resolve<T extends Object>() =>
      ApplicationContainer.instance().resolve<T>();

  /// Wizard de solicitação/criação parametrizado por (tipo, modo).
  static Widget wizard(DocumentType type, DocumentMode mode) {
    return BlocProvider(
      create: (_) => VoxRequestBloc(
        type: type,
        mode: mode,
        sessionBloc: _resolve(),
        requestDocument: _resolve(),
        createDocument: _resolve(),
        listDocumentReasons: _resolve(),
        listDocumentTemplates: _resolve(),
        historyCache: _resolve(),
        reasonsCache: _resolve(),
        templatesCache: _resolve(),
      ),
      child: const VoxRequestPage(),
    );
  }

  /// Histórico do tipo; o tap abre o detalhe.
  static Widget history(DocumentType type) {
    return BlocProvider(
      create: (_) => VoxHistoryBloc(
        type: type,
        sessionBloc: _resolve(),
        listDocuments: _resolve(),
        cache: _resolve(),
      ),
      child: VoxHistoryPage(
        onOpenDocument: (context, document) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => detail(type, document.id ?? ""),
          ));
        },
      ),
    );
  }

  /// Detalhe por id (Q7: sempre re-busca).
  static Widget detail(DocumentType type, String id) {
    return BlocProvider(
      create: (_) => VoxDetailBloc(
        type: type,
        id: id,
        getDocument: _resolve(),
      ),
      child: const VoxDetailPage(),
    );
  }

  static void openHistory(BuildContext context, DocumentType type) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => history(type)));
  }

  static void openWizard(
      BuildContext context, DocumentType type, DocumentMode mode) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => wizard(type, mode)));
  }
}
