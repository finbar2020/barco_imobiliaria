import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';
import 'package:lello/feature/vox/domain/use_case/get_document/get_document.dart';
import 'package:lello/feature/vox/presentation/detail/bloc/vox_detail_event.dart';
import 'package:lello/feature/vox/presentation/detail/bloc/vox_detail_state.dart';

/// Bloc do detalhe de um documento. Sempre re-busca por id (Q7).
class VoxDetailBloc extends Bloc<VoxDetailEvent, VoxDetailState> {
  final DocumentType type;
  final String id;
  final GetDocument getDocument;

  VoxDetailBloc({
    required this.type,
    required this.id,
    required this.getDocument,
  }) : super(VoxDetailState(type: type, status: VoxDetailStatus.loading)) {
    on<VoxDetailStartedEvent>(_onLoad);
    add(const VoxDetailStartedEvent());
  }

  Future<void> _onLoad(
      VoxDetailStartedEvent event, Emitter<VoxDetailState> emit) async {
    emit(state.copyWith(status: VoxDetailStatus.loading));

    final result = await getDocument(GetDocumentParam(type: type, id: id));

    emit(result.fold(
      (err) => state.copyWith(status: VoxDetailStatus.failure, error: err),
      (data) => state.copyWith(status: VoxDetailStatus.loaded, detail: data),
    ));
  }
}
