import 'dart:io';

import '../enums/legal_obligation_tab.dart';

abstract class LegalObligationEvent {
  const LegalObligationEvent();
}

class LegalObligationLoadTabEvent extends LegalObligationEvent {
  final LegalObligationTab tab;

  const LegalObligationLoadTabEvent(this.tab);
}

class LegalObligationLoadingEvent extends LegalObligationEvent {
  const LegalObligationLoadingEvent();
}

class LegalObligationErrorEvent extends LegalObligationEvent {
  final String error;

  const LegalObligationErrorEvent(this.error);
}

class LegalObligationDownloadFileEvent extends LegalObligationEvent {
  final String id;
  final String type;

  const LegalObligationDownloadFileEvent(
      {required this.id, required this.type});
}

class LegalObligationUploadFileEvent extends LegalObligationEvent {
  final File file;
  final DateTime expirationDate;
  final String obligationId;
  final String obligationType;
  final String condoId;

  const LegalObligationUploadFileEvent({
    required this.file,
    required this.expirationDate,
    required this.obligationId,
    required this.obligationType,
    required this.condoId,
  });
}

class LegalObligationSendTechnicalInspectionEmailEvent
    extends LegalObligationEvent {
  final String email;
  final String type;
  final String id;

  const LegalObligationSendTechnicalInspectionEmailEvent({
    required this.email,
    required this.type,
    required this.id,
  });
}

class LegalObligationRequestPartnerRenewalEvent extends LegalObligationEvent {
  final String type;
  final String id;

  const LegalObligationRequestPartnerRenewalEvent({
    required this.type,
    required this.id,
  });
}

/// Disparado quando a tela de obrigações legais não retornou dados e o
/// síndico opta por notificar o parceiro (envio de e-mail por filial).
class LegalObligationNotifyPartnerEmptyDataEvent extends LegalObligationEvent {
  final String type;

  const LegalObligationNotifyPartnerEmptyDataEvent({
    required this.type,
  });
}
