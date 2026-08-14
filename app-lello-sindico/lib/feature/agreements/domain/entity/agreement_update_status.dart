class AgreementUpdateStatus {
  String userName;
  String agreementId;
  bool approved;
  String? reason;

  AgreementUpdateStatus({
    required this.userName,
    required this.agreementId,
    required this.approved,
    this.reason,
  });
}
