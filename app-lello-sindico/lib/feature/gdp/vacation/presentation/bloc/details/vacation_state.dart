import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_locked_days.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_params.dart';

abstract class VacationState extends Equatable {
  final String? condominiumId;

  const VacationState(this.condominiumId);

  @override
  List<Object?> get props => [condominiumId];
}

class VacationLockedDaysState extends VacationState {
  final List<VacationLockedDays?>? vacationLockedDays;
  final DateTime? startDate;
  final DateTime? endDate;

  const VacationLockedDaysState(
      this.vacationLockedDays, this.startDate, this.endDate, String? condominiumId)
      : super(condominiumId);

  @override
  List<Object?> get props =>
      [...super.props, vacationLockedDays, startDate, endDate];
}

class VacationLoadingState extends VacationState {
  const VacationLoadingState(String? condominiumId) : super(condominiumId);
}

class VacationLoadFailedState extends VacationState {
  final Failure? error;

  const VacationLoadFailedState(String condominiumId, {this.error})
      : super(condominiumId);

  @override
  List<Object?> get props => [...super.props, error];
}

class VacationLoadedState extends VacationState {
  final VacationLockedDays lockedDays;
  final Vacation? data;
  final VacationParams? vacationParams;

  const VacationLoadedState(
      this.data, String? condominiumId, this.vacationParams, this.lockedDays)
      : super(condominiumId);

  @override
  List<Object?> get props => [...super.props, data, vacationParams, lockedDays];
}
