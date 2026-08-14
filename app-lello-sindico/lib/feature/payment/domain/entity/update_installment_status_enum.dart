enum UpdateInstallmentStatus { approved, canceled, suspended }

String updateInstallmentStatusToString(UpdateInstallmentStatus status) {
  switch (status) {
    case UpdateInstallmentStatus.approved:
      return "APROVADO";
    case UpdateInstallmentStatus.canceled:
      return "CANCELADO";
    case UpdateInstallmentStatus.suspended:
      return "SUSPENSO";
  }
}
