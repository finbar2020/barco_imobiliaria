import 'dart:convert';
import 'origin_answer_model.dart';

class TaskflowEventResponseModel {
  final bool success;
  final String? message;
  final TaskflowEventModel data;
  final String? errorCode;
  final int? legacyStatusCode;

  TaskflowEventResponseModel({
    required this.success,
    this.message,
    required this.data,
    this.errorCode,
    this.legacyStatusCode,
  });

  factory TaskflowEventResponseModel.fromJson(Map<String, dynamic> json) {
    return TaskflowEventResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: TaskflowEventModel.fromJson(json['data'] as Map<String, dynamic>),
      errorCode: json['error_code'] as String?,
      legacyStatusCode: json['legacy_status_code'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
      'errorCode': errorCode,
      'legacyStatusCode': legacyStatusCode,
    };
  }
}

class TaskflowEventModel {
  final String id;
  final String formularyId;
  final String status;
  final String responsibleName;
  final String? finishedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? taskId;
  final String? responsibleId;
  final String? responsibleType;
  final String? authorId;
  final String? localId;
  final String? partnerId;
  final String? deletedAt;
  final Map<String, TaskflowAnswerModel>? lastContentAnswers;
  final TaskflowFormularyModel formulary;
  final List<TaskflowChildTaskModel>? childTasks;

  TaskflowEventModel({
    required this.id,
    required this.formularyId,
    required this.status,
    required this.responsibleName,
    this.finishedAt,
    this.createdAt,
    this.updatedAt,
    this.taskId,
    this.responsibleId,
    this.responsibleType,
    this.authorId,
    this.localId,
    this.partnerId,
    this.deletedAt,
    this.lastContentAnswers,
    required this.formulary,
    this.childTasks,
  });

