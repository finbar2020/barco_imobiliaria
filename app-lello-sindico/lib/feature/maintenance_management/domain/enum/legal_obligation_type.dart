enum LegalObligationType {
  condominium,
  employee,
  technicalInspection,
}

extension LegalObligationTypeApiValue on LegalObligationType {
  String get apiValue {
    switch (this) {
      case LegalObligationType.condominium:
        return 'CONDOMINIUM';
      case LegalObligationType.employee:
        return 'EMPLOYEE';
      case LegalObligationType.technicalInspection:
        return 'TECHNICAL_INSPECTION';
    }
  }
}
