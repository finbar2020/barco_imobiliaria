import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation.dart';

abstract class ScheduleVacationState extends Equatable {
  final Vacation? data;
  final String? condominiumId;

  const ScheduleVacationState(this.data, this.condominiumId);

  @override
  List<Object?> get props => [data, condominiumId];
}

class ScheduleVacationLoadingState extends ScheduleVacationState {
  const ScheduleVacationLoadingState(Vacation? data, String condominiumId)
      : super(data, condominiumId);
}

class ScheduleVacationLoadFailedState extends ScheduleVacationState {
  final Failure error;

  const ScheduleVacationLoadFailedState(
      Vacation? data, String condominiumId, this.error)
      : super(data, condominiumId);

  @override
  List<Object?> get props => [...super.props, error];
}

class ScheduleVacationLoadedState extends ScheduleVacationState {
  const ScheduleVacationLoadedState(Vacation? data, String? condominiumId)
      : super(data, condominiumId);
}
