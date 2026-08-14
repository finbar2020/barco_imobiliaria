import 'package:lello/feature/payroll/domain/entity/payroll.dart';
import 'package:lello/feature/payroll/domain/use_case/list_payroll_entry/list_payroll_entry.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll_entry/payroll_entry_bloc.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll_entry/payroll_entry_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class PayrollEntryController {
  final PayrollEntryBloc payrollEntryBloc;
  final SessionBloc sessionBloc;
  final ListPayrollEntry listPayrollEntryUseCase;

  PayrollEntryController(
      {required this.payrollEntryBloc,
      required this.sessionBloc,
      required this.listPayrollEntryUseCase});

  Future<void> mapLoadEntry({required Payroll payroll}) async {
    payrollEntryBloc.add(
      PayrollEntryLoadingEvent(),
    );
    final response = await listPayrollEntryUseCase(
      ListPayrollEntryParam(
        condominiumId: sessionBloc.state.session?.selectedCondominium?.id ?? "",
        period: payroll.period ?? DateTime.now(),
      ),
    );
    response.fold(
      (error) => payrollEntryBloc.add(
        PayrollEntryLoadFailedEvent(error: error),
      ),
      (res) => payrollEntryBloc.add(
        PayrollEntryLoadedEvent(payrollEntry: res),
      ),
    );
  }
}
