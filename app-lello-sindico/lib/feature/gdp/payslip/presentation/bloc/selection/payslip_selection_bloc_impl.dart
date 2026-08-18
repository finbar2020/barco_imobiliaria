import 'dart:async';

import 'package:lello/feature/gdp/payslip/domain/entity/payslipFile.dart';
import 'package:lello/feature/gdp/payslip/domain/use_case/get_payslips/get_payslip.dart';
import 'package:lello/feature/gdp/payslip/domain/use_case/get_payslips_file/get_payslip_file.dart';
import 'package:lello/feature/gdp/payslip/presentation/bloc/selection/payslip_selection_bloc.dart';
import 'package:lello/feature/gdp/payslip/presentation/bloc/selection/payslip_selection_event.dart';
import 'package:lello/feature/gdp/payslip/presentation/bloc/selection/payslip_selection_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';

class PayslipSelectionBlocImpl extends PayslipSelectionBloc {
  final SessionBloc sessionBloc;
  final GetPayslip getPayslip;
  final GetPayslipFile getPayslipFile;
  String? pendingEmployeeId;

  StreamSubscription? _subscription;

  PayslipSelectionBlocImpl(
      {required this.sessionBloc,
      required this.getPayslip,
      required this.getPayslipFile})
      : super(PayslipLoadingState(null, null, PayslipFile())) {
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  @override
  Stream<PayslipSelectionState> mapEventToState(
      PayslipSelectionEvent event) async* {
    if (event is PayslipLoadEvent) yield* _mapLoad(event);

    if (event is PayslipDownloadFileEvent) yield* _mapDownload(event);
    if (event is PayslipResetEvent)
      yield PayslipLoadedState(
          state.data, state.numeroCadastro!, PayslipFile());
  }

  Stream<PayslipSelectionState> _mapLoad(PayslipLoadEvent event) async* {
    final employeeId = event.employeeId;
    final data = state.data;
    final selectedMonth = event.selectedMonth;

    yield PayslipLoadingState(data, employeeId, PayslipFile());

    final result =
        await getPayslip.call(GetPayslipParam(registrationNumber: employeeId));
    yield result.fold(
        (err) => PayslipLoadFailedState(data, employeeId, PayslipFile(), err),
        (res) => PayslipLoadedState(
            res
                .where((x) =>
                    x.processingDate!.month == selectedMonth!.month &&
                    x.processingDate!.year == selectedMonth.year)
                .toList(),
            employeeId,
            PayslipFile()));
  }

  Stream<PayslipSelectionState> _mapDownload(
      PayslipDownloadFileEvent event) async* {
    final nameFile = event.nameFile;
    final registrationNumber = event.registrationNumber;

    yield PayslipLoadingState(
      state.data,
      registrationNumber,
      PayslipFile(),
    );

    final result = await getPayslipFile.call(GetPayslipFileParam(
        nameFile: nameFile, registrationNumber: registrationNumber));
    yield result.fold(
        (err) => PayslipLoadFailedState(
            state.data, registrationNumber, PayslipFile(), err),
        (res) =>
            PayslipFileDownloadedState(state.data, registrationNumber, res));
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null && pendingEmployeeId != null) {
        add(PayslipLoadEvent(
            condominiumId: condominium.id, employeeId: pendingEmployeeId!));
        pendingEmployeeId = null;
      }
    }
  }

  @override
  void resetState() {
    add(PayslipResetEvent());
  }

  @override
  void beginLoad(String employeeId, DateTime selectedMonth) {
    if (!(sessionBloc.state is SessionLoadedState)) {
      pendingEmployeeId = employeeId;
    } else {
      add(PayslipLoadEvent(
          condominiumId: sessionBloc.state.session!.selectedCondominium!.id,
          employeeId: employeeId,
          selectedMonth: selectedMonth));
    }
  }

  @override
  void beginDownloadFile(String employeeId, String registrationNumber) {
    add(PayslipDownloadFileEvent(
        nameFile: employeeId, registrationNumber: registrationNumber));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
