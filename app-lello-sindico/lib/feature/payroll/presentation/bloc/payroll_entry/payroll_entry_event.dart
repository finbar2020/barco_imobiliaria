import 'package:essentials/essentials.dart';
import 'package:lello/feature/payroll/domain/entity/payroll_entry.dart';

abstract class PayrollEntryEvent {}

class PayrollEntryEmptyEvent extends PayrollEntryEvent {}

class PayrollEntryLoadingEvent extends PayrollEntryEvent {}

class PayrollEntryLoadFailedEvent extends PayrollEntryEvent {
  final Failure? error;
  PayrollEntryLoadFailedEvent({required this.error});
}

class PayrollEntryLoadedEvent extends PayrollEntryEvent {
  final List<PayrollEntry> payrollEntry;
  PayrollEntryLoadedEvent({required this.payrollEntry});
}
