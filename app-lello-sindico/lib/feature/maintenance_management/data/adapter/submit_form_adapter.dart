import '../../domain/entity/submit_form_entity.dart';
import '../model/submit_form_request_model.dart';
import '../model/submit_form_response_model.dart';

class SubmitFormAdapter {
  // Entity -> Model (para enviar na API)
  static SubmitFormRequestModel toModel(SubmitFormRequestEntity entity) {
    return SubmitFormRequestModel(
      eventId: entity.eventId,
      answers: entity.answers.map(
        (key, value) => MapEntry(
          key,
          AnswerModel(
            type: value.type,
            questionId: value.questionId,
            content: _convertContentToModel(value.content),
          ),
        ),
      ),
    );
  }

  // Model -> Entity (resposta da API)
  static SubmitFormResponseEntity toEntity(SubmitFormResponseModel model) {
    return SubmitFormResponseEntity(
      success: model.success,
      message: model.message,
      data: model.data,
    );
  }

  // Converte o content da entity para o formato do model
  static dynamic _convertContentToModel(dynamic content) {
    if (content == null) {
      return null;
    }
    
    if (content is FileContentEntity) {
      return FileContentModel(
        contentType: content.contentType,
        localUri: content.localUri,
        name: content.name,
        uploadTaskId: content.uploadTaskId,
        firebaseRef: content.firebaseRef,
        deviceId: content.deviceId,
        bucket: content.bucket,
        failCount: content.failCount,
        size: content.size,
        url: content.url,
      );
    }
    
    if (content is List<FileContentEntity>) {
      return content.map((file) => FileContentModel(
        contentType: file.contentType,
        localUri: file.localUri,
        name: file.name,
        uploadTaskId: file.uploadTaskId,
        firebaseRef: file.firebaseRef,
        deviceId: file.deviceId,
        bucket: file.bucket,
        failCount: file.failCount,
        size: file.size,
        url: file.url,
      )).toList();
    }
    
    // Para outros tipos (String, List<String>, etc), retorna direto
    return content;
  }
}
