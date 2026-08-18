import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/gdp/payslip/presentation/bloc/selection/payslip_selection_event.dart';
import 'package:lello/feature/gdp/payslip/presentation/bloc/selection/payslip_selection_state.dart';

abstract class PayslipSelectionBloc
    extends Bloc<PayslipSelectionEvent, PayslipSelectionState> {
  PayslipSelectionBloc(PayslipSelectionState initialState)
      : super(initialState);

  void beginLoad(String employeeId, DateTime selectedMonth);
  void beginDownloadFile(String nameFile, String registrationNumber);
  void resetState();
}
