import 'dart:async';
import 'dart:io';

import 'package:colaborador/core/database/digital_point_database/digital_point_database.dart';
import 'package:colaborador/core/uploader/uploader.dart';
import 'package:colaborador/feature/digital_point/data/data_source/local/digital_point_local_data_source.dart';
import 'package:colaborador/feature/digital_point/data/data_source/remote/digital_point_remote_data_source.dart';
import 'package:colaborador/feature/digital_point/data/model/digital_point_model.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_register_failure.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_status_enum.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_type_enum.dart';
import 'package:colaborador/feature/digital_point/domain/repository/digital_point_repository.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../core/failures/failures.dart';

class DigitalPointRepositoryImpl extends DigitalPointRepository {
  final DigitalPointLocalDataSource localDataSource;
  final DigitalPointRemoteDataSource remoteDataSource;
  final Uploader uploader;

  DigitalPointRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.uploader,
  });
  @override
  Future<Try<bool>> requestDigitalPoint(
      String condoId, String imageHash) async {
    try {
      final data =
          await remoteDataSource.requestDigitalPointService(condoId, imageHash);

      return Success(data);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<DigitalPointEntity>> registerPoint(
      DigitalPointEntity entity, String condoId, String meId) async {
    DigitalPointModel modelPrevious = DigitalPointModel.fromEntity(entity);
    DigitalPointModel modelUpdated = DigitalPointModel.fromEntity(entity);
    try {
      modelUpdated =
          await remoteDataSource.registerPoint(modelUpdated, condoId);
      await _saveOnShared(modelUpdated);
      return Success(modelUpdated.toEntity());
    } catch (e) {
      if (e is ApiFailure) {
        return _onRegisterError(e, modelPrevious, condoId, meId);
      } else {
        return Rejection(UnknownFailure(e));
      }
    }
  }

  Future<Try<DigitalPointEntity>> _onRegisterError(ApiFailure error,
      DigitalPointModel model, String condoId, String meId) async {
    String previousStatus = model.status;
    try {
      switch (error.status) {
        case 406:
          model = model.copyWith(
              status: enumToString(DigitalPointStatusEnum.refused));
          localDataSource.saveDigitalPointLog(
            model,
            previousStatus,
            description: error.detail ??
                error.failure?.toString() ??
                DigitalPointRegisterFailure.photoNotAccepted,
          );
          return Rejection(
            KnownFailure(DigitalPointRegisterFailure.photoNotAccepted, error),
          );
        case 409:
          model = model.copyWith(
              status: enumToString(DigitalPointStatusEnum.refused));
          localDataSource.saveDigitalPointLog(
            model,
            previousStatus,
            description: error.detail ??
                error.failure?.toString() ??
                DigitalPointRegisterFailure.onWorkLeaveNotAccepted,
          );
          return Rejection(
            KnownFailure(
                DigitalPointRegisterFailure.onWorkLeaveNotAccepted, error),
          );
        case 500:
          model = model.copyWith(
            status: enumToString(DigitalPointStatusEnum.pending),
            typeCapture: enumToString(DigitalPointTypeEnum.offline),
          );

          DigitalPointModel modelUpdated =
              await localDataSource.save(model, condoId, meId);
          localDataSource.saveDigitalPointLog(
            modelUpdated,
            previousStatus,
            description: error.detail ??
                error.failure?.toString() ??
                DigitalPointRegisterFailure.serverError,
          );

          await _saveOnShared(model);

          return Rejection(
            KnownFailure(DigitalPointRegisterFailure.serverError, error),
          );
        case 400:
          model = model.copyWith(
              status: enumToString(DigitalPointStatusEnum.refused));
          localDataSource.saveDigitalPointLog(
            model,
            previousStatus,
            description: error.detail ??
                error.failure?.toString() ??
                DigitalPointRegisterFailure.customRefusedMessage,
          );
          return Rejection(
            KnownFailure(
                DigitalPointRegisterFailure.customRefusedMessage, error),
          );
        default:
          return Rejection(UnknownFailure(error));
      }
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  Future<void> _saveOnShared(DigitalPointModel model) async {
    var sp = await SharedPreferences.getInstance();
    var curentList =
        sp.getStringList(SharedPreferencesKeys.digitalPointList) ?? [];
    curentList.add(model.date.toIso8601String());
    sp.setStringList(SharedPreferencesKeys.digitalPointList, curentList);
  }

  @override
  Future<Try<DigitalPointEntity>> savePoint(
      DigitalPointEntity entity, String condoId, String meId) async {
    DigitalPointModel model = DigitalPointModel.fromEntity(entity);
    try {
      final data = await localDataSource.save(model, condoId, meId);
      localDataSource.saveDigitalPointLog(model, "");
      DigitalPointEntity entity = data.toEntity();
      await _saveOnShared(model);
      return Success(entity);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<DigitalPointEntity>> savePointLog(DigitalPointEntity entity,
      String statusPrevious, String description) async {
    DigitalPointModel model = DigitalPointModel.fromEntity(entity);
    try {
      localDataSource.saveDigitalPointLog(
        model,
        statusPrevious,
        description: description,
      );
      return Success(entity);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<DigitalPointLogData>>> getPointLogs(int pointId) async {
    try {
      final data = await localDataSource.selectLogById(pointId);
      return Success(data);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<DigitalPointEntity>>> getPoints(
      String condoId, String meId) async {
    try {
      final data = await localDataSource.selectAll(condoId, meId);
      List<DigitalPointEntity> entity = data.map((e) => e.toEntity()).toList();
      return Success(entity);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<DigitalPointEntity>>> getPointsByStatus(
      String condoId, String meId, String status) async {
    try {
      final data = await localDataSource.select(condoId, meId, status);
      List<DigitalPointEntity> entity = data.map((e) => e.toEntity()).toList();
      return Success(entity);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<DigitalPointEntity>>> getPendingPoints() async {
    try {
      final data = await localDataSource.selectPendingFromDevice();
      List<DigitalPointEntity> entity = data.map((e) => e.toEntity()).toList();
      return Success(entity);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<DigitalPointEntity>>> syncPoints(
      String condoId, String meId, List<DigitalPointEntity> points) async {
    List<DigitalPointModel> pointsModelToSync =
        points.map((e) => DigitalPointModel.fromEntity(e)).toList();
    try {
      await Future.forEach<DigitalPointModel>(
          pointsModelToSync, (element) => _syncSinglePoint(element, condoId));

      return await getPointsByStatus(
          condoId, meId, enumToString(DigitalPointStatusEnum.pending)!);
    } on KnownFailure catch (e) {
      final rejectedPoints = await getPointsByStatus(
          condoId, meId, enumToString(DigitalPointStatusEnum.refused)!);
      return Rejection(
        DigitalPointSendFailure(
          points: rejectedPoints.fold(
            (failure) => [],
            (points) => points,
          ),
          message: e.error.detail,
          code: e.code,
        ),
      );
    }
  }

  Future<Try<DigitalPointEntity>> _syncSinglePoint(
      DigitalPointModel model, String condoId) async {
    String statusPrevious = model.status;
    try {
      model = await remoteDataSource.registerPoint(model, condoId);
      await localDataSource.updatePointStatus(
        id: model.id,
        newStatusEnum: DigitalPointStatusEnum.sended,
      );
      localDataSource.saveDigitalPointLog(model, statusPrevious);
      return Success(model.toEntity());
    } on ApiFailure catch (error) {
      switch (error.status) {
        case 406:
          model = model.copyWith(
              status: enumToString(DigitalPointStatusEnum.refused));
          localDataSource.saveDigitalPointLog(
            model,
            statusPrevious,
            description: DigitalPointRegisterFailure.photoNotAccepted,
          );
          await localDataSource.updatePointStatus(
            id: model.id,
            newStatusEnum: DigitalPointStatusEnum.refused,
          );
          throw KnownFailure(
            DigitalPointRegisterFailure.photoNotAccepted,
            error,
          );
        case 409:
          model = model.copyWith(
              status: enumToString(DigitalPointStatusEnum.refused));
          localDataSource.saveDigitalPointLog(
            model,
            statusPrevious,
            description: DigitalPointRegisterFailure.onWorkLeaveNotAccepted,
          );
          await localDataSource.updatePointStatus(
            id: model.id,
            newStatusEnum: DigitalPointStatusEnum.refused,
          );
          throw KnownFailure(
            DigitalPointRegisterFailure.onWorkLeaveNotAccepted,
            error,
          );
        case 500:
          localDataSource.saveDigitalPointLog(
            model,
            statusPrevious,
            description: DigitalPointRegisterFailure.serverError,
          );
          throw KnownFailure(
            DigitalPointRegisterFailure.serverError,
            error,
          );
        default:
          throw Rejection(UnknownFailure(error));
      }
    } catch (error) {
      localDataSource.saveDigitalPointLog(
        model,
        statusPrevious,
        description: DigitalPointRegisterFailure.serverError,
      );

      return Rejection(UnknownFailure(error));
    }
  }

  @override
  Future<Try<UrlUploadS3>> getUrlAws(String condoId) async {
    try {
      final data = await remoteDataSource.getUrlAws(condoId);
      UrlUploadS3 entity = data.toEntity();
      return Success(entity);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<String>> uploadImageToAws(File file, String url) async {
    try {
      final completer = Completer<Try<String>>();
      await uploader.uploadS3(
        url,
        file,
        onComplete: (url) {
          debugPrint("DEBUG PRINT: onComplete uploadImageToAws: $url");
          return completer.complete(Success(url));
        },
        onError: (e) {
          return completer.complete(Rejection(UnknownFailure(e)));
        },
      );
      return completer.future;
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<bool>> checkDigitalPoint(String condoId, DateTime date) async {
    try {
      final data = await remoteDataSource.checkDigitalPoint(condoId, date);
      return Success(data);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<void>> syncPointWithoutLogin({
    required DigitalPointEntity point,
  }) async {
    var model = DigitalPointModel.fromEntity(point);
    var statusPrevious = model.status;
    try {
      final data = await remoteDataSource.syncPointWithouLogin(model);

      await localDataSource.updatePointStatus(
        id: point.id,
        newStatusEnum: DigitalPointStatusEnum.sended,
      );
      return Success(data);
    } on ApiFailure catch (error) {
      switch (error.status) {
        case 406:
          model = model.copyWith(
              status: enumToString(DigitalPointStatusEnum.refused));
          localDataSource.saveDigitalPointLog(
            model,
            statusPrevious,
            description: DigitalPointRegisterFailure.photoNotAccepted,
          );
          await localDataSource.updatePointStatus(
            id: model.id,
            newStatusEnum: DigitalPointStatusEnum.refused,
          );
          throw KnownFailure(
            DigitalPointRegisterFailure.photoNotAccepted,
            error,
          );
        case 409:
          model = model.copyWith(
              status: enumToString(DigitalPointStatusEnum.refused));
          localDataSource.saveDigitalPointLog(
            model,
            statusPrevious,
            description: DigitalPointRegisterFailure.onWorkLeaveNotAccepted,
          );
          await localDataSource.updatePointStatus(
            id: model.id,
            newStatusEnum: DigitalPointStatusEnum.refused,
          );
          throw KnownFailure(
            DigitalPointRegisterFailure.onWorkLeaveNotAccepted,
            error,
          );
        case 500:
          throw KnownFailure(
            DigitalPointRegisterFailure.serverError,
            error,
          );
        default:
          throw Rejection(UnknownFailure(error));
      }
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }
}
