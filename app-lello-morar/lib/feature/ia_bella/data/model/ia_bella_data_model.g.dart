// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ia_bella_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IaBellaDataModel _$IaBellaDataModelFromJson(Map<String, dynamic> json) =>
    IaBellaDataModel(
      responseId: json['response_id'] as String?,
      uuidSession: json['uuid_session'] as String?,
      welcomeMessage: json['welcome_message'] as String?,
      response: json['response'] as String?,
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : IaBellaDocumentsModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$IaBellaDataModelToJson(IaBellaDataModel instance) =>
    <String, dynamic>{
      'response_id': instance.responseId,
      'uuid_session': instance.uuidSession,
      'welcome_message': instance.welcomeMessage,
      'response': instance.response,
      'documents': instance.documents,
    };
