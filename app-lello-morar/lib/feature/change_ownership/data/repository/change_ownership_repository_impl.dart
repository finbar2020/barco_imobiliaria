import 'dart:async';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/uploader/uploader.dart';
import 'package:morar/feature/change_ownership/data/data_source/change_ownership_data_source.dart';
import 'package:morar/feature/change_ownership/data/model/change_ownership_model.dart';
import 'package:morar/feature/change_ownership/domain/entity/can_change_entity.dart';
import 'package:morar/feature/change_ownership/domain/entity/ownership_entity.dart';
import 'package:morar/feature/change_ownership/domain/repository/change_ownership_repository.dart';
import 'package:shared_features/shared_features.dart';

class ChangeOwnershipRepositoryImpl extends ChangeOwnershipRepository {
  final ChangeOwnershipRemoteDataSource dataSource;
  final Uploader uploader;

  ChangeOwnershipRepositoryImpl(
      {required this.dataSource, required this.uploader});

  @override
  Future<Try<UrlUploadS3>> getAws(
      String reference, OwnershipEntity change) async {
    try {
      final data = await dataSource.getAws(reference);
      final entity = data.toEntity();
      change.archives = [entity.fileName];
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance
          .recordError(e, stacktrace, reason: 'reference: $reference');
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<String>> postChange(String condoId, OwnershipEntity entity) async {
    try {
      entity.document = entity.document?.replaceAll(RegExp(r'[^0-9]'), '');
      entity.rg = entity.rg?.replaceAll(RegExp(r'[^0-9]'), '');
      entity.phone = entity.phone?.replaceAll(RegExp(r'[^0-9]'), '');
      entity.cellphone = entity.cellphone?.replaceAll(RegExp(r'[^0-9]'), '');
      ChangeOwnershipModel model = ChangeOwnershipModel.fromEntity(entity);
      final data = await dataSource.postChange(condoId, model);
      return Success(data);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'condoId: $condoId',
      );
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
  Future<Try<CanChangeEntity>> getCanChange(String condoId) async {
    try {
      final data = await dataSource.getCanChange(condoId);
      final entity = data.toEntity();
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance
          .recordError(e, stacktrace, reason: 'reference: $condoId');
      return Rejection(UnknownFailure(e));
    }
  }
}
