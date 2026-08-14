import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/vox/domain/entity/attachment_kind.dart';
import 'package:lello/feature/vox/domain/entity/document_step.dart';

abstract class VoxRequestEvent extends Equatable {
  const VoxRequestEvent();

  @override
  List<Object?> get props => [];
}

/// Inicializa o fluxo: carrega motivos/templates (quando o tipo tem) e dispara
/// o analytics de acesso.
class VoxStartedEvent extends VoxRequestEvent {
  const VoxStartedEvent();
}

/// Navega para um passo do wizard.
class VoxStepRequestedEvent extends VoxRequestEvent {
  final DocumentStep step;

  const VoxStepRequestedEvent(this.step);

  @override
  List<Object?> get props => [step];
}

/// Adiciona arquivos PDF (já escolhidos pela UI).
class VoxFilesAttachedEvent extends VoxRequestEvent {
  final List<File> files;

  const VoxFilesAttachedEvent(this.files);

  @override
  List<Object?> get props => [files];
}

/// Adiciona uma imagem (já escolhida/cropada pela UI).
class VoxImageAttachedEvent extends VoxRequestEvent {
  final File image;

  const VoxImageAttachedEvent(this.image);

  @override
  List<Object?> get props => [image];
}

/// Remove um anexo (arquivo ou imagem) por índice.
class VoxAttachmentRemovedEvent extends VoxRequestEvent {
  final AttachmentKind kind;
  final int index;

  const VoxAttachmentRemovedEvent(this.kind, this.index);

  @override
  List<Object?> get props => [kind, index];
}

/// Disparado quando um campo do formulário muda — força o rebuild para
/// reavaliar a habilitação do botão "Avançar" (a `request` é mutável).
class VoxFieldChangedEvent extends VoxRequestEvent {
  const VoxFieldChangedEvent();
}

/// Envia a solicitação.
class VoxSubmittedEvent extends VoxRequestEvent {
  const VoxSubmittedEvent();
}
