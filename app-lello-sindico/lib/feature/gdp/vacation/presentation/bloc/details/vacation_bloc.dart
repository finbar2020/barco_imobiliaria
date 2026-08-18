import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_params.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/details/vacation_event.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/details/vacation_state.dart';

abstract class VacationBloc extends Bloc<VacationEvent, VacationState> {
  VacationBloc(VacationState initialState) : super(initialState);

  void beginLoad(String employeeId);

  VacationParams getVacationParams();

  void getVacationLockedDays(
      String employeeId, DateTime startDate, DateTime endDate);
}
