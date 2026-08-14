class AgreementAnalysisType {
  static const installmentQtd = "installment_qtd";
  static const dueDate = "due_date";

  static List<String> get getList => [
        installmentQtd,
        dueDate,
      ];

  static String getTypeKey(String? type) {
    switch (type) {
      case installmentQtd:
        return "agreements_analysis_reason_installments_number";
      case dueDate:
        return "agreements_analysis_reason_payment_days";
      default:
        return "agreements_analysis_reason_other";
    }
  }
}
