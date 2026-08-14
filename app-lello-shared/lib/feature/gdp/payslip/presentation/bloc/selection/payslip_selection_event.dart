import 'package:essentials/essentials.dart';

abstract class PayslipSelectionEvent extends Equatable {
  const PayslipSelectionEvent();

  @override
  List<Object?> get props => [];
}

class PayslipLoadEvent extends PayslipSelectionEvent {
  final String condominiumId;
  final String employeeId;
  final DateTime? selectedMonth;

  const PayslipLoadEvent(
      {required this.condominiumId,
      required this.employeeId,
      this.selectedMonth});

  @override
  List<Object?> get props => [condominiumId, employeeId, selectedMonth];
}

class PayslipDownloadFileEvent extends PayslipSelectionEvent {
  final String registrationNumber;
  final String nameFile;

  const PayslipDownloadFileEvent(
      {required this.registrationNumber, required this.nameFile});

  @override
  List<Object?> get props => [registrationNumber, nameFile];
}

class PayslipResetEvent extends PayslipSelectionEvent {
  const PayslipResetEvent();
}
