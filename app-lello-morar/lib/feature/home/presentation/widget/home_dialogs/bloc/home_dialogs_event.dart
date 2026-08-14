import 'package:essentials/essentials.dart';
import 'package:morar/feature/home/domain/entity/unity.dart';
import 'package:morar/feature/me/domain/entity/condominium.dart';

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

class ComfortEvent extends HomeDialogEvent {
  const ComfortEvent();
}

class AlertSwitchRoleEvent extends HomeDialogEvent {
  final Condominium switchCondominium;
  final Unity switchUnity;

  const AlertSwitchRoleEvent({
    required this.switchCondominium,
    required this.switchUnity,
  });

  @override
  List<Object?> get props => [switchCondominium, switchUnity];
}
