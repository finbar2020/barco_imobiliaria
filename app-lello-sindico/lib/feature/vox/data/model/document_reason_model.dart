import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/vox/domain/entity/document_reason.dart';

part 'document_reason_model.g.dart';

/// Model único de motivo (unifica `WarningReasonsModel` e `FinesReasonsModel`,
/// que eram idênticos). Serve aos endpoints /warnings/{id}/reasons e
/// /fines/{id}/reasons.
@JsonSerializable(fieldRename: FieldRename.snake)
class DocumentReasonModel {
  String? id;
  String? description;
  String? keywords;
  String? updatedAt;
  String? userId;
  bool? flagActive;

  DocumentReasonModel();

  factory DocumentReasonModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentReasonModelFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentReasonModelToJson(this);

  DocumentReason toEntity() => DocumentReason()
    ..id = id
    ..description = description
    ..keywords = keywords
    ..updatedAt = updatedAt
    ..userId = userId
    ..flagActive = flagActive;
}
