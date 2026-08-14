import 'dart:async';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/uploader/uploader.dart';
import 'package:morar/feature/access_control/data/data_source/access_control_remote_data_source.dart';
import 'package:morar/feature/access_control/data/model/access_control_authorizations_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_date_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_itens_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_recurrence_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_send_invite_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_visitant_model.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_register_facial_response.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_send_invite.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_visitant.dart';
import 'package:morar/feature/access_control/domain/repository/access_control_repository.dart';
import 'package:shared_features/shared_features.dart';

class AccessControlRepositoryImpl extends AccessControlRepository {
  final AccessControlRemoteDataSource remoteDataSource;
  final Uploader uploader;

  AccessControlRepositoryImpl({
    required this.remoteDataSource,
    required this.uploader,
  });

  @override
  Future<Try<List<AccessControl>>> listVisitants(String unitId) async {
    try {
      final result = await remoteDataSource.listVisitants(unitId);
      return Success(result.map((model) => model.toEntity()).toList());
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'unitId: $unitId',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<AccessControl>> saveVisitant(
      AccessControlVisitant visitant) async {
    var model = AccessControlVisitantModel(
      autorizarionType: visitant.autorizarionType,
      gest: AccessControlModel(
        idGest: visitant.gest?.idGest,
        document: visitant.gest?.document,
        foreignDocument: visitant.gest?.foreignDocument,
        typeDocument: visitant.gest?.typeDocument,
        name: visitant.gest?.name,
        business: visitant.gest?.business,
        type: visitant.gest?.type,
        phone: visitant.gest?.phone?.replaceAll(RegExp(r'[^0-9]'), ''),
      ),
      idGestUnit: visitant.idGestUnit,
      observation: visitant.observation,
      units: visitant.units,
    );
    try {
      final result = await remoteDataSource.saveVisitant(model);
      return Success(result.toEntity());
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(e, stacktrace);
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<String>> editVisitant(AccessControlVisitant visitant) async {
    var model = AccessControlVisitantModel(
      autorizarionType: visitant.autorizarionType,
      gest: AccessControlModel(
        idGest: visitant.gest?.idGest,
        document: visitant.gest?.document,
        name: visitant.gest?.name,
        business: visitant.gest?.business,
        foreignDocument: visitant.gest?.foreignDocument,
        typeDocument: visitant.gest?.typeDocument,
        type: visitant.gest?.type,
        phone: visitant.gest?.phone?.replaceAll(RegExp(r'[^0-9]'), ''),
      ),
      idGestUnit: visitant.idGestUnit,
      observation: visitant.observation,
      units: visitant.units,
    );
    try {
      final result = await remoteDataSource.editVisitant(model);
      return Success(result);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(e, stacktrace);
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<String>> deleteVisitant(String gestId) async {
    try {
      final result = await remoteDataSource.deleteVisitant(gestId);
      return Success(result);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'gestId: $gestId',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<String>> addVisit(
    String gestId,
    String unitId,
    AccessControlAuthorizations model,
  ) async {
    try {
      List<AccessControlItensModel> itens = [];
      if (model.recurrence?.itens != null) {
        model.recurrence!.itens!.forEach((element) {
          itens.add(AccessControlItensModel(
            recurrenceValue: element.recurrenceValue,
            end: AccessControlDateModel(
                hour: element.end?.hour,
                minute: element.end?.minute,
                aecond: element.end?.aecond,
                nano: element.end?.nano),
            start: AccessControlDateModel(
                hour: element.start?.hour,
                minute: element.start?.minute,
                aecond: element.start?.aecond,
                nano: element.start?.nano),
          ));
        });
      }
      AccessControlAuthorizationsModel access =
          AccessControlAuthorizationsModel(
        idConcierge: model.idConcierge,
        end: model.end,
        start: model.start,
        autorizationType: model.autorizationType,
        idGest: model.idGest,
        idUnit: model.idUnit,
        useFacialBiometric: model.useFacialBiometric,
        recurrence: model.recurrence != null
            ? AccessControlRecurrenceModel(
                idRecurrence: model.recurrence?.idRecurrence ?? '',
                interval: model.recurrence?.interval ?? 0,
                itens: itens,
                recurrenceType: model.recurrence?.recurrenceType,
              )
            : null,
      );
      final result = await remoteDataSource.addVisit(gestId, unitId, access);
      return Success(result);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'gestId: $gestId - unitId: $unitId',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<String>> deleteVisit(String recurrenceId) async {
    try {
      final result = await remoteDataSource.deleteVisit(recurrenceId);
      return Success(result);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'recurrenceId: $recurrenceId',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<String>> editVisit(
      AccessControlAuthorizations model, String recurrenceId) async {
    try {
      List<AccessControlItensModel> itens = [];
      if (model.recurrence?.itens != null) {
        model.recurrence!.itens!.forEach((element) {
          itens.add(AccessControlItensModel(
            recurrenceValue: element.recurrenceValue,
            end: AccessControlDateModel(
                hour: element.end?.hour,
                minute: element.end?.minute,
                aecond: element.end?.aecond,
                nano: element.end?.nano),
            start: AccessControlDateModel(
                hour: element.start?.hour,
                minute: element.start?.minute,
                aecond: element.start?.aecond,
                nano: element.start?.nano),
          ));
        });
      }

      AccessControlAuthorizationsModel access =
          AccessControlAuthorizationsModel(
        id: model.id,
        idConcierge: model.idConcierge,
        end: model.end,
        start: model.start,
        autorizationType: model.autorizationType,
        idGest: model.idGest,
        idUnit: model.idUnit,
        useFacialBiometric: model.useFacialBiometric,
        recurrence: model.recurrence == null
            ? null
            : AccessControlRecurrenceModel(
                idRecurrence: model.recurrence?.idRecurrence ?? '',
                interval: model.recurrence?.interval ?? 0,
                itens: itens,
                recurrenceType: model.recurrence?.recurrenceType ?? "",
              ),
      );
      final result = await remoteDataSource.editVisit(access, recurrenceId);
      return Success(result);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'recurrenceId: $recurrenceId',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<UrlUploadS3>> getUrlAws() async {
    try {
      final data = await remoteDataSource.getUrlAws();
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
  Future<Try<AccessControlRegisterFacialResponse>> registerFacialBiometric(
      String hash) async {
    try {
      final result = await remoteDataSource.registerFacialBiometric(hash);
      return Success(result.toEntity());
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<String>> sendInvite(AccessControlSendInviteEntity entity) async {
    try {
      AccessControlSendInviteModel model =
          AccessControlSendInviteModel.fromEntity(entity)!;
      final result = await remoteDataSource.sendInvite(model);
      return Success(result);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }
}
