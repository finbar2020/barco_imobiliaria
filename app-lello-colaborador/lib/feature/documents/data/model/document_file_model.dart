import 'package:colaborador/feature/documents/domain/entity/document_file.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_file_model.g.dart';

@JsonSerializable()
class DocumentFileModel {
  String id;
  String name;
  String type;
  String data;

  DocumentFileModel({
    required this.id,
    required this.name,
    required this.type,
    required this.data,
  });

  factory DocumentFileModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentFileModelFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentFileModelToJson(this);

  static DocumentFileModel? fromEntity(DocumentFile? entity) => entity == null
      ? null
      : DocumentFileModel(
          id: entity.id,
          name: entity.name,
          type: entity.type,
          data: entity.data,
        );

  DocumentFile toEntity() => DocumentFile(
        id: id,
        name: name,
        type: type,
        data: data,
      );
}
