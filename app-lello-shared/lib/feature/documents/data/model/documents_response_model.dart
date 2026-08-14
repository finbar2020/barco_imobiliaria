import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/documents/domain/entity/documents.dart';
import 'package:shared_features/feature/documents/domain/entity/documents_type.dart';

part 'documents_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DocumentsResponseModel {
  String? id;
  String? name;
  String? description;
  String? content;
  String? createdAt;
  bool? flagEmailDistribution;
  bool? flagPrintDistribution;
  int? pagesQuantity;
  String? status;
  String? notificationParameter;

  DocumentsType? documentsType;

  DocumentsResponseModel();

  factory DocumentsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentsResponseModelToJson(this);

  static DocumentsResponseModel? fromEntity(Documents? entity) => entity == null
      ? null
      : (DocumentsResponseModel()
        ..id = entity.id
        ..name = entity.name
        ..status = entity.status
        ..description = entity.description
        ..createdAt = entity.createdAt
        ..flagEmailDistribution = entity.flagEmailDistribution
        ..flagPrintDistribution = entity.flagPrintDistribution
        ..pagesQuantity = entity.pagesQuantity
        ..documentsType = entity.documentsType
        ..notificationParameter = entity.notificationParameter);

  Documents toEntity() => Documents()
    ..id = this.id
    ..createdAt = this.createdAt
    ..flagEmailDistribution = this.flagEmailDistribution
    ..flagPrintDistribution = this.flagPrintDistribution
    ..pagesQuantity = this.pagesQuantity
    ..name = this.name
    ..status = this.status
    ..description = this.description
    ..documentsType = this.documentsType
    ..notificationParameter = this.notificationParameter;
}
