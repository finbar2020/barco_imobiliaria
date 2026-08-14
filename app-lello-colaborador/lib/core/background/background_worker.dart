import 'dart:async';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/check_digital_point/check_digital_point.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_features/shared_features.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundWorker {
  ApplicationContainer applicationContainer;
  FlutterLocalNotificationsPlugin flip;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static const String groupKey = 'app.lello.colaborador.notificacao';
  static const String groupChannelId = 'app.lello.colaborador.notificacao';
  static const String groupChannelName = 'app.lello.colaborador.notificacao';
  static const String groupChannelDescription =
      'app.lello.colaborador.notificacao';
  String task;
  Map<String, dynamic>? inputData;

  late CheckDigitalPointUsecase _check;
  BackgroundWorker(
    this.applicationContainer,
    this.flip,
    this.task,
    this.inputData,
  ) {
    _check = applicationContainer.resolve<CheckDigitalPointUsecase>();
  }

  Future<bool> executeBackgroundWork() async {
    Completer<bool> completerTask = Completer<bool>();
    try {
      var date = DateTime.parse(inputData?.values.first);
      debugPrint("TaskName: $task - $inputData");

      final SessionBloc sessi = applicationContainer.resolve();
      sessi.stopSchedulerTask();
      sessi.beginLoadSession(onlyLocal: true);

      sessi.stream.listen((event) async {
        switch (event.runtimeType) {
          case SessionInitialState:
            break;
          case SessionLoadingState:
            break;
          case SessionLoadedState:
            await _checkDate(date, event as SessionLoadedState);
            completerTask.complete(true);
            break;
          case SessionFailedState:
            completerTask.complete(false);
            break;
        }
      });
      return completerTask.future;
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<void> _checkDate(DateTime date, SessionLoadedState state) async {
    var sp = await SharedPreferences.getInstance();
    var curentList =
        sp.getStringList(SharedPreferencesKeys.digitalPointList) ?? [];
    var listDate = curentList.map((e) => DateTime.parse(e));

    if (!listDate
        .any((element) => element.difference(date).inMinutes.abs() <= 30)) {
      var checkDigitalPoint = await _check.call(CheckDigitalPointParam(
        condoId: state.session.condominiumId,
        date: date,
      ));
      var resultOnline = checkDigitalPoint.fold((l) => null, (r) => r);

      if (resultOnline == false) {
        await _enviaNotificacao(date);
      }
    } else {
      debugPrint(
          "TaskName: $task - $inputData - Não precisa notificar, achou ponto batido");
    }
  }

  Future<void> _enviaNotificacao(date) async {
    const AndroidNotificationDetails firstNotificationAndroidSpecifics =
        AndroidNotificationDetails(groupChannelId, groupChannelName,
            channelDescription: groupChannelDescription,
            importance: Importance.max,
            priority: Priority.high,
            groupKey: groupKey);
    const NotificationDetails secondNotificationPlatformSpecifics =
        NotificationDetails(android: firstNotificationAndroidSpecifics);

    await flip.show(
        id: 0,
        title: "Não esqueca de bater seu ponto!",
        body:
            "Atenção! Você esqueceu de registrar o seu ponto. Por favor, faça isso agora.",
        notificationDetails: secondNotificationPlatformSpecifics);
  }
}
