import 'package:essentials/essentials.dart';
import 'package:lello/feature/payroll/domain/entity/payroll.dart';

abstract class PayrollEvent {}

class PayrollEmptyEvent extends PayrollEvent {}

class PayrollsListLoadingEvent extends PayrollEvent {}

class PayrollDetailLoadingEvent extends PayrollEvent {}

class PayrollsListlLoadFailedEvent extends PayrollEvent {
  final Failure? error;
  PayrollsListlLoadFailedEvent({required this.error});
}

class PayrollDetailLoadFailedEvent extends PayrollEvent {
  final Failure? error;
  PayrollDetailLoadFailedEvent({required this.error});
}

class PayrollsListLoadedEvent extends PayrollEvent {
  final List<Payroll>? payrolls;
  PayrollsListLoadedEvent({required this.payrolls});
}

class PayrollDetailLoadedEvent extends PayrollEvent {
  final Payroll? payroll;
  PayrollDetailLoadedEvent({required this.payroll});
}
