class LegalObligationActivityHistoryResponseModel {
  final bool success;
  final String? message;
  final List<LegalObligationActivityHistoryItemModel> data;
  final String? errorCode;
  final int? legacyStatusCode;

  const LegalObligationActivityHistoryResponseModel({
    required this.success,
    required this.data,
    this.message,
    this.errorCode,
    this.legacyStatusCode,
  });

  factory LegalObligationActivityHistoryResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LegalObligationActivityHistoryResponseModel(
      success: json['success'] == true,
      message: json['message'] as String?,
      data: _toItems(json['data']),
      errorCode: (json['errorCode'] ?? json['error_code']) as String?,
      legacyStatusCode: _toInt(
        json['legacyStatusCode'] ?? json['legacy_status_code'],
      ),
    );
  }

  static List<LegalObligationActivityHistoryItemModel> _toItems(Object? value) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map((item) => LegalObligationActivityHistoryItemModel.fromJson(
              item.cast<String, dynamic>(),
            ))
        .toList();
  }
}

class LegalObligationActivityHistoryItemModel {
  final String? collectionCode;
  final String? date;
  final String? description;
  final String? responsible;
  final String? status;

  const LegalObligationActivityHistoryItemModel({
    this.collectionCode,
    this.date,
    this.description,
    this.responsible,
    this.status,
  });

  factory LegalObligationActivityHistoryItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LegalObligationActivityHistoryItemModel(
      collectionCode: (json['collectionCode'] ?? json['collection_code'])
          as String?,
      date: json['date'] as String?,
      description: json['description'] as String?,
      responsible: (json['responsible'] ?? json['responsible_name']) as String?,
      status: json['status'] as String?,
    );
  }
}

int? _toInt(Object? value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}
