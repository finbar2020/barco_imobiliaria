import 'package:morar/feature/ia_bella/data/model/ia_bella_data_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_final_evaluation_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_pdf_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_rate_response_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_send_message_model.dart';

abstract class IaBellaRemoteDataSource {
  Future<IaBellaDataModel> startSession(String condoId);
  Future<IaBellaDataModel> sendMessage(
      String condoId, IaBellaSendMessageModel userInput);
  Future<IaBellaPdfModel> downloadPdf(
      String condoId, String documentId, String serviceType);
  Future<IaBellaRateResponseModel> evaluate(
      String condoId, IaBellaRateResponseModel userRate);
  Future<IaBellaFinalEvaluationModel> finalEvaluation(
      String condoId, IaBellaFinalEvaluationModel messageEvaluation);
}
