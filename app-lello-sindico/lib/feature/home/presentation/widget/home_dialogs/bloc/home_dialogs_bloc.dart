import 'dart:async';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_event.dart';
import 'package:lello/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_state.dart';
import 'package:lello/feature/home/presentation/widget/home_dialogs/comfort_dialog/comfort_to_your_condo_dialog.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/shared_features.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDialogBloc extends Bloc<HomeDialogEvent, HomeDialogState> {
  final SessionBloc sessionBloc;
  final CircuitBreakerController circuitBreakController =
      ApplicationContainer.instance().resolve();

  HomeDialogBloc({required this.sessionBloc})
      : super(const HomeDialogInitialState()) {
    on<InitialEvent>(_checkJobs);
    sessionBloc.stream.listen(_onSessionChanged);
  }

  Condominium? switchCondominium;
  bool jumpFirstStep = false;
  bool jumpSecondStep = false;

  void initialState() {
    add(const InitialEvent());
  }

  void showUpdate() {
    add(const NeedsUpdateEvent());
  }

  void switchRolesNeeded(Condominium switchCondominium) {
    this.switchCondominium = switchCondominium;
    add(const InitialEvent());
  }

  Future<void> _checkJobs(
    InitialEvent event,
    Emitter<HomeDialogState> emit,
  ) async {
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
            emit(const NotificationPermissionState());
            return;
          }
        } else {
          if (statuses == PermissionStatus.permanentlyDenied ||
              statuses == PermissionStatus.denied) {
            await preferences.setString(
                SharedPreferencesKeys.notificationPermission,
                dateFormat.format(DateTime.now()));
            jumpFirstStep = true;
            emit(const NotificationPermissionState());
            return;
          }
        }

        if (statuses != PermissionStatus.granted) {
          jumpFirstStep = true;
          emit(const NotificationPermissionState());
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
        emit(const ToYourCondoNewsState());
        return;
      }
    }

    //Passo 3 - Alert Switch Role
    if (switchCondominium != null) {
      emit(AlertSwitchRoleState(switchCondominium: switchCondominium!));
      switchCondominium = null;
      return;
    }
  }

  // ignore: unused_element
  Future<void> _checkSwitchRoles(
    AlertSwitchRoleEvent event,
    Emitter<HomeDialogState> emit,
  ) async {
    emit(AlertSwitchRoleState(switchCondominium: event.switchCondominium));
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {
      initialState();
    }
  }
}
