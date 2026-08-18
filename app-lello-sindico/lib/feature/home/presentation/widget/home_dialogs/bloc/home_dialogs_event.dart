import 'package:lello/feature/condominium/domain/entity/condominium.dart';

abstract class HomeDialogEvent {}

class InitialEvent extends HomeDialogEvent {}

class NeedsUpdateEvent extends HomeDialogEvent {}

class AlertSwitchRoleEvent extends HomeDialogEvent {
  Condominium switchCondominium;
  AlertSwitchRoleEvent({required this.switchCondominium});
}
