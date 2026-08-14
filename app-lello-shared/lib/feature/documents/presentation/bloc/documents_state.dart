import 'package:shared_features/feature/documents/domain/entity/document_file.dart';
import 'package:shared_features/feature/documents/domain/entity/documents.dart';
import 'package:shared_features/feature/documents/domain/entity/documents_list_result.dart';

abstract class DocumentsState {
  List<Documents> documents = [];
  DocumentFile? file;
}

class DocumentsEmptyState extends DocumentsState {}

class DocumentsLoadingState extends DocumentsState {}

class DocumentsLoadedState extends DocumentsState {
  @override
  List<Documents> documents;
  final DocsFreshness freshness;
  final DateTime? lastFetchedAt;

  DocumentsLoadedState({
    required this.documents,
    this.freshness = DocsFreshness.fresh,
    this.lastFetchedAt,
  });
}

class DocumentsFileLoadingState extends DocumentsState {}

class DocumentsFileLoadedState extends DocumentsState {
  final DocumentFile file;
  DocumentsFileLoadedState({
    required this.file,
  });
}

class DocumentsFileFailureState extends DocumentsState {
  final String error;
  DocumentsFileFailureState({required this.error}) : super();
}

class DocumentsFailureState extends DocumentsState {
  final String error;

  DocumentsFailureState({required this.error}) : super();
}

/// Conjunto de states que afetam a tela de listagem. Usar em `buildWhen` pra
/// evitar que a lista reaja a eventos do fluxo de arquivo (detalhe).
bool isListAffectingState(DocumentsState state) {
  return state is DocumentsEmptyState ||
      state is DocumentsLoadingState ||
      state is DocumentsLoadedState ||
      state is DocumentsFailureState;
}

/// Conjunto de states que afetam a tela de detalhe (download de arquivo).
bool isFileAffectingState(DocumentsState state) {
  return state is DocumentsFileLoadingState ||
      state is DocumentsFileLoadedState ||
      state is DocumentsFileFailureState;
}
