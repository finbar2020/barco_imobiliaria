abstract class PayslipSelectionEvent {}

class PayslipLoadEvent extends PayslipSelectionEvent {
  final String condominiumId;
  final String employeeId;
  final DateTime? selectedMonth;

  PayslipLoadEvent(
      {required this.condominiumId,
      required this.employeeId,
      this.selectedMonth});
}

class PayslipDownloadFileEvent extends PayslipSelectionEvent {
  final String registrationNumber;
  final String nameFile;
  PayslipDownloadFileEvent(
      {required this.registrationNumber, required this.nameFile});
}

class PayslipResetEvent extends PayslipSelectionEvent {
  PayslipResetEvent();
}
