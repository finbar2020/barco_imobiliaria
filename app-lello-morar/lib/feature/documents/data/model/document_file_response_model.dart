import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/documents/domain/entity/document_file.dart';

part 'document_file_response_model.g.dart';

@JsonSerializable()
class DocumentFileResponseModel {
  String? id;
  String? name;
  String? type;
  String? data;
  String? extractedText;

  DocumentFileResponseModel();

  factory DocumentFileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentFileResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentFileResponseModelToJson(this);

  static DocumentFileResponseModel? fromEntity(DocumentFile? entity) =>
      entity == null
          ? null
          : (DocumentFileResponseModel()
            ..id = entity.id
            ..name = entity.name
            ..type = entity.type
            ..data = entity.data
            ..extractedText = entity.extractedText);

  DocumentFile toEntity() => DocumentFile()
    ..id = id
    ..name = name
    ..type = type
    ..data = data
    ..extractedText = extractedText;
}
