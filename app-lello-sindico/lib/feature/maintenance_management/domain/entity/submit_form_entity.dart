class FileContentEntity {
  final String contentType;
  final String localUri;
  final String name;
  final String uploadTaskId;
  final String firebaseRef;
  final String deviceId;
  final String bucket;
  final int failCount;
  final int size;
  final String url;

  FileContentEntity({
    required this.contentType,
    required this.localUri,
    required this.name,
    required this.uploadTaskId,
    required this.firebaseRef,
    required this.deviceId,
    required this.bucket,
    required this.failCount,
    required this.size,
    required this.url,
  });
}

class AnswerEntity {
  final String type;
  final String questionId;
  final dynamic content; // Pode ser null, String, List<String>, FileContentEntity, etc

  AnswerEntity({
    required this.type,
    required this.questionId,
    this.content,
  });
}

class SubmitFormRequestEntity {
  final String eventId;
  final Map<String, AnswerEntity> answers;

  SubmitFormRequestEntity({
    required this.eventId,
    required this.answers,
  });
}

class SubmitFormResponseEntity {
  final bool success;
  final String? message;
  final String? data; // ID do evento criado/atualizado

  SubmitFormResponseEntity({
    required this.success,
    this.message,
    this.data,
  });
}
