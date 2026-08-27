import 'dart:async';
import 'dart:io';

import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/home/domain/entity/unity.dart';
import 'package:morar/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_event.dart';
import 'package:morar/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_state.dart';
import 'package:morar/feature/me/domain/entity/condominium.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/shared_features.dart';

class HomeDialogBloc extends Bloc<HomeDialogEvent, HomeDialogState> {
  final SessionBloc sessionBloc;

  Condominium? switchCondominium;
  Unity? switchUnity;
  bool jumpFirstStep = false;

  HomeDialogBloc({required this.sessionBloc})
      : super(const HomeDialogInitialState()) {
    on<InitialEvent>(_checkJobs);
    on<AlertSwitchRoleEvent>(_checkSwitchRoles);
    on<NeedsUpdateEvent>(_showUpdate);
    on<ComfortEvent>(_showComfort);
    initialState();
  }

  void initialState() {
    add(const InitialEvent());
  }

  void showUpdate({
    NeedsUpdate needsUpdate = NeedsUpdate.minor,
    AppOriginEnum appOriginEnum = AppOriginEnum.owner,
  }) {
    add(NeedsUpdateEvent(
        needsUpdate: needsUpdate, appOriginEnum: appOriginEnum));
  }

  void showConfort() {
    add(const ComfortEvent());
  }

  void switchRolesNeeded(Condominium switchCondominium, Unity switchUnity) {
    this.switchCondominium = switchCondominium;
    this.switchUnity = switchUnity;

    add(const InitialEvent());
  }

  Future<void> _checkJobs(
    InitialEvent event,
    Emitter<HomeDialogState> emit,
  ) async {
    // //Passo 1 - permissao de notificacao
    if (!jumpFirstStep) {
      PermissionStatus? statuses = await Permission.notification.status;
      var preferences = await SharedPreferences.getInstance();
      var dateFormat = DateFormat.yMd().add_Hms();
      var remoteConfigDaysDelay = sessionBloc.getRemoteConfig
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

    //Passo 2 - Alert Switch Role
    if (switchCondominium != null && switchUnity != null) {
      emit(AlertSwitchRoleState(
          switchCondominium: switchCondominium!, switchUnity: switchUnity!));
      switchCondominium = null;
      switchUnity = null;
      return;
    }
  }

  Future<void> _showUpdate(
    NeedsUpdateEvent event,
    Emitter<HomeDialogState> emit,
  ) async {
    emit(NeedsUpdateState(
        appOriginEnum: event.appOriginEnum, needsUpdate: event.needsUpdate));
  }

  Future<void> _showComfort(
    ComfortEvent event,
    Emitter<HomeDialogState> emit,
  ) async {
    emit(const ComfortState());
  }

  Future<void> _checkSwitchRoles(
    AlertSwitchRoleEvent event,
    Emitter<HomeDialogState> emit,
  ) async {
    emit(AlertSwitchRoleState(
        switchCondominium: event.switchCondominium,
        switchUnity: event.switchUnity));
  }
}
