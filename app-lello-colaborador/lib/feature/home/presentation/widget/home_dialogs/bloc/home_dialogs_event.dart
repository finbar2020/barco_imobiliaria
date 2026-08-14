import 'package:essentials/essentials.dart';

abstract class HomeDialogEvent extends Equatable {
  const HomeDialogEvent();

  @override
  List<Object?> get props => [];
}

class InitialEvent extends HomeDialogEvent {
  const InitialEvent();
}
