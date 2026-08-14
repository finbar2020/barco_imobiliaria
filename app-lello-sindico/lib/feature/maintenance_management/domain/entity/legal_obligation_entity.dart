class LegalObligationItemEntity {
  final String? id;
  final String? reference;
  final String? collectionCode;
  final String? documentType;
  final String? document;
  final String? description;
  final String? status;
  final String? expirationDate;
  final List<String> availableActions;
  final String? submittedByName;
  final String? statusTooltip;
  final String? collectionType;
  final String? contentType;
  final String? lastNotificationDate;
  final String? observations;
  final String? errorCode;
  final int? legacyStatusCode;

  const LegalObligationItemEntity({
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
}

class LegalObligationEntity {
  final List<LegalObligationItemEntity> items;
  final bool? requestPartner;
  final String? message;
  final String? errorCode;
  final int? legacyStatusCode;

  const LegalObligationEntity({
    required this.items,
    this.requestPartner,
    this.message,
    this.errorCode,
    this.legacyStatusCode,
  });

  const LegalObligationEntity.empty()
      : items = const [],
        requestPartner = null,
        message = null,
        errorCode = null,
        legacyStatusCode = null;

  bool get isEmpty => items.isEmpty;
}
