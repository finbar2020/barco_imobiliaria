import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';

class HomeDialogState {}

class NeedsUpdateState extends HomeDialogState {
  AppOriginEnum appOriginEnum;
  NeedsUpdate needsUpdate;

  NeedsUpdateState({
    required this.appOriginEnum,
    required this.needsUpdate,
  });
}

class AlertSwitchRoleState extends HomeDialogState {
  Condominium switchCondominium;
  AlertSwitchRoleState({required this.switchCondominium});
}

class NotificationPermissionState extends HomeDialogState {}

class ToYourCondoNewsState extends HomeDialogState {}
