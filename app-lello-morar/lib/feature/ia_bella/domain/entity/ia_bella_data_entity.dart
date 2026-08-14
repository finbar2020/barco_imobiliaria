import 'package:morar/feature/ia_bella/domain/entity/ia_bella_documents_entity.dart';

class IaBellaDataEntity {
  final String? responseId;
  final String? uuidSession;
  final String? welcomeMessage;
  final String? response;
  final List<IaBellaDocumentsEntity?> documents;

  IaBellaDataEntity({
    this.responseId,
    this.uuidSession,
    this.welcomeMessage,
    this.response,
    this.documents = const [],
  });

  IaBellaDataEntity copyWith({
    String? responseId,
    String? uuidSession,
    String? welcomeMessage,
    String? response,
    List<IaBellaDocumentsEntity>? documents,
  }) {
    return IaBellaDataEntity(
      responseId: responseId ?? this.responseId,
      uuidSession: uuidSession ?? this.uuidSession,
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
      response: response ?? this.response,
      documents: documents ?? this.documents,
    );
  }
}
