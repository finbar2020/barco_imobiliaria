import 'package:essentials/essentials.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_documents_model.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_data_entity.dart';
part 'ia_bella_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class IaBellaDataModel {
  final String? responseId;
  final String? uuidSession;
  final String? welcomeMessage;
  final String? response;
  final List<IaBellaDocumentsModel?> documents;

  IaBellaDataModel({
    this.responseId,
    this.uuidSession,
    this.welcomeMessage,
    this.response,
    this.documents = const [],
  });

  factory IaBellaDataModel.fromJson(Map<String, dynamic> json) =>
      _$IaBellaDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$IaBellaDataModelToJson(this);

  static IaBellaDataModel? fromEntity(IaBellaDataEntity? entity) =>
      entity == null
          ? null
          : (IaBellaDataModel(
              responseId: entity.responseId,
              uuidSession: entity.uuidSession,
              welcomeMessage: entity.welcomeMessage,
              response: entity.response,
              documents: entity.documents
                  .map((e) => IaBellaDocumentsModel.fromEntity(e))
                  .toList(),
            ));

  IaBellaDataEntity toEntity() => IaBellaDataEntity(
        responseId: responseId,
        uuidSession: uuidSession,
        welcomeMessage: welcomeMessage,
        response: response,
        documents: documents.isNotEmpty
            ? documents.map((e) => e!.toEntity()).toList()
            : [],
      );
}
