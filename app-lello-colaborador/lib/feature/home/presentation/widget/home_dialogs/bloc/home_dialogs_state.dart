import 'package:essentials/essentials.dart';

abstract class HomeDialogState extends Equatable {
  const HomeDialogState();

  @override
  List<Object?> get props => [];
}

class HomeDialogInitialState extends HomeDialogState {
  const HomeDialogInitialState();
}

class NotificationPermissionState extends HomeDialogState {
  const NotificationPermissionState();
}
