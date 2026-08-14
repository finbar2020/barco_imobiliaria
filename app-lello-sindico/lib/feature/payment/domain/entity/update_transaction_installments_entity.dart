class UpdateTransactionInstallmentsEntity {
  final int? transactionId;
  final int? installmentId;

  UpdateTransactionInstallmentsEntity({
    this.transactionId,
    this.installmentId,
  });

  UpdateTransactionInstallmentsEntity copyWith({
    int? transactionId,
    int? installmentId,
  }) {
    return UpdateTransactionInstallmentsEntity(
      transactionId: transactionId ?? this.transactionId,
      installmentId: installmentId ?? this.installmentId,
    );
  }
}
