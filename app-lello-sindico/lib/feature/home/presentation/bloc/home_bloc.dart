import 'package:essentials/essentials.dart';
import 'package:essentials/methods/device/device_identifier_service.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/home/presentation/bloc/home_event.dart';
import 'package:lello/feature/home/presentation/bloc/home_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/shared_features.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final RegisterFcm registerFcm;
  final SessionBloc sessionBloc;
  final DeviceIdentifierService deviceIdentifierService;

  HomeBloc({
    required this.registerFcm,
    required this.sessionBloc,
    required this.deviceIdentifierService,
  }) : super(const HomeViewState(showCondominumSelector: false)) {
    on<HomeEvent>((event, emit) {
      emit(HomeViewState(
        showCondominumSelector: event is ShowCondominiumSelectorHomeEvent,
      ));
    });
  }

  void showCondominiumSelector() {
    add(const ShowCondominiumSelectorHomeEvent());
  }

  void collapseCondominiumSelector() {
    add(const CollapseCondominiumSelectorHomeEvent());
  }

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
