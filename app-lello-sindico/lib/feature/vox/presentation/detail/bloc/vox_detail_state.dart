import 'package:essentials/essentials.dart';
import 'package:lello/feature/vox/domain/entity/document_detail.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';

enum VoxDetailStatus { loading, loaded, failure }

class VoxDetailState {
  final DocumentType type;
  final VoxDetailStatus status;
  final DocumentDetail? detail;
  final Failure? error;

  const VoxDetailState({
    required this.type,
    required this.status,
    this.detail,
    this.error,
  });

  VoxDetailState copyWith({
    VoxDetailStatus? status,
    DocumentDetail? detail,
    Failure? error,
  }) =>
      VoxDetailState(
        type: type,
        status: status ?? this.status,
        detail: detail ?? this.detail,
        error: error,
      );
}
