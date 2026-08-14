import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_features/feature/documents/domain/entity/documents_list_result.dart';
import 'package:shared_features/feature/documents/presentation/bloc/documents_event.dart';
import 'package:shared_features/feature/documents/presentation/bloc/documents_state.dart';

class DocumentsBloc extends Bloc {
  DocumentsBloc() : super(DocumentsEmptyState()) {
    on<DocumentsEmptyEvent>(handleDocumentsEmptyEvent);
    on<DocumentsLoadingEvent>(handleDocumentsLoadingEvent);
    on<DocumentsLoadedEvent>(handleDocumentsLoadedEvent);
    on<DocumentsFailedEvent>(handleDocumentsFailedEvent);
    on<DocumentsFileLoadingEvent>(handleDocumentsFileLoadingEvent);
    on<DocumentsFileLoadedEvent>(handleDocumentsFileLoadedEvent);
    on<DocumentsFileFailedEvent>(handleDocumentsFileFailedEvent);
    on<DocumentsCacheResultEvent>(handleDocumentsCacheResultEvent);
  }

  void handleDocumentsEmptyEvent(DocumentsEmptyEvent event, Emitter emit) {
    emit(DocumentsEmptyState());
  }

  void handleDocumentsLoadingEvent(DocumentsLoadingEvent event, Emitter emit) {
    emit(DocumentsLoadingState());
  }

  void handleDocumentsLoadedEvent(DocumentsLoadedEvent event, Emitter emit) {
    emit(DocumentsLoadedState(documents: event.documents));
  }

  void handleDocumentsFailedEvent(DocumentsFailedEvent event, Emitter emit) {
    emit(DocumentsFailureState(error: event.error));
  }

  void handleDocumentsFileLoadingEvent(
      DocumentsFileLoadingEvent event, Emitter emit) {
    emit(DocumentsFileLoadingState());
  }

  void handleDocumentsFileLoadedEvent(
      DocumentsFileLoadedEvent event, Emitter emit) {
    emit(DocumentsFileLoadedState(file: event.file));
  }

  void handleDocumentsFileFailedEvent(
      DocumentsFileFailedEvent event, Emitter emit) {
    emit(DocumentsFileFailureState(error: event.error));
  }

  void handleDocumentsCacheResultEvent(
      DocumentsCacheResultEvent event, Emitter emit) {
    final r = event.result;
    switch (r.freshness) {
      case DocsFreshness.fresh:
        if (r.docs.isEmpty) {
          emit(DocumentsEmptyState());
        } else {
          emit(DocumentsLoadedState(
            documents: r.docs,
            freshness: DocsFreshness.fresh,
            lastFetchedAt: r.lastFetchedAt,
          ));
        }
        break;
      case DocsFreshness.staleRevalidating:
        emit(DocumentsLoadedState(
          documents: r.docs,
          freshness: DocsFreshness.staleRevalidating,
          lastFetchedAt: r.lastFetchedAt,
        ));
        break;
      case DocsFreshness.staleFailed:
        emit(DocumentsLoadedState(
          documents: r.docs,
          freshness: DocsFreshness.staleFailed,
          lastFetchedAt: r.lastFetchedAt,
        ));
        break;
      case DocsFreshness.coldLoading:
        emit(DocumentsLoadingState());
        break;
      case DocsFreshness.error:
        emit(DocumentsFailureState(error: r.error?.toString() ?? ""));
        break;
    }
  }
}
