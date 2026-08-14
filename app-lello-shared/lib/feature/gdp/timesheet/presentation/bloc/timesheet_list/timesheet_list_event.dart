import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_event.dart';

abstract class TimesheetListEvent extends Equatable {
  const TimesheetListEvent();

  @override
  List<Object?> get props => [];
}

class TimesheetListLoadEvent extends TimesheetListEvent {
  final String? condominiumId;

  const TimesheetListLoadEvent({this.condominiumId});

  @override
  List<Object?> get props => [condominiumId];
}

class TimesheetListInsertEvent extends TimesheetListEvent {
  final TimesheetEvent timesheetEvent;

  const TimesheetListInsertEvent({required this.timesheetEvent});

  @override
  List<Object?> get props => [timesheetEvent];
}
