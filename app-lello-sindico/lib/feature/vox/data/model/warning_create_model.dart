import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/vox/data/model/document_content_codec.dart';
import 'package:lello/feature/vox/domain/entity/document_request.dart';

part 'warning_create_model.g.dart';

/// Model de fio da criação direta de advertência
/// (POST /warnings/condominium/{id}/models). Fiel ao body antigo (`WarningsModel`):
/// o conteúdo vai em Base64 e não há `flag_overrride` no fio.
@JsonSerializable(fieldRename: FieldRename.snake)
class WarningCreateModel {
  String? content;
  String? createdAt;
  String? description;
  bool? flagEmailBodyAttachment;
  bool? flagEmailDistribution;
  bool? flagPrintDistribution;
  String? id;
  String? modelId;
  String? name;
  DateTime? occurrenceDate;
  int? pagesQuantity;
  String? reason;
  String? reasonId;
  List<String>? recipientList;
  int? recipientType;
  int? singleCopiesQuantity;
  String? status;
  String? unityId;

  WarningCreateModel();

  factory WarningCreateModel.fromJson(Map<String, dynamic> json) =>
      _$WarningCreateModelFromJson(json);
  Map<String, dynamic> toJson() => _$WarningCreateModelToJson(this);

  static WarningCreateModel fromEntity(DocumentRequest entity) =>
      WarningCreateModel()
        ..content = encodeHtmlToBase64(entity.content)
        ..name = entity.title
        ..modelId = entity.model
        ..reason = entity.reason
        ..reasonId = entity.reasonId
        ..occurrenceDate = entity.occurrenceDate
        ..recipientList = entity.recipientList
        ..recipientType = entity.recipientType?.value
        ..singleCopiesQuantity = entity.singleCopiesQuantity
        ..unityId = entity.unityId
        ..flagEmailBodyAttachment = entity.flagEmailBodyAttachment
        ..flagEmailDistribution = entity.flagEmailDistribution
        ..flagPrintDistribution = entity.flagPrintDistribution;
}
