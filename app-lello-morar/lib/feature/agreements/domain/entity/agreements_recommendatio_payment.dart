class AgreementRecommendationPayment {
  String? paymentMethod;
  int? dueDay;
  int installmentQtd;
  bool recomendation;

  AgreementRecommendationPayment({
    this.paymentMethod = "billet",
    this.dueDay,
    required this.installmentQtd,
    required this.recomendation,
  });
}
