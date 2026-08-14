// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_obligation_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LegalObligationResponseModel _$LegalObligationResponseModelFromJson(
        Map<String, dynamic> json) =>
    LegalObligationResponseModel(
      success: json['success'] as bool? ?? false,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) =>
                  LegalObligationItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      metadata: json['metadata'] == null
          ? null
          : LegalObligationMetadataModel.fromJson(
              json['metadata'] as Map<String, dynamic>),
      message: json['message'] as String?,
      errorCode: LegalObligationResponseModel._readErrorCode(json, 'errorCode')
          as String?,
      legacyStatusCode: _toInt(
          LegalObligationResponseModel._readLegacyStatusCode(
              json, 'legacyStatusCode')),
    );

Map<String, dynamic> _$LegalObligationResponseModelToJson(
        LegalObligationResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data.map((e) => e.toJson()).toList(),
      'metadata': instance.metadata?.toJson(),
      'errorCode': instance.errorCode,
      'legacyStatusCode': instance.legacyStatusCode,
    };

LegalObligationMetadataModel _$LegalObligationMetadataModelFromJson(
        Map<String, dynamic> json) =>
    LegalObligationMetadataModel(
      requestPartner: LegalObligationMetadataModel._readRequestPartner(
              json, 'requestPartner')
          as bool?,
    );

Map<String, dynamic> _$LegalObligationMetadataModelToJson(
        LegalObligationMetadataModel instance) =>
    <String, dynamic>{
      'requestPartner': instance.requestPartner,
    };

LegalObligationItemModel _$LegalObligationItemModelFromJson(
        Map<String, dynamic> json) =>
    LegalObligationItemModel(
      id: LegalObligationItemModel._readId(json, 'id') as String?,
      reference: json['reference'] as String?,
      collectionCode:
          LegalObligationItemModel._readCollectionCode(json, 'collectionCode')
              as String?,
      documentType:
          LegalObligationItemModel._readDocumentType(json, 'documentType')
              as String?,
      document: json['document'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      expirationDate:
          LegalObligationItemModel._readExpirationDate(json, 'expirationDate')
              as String?,
      availableActions: LegalObligationItemModel._readAvailableActions(
                  json, 'availableActions') ==
              null
          ? const []
          : _toStringList(LegalObligationItemModel._readAvailableActions(
              json, 'availableActions')),
      submittedByName:
          LegalObligationItemModel._readSubmittedByName(json, 'submittedByName')
              as String?,
      statusTooltip:
          LegalObligationItemModel._readStatusTooltip(json, 'statusTooltip')
              as String?,
      collectionType:
          LegalObligationItemModel._readCollectionType(json, 'collectionType')
              as String?,
      contentType:
          LegalObligationItemModel._readContentType(json, 'contentType')
              as String?,
      lastNotificationDate: LegalObligationItemModel._readLastNotificationDate(
          json, 'lastNotificationDate') as String?,
      observations: json['observations'] as String?,
      errorCode:
          LegalObligationItemModel._readErrorCode(json, 'errorCode') as String?,
      legacyStatusCode: _toInt(LegalObligationItemModel._readLegacyStatusCode(
          json, 'legacyStatusCode')),
    );

Map<String, dynamic> _$LegalObligationItemModelToJson(
        LegalObligationItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reference': instance.reference,
      'collectionCode': instance.collectionCode,
      'documentType': instance.documentType,
      'document': instance.document,
      'description': instance.description,
      'status': instance.status,
      'expirationDate': instance.expirationDate,
      'availableActions': instance.availableActions,
      'submittedByName': instance.submittedByName,
      'statusTooltip': instance.statusTooltip,
      'collectionType': instance.collectionType,
      'contentType': instance.contentType,
      'lastNotificationDate': instance.lastNotificationDate,
      'observations': instance.observations,
      'errorCode': instance.errorCode,
      'legacyStatusCode': instance.legacyStatusCode,
    };
