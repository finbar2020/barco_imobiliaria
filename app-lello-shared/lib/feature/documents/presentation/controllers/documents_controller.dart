import 'dart:async';

import 'package:shared_features/shared_features.dart';
import 'package:shared_features/feature/documents/domain/entity/document_file.dart';
import 'package:shared_features/feature/documents/domain/entity/documents.dart';
import 'package:shared_features/feature/documents/domain/entity/documents_list_result.dart';
import 'package:shared_features/feature/documents/domain/entity/documents_type.dart';
import 'package:shared_features/feature/documents/domain/repository/documents_repository.dart';
import 'package:shared_features/feature/documents/domain/use_case/download_document/download_document.dart';
import 'package:shared_features/feature/documents/domain/use_case/get_extracted_text/get_extracted_text.dart';
import 'package:shared_features/feature/documents/presentation/bloc/documents_bloc.dart';
import 'package:shared_features/feature/documents/presentation/bloc/documents_event.dart';
import 'package:shared_features/feature/documents/presentation/controllers/documents_analytics.dart';

class DocumentsController {
  final DocumentsBloc bloc;
  final DocumentsRepository repository;
  final DownloadDocument downloadDocument;
  final GetExtractedText getExtractedText;

  /// Sessão compartilhada. `unitId` vazio (síndico) faz a listagem cair no
  /// escopo do condomínio; preenchido (morador) lista a unidade.
  final SharedSession session;

  /// Estratégia de analytics injetada pelo app.
  final DocumentsAnalytics analytics;

  StreamSubscription<DocsListResult>? _listSubscription;
  String? _currentType;

  DocumentsController({
    required this.bloc,
    required this.repository,
    required this.downloadDocument,
    required this.getExtractedText,
    required this.session,
    this.analytics = const NoopDocumentsAnalytics(),
  });

  Future<void> getDocs(String documentType,
      {bool forceRefresh = false}) async {
    await _listSubscription?.cancel();
    _currentType = documentType;

    final stream = repository.watch(
      session.condominiumId,
      documentTypeToApiNumber(documentType),
      session.unitId,
      forceRefresh: forceRefresh,
    );

    var loggedThisRun = false;
    _listSubscription = stream.listen((result) {
      if (!loggedThisRun &&
          result.freshness == DocsFreshness.fresh &&
          result.docs.isNotEmpty) {
        analytics.logAccess(documentType);
        loggedThisRun = true;
      }
      bloc.add(DocumentsCacheResultEvent(result));
    });
  }

  Future<void> refresh() async {
    final type = _currentType;
    if (type == null) return;
    await getDocs(type, forceRefresh: true);
  }

  Future<void> getFile(Documents document, String documentType) async {
    bloc.add(DocumentsFileLoadingEvent());

    final response = await downloadDocument.call(
      DownloadDocumentParam(
          documentId: document.id!, documentType: documentType),
    );

    response.fold(
      (error) => bloc.add(DocumentsFileFailedEvent(error: "")),
      (file) {
        bloc.add(DocumentsFileLoadedEvent(
          file: DocumentFile(
            id: document.id,
            name: document.name,
            documentName: document.name,
            localFile: file,
            loadExtractedText: () async {
              final r = await getExtractedText.call(GetExtractedTextParam(
                  documentId: document.id!, documentType: documentType));
              return r.fold((_) => null, (text) => text);
            },
          ),
        ));
      },
    );
  }

  Future<void> dispose() async {
    await _listSubscription?.cancel();
    _listSubscription = null;
  }
}
