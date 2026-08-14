import 'package:shared_features/feature/documents/domain/entity/document_file.dart';
import 'package:shared_features/feature/documents/domain/entity/documents.dart';
import 'package:shared_features/feature/documents/domain/entity/documents_list_result.dart';

abstract class DocumentsEvent {}

class DocumentsLoadingEvent extends DocumentsEvent {}

class DocumentsEmptyEvent extends DocumentsEvent {}

class DocumentsLoadedEvent extends DocumentsEvent {
  final List<Documents> documents;
  DocumentsLoadedEvent({required this.documents});
}

class DocumentsFailedEvent extends DocumentsEvent {
  final String error;

  DocumentsFailedEvent({required this.error});
}

class DocumentsFileLoadingEvent extends DocumentsEvent {}

class DocumentsFileLoadedEvent extends DocumentsEvent {
  final DocumentFile file;
  DocumentsFileLoadedEvent({
    required this.file,
  });
}

class DocumentsFileFailedEvent extends DocumentsEvent {
  final String error;

  DocumentsFileFailedEvent({required this.error});
}

/// Emitido pelo controller para cada result emitido pelo stream SWR do
/// repository (cache imediato, revalidação concluída, falha, etc.).
class DocumentsCacheResultEvent extends DocumentsEvent {
  final DocsListResult result;
  DocumentsCacheResultEvent(this.result);
}
