import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/vox/domain/entity/document_reason.dart';
import 'package:lello/feature/vox/domain/entity/document_request.dart';
import 'package:lello/feature/vox/domain/entity/document_step.dart';
import 'package:lello/feature/vox/domain/entity/document_template.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';

enum VoxRequestStatus { loading, ready, submitting, success, failure }

/// Estado único do wizard de solicitação. Todo o form vive aqui (Q2): a
/// `request` (mutável, editada pela UI), listas de motivos/templates, anexos
/// escolhidos e o passo atual.
class VoxRequestState {
  final DocumentType type;
  final VoxRequestStatus status;
  final DocumentRequest request;
  final List<DocumentReason> reasons;
  final List<DocumentTemplate> templates;
  final List<File> files;
  final List<File> images;
  final DocumentStep step;
  final Failure? error;

  const VoxRequestState({
    required this.type,
    required this.status,
    required this.request,
    required this.reasons,
    required this.templates,
    required this.files,
    required this.images,
    required this.step,
    this.error,
  });

  factory VoxRequestState.initial(DocumentType type) => VoxRequestState(
        type: type,
        status: VoxRequestStatus.loading,
        request: DocumentRequest(),
        reasons: const [],
        templates: const [],
        files: const [],
        images: const [],
        step: DocumentStep.data,
      );

  VoxRequestState copyWith({
    VoxRequestStatus? status,
    DocumentRequest? request,
    List<DocumentReason>? reasons,
    List<DocumentTemplate>? templates,
    List<File>? files,
    List<File>? images,
    DocumentStep? step,
    Failure? error,
  }) =>
      VoxRequestState(
        type: type,
        status: status ?? this.status,
        request: request ?? this.request,
        reasons: reasons ?? this.reasons,
        templates: templates ?? this.templates,
        files: files ?? this.files,
        images: images ?? this.images,
        step: step ?? this.step,
        // error não é preservado entre transições; só vale no estado de falha.
        error: error,
      );
}
