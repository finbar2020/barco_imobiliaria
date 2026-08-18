import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_created.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_event.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_state.dart';

abstract class ScheduleVacationBloc
    extends Bloc<ScheduleVacationEvent, ScheduleVacationState> {
  ScheduleVacationBloc(ScheduleVacationState initialState)
      : super(initialState);

  void createScheduledVacation(
      String employeeId, VacationCreated vacationCreated);
}
