import 'dart:async';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_bloc.dart';
import 'package:lello/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_event.dart';
import 'package:lello/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_state.dart';
import 'package:lello/feature/home/presentation/widget/home_dialogs/comfort_dialog/comfort_to_your_condo_dialog.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/shared_features.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDialogBlocImpl extends HomeDialogBloc {
  final SessionBloc sessionBloc;
  final CircuitBreakerController circuitBreakController =
      ApplicationContainer.instance().resolve();

  HomeDialogBlocImpl({required this.sessionBloc}) : super(HomeDialogState()) {
    sessionBloc.stream.listen(_onSessionChanged);
  }
  Condominium? switchCondominium;
  bool jumpFirstStep = false;
  bool jumpSecondStep = false;

  @override
  Stream<HomeDialogState> mapEventToState(HomeDialogEvent event) async* {
    if (event is InitialEvent) yield* _checkJobs(event);
  }

  @override
  void initialState() {
    add(InitialEvent());
  }

  @override
  void showUpdate() {
    add(NeedsUpdateEvent());
  }

  @override
  void switchRolesNeeded(Condominium switchCondominium) {
    this.switchCondominium = switchCondominium;

    add(InitialEvent());
  }

  Stream<HomeDialogState> _checkJobs(InitialEvent event) async* {
    //Passo 1 - permissao de notificacao
    if (!jumpFirstStep) {
      PermissionStatus? statuses = await Permission.notification.status;
      var preferences = await SharedPreferences.getInstance();
      var dateFormat = DateFormat.yMd().add_Hms();
      var remoteConfigDaysDelay = sessionBloc
          .getRemoteConfig()
          ?.getInt(CustomFirebaseRemoteConfig.notificationsPermsDaysDelay);
      var delayDurationAskNotification =
          Duration(days: remoteConfigDaysDelay ?? 60);

      var permissionNotificationDateString =
          preferences.getString(SharedPreferencesKeys.notificationPermission);
      DateTime? permissionNotificationDate;

      if (permissionNotificationDateString != null) {
        permissionNotificationDate = DateTimeUtils.tryParseDate(
            permissionNotificationDateString, dateFormat.pattern!);
        if (permissionNotificationDate == null) {
          // remove config if parsing fails
          await preferences
              .remove(SharedPreferencesKeys.notificationPermission);
        }
      }

      if (permissionNotificationDate == null ||
          permissionNotificationDate
              .add(delayDurationAskNotification)
              .isBefore(DateTime.now())) {
        debugPrint("STATUS => $statuses");

        if (Platform.isIOS) {
          if (statuses == PermissionStatus.permanentlyDenied) {
            await preferences.setString(
                SharedPreferencesKeys.notificationPermission,
                dateFormat.format(DateTime.now()));
            jumpFirstStep = true;
            yield NotificationPermissionState();
            return;
          }
        } else {
          if (statuses == PermissionStatus.permanentlyDenied ||
              statuses == PermissionStatus.denied) {
            await preferences.setString(
                SharedPreferencesKeys.notificationPermission,
                dateFormat.format(DateTime.now()));
            jumpFirstStep = true;
            yield NotificationPermissionState();
            return;
          }
        }

        if (statuses != PermissionStatus.granted) {
          jumpFirstStep = true;
          yield NotificationPermissionState();
          return;
        }
      }
    }

    //Passo 2 - Novidades categoria Seu Condominio (Comodidades)
    if (jumpSecondStep == false) {
      var canShowConfortToYourCondo =
          await ComfortToYourCondoDialog.canShowConfortToYourCondo();
      if (canShowConfortToYourCondo &&
          circuitBreakController.checkVisible(
              applicationRbac: ApplicationRbac.sindicoComodidadesSeuCondominio,
              reference:
                  sessionBloc.state.session?.selectedCondominium?.reference ??
                      "")) {
        jumpSecondStep = true;
        yield ToYourCondoNewsState();
        return;
      }
    }

    //Passo 3 - Alert Switch Role
    if (switchCondominium != null) {
      yield AlertSwitchRoleState(switchCondominium: switchCondominium!);
      switchCondominium = null;
      return;
    }
    // var checkNeedsUpdate = await AppUpdateConfig.checkNeedsUpdate(
    //     appOriginEnum: AppOriginEnum.manager);
    // if (checkNeedsUpdate != null &&
    //     checkNeedsUpdate.needsUpdate != null &&
    //     checkNeedsUpdate.needsUpdate != NeedsUpdate.none) {
    //   yield NeedsUpdateState(
    //     appOriginEnum: AppOriginEnum.manager,
    //     needsUpdate: checkNeedsUpdate.needsUpdate!,
    //   );
    //   return;
    // }
  }

  Stream<HomeDialogState> _checkSwitchRoles(AlertSwitchRoleEvent event) async* {
    yield AlertSwitchRoleState(switchCondominium: event.switchCondominium);
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {
      initialState();
    }
  }
}
