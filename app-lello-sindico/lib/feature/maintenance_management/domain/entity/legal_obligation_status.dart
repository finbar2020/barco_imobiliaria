import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

enum LegalObligationStatus {
  pendente('pendente', 'Pendente'),
  aVencer('a-vencer', 'À vencer'),
  vencido('vencido', 'Vencido'),
  emRenovacao('em-renovacao', 'Em renovação'),
  emAnalise('em-analise', 'Em análise'),
  recusado('recusado', 'Recusado'),
  valido('valido', 'Válido');

  final String apiValue;
  final String label;

  const LegalObligationStatus(this.apiValue, this.label);
}

extension LegalObligationStatusExtension on LegalObligationStatus {
  static LegalObligationStatus? fromApiValue(String? value) {
    if (value == null) return null;
    final normalized =
        value.trim().toLowerCase().replaceAll('_', '-').replaceAll(' ', '-');

    for (final status in LegalObligationStatus.values) {
      if (status.apiValue == normalized) return status;
    }

    switch (normalized) {
      case 'à-vencer':
        return LegalObligationStatus.aVencer;
      case 'em-renovação':
        return LegalObligationStatus.emRenovacao;
      case 'em-análise':
        return LegalObligationStatus.emAnalise;
      case 'válido':
        return LegalObligationStatus.valido;
    }

    return null;
  }

  String get statusLabelKey {
    switch (this) {
      case LegalObligationStatus.pendente:
        return 'legal_obligation_status_pending';
      case LegalObligationStatus.aVencer:
        return 'legal_obligation_status_expiring';
      case LegalObligationStatus.vencido:
        return 'legal_obligation_status_expired';
      case LegalObligationStatus.emRenovacao:
        return 'legal_obligation_status_in_renewal';
      case LegalObligationStatus.emAnalise:
        return 'legal_obligation_status_under_review';
      case LegalObligationStatus.recusado:
        return 'legal_obligation_status_rejected';
      case LegalObligationStatus.valido:
        return 'legal_obligation_status_valid';
    }
  }

  String get helpDescriptionKey {
    switch (this) {
      case LegalObligationStatus.pendente:
        return 'legal_obligation_help_status_pending_description';
      case LegalObligationStatus.aVencer:
        return 'legal_obligation_help_status_expiring_description';
      case LegalObligationStatus.vencido:
        return 'legal_obligation_help_status_expired_description';
      case LegalObligationStatus.emRenovacao:
        return 'legal_obligation_help_status_in_renewal_description';
      case LegalObligationStatus.emAnalise:
        return 'legal_obligation_help_status_under_review_description';
      case LegalObligationStatus.recusado:
        return 'legal_obligation_help_status_rejected_description';
      case LegalObligationStatus.valido:
        return 'legal_obligation_help_status_valid_description';
    }
  }

  /// Padrão visual inspirado nas tags do design atual (ver imagem).
  bool get isOutlined =>
      this == LegalObligationStatus.emAnalise ||
      this == LegalObligationStatus.recusado;

  Color color(ThemeData theme) {
    final palette = LelloTheme.palleteOf(theme);
    switch (this) {
      case LegalObligationStatus.pendente:
        return palette.grey();
      case LegalObligationStatus.aVencer:
        return palette.warning();
      case LegalObligationStatus.vencido:
        return palette.negative();
      case LegalObligationStatus.emRenovacao:
        return palette.raffle();
      case LegalObligationStatus.emAnalise:
        return palette.raffle();
      case LegalObligationStatus.recusado:
        return palette.negative();
      case LegalObligationStatus.valido:
        return palette.success();
    }
  }
}
