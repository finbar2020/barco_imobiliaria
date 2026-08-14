import 'package:lello/feature/vox/domain/entity/document_attachment.dart';
import 'package:lello/feature/vox/domain/entity/recipient_type.dart';

/// Payload unificado de solicitação/criação de documento.
///
/// Núcleo compartilhado das três features antigas (`WarningsRequest`,
/// `FinesRequest`, `AnnouncementsRequest`), que eram ~90% idênticas.
///
/// Notas de modelagem (branch melhorias-vox / item B):
///   * Nomes limpos no domínio. O typo histórico do fio (`flag_overrride`) e a
///     divergência de tipo de `single_copies_quantity` ficam escondidos na
///     camada data, atrás de `@JsonKey` (item B5 / Q5).
///   * [content] na *criação* é HTML (editor rico) e o Base64 é aplicado no
///     create model; na *solicitação* é texto literal e trafega sem Base64,
///     com o título embutido no conteúdo (`composeRequestContent`) — fiel ao
///     contrato antigo (item B5).
///   * [recipientType] é tipado via enum (item B4).
///   * Campos só relevantes a alguns tipos (`reason`, `model`, `value`,
///     `occurrenceDate`) são opcionais — o `DocumentType` declara quais valem.
class DocumentRequest {
  String? id;
  String? userId;
  String? condominiumId;
  String? unityId;

  /// Conteúdo do documento. Na *criação* é HTML (editor rico); na *solicitação*
  /// é texto literal multilinha (`\n` reais). Sempre sem Base64 aqui.
  String? content;

  String? block;

  /// Motivo (advertência/multa) — descrição legível.
  String? reason;

  /// Id do motivo selecionado (advertência/multa). Vai no fio da criação como
  /// `reason_id`; a descrição segue em [reason].
  String? reasonId;

  /// Id do template/modelo (advertência/multa).
  String? model;

  /// Valor da multa.
  String? value;

  /// Data de ocorrência (advertência/multa).
  DateTime? occurrenceDate;

  List<String> recipientList;

  /// Mapa unidade→nome dos destinatários (apenas presentation; não vai no fio).
  Map<String, String> recipientListMap;

  RecipientType? recipientType;

  bool? flagEmailDistribution;
  bool? flagPrintDistribution;
  bool? flagOverride;
  bool? flagEmailBodyAttachment;

  int? singleCopiesQuantity;

  List<DocumentAttachment> attachments;

  /// Título (multa/comunicado). Marcado como não utilizado no código antigo;
  /// preservado por compatibilidade.
  String? title;

  DocumentRequest({
    this.id,
    this.userId,
    this.condominiumId,
    this.unityId,
    this.content,
    this.block,
    this.reason,
    this.reasonId,
    this.model,
    this.value,
    this.occurrenceDate,
    this.recipientList = const [],
    Map<String, String>? recipientListMap,
    this.recipientType,
    this.flagEmailDistribution = true,
    this.flagPrintDistribution,
    this.flagOverride,
    this.flagEmailBodyAttachment,
    this.singleCopiesQuantity,
    this.attachments = const [],
    this.title,
  }) : recipientListMap = recipientListMap ?? <String, String>{};

  /// Rótulo legível dos destinatários (substitui `recipientsListString()`).
  ///
  /// Usa as CHAVES do `recipientListMap` (`group|title`) para as unidades — o
  /// valor agora guarda o id no fio, não o rótulo. Blocos têm chave = nome.
  String recipientsLabel() {
    switch (recipientType) {
      case RecipientType.all:
        return "TODOS";
      case RecipientType.block:
        return "Blocos: " + recipientListMap.keys.join(", ");
      case RecipientType.units:
        final labels = recipientListMap.keys.map(_unitKeyLabel).join(", ");
        return "Unidades: " + labels;
      case null:
        return "";
    }
  }

  /// Converte a chave de unidade (`group|title`) no rótulo exibível
  /// (`group - title`).
  String _unitKeyLabel(String key) =>
      key.split('|').where((e) => e.isNotEmpty).join(' - ');
}
