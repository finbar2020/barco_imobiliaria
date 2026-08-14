import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_entity.dart';

abstract class TimesheetPointMirrorState extends Equatable {
  const TimesheetPointMirrorState();

  @override
  List<Object?> get props => [];
}

class TimesheetPointMirrorLoadingState extends TimesheetPointMirrorState {
  const TimesheetPointMirrorLoadingState();
}

class TimesheetPointMirrorLoadedState extends TimesheetPointMirrorState {
  final List<TimesheetEntity> list;
  final bool saveSuccess;
  final bool saveFailed;

  const TimesheetPointMirrorLoadedState({
    required this.list,
    this.saveSuccess = false,
    this.saveFailed = false,
  });

  @override
  List<Object?> get props => [list, saveSuccess, saveFailed];
}

class TimesheetPointMirrorFailedState extends TimesheetPointMirrorState {
  const TimesheetPointMirrorFailedState();
}
