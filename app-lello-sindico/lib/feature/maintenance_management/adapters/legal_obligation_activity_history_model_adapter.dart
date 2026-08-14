import '../data/model/legal_obligation_activity_history_response_model.dart';
import '../domain/entity/legal_obligation_activity_history_entity.dart';

extension LegalObligationActivityHistoryResponseModelAdapter
    on LegalObligationActivityHistoryResponseModel {
  LegalObligationActivityHistoryEntity get toEntity =>
      LegalObligationActivityHistoryEntity(
        items: data.map((item) => item.toEntity).toList(),
        message: message,
        errorCode: errorCode,
        legacyStatusCode: legacyStatusCode,
      );
}

extension LegalObligationActivityHistoryItemModelAdapter
    on LegalObligationActivityHistoryItemModel {
  LegalObligationActivityHistoryItemEntity get toEntity =>
      LegalObligationActivityHistoryItemEntity(
        collectionCode: collectionCode,
        date: date,
        description: description,
        responsible: responsible,
        status: status,
      );
}
