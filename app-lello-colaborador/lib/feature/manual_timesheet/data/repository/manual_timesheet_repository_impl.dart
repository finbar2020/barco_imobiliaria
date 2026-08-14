import 'dart:async';
import 'dart:io';

import 'package:colaborador/core/uploader/uploader.dart';
import 'package:colaborador/feature/manual_timesheet/data/data_source/remote/manual_timesheet_remote_data_source.dart';
import 'package:colaborador/feature/manual_timesheet/data/model/manual_timesheet_model.dart';
import 'package:colaborador/feature/manual_timesheet/domain/entity/manual_timesheet.dart';
import 'package:colaborador/feature/manual_timesheet/domain/repository/manual_timesheet_repository.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/shared_features.dart';

class ManualTimeSheetRepositoryImpl extends ManualTimeSheetRepository {
  final ManualTimeSheetRemoteDataSource remoteDataSource;
  final Uploader uploader;

  ManualTimeSheetRepositoryImpl({
    required this.remoteDataSource,
    required this.uploader,
  });

  @override
  Future<Try<ManualTimeSheetEntity>> registerManualTimeSheet(
      ManualTimeSheetEntity entity, String condoId, String meId) async {
    ManualTimeSheetModel modelUpdated = ManualTimeSheetModel.fromEntity(entity);
    try {
      modelUpdated =
          await remoteDataSource.registerManualTimeSheet(modelUpdated, condoId);
      return Success(modelUpdated.toEntity());
    } catch (e) {
      return Rejection(UnknownFailure(e));
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
}
