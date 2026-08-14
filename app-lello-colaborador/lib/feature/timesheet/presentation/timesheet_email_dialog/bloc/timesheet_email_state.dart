import 'package:essentials/essentials.dart';

abstract class TimesheetEmailState extends Equatable {
  final String? email;
  const TimesheetEmailState({this.email});

  @override
  List<Object?> get props => [email];
}

class TimesheetEmailInitialState extends TimesheetEmailState {
  const TimesheetEmailInitialState({
    super.email,
  });
}

class TimesheetEmailLoadingState extends TimesheetEmailState {
  const TimesheetEmailLoadingState({
    required String email,
  }) : super(email: email);
}

class TimesheetEmailSuccessState extends TimesheetEmailState {
  const TimesheetEmailSuccessState({
    required String email,
  }) : super(email: email);
}

class TimesheetEmailFailedState extends TimesheetEmailState {
  const TimesheetEmailFailedState({
    required String email,
  }) : super(email: email);
}
