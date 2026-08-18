import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation.dart';

abstract class ScheduleVacationState {
  final Vacation? data;
  final String? condominiumId;

  ScheduleVacationState(this.data, this.condominiumId);
}

class ScheduleVacationLoadingState extends ScheduleVacationState {
  ScheduleVacationLoadingState(Vacation? data, String condominiumId)
      : super(data, condominiumId);
}

class ScheduleVacationLoadFailedState extends ScheduleVacationState {
  final Failure error;

  ScheduleVacationLoadFailedState(
      Vacation? data, String condominiumId, this.error)
      : super(data, condominiumId);
}

class ScheduleVacationLoadedState extends ScheduleVacationState {
  ScheduleVacationLoadedState(Vacation? data, String? condominiumId)
      : super(data, condominiumId);
}
