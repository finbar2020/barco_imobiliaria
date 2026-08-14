import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';

abstract class HomeDialogEvent extends Equatable {
  const HomeDialogEvent();

  @override
  List<Object?> get props => [];
}

class InitialEvent extends HomeDialogEvent {
  const InitialEvent();
}

class NeedsUpdateEvent extends HomeDialogEvent {
  const NeedsUpdateEvent();
}

class AlertSwitchRoleEvent extends HomeDialogEvent {
  final Condominium switchCondominium;

  const AlertSwitchRoleEvent({required this.switchCondominium});

  @override
  List<Object?> get props => [switchCondominium];
}
