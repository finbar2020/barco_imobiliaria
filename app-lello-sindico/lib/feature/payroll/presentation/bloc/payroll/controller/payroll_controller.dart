import 'package:lello/feature/payroll/domain/use_case/get_payroll/get_payroll.dart';
import 'package:lello/feature/payroll/domain/use_case/list_payroll/list_payroll.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll/payroll_bloc.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll/payroll_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class PayrollController {
  final PayrollBloc payrollBloc;
  final SessionBloc sessionBloc;
  final GetPayroll getPayrollUseCase;
  final ListPayroll listPayrollUseCase;

  PayrollController({
    required this.payrollBloc,
    required this.sessionBloc,
    required this.getPayrollUseCase,
    required this.listPayrollUseCase,
  });

  Future<void> getPayrollsList() async {
    payrollBloc.add(
      PayrollsListLoadingEvent(),
    );
    final response = await listPayrollUseCase(
      ListPayrollParam(
        condominiumId: sessionBloc.state.session?.selectedCondominium?.id ?? "",
      ),
    );
    response.fold(
      (error) => payrollBloc.add(
        PayrollsListlLoadFailedEvent(error: error),
      ),
      (res) => payrollBloc.add(
        PayrollsListLoadedEvent(payrolls: res),
      ),
    );
  }

  Future<void> getPayrollDetail({required DateTime period}) async {
    payrollBloc.add(
      PayrollDetailLoadingEvent(),
    );
    final response = await getPayrollUseCase(
      GetPayrollParam(
        condominiumId: sessionBloc.state.session?.selectedCondominium?.id ?? "",
        period: period,
      ),
    );

    response.fold(
      (error) => payrollBloc.add(
        PayrollDetailLoadFailedEvent(error: error),
      ),
      (res) => payrollBloc.add(
        PayrollDetailLoadedEvent(payroll: res),
      ),
    );
  }

  void dispose() {
    payrollBloc.add(PayrollEmptyEvent());
  }
}
