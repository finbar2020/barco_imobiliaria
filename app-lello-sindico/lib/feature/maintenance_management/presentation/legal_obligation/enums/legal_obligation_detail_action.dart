enum LegalObligationDetailAction {
  sendNewDocument('enviar-novo-documento'),
  requestPartnerRenewal('solicitar-renovacao-com-parceiro'),
  viewHistory('ver-historico'),
  downloadFile('visualizar-documento');

  final String apiValue;

  const LegalObligationDetailAction(this.apiValue);
}

extension LegalObligationDetailActionExtension on LegalObligationDetailAction {
  static LegalObligationDetailAction? fromApiValue(String? value) {
    if (value == null) return null;

    final normalized =
        value.trim().toLowerCase().replaceAll('_', '-').replaceAll(' ', '-');

    for (final action in LegalObligationDetailAction.values) {
      if (action.apiValue == normalized) return action;
    }

    return null;
  }

  static List<LegalObligationDetailAction> fromApiValues(List<String> values) {
    final result = <LegalObligationDetailAction>[];

    for (final value in values) {
      final action = fromApiValue(value);
      if (action != null && !result.contains(action)) {
        result.add(action);
      }
    }

    return result;
  }

  String get labelKey {
    switch (this) {
      case LegalObligationDetailAction.sendNewDocument:
        return 'legal_obligation_action_send_new_document';
      case LegalObligationDetailAction.requestPartnerRenewal:
        return 'legal_obligation_action_request_partner_renewal';
      case LegalObligationDetailAction.viewHistory:
        return 'legal_obligation_action_view_history';
      case LegalObligationDetailAction.downloadFile:
        return 'legal_obligation_action_download_file';
    }
  }
}
