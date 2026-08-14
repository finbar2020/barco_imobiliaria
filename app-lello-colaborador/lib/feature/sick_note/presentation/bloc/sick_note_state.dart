import 'package:essentials/essentials.dart';

abstract class SickNoteState extends Equatable {
  const SickNoteState();

  @override
  List<Object?> get props => [];
}

class SickNoteInitialState extends SickNoteState {
  const SickNoteInitialState();
}

class SickNoteLoadingState extends SickNoteState {
  const SickNoteLoadingState();
}

class SickNoteRegisterLoadedState extends SickNoteState {
  const SickNoteRegisterLoadedState();
}

class SickNoteRegisterFailedState extends SickNoteState {
  const SickNoteRegisterFailedState();
}
