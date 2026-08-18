import 'dart:io';

import 'package:lello/feature/vox/domain/entity/attachment_kind.dart';
import 'package:lello/feature/vox/domain/entity/document_step.dart';

abstract class VoxRequestEvent {}

/// Inicializa o fluxo: carrega motivos/templates (quando o tipo tem) e dispara
/// o analytics de acesso.
class VoxStarted extends VoxRequestEvent {}

/// Navega para um passo do wizard.
class VoxStepRequested extends VoxRequestEvent {
  final DocumentStep step;
  VoxStepRequested(this.step);
}

/// Adiciona arquivos PDF (já escolhidos pela UI).
class VoxFilesAttached extends VoxRequestEvent {
  final List<File> files;
  VoxFilesAttached(this.files);
}

/// Adiciona uma imagem (já escolhida/cropada pela UI).
class VoxImageAttached extends VoxRequestEvent {
  final File image;
  VoxImageAttached(this.image);
}

/// Remove um anexo (arquivo ou imagem) por índice.
class VoxAttachmentRemoved extends VoxRequestEvent {
  final AttachmentKind kind;
  final int index;
  VoxAttachmentRemoved(this.kind, this.index);
}

/// Disparado quando um campo do formulário muda — força o rebuild para
/// reavaliar a habilitação do botão "Avançar" (a `request` é mutável).
class VoxFieldChanged extends VoxRequestEvent {}

/// Envia a solicitação.
class VoxSubmitted extends VoxRequestEvent {}
