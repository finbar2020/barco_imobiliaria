import 'dart:async';

import 'package:colaborador/feature/digital_point/domain/entity/digital_point_type_enum.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_pending_points_usecase.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/sync_point_without_login/sync_point_without_login.dart';
import 'package:essentials/essentials.dart';

class SyncDigitalPointsWorker {
  final SyncPointWithoutLoginUsecase _syncPointWithoutLoginUsecase;
  final GetPendingPointsUsecase _getPendingPointsUsecase;
  static String uniqueName = "digital_points_worker";
  static String taskName = "sync_digital_points";

  SyncDigitalPointsWorker({
    required SyncPointWithoutLoginUsecase syncPointWithoutLoginUsecase,
    required GetPendingPointsUsecase getPendingPointsUsecase,
  })  : _syncPointWithoutLoginUsecase = syncPointWithoutLoginUsecase,
        _getPendingPointsUsecase = getPendingPointsUsecase;

  Future<bool> syncPoints() async {
    Completer<bool> completerTask = Completer<bool>();
    final result = await _getPendingPointsUsecase();

    Fluttertoast.showToast(
        msg: "Enviando pontos offline...", toastLength: Toast.LENGTH_SHORT);

    var points = result.fold((failure) => throw failure, (points) => points);

    if (points.isEmpty == true ||
        !points.any((x) => x.reference?.isNotEmpty == true)) {
      completerTask.complete(true);
      Fluttertoast.showToast(
          msg: "Sem pontos a serem enviados", toastLength: Toast.LENGTH_LONG);
      return completerTask.future;
    }

    var errors = 0;

    for (var point in points) {
      //Alterar pontos para offline
      var offllinePoint =
          point.copyWith(typePoint: DigitalPointTypeEnum.offline);
      final result = await _syncPointWithoutLoginUsecase(
        SyncPointWithoutLoginParam(digitalPoint: offllinePoint),
      );
      result.fold((failure) {
        errors++;
      }, (success) => success);
    }

    Fluttertoast.showToast(
        msg: "Enviados ${points.length - errors} de ${points.length} pontos",
        toastLength: Toast.LENGTH_SHORT);

    completerTask.complete(true);

    return completerTask.future;
  }

  Future<void> schedule() async {
    await _initFirebaseRemoteConfig();

    Workmanager().registerPeriodicTask(uniqueName, taskName,
        constraints: Constraints(networkType: NetworkType.connected),
        frequency: const Duration(hours: 4),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.replace);
  }

  Future<void> _initFirebaseRemoteConfig() async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 60),
        minimumFetchInterval: const Duration(hours: 12),
      ),
    );
    await remoteConfig.fetch();
    await remoteConfig.fetchAndActivate();
  }
}
