class LegalObligationNotifyPartnerResultModel {
  final bool success;
  final String? message;
  final bool shouldLockButton;

  const LegalObligationNotifyPartnerResultModel({
    required this.success,
    required this.shouldLockButton,
    this.message,
  });
}
