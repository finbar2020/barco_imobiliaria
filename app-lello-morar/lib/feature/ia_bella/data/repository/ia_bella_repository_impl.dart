import 'dart:developer';

import 'package:essentials/essentials.dart';
import 'package:morar/feature/ia_bella/data/data_source/ia_bella_remote_data_source.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_final_evaluation_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_rate_response_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_send_message_model.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_data_entity.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_final_evaluation_entity.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_pdf_entity.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_rate_response_entity.dart';
import 'package:morar/feature/ia_bella/domain/repository/ia_bella_repository.dart';

class IaBellaRepositoryImpl implements IaBellaRepository {
  final IaBellaRemoteDataSource remoteDataSource;

  IaBellaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Try<IaBellaDataEntity>> startSession(String condoId) async {
    try {
      final result = await remoteDataSource.startSession(condoId);
      final entity = result.toEntity();
      return Success(entity);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<IaBellaDataEntity>> sendMessage(
      String condoId, IaBellaSendMessageModel userInput) async {
    try {
      final result = await remoteDataSource.sendMessage(condoId, userInput);
      final entity = result.toEntity();

      return Success(entity);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<IaBellaRateResponseEntity>> evaluate(
      String condoId, IaBellaRateResponseModel userRate) async {
    try {
      final result = await remoteDataSource.evaluate(condoId, userRate);
      final entity = result.toEntity();
      return Success(entity);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<IaBellaPdfEntity>> downloadPdf(
      String condoId, String documentId, String serviceType) async {
    try {
      final result =
          await remoteDataSource.downloadPdf(condoId, documentId, serviceType);
      final entity = result.toEntity();
      return Success(entity);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<IaBellaFinalEvaluationEntity>> finalEvaluation(
      String condoId, IaBellaFinalEvaluationModel messageEvaluation) async {
    try {
      final result =
          await remoteDataSource.finalEvaluation(condoId, messageEvaluation);
      final entity = result.toEntity();
      return Success(entity);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }
}
