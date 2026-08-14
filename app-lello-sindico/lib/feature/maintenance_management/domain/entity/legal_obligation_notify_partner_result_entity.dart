class LegalObligationNotifyPartnerResultEntity {
  final bool success;
  final String? message;
  final bool shouldLockButton;

  const LegalObligationNotifyPartnerResultEntity({
    required this.success,
    required this.shouldLockButton,
    this.message,
  });
}
