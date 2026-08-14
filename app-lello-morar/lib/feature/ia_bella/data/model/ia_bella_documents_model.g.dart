// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ia_bella_documents_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IaBellaDocumentsModel _$IaBellaDocumentsModelFromJson(
        Map<String, dynamic> json) =>
    IaBellaDocumentsModel(
      id: json['id'] as String?,
      description: json['description'] as String?,
      serviceType: json['service_type'] as String?,
    );

Map<String, dynamic> _$IaBellaDocumentsModelToJson(
        IaBellaDocumentsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'service_type': instance.serviceType,
    };
