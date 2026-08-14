import 'dart:developer';

import 'package:essentials/essentials.dart';
import 'package:morar/feature/ia_bella/data/data_source/ia_bella_api.dart';
import 'package:morar/feature/ia_bella/data/data_source/ia_bella_remote_data_source.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_data_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_final_evaluation_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_pdf_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_rate_response_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_send_message_model.dart';

class IaBellaRemoteDataSourceImpl implements IaBellaRemoteDataSource {
  final IaBellaApi api;

  IaBellaRemoteDataSourceImpl({required this.api});

  @override
  Future<IaBellaDataModel> startSession(String condoId) async {
    final response = await api.startSession(condoId);
    return ApiMapper.map(response, (json) => IaBellaDataModel.fromJson(json));
  }

  @override
  Future<IaBellaDataModel> sendMessage(
      String condoId, IaBellaSendMessageModel userInput) async {
    final response = await api.sendMessage(condoId, userInput);
    return ApiMapper.map(response, (json) => IaBellaDataModel.fromJson(json));
  }

  @override
  Future<IaBellaPdfModel> downloadPdf(
      String condoId, String documentId, String serviceType) async {
    final response = await api.downloadPdf(condoId, documentId, serviceType);
    return ApiMapper.map(response, (json) => IaBellaPdfModel.fromJson(json));
  }

  @override
  Future<IaBellaRateResponseModel> evaluate(
      String condoId, IaBellaRateResponseModel userRate) async {
    final response = await api.evaluate(condoId, userRate);
    return ApiMapper.map(
        response, (json) => IaBellaRateResponseModel.fromJson(json));
  }

  @override
  Future<IaBellaFinalEvaluationModel> finalEvaluation(
      String condoId, IaBellaFinalEvaluationModel messageEvaluation) async {
    final response = await api.finalEvaluation(condoId, messageEvaluation);
    return ApiMapper.map(
        response, (json) => IaBellaFinalEvaluationModel.fromJson(json));
  }
}