  factory TaskflowEventModel.fromJson(Map<String, dynamic> json) {
    return TaskflowEventModel(
      id: json['id'] as String,
      formularyId: json['formulary_id'] as String,
      status: json['status'] as String,
      responsibleName: json['responsible_name'] as String,
      finishedAt: json['finished_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      taskId: json['task_id'] as String?,
      responsibleId: json['responsible_id'] as String?,
      responsibleType: json['responsible_type'] as String?,
      authorId: json['author_id'] as String?,
      localId: json['local_id'] as String?,
      partnerId: json['partner_id'] as String?,
      deletedAt: json['deleted_at'] as String?,
      lastContentAnswers: json['last_content_answers'] != null
          ? (json['last_content_answers'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key,
                TaskflowAnswerModel.fromJson(value as Map<String, dynamic>),
              ),
            )
          : null,
      formulary: TaskflowFormularyModel.fromJson(
        json['formulary'] as Map<String, dynamic>,
      ),
      childTasks: json['child_tasks'] != null
          ? (json['child_tasks'] as List)
              .map((item) =>
                  TaskflowChildTaskModel.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'formularyId': formularyId,
      'status': status,
      'responsibleName': responsibleName,
      'finishedAt': finishedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'taskId': taskId,
      'responsibleId': responsibleId,
      'responsibleType': responsibleType,
      'authorId': authorId,
      'localId': localId,
      'partnerId': partnerId,
      'deletedAt': deletedAt,
      'lastContentAnswers': lastContentAnswers?.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'formulary': formulary.toJson(),
    };
  }
}

class TaskflowAnswerModel {
  final String questionId;
  final String type;
  final dynamic content; // Can be String, List<TaskflowFileModel>, etc.
  final int? updatedAt;

  TaskflowAnswerModel({
    required this.questionId,
    required this.type,
    this.content,
    this.updatedAt,
  });

  factory TaskflowAnswerModel.fromJson(Map<String, dynamic> json) {
    return TaskflowAnswerModel(
      questionId: json['question_id'] as String,
      type: json['type'] as String,
      content: _parseContent(json['content'], json['type'] as String),
      updatedAt: json['updated_at'] as int?,
    );
  }

  static dynamic _parseContent(dynamic content, String type) {
    if (content == null) return null;

    switch (type) {
      case 'FILE':
        if (content is List) {
          return content
              .map((e) => TaskflowFileModel.fromJson(e as Map<String, dynamic>))
              .toList();
        } else if (content is String) {
          // Tenta fazer parse do JSON string
          try {
            final decoded = json.decode(content);
            if (decoded is List) {
              return decoded
                  .map((e) =>
                      TaskflowFileModel.fromJson(e as Map<String, dynamic>))
                  .toList();
            }
          } catch (e) {
            // Se não conseguir fazer parse, retorna como string
            return content;
          }
        }
        return content;
      case 'TEXT':
      case 'RADIO':
      case 'LOCAL':
      case 'SECTOR':
      default:
        return content.toString();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'type': type,
      'content': _contentToJson(),
      'updatedAt': updatedAt,
    };
  }

  dynamic _contentToJson() {
    if (content is List<TaskflowFileModel>) {
      return (content as List<TaskflowFileModel>)
          .map((e) => e.toJson())
          .toList();
    }
    return content;
  }
}

class TaskflowFormularyModel {
  final String id;
  final String name;
  final int? position;
  final String? procedureId;
  final bool? enabled;
  final String? createdAt;
  final String? updatedAt;
  final List<TaskflowQuestionModel> questions;
  final List<TaskflowExpressionModel>? expressions;

  TaskflowFormularyModel({
    required this.id,
    required this.name,
    this.position,
    this.procedureId,
    this.enabled,
    this.createdAt,
    this.updatedAt,
    required this.questions,
    this.expressions,
  });

  factory TaskflowFormularyModel.fromJson(Map<String, dynamic> json) {
    return TaskflowFormularyModel(
      id: json['id'] as String,
      name: json['name'] as String,
      position: json['position'] as int?,
      procedureId: json['procedure_id'] as String?,
      enabled: json['enabled'] as bool?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => TaskflowQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      expressions: json['expressions'] != null
          ? (json['expressions'] as List<dynamic>)
              .map((e) =>
                  TaskflowExpressionModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'procedureId': procedureId,
      'enabled': enabled,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'questions': questions.map((e) => e.toJson()).toList(),
      'expressions': expressions?.map((e) => e.toJson()).toList(),
    };
  }
}

class TaskflowQuestionModel {
  final String id;
  final String name;
  final int? position;
  final String? formularyId;
  final bool? hidden;
  final bool? required;
  final String? createdAt;
  final String? updatedAt;
  final String? fieldType;
  final List<TaskflowQuestionOptionModel>? options;

  TaskflowQuestionModel({
    required this.id,
    required this.name,
    this.position,
    this.formularyId,
    this.hidden,
    this.required,
    this.createdAt,
    this.updatedAt,
    this.fieldType,
    this.options,
  });

  factory TaskflowQuestionModel.fromJson(Map<String, dynamic> json) {
    return TaskflowQuestionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      position: json['position'] as int?,
      formularyId: json['formulary_id'] as String?,
      hidden: json['hidden'] as bool?,
      required: json['required'] as bool?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      fieldType: json['field_type'] as String?,
      options: json['options'] != null
          ? (json['options'] as List<dynamic>)
              .map((e) => TaskflowQuestionOptionModel.fromJson(
                  e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'formularyId': formularyId,
      'hidden': hidden,
      'required': required,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'fieldType': fieldType,
      'options': options?.map((e) => e.toJson()).toList(),
    };
  }
}

class TaskflowQuestionOptionModel {
  final String id;
  final String name;
  final int? position;
  final String? questionId;
  final String? createdAt;
  final String? updatedAt;

  TaskflowQuestionOptionModel({
    required this.id,
    required this.name,
    this.position,
    this.questionId,
    this.createdAt,
    this.updatedAt,
  });

  factory TaskflowQuestionOptionModel.fromJson(Map<String, dynamic> json) {
    return TaskflowQuestionOptionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      position: json['position'] as int?,
      questionId: json['question_id'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'questionId': questionId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class TaskflowExpressionModel {
  final String id;
  final List<TaskflowFactorModel> factors;

  TaskflowExpressionModel({
    required this.id,
    required this.factors,
  });

  factory TaskflowExpressionModel.fromJson(Map<String, dynamic> json) {
    return TaskflowExpressionModel(
      id: json['id'] as String,
      factors: (json['factors'] as List<dynamic>)
          .map((e) => TaskflowFactorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'factors': factors.map((e) => e.toJson()).toList(),
    };
  }
}

class TaskflowFactorModel {
  final String targetValue;
  final String originId;
  final String comparisonType;

  TaskflowFactorModel({
    required this.targetValue,
    required this.originId,
    required this.comparisonType,
  });

  factory TaskflowFactorModel.fromJson(Map<String, dynamic> json) {
    return TaskflowFactorModel(
      targetValue: json['target_value'] as String,
      originId: json['origin_id'] as String,
      comparisonType: json['comparison_type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'targetValue': targetValue,
      'originId': originId,
      'comparisonType': comparisonType,
    };
  }
}

class TaskflowFileModel {
  final String id;
  final int size;
  final String name;
  final String contentType;
  final String status;
  final String bucket;
  final String firebaseRef;
  final String localUri;
  final String uploadTaskId;
  final String deviceId;
  final String url;

  TaskflowFileModel({
    required this.id,
    required this.size,
    required this.name,
    required this.contentType,
    required this.status,
    required this.bucket,
    required this.firebaseRef,
    required this.localUri,
    required this.uploadTaskId,
    required this.deviceId,
    required this.url,
  });

  factory TaskflowFileModel.fromJson(Map<String, dynamic> json) {
    // Se não tem ID, gera um baseado na URL
    final id = json['id'] as String? ??
        (json['url'] as String?)?.hashCode.toString() ??
        DateTime.now().millisecondsSinceEpoch.toString();

    return TaskflowFileModel(
      id: id,
      size: json['size'] as int? ?? 0,
      name: json['name'] as String,
      contentType: json['contentType'] as String,
      status: json['status'] as String? ?? 'uploaded',
      bucket: json['bucket'] as String? ?? '',
      firebaseRef: json['firebaseRef'] as String? ?? '',
      localUri: json['localUri'] as String? ?? '',
      uploadTaskId: json['uploadTaskId'] as String? ?? '',
      deviceId: json['deviceId'] as String? ?? '',
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'size': size,
      'name': name,
      'contentType': contentType,
      'status': status,
      'bucket': bucket,
      'firebaseRef': firebaseRef,
      'localUri': localUri,
      'uploadTaskId': uploadTaskId,
      'deviceId': deviceId,
      'url': url,
    };
  }
}

class TaskflowApiResponse {
  final bool success;
  final String message;
  final TaskflowEventModel data;
  final String? errorCode;
  final int legacyStatusCode;

  TaskflowApiResponse({
    required this.success,
    required this.message,
    required this.data,
    this.errorCode,
    required this.legacyStatusCode,
  });

  factory TaskflowApiResponse.fromJson(Map<String, dynamic> json) {
    return TaskflowApiResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: TaskflowEventModel.fromJson(json['data'] as Map<String, dynamic>),
      errorCode: json['errorCode'] as String?,
      legacyStatusCode: json['legacyStatusCode'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
      'errorCode': errorCode,
      'legacyStatusCode': legacyStatusCode,
    };
  }
}

class TaskflowChildTaskModel {
  final String? scheduleEventId;
  final OriginAnswerModel? originAnswer;

  TaskflowChildTaskModel({
    this.scheduleEventId,
    this.originAnswer,
  });

  factory TaskflowChildTaskModel.fromJson(Map<String, dynamic> json) {
    return TaskflowChildTaskModel(
      scheduleEventId: json['schedule_event_id'] as String?,
      originAnswer: json['origin_answer'] != null
          ? OriginAnswerModel.fromJson(
              json['origin_answer'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schedule_event_id': scheduleEventId,
      'origin_answer': originAnswer?.toJson(),
    };
  }
}
