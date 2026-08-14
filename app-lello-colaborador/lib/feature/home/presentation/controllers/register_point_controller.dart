import 'dart:io';

import 'package:colaborador/core/app_connectivity/app_connectivity.dart';
import 'package:colaborador/feature/home/presentation/bloc/register_point_bloc.dart';
import 'package:colaborador/feature/me/domain/enum/device_type_allowed_enum.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';

import '../../../digital_point/controllers/digital_point_controller.dart';
import '../../../session/domain/entity/session.dart';

class RegisterPointController {
  final AppConnectivity appConnectivity;
  final SessionBloc sessionBloc;
  final RegisterPointBloc registerPointBloc;
  final DigitalPointController digitalPointController;

  bool isLoading = false;

  RegisterPointController({
    required this.appConnectivity,
    required this.sessionBloc,
    required this.registerPointBloc,
    required this.digitalPointController,
  });

  Future<void> checkDistanceAndGo() async {
    if (sessionBloc.getSession?.me.isTabletSession == true) {
      //tablet, não pedir localização
      registerPointBloc.add(RegisterPointSuccessEvent());
      return;
    }

    isLoading = true;
    final bool? hasUserRangeAllowed =
        await digitalPointController.hasUserRangeAllowed();
    isLoading = false;

    if (hasUserRangeAllowed == true) {
      registerPointBloc.add(RegisterPointSuccessEvent());
    } else if (hasUserRangeAllowed == null) {
      registerPointBloc.add(NoLocationPermissionEvent());
    } else {
      registerPointBloc.add(OutOfRangeEvent());
    }
  }

  Future<void> onTap() async {
    if (sessionBloc.getSession!.condominium.isDigitalPointBlockedByLeave) {
      registerPointBloc.add(
        WorkLeaveEvent(
          description: sessionBloc.getSession!.condominium.workLeaveDescription,
        ),
      );
      return;
    }

    if (((!sessionBloc.getSession!.me.isTabletSession!) &&
        sessionBloc.getSession!.condominium.deviceTypeEnum.isOnlyTablet)) {
      registerPointBloc.add(
        DeviceTypeFailureEvent(onlyTablet: true),
      );
      return;
    }
    if ((sessionBloc.getSession!.me.isTabletSession!) &&
        sessionBloc.getSession!.condominium.deviceTypeEnum.isOnlyPhone) {
      registerPointBloc.add(
        DeviceTypeFailureEvent(onlyPhone: true),
      );
      return;
    }

    final bool isOffline = await appConnectivity.isOfflineMode();
    if (isOffline && !Platform.isIOS) {
      registerPointBloc.add(OfflineFailureEvent());
    } else {
      registerPointBloc.add(StartRegisterPointEvent());
    }
  }

  Session get session => sessionBloc.getSession!;
}
