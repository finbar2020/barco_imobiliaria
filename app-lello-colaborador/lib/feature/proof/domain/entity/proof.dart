class ProofEntity {
  int? nsr; //Sequential registration number
  String dateTimeClockIn;
  String? proofName;

  ProofEntity({
    this.nsr,
    required this.dateTimeClockIn,
    required this.proofName,
  });
}
