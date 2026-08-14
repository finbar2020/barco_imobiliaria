import 'package:essentials/essentials.dart';
import 'package:lello/feature/payroll/domain/entity/payroll.dart';

abstract class PayrollState {}

class PayrollEmptyState extends PayrollState {}

class PayrollsListLoadingState extends PayrollState {}

class PayrollDetailLoadingState extends PayrollState {}

class PayrollsListLoadFailedState extends PayrollState {
  final Failure? error;
  PayrollsListLoadFailedState({
    required this.error,
  });
}

class PayrollDetailLoadFailedState extends PayrollState {
  final Failure? error;
  PayrollDetailLoadFailedState({
    required this.error,
  });
}

class PayrollsListLoadedState extends PayrollState {
  final List<Payroll> payrolls;
  PayrollsListLoadedState({
    required this.payrolls,
  });
}

class PayrollDetailLoadedState extends PayrollState {
  final Payroll? payroll;
  PayrollDetailLoadedState({
    required this.payroll,
  });
}
