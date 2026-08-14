import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:essentials/essentials.dart';

part 'document_info_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DocumentInfoModel {
  final String name;
  final String type;
  final DateTime documentProcessingDate;

  DocumentInfoModel({
    required this.name,
    required this.type,
    required this.documentProcessingDate,
  });

  factory DocumentInfoModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentInfoModelToJson(this);

  static DocumentInfoModel fromEntity(DocumentInfo info) => DocumentInfoModel(
        name: info.name,
        type: enumToString(info.type) ?? "",
        documentProcessingDate: info.documentProcessingDate,
      );

  DocumentInfo? toEntity() {
    DocumentTypeEnum? typeEnum = stringToEnum(DocumentTypeEnum.values, type);
    if (typeEnum == null) {
      return null;
    }
    return DocumentInfo(
      name: name,
      type: typeEnum,
      documentProcessingDate: documentProcessingDate,
    );
  }
}
