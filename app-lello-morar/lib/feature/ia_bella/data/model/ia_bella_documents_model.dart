import 'package:essentials/essentials.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_documents_entity.dart';
part 'ia_bella_documents_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class IaBellaDocumentsModel {
  final String? id;
  final String? description;
  final String? serviceType;

  IaBellaDocumentsModel({
    this.id,
    this.description,
    this.serviceType,
  });

  factory IaBellaDocumentsModel.fromJson(Map<String, dynamic> json) =>
      _$IaBellaDocumentsModelFromJson(json);
  Map<String, dynamic> toJson() => _$IaBellaDocumentsModelToJson(this);

  static IaBellaDocumentsModel? fromEntity(IaBellaDocumentsEntity? entity) =>
      entity == null
          ? null
          : (IaBellaDocumentsModel(
              id: entity.id,
              description: entity.description,
              serviceType: entity.serviceType,
            ));

  IaBellaDocumentsEntity toEntity() => IaBellaDocumentsEntity(
        id: id,
        description: description,
        serviceType: serviceType,
      );
}
