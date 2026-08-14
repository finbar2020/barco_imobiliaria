import 'package:json_annotation/json_annotation.dart';

part 'legal_obligation_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LegalObligationResponseModel {
  @JsonKey(defaultValue: false)
  final bool success;
  final String? message;
  @JsonKey(defaultValue: <LegalObligationItemModel>[])
  final List<LegalObligationItemModel> data;
  final LegalObligationMetadataModel? metadata;
  @JsonKey(readValue: _readErrorCode)
  final String? errorCode;
  @JsonKey(readValue: _readLegacyStatusCode, fromJson: _toInt)
  final int? legacyStatusCode;

  const LegalObligationResponseModel({
    required this.success,
    required this.data,
    this.metadata,
    this.message,
    this.errorCode,
    this.legacyStatusCode,
  });

  factory LegalObligationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LegalObligationResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LegalObligationResponseModelToJson(this);

  static Object? _readErrorCode(Map json, String key) =>
      json['errorCode'] ?? json['error_code'];

  static Object? _readLegacyStatusCode(Map json, String key) =>
      json['legacyStatusCode'] ?? json['legacy_status_code'];
}

@JsonSerializable()
class LegalObligationMetadataModel {
  @JsonKey(readValue: _readRequestPartner)
  final bool? requestPartner;

  const LegalObligationMetadataModel({
    this.requestPartner,
  });

  factory LegalObligationMetadataModel.fromJson(Map<String, dynamic> json) =>
      _$LegalObligationMetadataModelFromJson(json);

  Map<String, dynamic> toJson() => _$LegalObligationMetadataModelToJson(this);

  static Object? _readRequestPartner(Map json, String key) =>
      json['requestPartner'] ?? json['request_partner'];
}

@JsonSerializable()
class LegalObligationItemModel {
  @JsonKey(readValue: _readId)
  final String? id;
  final String? reference;
  @JsonKey(readValue: _readCollectionCode)
  final String? collectionCode;
  @JsonKey(readValue: _readDocumentType)
  final String? documentType;
  final String? document;
  final String? description;
  final String? status;
  @JsonKey(readValue: _readExpirationDate)
  final String? expirationDate;
  @JsonKey(readValue: _readAvailableActions, fromJson: _toStringList)
  final List<String> availableActions;
  @JsonKey(readValue: _readSubmittedByName)
  final String? submittedByName;
  @JsonKey(readValue: _readStatusTooltip)
  final String? statusTooltip;
  @JsonKey(readValue: _readCollectionType)
  final String? collectionType;
  @JsonKey(readValue: _readContentType)
  final String? contentType;
  @JsonKey(readValue: _readLastNotificationDate)
  final String? lastNotificationDate;
  final String? observations;
  @JsonKey(readValue: _readErrorCode)
  final String? errorCode;
  @JsonKey(readValue: _readLegacyStatusCode, fromJson: _toInt)
  final int? legacyStatusCode;

  const LegalObligationItemModel({
    this.id,
    this.reference,
    this.collectionCode,
    this.documentType,
    this.document,
    this.description,
    this.status,
    this.expirationDate,
    this.availableActions = const [],
    this.submittedByName,
    this.statusTooltip,
    this.collectionType,
    this.contentType,
    this.lastNotificationDate,
    this.observations,
    this.errorCode,
    this.legacyStatusCode,
  });

  factory LegalObligationItemModel.fromJson(Map<String, dynamic> json) =>
      _$LegalObligationItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$LegalObligationItemModelToJson(this);

  static Object? _readId(Map json, String key) => json['id'];

  static Object? _readCollectionCode(Map json, String key) =>
      json['collectionCode'] ?? json['collection_code'];

  static Object? _readDocumentType(Map json, String key) =>
      json['documentType'] ?? json['document_type'];

  static Object? _readExpirationDate(Map json, String key) =>
      json['expirationDate'] ?? json['expiration_date'];

  static Object? _readAvailableActions(Map json, String key) =>
      json['availableActions'] ?? json['available_actions'];

  static Object? _readSubmittedByName(Map json, String key) =>
      json['submittedByName'] ?? json['submitted_by_name'];

  static Object? _readStatusTooltip(Map json, String key) =>
      json['statusTooltip'] ?? json['status_tooltip'];

  static Object? _readCollectionType(Map json, String key) =>
      json['collectionType'] ?? json['collection_type'];

  static Object? _readContentType(Map json, String key) =>
      json['contentType'] ?? json['content_type'];

  static Object? _readLastNotificationDate(Map json, String key) =>
      json['lastNotificationDate'] ?? json['last_notification_date'];

  static Object? _readErrorCode(Map json, String key) =>
      json['errorCode'] ?? json['error_code'];

  static Object? _readLegacyStatusCode(Map json, String key) =>
      json['legacyStatusCode'] ?? json['legacy_status_code'];
}

int? _toInt(Object? value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

List<String> _toStringList(Object? value) {
  if (value is List) {
    return value
        .where((item) => item != null)
        .map((item) => item.toString())
        .toList();
  }
  if (value is String && value.isNotEmpty) {
    return [value];
  }
  return const [];
}
