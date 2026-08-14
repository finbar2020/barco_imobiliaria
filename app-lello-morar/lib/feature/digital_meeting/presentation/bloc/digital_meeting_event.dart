import 'package:essentials/essentials.dart';
import 'package:morar/feature/digital_meeting/domain/entity/digital_meeting.dart';

abstract class DigitalMeetingEvent extends Equatable {
  const DigitalMeetingEvent();

  @override
  List<Object?> get props => [];
}

class DigitalMeetingEmptyEvent extends DigitalMeetingEvent {
  const DigitalMeetingEmptyEvent();
}

class DigitalMeetingLoadingEvent extends DigitalMeetingEvent {
  const DigitalMeetingLoadingEvent();
}

class DigitalMeetingLoadedEvent extends DigitalMeetingEvent {
  final List<DigitalMeeting> meetings;

  const DigitalMeetingLoadedEvent({
    required this.meetings,
  });

  @override
  List<Object?> get props => [meetings];
}

class DigitalMeetingShowAllEvent extends DigitalMeetingEvent {
  final List<DigitalMeeting> meetings;

  const DigitalMeetingShowAllEvent({
    required this.meetings,
  });

  @override
  List<Object?> get props => [meetings];
}

class DigitalMeetingWebViewEvent extends DigitalMeetingEvent {
  final DigitalMeeting meeting;

  const DigitalMeetingWebViewEvent({
    required this.meeting,
  });

  @override
  List<Object?> get props => [meeting];
}

class DigitalMeetingFailureAssembliesEvent extends DigitalMeetingEvent {
  final String message;

  const DigitalMeetingFailureAssembliesEvent({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class DigitalMeetingFailureEvent extends DigitalMeetingEvent {
  final String message;

  const DigitalMeetingFailureEvent({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
