import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:morar/feature/home/domain/entity/unity.dart';
import 'package:morar/feature/me/domain/entity/condominium.dart';

abstract class HomeDialogState extends Equatable {
  const HomeDialogState();

  @override
  List<Object?> get props => [];
}

class HomeDialogInitialState extends HomeDialogState {
  const HomeDialogInitialState();
}

class NeedsUpdateState extends HomeDialogState {
  final AppOriginEnum appOriginEnum;
  final NeedsUpdate needsUpdate;

  const NeedsUpdateState({
    required this.appOriginEnum,
    required this.needsUpdate,
  });

  @override
  List<Object?> get props => [appOriginEnum, needsUpdate];
}

class AlertSwitchRoleState extends HomeDialogState {
  final Condominium switchCondominium;
  final Unity switchUnity;

  const AlertSwitchRoleState({
    required this.switchCondominium,
    required this.switchUnity,
  });

  @override
  List<Object?> get props => [switchCondominium, switchUnity];
}

class NotificationPermissionState extends HomeDialogState {
  const NotificationPermissionState();
}
