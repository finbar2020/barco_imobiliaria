import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/vox/domain/entity/document.dart';
import 'package:lello/feature/vox/domain/entity/document_detail.dart';

part 'fine_model.g.dart';

/// Model de leitura de multa (lista GET /fines/condominium/{id} e detalhe
/// GET /fines/{id}). Fiel ao `fromJson` antigo (`FinesModel`).
@JsonSerializable(fieldRename: FieldRename.snake)
class FineModel {
  String? id;
  String? name;
  String? description;
  String? reason;
  DateTime? occurrenceDate;
  String? content;
  DateTime? createdAt;
  bool? flagEmailDistribution;
  bool? flagPrintDistribution;
  int? pagesQuantity;
  String? status;

  FineModel();

  factory FineModel.fromJson(Map<String, dynamic> json) =>
      _$FineModelFromJson(json);
  Map<String, dynamic> toJson() => _$FineModelToJson(this);

  Document toDocument() => Document()
    ..id = id
    ..name = name
    ..description = description
    ..reason = reason
    ..occurrenceDate = occurrenceDate
    ..content = content
    ..createdAt = createdAt?.toIso8601String()
    ..flagEmailDistribution = flagEmailDistribution
    ..flagPrintDistribution = flagPrintDistribution
    ..pagesQuantity = pagesQuantity
    ..status = status;

  DocumentDetail toDetail() => DocumentDetail()
    ..id = id
    ..name = name
    ..description = description
    ..content = content
    ..occurrenceDate = occurrenceDate
    ..createdAt = createdAt?.toIso8601String()
    ..flagEmailDistribution = flagEmailDistribution
    ..flagPrintDistribution = flagPrintDistribution
    ..pagesQuantity = pagesQuantity
    ..status = status;
}
