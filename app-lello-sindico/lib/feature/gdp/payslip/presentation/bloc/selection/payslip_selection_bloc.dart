import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lello/feature/gdp/payslip/domain/entity/payslipFile.dart';
import 'package:lello/feature/gdp/payslip/domain/use_case/get_payslips/get_payslip.dart';
import 'package:lello/feature/gdp/payslip/domain/use_case/get_payslips_file/get_payslip_file.dart';
import 'package:lello/feature/gdp/payslip/presentation/bloc/selection/payslip_selection_event.dart';
import 'package:lello/feature/gdp/payslip/presentation/bloc/selection/payslip_selection_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';

class PayslipSelectionBloc
    extends Bloc<PayslipSelectionEvent, PayslipSelectionState> {
  final SessionBloc sessionBloc;
  final GetPayslip getPayslip;
  final GetPayslipFile getPayslipFile;
  String? pendingEmployeeId;

  StreamSubscription? _subscription;

  PayslipSelectionBloc(
      {required this.sessionBloc,
      required this.getPayslip,
      required this.getPayslipFile})
      : super(PayslipLoadingState(null, null, PayslipFile())) {
    on<PayslipLoadEvent>(_mapLoad);
    on<PayslipDownloadFileEvent>(_mapDownload);
    on<PayslipResetEvent>((event, emit) {
      emit(PayslipLoadedState(
          state.data, state.numeroCadastro!, PayslipFile()));
    });
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  Future<void> _mapLoad(
    PayslipLoadEvent event,
    Emitter<PayslipSelectionState> emit,
  ) async {
    final employeeId = event.employeeId;
    final data = state.data;
    final selectedMonth = event.selectedMonth;

    emit(PayslipLoadingState(data, employeeId, PayslipFile()));

    final result =
        await getPayslip.call(GetPayslipParam(registrationNumber: employeeId));
    emit(result.fold(
        (err) => PayslipLoadFailedState(data, employeeId, PayslipFile(), err),
        (res) => PayslipLoadedState(
            res
                .where((x) =>
                    x.processingDate!.month == selectedMonth!.month &&
                    x.processingDate!.year == selectedMonth.year)
                .toList(),
            employeeId,
            PayslipFile())));
  }

  Future<void> _mapDownload(
    PayslipDownloadFileEvent event,
    Emitter<PayslipSelectionState> emit,
  ) async {
    final nameFile = event.nameFile;
    final registrationNumber = event.registrationNumber;

    emit(PayslipLoadingState(
      state.data,
      registrationNumber,
      PayslipFile(),
    ));

    final result = await getPayslipFile.call(GetPayslipFileParam(
        nameFile: nameFile, registrationNumber: registrationNumber));
    emit(result.fold(
        (err) => PayslipLoadFailedState(
            state.data, registrationNumber, PayslipFile(), err),
        (res) =>
            PayslipFileDownloadedState(state.data, registrationNumber, res)));
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

  void resetState() {
    add(PayslipResetEvent());
  }

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
