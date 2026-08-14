import '../data/model/legal_obligation_response_model.dart';
import '../domain/entity/legal_obligation_entity.dart';

extension LegalObligationResponseModelAdapter on LegalObligationResponseModel {
  LegalObligationEntity get toEntity => LegalObligationEntity(
        items: data.map((item) => item.toEntity).toList(),
        requestPartner: metadata?.requestPartner,
        message: message,
        errorCode: errorCode,
        legacyStatusCode: legacyStatusCode,
      );
}

extension LegalObligationItemModelAdapter on LegalObligationItemModel {
  LegalObligationItemEntity get toEntity => LegalObligationItemEntity(
        id: id,
        reference: reference,
        collectionCode: collectionCode,
        documentType: documentType,
        document: document,
        description: description,
        status: status,
        expirationDate: expirationDate,
        availableActions: availableActions,
        submittedByName: submittedByName,
        statusTooltip: statusTooltip,
        collectionType: collectionType,
        contentType: contentType,
        lastNotificationDate: lastNotificationDate,
        observations: observations,
        errorCode: errorCode,
        legacyStatusCode: legacyStatusCode,
      );
}
