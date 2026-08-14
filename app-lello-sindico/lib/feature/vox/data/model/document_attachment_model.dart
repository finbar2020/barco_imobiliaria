import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/vox/domain/entity/document_attachment.dart';

part 'document_attachment_model.g.dart';

/// Model único de anexo (unifica os três models idênticos antigos).
///
/// O fio carrega o conteúdo em Base64; a entidade carrega bytes crus. A
/// conversão acontece aqui, na camada data (item B5).
@JsonSerializable(fieldRename: FieldRename.snake)
class DocumentAttachmentModel {
  String? type;

  /// Conteúdo em Base64 (formato de fio).
  String? content;

  String? name;

  DocumentAttachmentModel({this.type, this.content, this.name});

  factory DocumentAttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentAttachmentModelFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentAttachmentModelToJson(this);

  static DocumentAttachmentModel? fromEntity(DocumentAttachment? entity) =>
      entity == null
          ? null
          : DocumentAttachmentModel(
              type: entity.type,
              content:
                  entity.bytes == null ? null : base64Encode(entity.bytes!),
              name: entity.name,
            );

  DocumentAttachment toEntity() => DocumentAttachment(
        type: type,
        bytes: content == null ? null : base64Decode(content!),
        name: name,
      );
}
