import 'package:essentials/essentials.dart';

abstract class ManualTimeSheetState extends Equatable {
  const ManualTimeSheetState();

  @override
  List<Object?> get props => [];
}

class ManualTimeSheetInitialState extends ManualTimeSheetState {
  const ManualTimeSheetInitialState();
}

class ManualTimeSheetLoadingState extends ManualTimeSheetState {
  const ManualTimeSheetLoadingState();
}

class ManualTimeSheetRegisterLoadedState extends ManualTimeSheetState {
  const ManualTimeSheetRegisterLoadedState();
}

class ManualTimeSheetRegisterFailedState extends ManualTimeSheetState {
  const ManualTimeSheetRegisterFailedState();
}
