import 'dart:async';
import 'dart:io';

import 'package:colaborador/core/uploader/uploader.dart';
import 'package:colaborador/feature/employee_referral/data/data_source/employee_referral_remote_data_source.dart';
import 'package:colaborador/feature/employee_referral/data/model/city_model.dart';
import 'package:colaborador/feature/employee_referral/data/model/employee_referral_model.dart';
import 'package:colaborador/feature/employee_referral/domain/entity/city.dart';
import 'package:colaborador/feature/employee_referral/domain/repository/employee_referral_repository.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/shared_features.dart';

import '../../domain/entity/employee_referral.dart';

class EmployeeReferralRepositoryImpl extends EmployeeReferralRepository {
  final EmployeeReferralRemoteDataSource remoteDataSource;
  final Uploader uploader;

  EmployeeReferralRepositoryImpl({
    required this.remoteDataSource,
    required this.uploader,
  });

  @override
  Future<Try<EmployeeReferralEntity>> registerEmployeeReferral(
      EmployeeReferralEntity entity, String condoId, String employeeId) async {
    EmployeeReferralModel modelUpdated =
        EmployeeReferralModel.fromEntity(entity);
    try {
      modelUpdated = await remoteDataSource.registerEmployeeReferral(
          modelUpdated, condoId, employeeId);
      return Success(modelUpdated.toEntity());
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<CityEntity>>> getCities(
      String condoId, String employeeId) async {
    try {
      List<CityModel> response =
          await remoteDataSource.getCities(condoId, employeeId);
      List<CityEntity> entity =
          response.map((e) => e.toEntity()).cast<CityEntity>().toList();

      return Success(entity);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<UrlUploadS3>> getUrlAws(String condoId, String employeeId) async {
    try {
      final data = await remoteDataSource.getUrlAws(condoId, employeeId);
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
