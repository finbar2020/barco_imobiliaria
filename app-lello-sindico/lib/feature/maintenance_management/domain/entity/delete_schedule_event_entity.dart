import 'package:equatable/equatable.dart';

class DeleteScheduleEventRequestEntity extends Equatable {
  final String scheduleEventId;
  final String mode; // THIS_SCHEDULE_EVENT ou NEXT_SCHEDULE_EVENTS

  const DeleteScheduleEventRequestEntity({
    required this.scheduleEventId,
    required this.mode,
  });

  @override
  List<Object?> get props => [scheduleEventId, mode];
}

class DeleteScheduleEventResponseEntity extends Equatable {
  final bool success;
  final String? message;

  const DeleteScheduleEventResponseEntity({
    required this.success,
    this.message,
  });

  @override
  List<Object?> get props => [success, message];
}
