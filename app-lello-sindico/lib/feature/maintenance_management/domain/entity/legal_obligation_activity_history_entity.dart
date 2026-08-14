class LegalObligationActivityHistoryItemEntity {
  final String? collectionCode;
  final String? date;
  final String? description;
  final String? responsible;
  final String? status;

  const LegalObligationActivityHistoryItemEntity({
    this.collectionCode,
    this.date,
    this.description,
    this.responsible,
    this.status,
  });
}

class LegalObligationActivityHistoryEntity {
  final List<LegalObligationActivityHistoryItemEntity> items;
  final String? message;
  final String? errorCode;
  final int? legacyStatusCode;

  const LegalObligationActivityHistoryEntity({
    required this.items,
    this.message,
    this.errorCode,
    this.legacyStatusCode,
  });
}
