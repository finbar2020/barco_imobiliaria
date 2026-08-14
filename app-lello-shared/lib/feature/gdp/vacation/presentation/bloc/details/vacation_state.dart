import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_locked_days.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_params.dart';

abstract class VacationGDPState extends Equatable {
  final String? condominiumId;

  const VacationGDPState(this.condominiumId);

  @override
  List<Object?> get props => [condominiumId];
}

class VacationGDPLockedDaysState extends VacationGDPState {
  final List<VacationLockedDays?>? vacationLockedDays;
  final DateTime? startDate;
  final DateTime? endDate;

  const VacationGDPLockedDaysState(
      this.vacationLockedDays, this.startDate, this.endDate, condominiumId)
      : super(condominiumId);

  @override
  List<Object?> get props =>
      [...super.props, vacationLockedDays, startDate, endDate];
}

class VacationGDPLoadingState extends VacationGDPState {
  const VacationGDPLoadingState(String? condominiumId) : super(condominiumId);
}

class VacationGDPLoadFailedState extends VacationGDPState {
  final Failure? error;

  const VacationGDPLoadFailedState(String condominiumId, {this.error})
      : super(condominiumId);

  @override
  List<Object?> get props => [...super.props, error];
}

class VacationGDPLoadedState extends VacationGDPState {
  final VacationLockedDays lockedDays;
  final Vacation? data;
  final VacationParams? vacationParams;

  const VacationGDPLoadedState(
      this.data, condominiumId, this.vacationParams, this.lockedDays)
      : super(condominiumId);

  @override
  List<Object?> get props => [...super.props, data, vacationParams, lockedDays];
}
