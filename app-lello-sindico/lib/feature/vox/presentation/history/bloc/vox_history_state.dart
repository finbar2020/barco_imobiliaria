import 'package:essentials/essentials.dart';
import 'package:lello/feature/vox/domain/entity/document.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';

enum VoxHistoryStatus { loading, loaded, empty, failure }

class VoxHistoryState {
  final DocumentType type;
  final VoxHistoryStatus status;
  final List<Document> documents;
  final Failure? error;

  const VoxHistoryState({
    required this.type,
    required this.status,
    this.documents = const [],
    this.error,
  });

  VoxHistoryState copyWith({
    VoxHistoryStatus? status,
    List<Document>? documents,
    Failure? error,
  }) =>
      VoxHistoryState(
        type: type,
        status: status ?? this.status,
        documents: documents ?? this.documents,
        error: error,
      );
}
