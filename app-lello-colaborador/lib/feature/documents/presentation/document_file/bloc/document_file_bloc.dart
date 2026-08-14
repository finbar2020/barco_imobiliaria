import 'package:colaborador/feature/documents/domain/use_case/get_document_file/get_document_file.dart';
import 'package:colaborador/feature/documents/presentation/document_file/bloc/document_file_event.dart';
import 'package:colaborador/feature/documents/presentation/document_file/bloc/document_file_state.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DocumentFileBloc extends Bloc<DocumentFileEvent, DocumentFileState> {
  final GetDocumentFileUseCase getDocumentFileUseCase;
  final SessionBloc sessionBloc;

  DocumentFileBloc({
    required this.getDocumentFileUseCase,
    required this.sessionBloc,
  }) : super(const DocumentFileInitialState()) {
    on<GetDocumentFileEvent>(_mapGetDocumentFile);
  }

  void getDocumentFile({required String documentName}) {
    add(GetDocumentFileEvent(documentName: documentName));
  }

  Future<void> _mapGetDocumentFile(
    GetDocumentFileEvent event,
    Emitter<DocumentFileState> emit,
  ) async {
    emit(const DocumentFileLoadingState());

    final result = await getDocumentFileUseCase
        .call(GetDocumentFileParam(documentName: event.documentName));

    DocumentFileState response = result.fold(
      (error) {
        return const DocumentFileFailedState();
      },
      (res) => DocumentFileLoadedState(res),
    );

    emit(response);
  }
}
