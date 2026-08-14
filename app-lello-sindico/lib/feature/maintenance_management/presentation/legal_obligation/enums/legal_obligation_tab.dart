import '../../../domain/enum/legal_obligation_type.dart';

enum LegalObligationTab {
  condominium,
  employee,
  technicalInspection,
}

extension LegalObligationTabCardLabel on LegalObligationTab {
  /// Só a aba Condomínio fixa o título dos cards; nas demais usa-se `documentType`.
  String? get listCategoryLabel {
    switch (this) {
      case LegalObligationTab.condominium:
        return 'CONDOMÍNIO';
      case LegalObligationTab.employee:
        return 'Funcionários';
      case LegalObligationTab.technicalInspection:
        return null;
    }
  }

  /// Valor enviado ao BFF como `type` no endpoint de download.
  String get obligationTypeValue {
    switch (this) {
      case LegalObligationTab.condominium:
        return LegalObligationType.condominium.apiValue; // CONDOMINIUM
      case LegalObligationTab.employee:
        return LegalObligationType.employee.apiValue; // EMPLOYEE
      case LegalObligationTab.technicalInspection:
        return LegalObligationType
            .technicalInspection.apiValue; // TECHNICAL_INSPECTION
    }
  }
}
