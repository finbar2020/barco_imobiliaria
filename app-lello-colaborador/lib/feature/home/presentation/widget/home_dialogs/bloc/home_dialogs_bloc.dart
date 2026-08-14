import 'dart:convert';
import 'dart:io';

import 'package:colaborador/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_event.dart';
import 'package:colaborador/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_state.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_features/shared_features.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDialogBloc extends Bloc<HomeDialogEvent, HomeDialogState> {
  final SessionBloc sessionBloc;
  bool jumpFirstStep = false;

  HomeDialogBloc({required this.sessionBloc})
      : super(const HomeDialogInitialState()) {
    on<InitialEvent>(_checkJobs);
    initialState();
  }

  void initialState() {
    add(const InitialEvent());
  }

  Future<void> _checkJobs(
    InitialEvent event,
    Emitter<HomeDialogState> emit,
  ) async {
    if (jumpFirstStep == false) {
      PermissionStatus? statuses = await Permission.notification.status;
      var preferences = await SharedPreferences.getInstance();
      var permissionNotification =
          preferences.getString(SharedPreferencesKeys.notificationPermission);
      if (permissionNotification == null || permissionNotification.isEmpty) {
        debugPrint("STATUS => $statuses");
        if (Platform.isIOS) {
          if (statuses == PermissionStatus.permanentlyDenied) {
            await preferences.setString(
                SharedPreferencesKeys.notificationPermission,
                json.encode({
                  'accept': true,
                }));
            jumpFirstStep = true;
            emit(const NotificationPermissionState());
            return;
          }
        } else {
          if (statuses == PermissionStatus.permanentlyDenied ||
              statuses == PermissionStatus.denied) {
            await preferences.setString(
                SharedPreferencesKeys.notificationPermission,
                json.encode({
                  'accept': true,
                }));
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
  }
}
