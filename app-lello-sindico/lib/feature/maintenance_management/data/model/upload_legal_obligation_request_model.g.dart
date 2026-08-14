// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_legal_obligation_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadLegalObligationRequestModel _$UploadLegalObligationRequestModelFromJson(
        Map<String, dynamic> json) =>
    UploadLegalObligationRequestModel(
      type: json['type'] as String,
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      fileUrl: json['fileUrl'] as String,
      date: json['date'] as String,
    );

Map<String, dynamic> _$UploadLegalObligationRequestModelToJson(
        UploadLegalObligationRequestModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'fileName': instance.fileName,
      'fileUrl': instance.fileUrl,
      'date': instance.date,
    };
