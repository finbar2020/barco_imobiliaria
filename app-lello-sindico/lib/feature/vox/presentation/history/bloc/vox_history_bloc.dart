import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/vox/domain/entity/document.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';
import 'package:lello/feature/vox/domain/use_case/list_documents/list_documents.dart';
import 'package:lello/feature/vox/presentation/history/bloc/vox_history_event.dart';
import 'package:lello/feature/vox/presentation/history/bloc/vox_history_state.dart';
import 'package:lello/feature/vox/presentation/history/vox_history_cache.dart';

/// Bloc do histórico de documentos, parametrizado por [DocumentType]. Usa o
/// [VoxHistoryCache] (TTL 1h) na carga inicial; o pull-to-refresh força a
/// recarga, invalidando o cache.
class VoxHistoryBloc extends Bloc<VoxHistoryEvent, VoxHistoryState> {
  final DocumentType type;
  final SessionBloc sessionBloc;
  final ListDocuments listDocuments;
  final VoxHistoryCache cache;

  VoxHistoryBloc({
    required this.type,
    required this.sessionBloc,
    required this.listDocuments,
    required this.cache,
  }) : super(VoxHistoryState(type: type, status: VoxHistoryStatus.loading)) {
    on<VoxHistoryStartedEvent>(_onStarted);
    on<VoxHistoryRefreshedEvent>(_onRefreshed);
    add(const VoxHistoryStartedEvent());
  }

  String get _condominiumId =>
      sessionBloc.state.session?.selectedCondominium?.id ?? "";

  /// Carga inicial: serve do cache se ainda válido; senão busca e armazena.
  Future<void> _onStarted(
      VoxHistoryStartedEvent event, Emitter<VoxHistoryState> emit) async {
    final condominiumId = _condominiumId;
    final cached = cache.get(type, condominiumId);
    if (cached != null) {
      emit(_loaded(cached));
      return;
    }
    emit(state.copyWith(status: VoxHistoryStatus.loading));
    await _fetch(emit, condominiumId);
  }

  /// Pull-to-refresh / retry: ignora o cache e rebusca (mantém a lista visível,
  /// sem loading full-screen, pois o RefreshIndicator já indica o progresso).
  Future<void> _onRefreshed(
      VoxHistoryRefreshedEvent event, Emitter<VoxHistoryState> emit) async {
    final condominiumId = _condominiumId;
    cache.invalidate(type, condominiumId);
    await _fetch(emit, condominiumId);
  }

  Future<void> _fetch(
      Emitter<VoxHistoryState> emit, String condominiumId) async {
    final result = await listDocuments(
        ListDocumentsParam(type: type, condominiumId: condominiumId));

    emit(result.fold(
      (err) => state.copyWith(status: VoxHistoryStatus.failure, error: err),
      (data) {
        cache.put(type, condominiumId, data);
        return _loaded(data);
      },
    ));
  }

  VoxHistoryState _loaded(List<Document> documents) => documents.isEmpty
      ? state.copyWith(status: VoxHistoryStatus.empty, documents: documents)
      : state.copyWith(status: VoxHistoryStatus.loaded, documents: documents);
}
