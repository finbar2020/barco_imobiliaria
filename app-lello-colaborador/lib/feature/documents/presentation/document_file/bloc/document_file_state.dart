import 'package:colaborador/feature/documents/domain/entity/document_file.dart';
import 'package:essentials/essentials.dart';

abstract class DocumentFileState extends Equatable {
  const DocumentFileState();

  @override
  List<Object?> get props => [];
}

class DocumentFileInitialState extends DocumentFileState {
  const DocumentFileInitialState();
}

class DocumentFileLoadingState extends DocumentFileState {
  const DocumentFileLoadingState();
}

class DocumentFileLoadedState extends DocumentFileState {
  final DocumentFile documentFile;
  const DocumentFileLoadedState(this.documentFile);

  @override
  List<Object?> get props => [documentFile];
}

class DocumentFileFailedState extends DocumentFileState {
  const DocumentFileFailedState();
}
