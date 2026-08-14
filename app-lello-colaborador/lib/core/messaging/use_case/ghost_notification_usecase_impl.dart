import 'dart:convert';
import 'dart:io';

import 'package:colaborador/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:colaborador/feature/digital_point/data/model/digital_point_model.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_points_usecase.dart';
import 'package:colaborador/feature/me/data/model/me_model.dart';
import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:colaborador/feature/session/data/model/session_model.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/feature/ghost_notification/data/model/ghost_notification_model.dart';
import 'package:shared_features/shared_features.dart';

import '../../../lello_app.dart';

class GhostNotificationUsecaseImpl extends GhostNotificationUsecase {
  final GhostNotificationRepository repository;
  final SessionBloc sessionBloc;
  final AuthenticationStore authenticationStore;
  final GetPointsUsecase getPointsUsecase;
  GhostNotificationUsecaseImpl({
    required this.repository,
    required this.sessionBloc,
    required this.authenticationStore,
    required this.getPointsUsecase,
  });

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  @override
  Future<Try<String?>> call(GhostNotificationParams params) async {
    GhostNotificationType type =
        GhostNotificationTypeUtils.stringToGhostNotificationEnum(params.type);
    switch (type) {
      case GhostNotificationType.imAlive:
        return sendImAliveNotification(params);
      case GhostNotificationType.userAppData:
        return sendUserDataNotification(params);
      case GhostNotificationType.detailedLog:
        return sendDebugLog(params);
      case GhostNotificationType.dataCleaning:
        return clearData(params);
      case GhostNotificationType.timesheetReport:
        return sendTimesheetReport(params);
      default:
        return Rejection(
          UnknownFailure("not_implemented"),
        );
    }
  }

  Future<Try<String?>> sendImAliveNotification(
      GhostNotificationParams params) async {
    var customData = await setCustomData(params);
    GhostNotificationModel model = await setData(customData, params);
    return await repository.send(
      model,
      params.id,
      params.type,
    );
  }

  Future<Try<String?>> sendUserDataNotification(
      GhostNotificationParams params) async {
    var customData = await setCustomData(params);
    GhostNotificationModel model = await setData(customData, params);
    return await repository.send(
      model,
      params.id,
      params.type,
    );
  }

  Future<Try<String?>> sendDebugLog(GhostNotificationParams params) async {
    var customData = await setCustomData(params);
    GhostNotificationModel model = await setData(customData, params);
    return await repository.send(
      model,
      params.id,
      params.type,
    );
  }

  Future<Try<String?>> clearData(GhostNotificationParams params) async {
    var customData = await setCustomData(params);
    GhostNotificationModel model = await setData(customData, params);
    if (navigatorKey.currentState != null) {
      authenticationStore.logout();

      navigatorKey.currentState?.pushNamedAndRemoveUntil(
          SharedApplicationRoute.splash, (Route<dynamic> route) => false);
      return await repository.send(
        model,
        params.id,
        params.type,
      );
    } else {
      var preferences = await SharedPreferences.getInstance();
      await preferences.setString(
          SharedPreferencesKeys.ghostNotificationLogout, _serialize(model));
      return Rejection(UnknownFailure(""));
    }
  }

  Future<Try<String?>> sendTimesheetReport(
      GhostNotificationParams params) async {
    var customData = await setCustomData(params);
    GhostNotificationModel model = await setData(customData, params);
    return await repository.send(
      model,
      params.id,
      params.type,
    );
  }

  Future<GhostNotificationModel> setData(
      dynamic customData, GhostNotificationParams params) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    var deviceName = "";
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = androidInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName = iosInfo.name;
    }
    var packageInfo = await PackageInfo.fromPlatform();
    var token = await _fcm.getToken();
    var appVersion = packageInfo.version;
    var appType = packageInfo.packageName;
    Me? me = sessionBloc.getSession?.me;
    GhostNotificationEntity entity = GhostNotificationEntity(
      id: params.id,
      token: token,
      appType: appType,
      recivedDate: DateTime.now().toIso8601String(),
      appVersion: appVersion,
      deviceName: deviceName,
      logedUserCpf: me?.cpf,
      logedUserId: me?.id,
      customData: customData,
    );
    GhostNotificationModel model = GhostNotificationModel.fromEntity(entity)!;
    return model;
  }

  setCustomData(GhostNotificationParams params) async {
    var packageInfo = await PackageInfo.fromPlatform();
    var appVersion = packageInfo.version;
    Me? me = sessionBloc.getSession?.me;
    MeModel? meModel = MeModel.fromEntity(me);
    SessionModel? sessionModel =
        SessionModel.fromEntity(sessionBloc.getSession);
    GhostNotificationType type =
        GhostNotificationTypeUtils.stringToGhostNotificationEnum(params.type);
    switch (type) {
      case GhostNotificationType.imAlive:
        return {};
      case GhostNotificationType.userAppData:
        return {
          "appVersion": appVersion,
          "user": meModel,
        };
      case GhostNotificationType.detailedLog:
        return {
          "detail_log": sessionModel,
        };
      case GhostNotificationType.dataCleaning:
        return {};
      case GhostNotificationType.timesheetReport:
        {
          List<DigitalPointModel> digitalPointModelList = [];

          final result = await getPointsUsecase.call(
            GetPointsParam(
              condoId: sessionBloc.getSession!.condominiumId,
              meId: sessionBloc.getSession!.userId,
            ),
          );
          result.fold((error) => digitalPointModelList, (response) {
            digitalPointModelList = response
                .map(
                  (e) => DigitalPointModel.fromEntity(e),
                )
                .toList();
          });

          return {
            "timesheet_report": digitalPointModelList,
          };
        }
      case GhostNotificationType.updateUser:
        {}
      case GhostNotificationType.updateFCMToken:
        return {};
    }
  }

  String _serialize(GhostNotificationModel model) =>
      json.encode(model.toJson());
}
