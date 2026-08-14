import 'package:essentials/essentials.dart';
import 'package:lello/feature/payroll/domain/entity/payroll_entry.dart';

abstract class PayrollEntryState {}

class PayrollEntryEmptyState extends PayrollEntryState {}

class PayrollEntryLoadingState extends PayrollEntryState {}

class PayrollEntryLoadFailedState extends PayrollEntryState {
  final Failure? error;
  PayrollEntryLoadFailedState({required this.error});
}

class PayrollEntryLoadedState extends PayrollEntryState {
  final List<PayrollEntry> payrollEntry;
  PayrollEntryLoadedState({required this.payrollEntry});
}
