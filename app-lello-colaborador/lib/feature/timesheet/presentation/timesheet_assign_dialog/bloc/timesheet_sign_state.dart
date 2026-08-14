import 'package:essentials/essentials.dart';

abstract class TimesheetSignState extends Equatable {
  const TimesheetSignState();

  @override
  List<Object?> get props => [];
}

class TimesheetSignInitialState extends TimesheetSignState {
  const TimesheetSignInitialState();
}

class TimesheetSignLoadingState extends TimesheetSignState {
  const TimesheetSignLoadingState();
}

class TimesheetSignSuccessState extends TimesheetSignState {
  const TimesheetSignSuccessState();
}

class TimesheetSignFailedState extends TimesheetSignState {
  const TimesheetSignFailedState();
}
