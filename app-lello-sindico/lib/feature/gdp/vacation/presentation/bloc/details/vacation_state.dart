import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_locked_days.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_params.dart';

abstract class VacationState {
  final String? condominiumId;

  VacationState(this.condominiumId);
}

class VacationLockedDaysState extends VacationState {
  final List<VacationLockedDays?>? vacationLockedDays;
  //final String? condominiumId;
  final DateTime? startDate;
  final DateTime? endDate;

  VacationLockedDaysState(
      this.vacationLockedDays, this.startDate, this.endDate, condominiumId)
      : super(condominiumId);
}

class VacationLoadingState extends VacationState {
  VacationLoadingState(String? condominiumId) : super(condominiumId);
}

class VacationLoadFailedState extends VacationState {
  final Failure? error;
  VacationLoadFailedState(String condominiumId, {this.error})
      : super(condominiumId);
}

class VacationLoadedState extends VacationState {
  VacationLockedDays lockedDays;
  final Vacation? data;
  final VacationParams? vacationParams;
  VacationLoadedState(
      this.data, condominiumId, this.vacationParams, this.lockedDays)
      : super(condominiumId);
}
