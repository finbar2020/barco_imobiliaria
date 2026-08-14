import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_entity.dart';

abstract class TimesheetPointMirrorEvent extends Equatable {
  const TimesheetPointMirrorEvent();

  @override
  List<Object?> get props => [];
}

class TimesheetPointMirrorLoadingEvent extends TimesheetPointMirrorEvent {
  const TimesheetPointMirrorLoadingEvent();
}

class TimesheetPointMirrorLoadedEvent extends TimesheetPointMirrorEvent {
  final List<TimesheetEntity> list;
  final bool saveSuccess;
  final bool saveFailed;

  const TimesheetPointMirrorLoadedEvent({
    required this.list,
    this.saveSuccess = false,
    this.saveFailed = false,
  });

  @override
  List<Object?> get props => [list, saveSuccess, saveFailed];
}

class TimesheetPointMirrorFailedEvent extends TimesheetPointMirrorEvent {
  const TimesheetPointMirrorFailedEvent();
}
