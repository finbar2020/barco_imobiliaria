import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/vox/domain/entity/document.dart';
import 'package:lello/feature/vox/domain/entity/document_detail.dart';
import 'package:lello/feature/vox/domain/entity/recipient_type.dart';

part 'warning_model.g.dart';

/// Model de leitura de advertência (lista GET /warnings/condominium/{id} e
/// detalhe GET /warnings/{id}). Fiel ao `fromJson` antigo (`WarningsModel`).
@JsonSerializable(fieldRename: FieldRename.snake)
class WarningModel {
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

  WarningModel();

  factory WarningModel.fromJson(Map<String, dynamic> json) =>
      _$WarningModelFromJson(json);
  Map<String, dynamic> toJson() => _$WarningModelToJson(this);

  Document toDocument() => Document()
    ..id = id
    ..name = name
    ..description = description
    ..content = content
    ..status = status
    ..pagesQuantity = pagesQuantity
    ..createdAt = createdAt
    ..flagEmailDistribution = flagEmailDistribution
    ..flagPrintDistribution = flagPrintDistribution
    ..flagEmailBodyAttachment = flagEmailBodyAttachment
    ..reason = reason
    ..reasonId = reasonId
    ..modelId = modelId
    ..occurrenceDate = occurrenceDate
    ..unityId = unityId
    ..recipientType = RecipientType.fromValue(recipientType)
    ..singleCopiesQuantity = singleCopiesQuantity;

  DocumentDetail toDetail() => DocumentDetail()
    ..id = id
    ..name = name
    ..description = description
    ..content = content
    ..status = status
    ..pagesQuantity = pagesQuantity
    ..createdAt = createdAt
    ..occurrenceDate = occurrenceDate
    ..flagEmailDistribution = flagEmailDistribution
    ..flagPrintDistribution = flagPrintDistribution;
}
