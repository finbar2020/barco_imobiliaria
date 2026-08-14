import 'package:essentials/essentials.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object?> get props => [];
}

class EmployeeLoadEvent extends EmployeeEvent {
  final String condominiumId;
  final String employeeId;

  const EmployeeLoadEvent({
    required this.condominiumId,
    required this.employeeId,
  });

  @override
  List<Object?> get props => [condominiumId, employeeId];
}
