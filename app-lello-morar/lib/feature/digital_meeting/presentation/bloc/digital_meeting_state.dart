import 'package:essentials/essentials.dart';
import 'package:morar/feature/digital_meeting/domain/entity/digital_meeting.dart';

abstract class DigitalMeetingState extends Equatable {
  const DigitalMeetingState();

  @override
  List<Object?> get props => [];
}

class DigitalMeetingInitialState extends DigitalMeetingState {
  const DigitalMeetingInitialState();
}

class DigitalMeetingLoadingState extends DigitalMeetingState {
  const DigitalMeetingLoadingState();
}

class DigitalMeetingLoadedState extends DigitalMeetingState {
  final List<DigitalMeeting> meetings;

  const DigitalMeetingLoadedState({
    required this.meetings,
  });

  @override
  List<Object?> get props => [meetings];
}

class DigitalMeetingShowAllState extends DigitalMeetingState {
  final List<DigitalMeeting> meetings;

  const DigitalMeetingShowAllState({
    required this.meetings,
  });

  @override
  List<Object?> get props => [meetings];
}

class DigitalMeetingWebViewState extends DigitalMeetingState {
  final DigitalMeeting meeting;

  const DigitalMeetingWebViewState({
    required this.meeting,
  });

  @override
  List<Object?> get props => [meeting];
}

class DigitalMeetingFailureAssembliesState extends DigitalMeetingState {
  final String message;

  const DigitalMeetingFailureAssembliesState({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class DigitalMeetingFailureState extends DigitalMeetingState {
  final String message;

  const DigitalMeetingFailureState({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
