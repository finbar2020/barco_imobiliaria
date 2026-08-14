import 'dart:convert';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:morar/feature/home/presentation/bloc/home_bloc.dart';
import 'package:morar/feature/me/data/model/me_model.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/me/domain/use_case/get_me/get_me.dart';
import 'package:morar/feature/session/data/model/session_model.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/feature/ghost_notification/data/model/ghost_notification_model.dart';
import 'package:shared_features/shared_features.dart';

import '../../../lello_app.dart';

class GhostNotificationUsecaseImpl extends GhostNotificationUsecase {
  final GhostNotificationRepository repository;
  final SessionBloc sessionBloc;
  final AuthenticationStore authenticationStore;
  final GetMe getMe;
  final SwitchRoles switchRoles;
  final HomeBloc homeBloc;
  GhostNotificationUsecaseImpl(
      {required this.repository,
      required this.sessionBloc,
      required this.authenticationStore,
      required this.getMe,
      required this.switchRoles,
      required this.homeBloc});

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
      case GhostNotificationType.updateUser:
        return updateUser(params);
      case GhostNotificationType.updateFCMToken:
        return updateFCMToken(params);
      default:
        return Rejection(UnknownFailure("not_implemented"));
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

  Future<Try<String?>> updateFCMToken(GhostNotificationParams params) async {
    await homeBloc.registerFcmToken();
    return Success("");
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
    return redirectForSplash(params, model);
  }

  Future<Try<String?>> updateUser(GhostNotificationParams params) async {
    var customData = await setCustomData(params);
    GhostNotificationModel model = await setData(customData, params);
    Me? me;
    try {
      final getUser =
          await getMe.call(DataOrigin.remote).timeout(Duration(seconds: 20));
      getUser.fold((l) {
        return redirectForSplash(params, model);
      }, (r) {
        sessionBloc.updateMe(r);
        return me = r;
      });
      if (me != null) {
        var successCustomData = await setCustomData(params, getMe: me);
        GhostNotificationModel successModel =
            await setData(successCustomData, params);
        var switchR = await switchRoles.call(SwitchParams(
            role: sessionBloc.state.session!.unity!.id!,
            name: sessionBloc.state.session!.tokenName!));
        switchR.fold((l) {
          print("updateUserGhost: Falha no Switch roles remoto");
          return redirectForSplash(params, successModel);
        }, (token) {
          print("updateUserGhost: Sucesso no Switch roles remoto");
          authenticationStore.switchRole(token: token, isUpdate: true, me: me);
          return repository.send(
            successModel,
            params.id,
            params.type,
          );
        });
      } else {
        print("updateUserGhost: Get Me = null");
        return redirectForSplash(params, model);
      }
    } catch (e) {
      print("updateUserGhost: catch => Erro ao buscar o Me");
      return redirectForSplash(params, model);
    }
    return Success("");
  }

  Future<GhostNotificationModel> setData(
      dynamic customData, GhostNotificationParams params) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? deviceName = "";
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
    Me? me = sessionBloc.state.session?.me;
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

  setCustomData(GhostNotificationParams params, {Me? getMe}) async {
    var packageInfo = await PackageInfo.fromPlatform();
    var appVersion = packageInfo.version;
    Me? me = sessionBloc.state.session?.me;
    MeModel? meModel = MeModel.fromEntity(me!);
    SessionModel? sessionModel =
        SessionModel.fromEntity(sessionBloc.state.session!);
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
      case GhostNotificationType.updateUser:
        return {
          "me": getMe != null ? MeModel.fromEntity(getMe) : "",
        };
      default:
        return {};
    }
  }

  redirectForSplash(
      GhostNotificationParams params, GhostNotificationModel model) async {
    model.type = params.type;
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

  String _serialize(GhostNotificationModel model) =>
      json.encode(model.toJson());
}
