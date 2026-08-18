import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:essentials/methods/device/device_identifier_service.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/home/presentation/bloc/home_bloc.dart';
import 'package:lello/feature/home/presentation/bloc/home_event.dart';
import 'package:lello/feature/home/presentation/bloc/home_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/shared_features.dart';

class HomeBlocImpl extends HomeBloc {
  final RegisterFcm registerFcm;
  final SessionBloc sessionBloc;
  final DeviceIdentifierService deviceIdentifierService;

  HomeBlocImpl(
      {required this.registerFcm,
      required this.sessionBloc,
      required this.deviceIdentifierService})
      : super(HomeState(showCondominumSelector: false));

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    yield HomeState(
        showCondominumSelector: event is ShowCondominiumSelectorHomeEvent);
  }

  @override
  void showCondominiumSelector() {
    add(ShowCondominiumSelectorHomeEvent());
  }

  @override
  void collapseCondominiumSelector() {
    add(CollapseCondominiumSelectorHomeEvent());
  }

  @override
  void registerFcmToken() async {
    final FirebaseMessaging fcm = FirebaseMessaging.instance;

    String? fcmToken = await fcm.getToken();
    var condoList = sessionBloc.state.session?.me?.allCondominiunsEntity
        .map((e) => e.id)
        .toList();
    if (condoList == null || condoList.isEmpty) return;

    String? deviceId = await deviceIdentifierService.getDeviceIdentifier();
    RegisterFcmToken fcmTokenParams = RegisterFcmToken();
    fcmTokenParams.reference = condoList;
    fcmTokenParams.type = 'APPSINDICO';
    fcmTokenParams.token = fcmToken;
    fcmTokenParams.deviceId = deviceId;

    debugPrint("FCM Token => $fcmToken");

    await registerFcm.call(RegisterFcmTokenParams(fcmToken: fcmTokenParams));
  }
}
