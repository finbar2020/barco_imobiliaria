class PaymentInstallmentApprover {
  final String? name;
  final String? status;
  final String? approvalDate;
  final String? approvalTime;
  final String? channel;

  PaymentInstallmentApprover({
    this.name,
    this.status,
    this.approvalDate,
    this.approvalTime,
    this.channel,
  });

  PaymentInstallmentApprover copyWith({
    String? name,
    String? status,
    String? approvalDate,
    String? approvalTime,
    String? channel,
  }) {
    return PaymentInstallmentApprover(
      name: name ?? this.name,
      status: status ?? this.status,
      approvalDate: approvalDate ?? this.approvalDate,
      approvalTime: approvalTime ?? this.approvalTime,
      channel: channel ?? this.channel,
    );
  }
}
