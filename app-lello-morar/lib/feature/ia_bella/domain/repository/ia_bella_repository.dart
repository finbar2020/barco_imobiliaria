import 'package:essentials/functional/try.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_final_evaluation_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_rate_response_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_send_message_model.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_data_entity.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_final_evaluation_entity.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_pdf_entity.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_rate_response_entity.dart';

abstract class IaBellaRepository {
  Future<Try<IaBellaDataEntity>> startSession(String condoId);
  Future<Try<IaBellaDataEntity>> sendMessage(
      String condoId, IaBellaSendMessageModel userInput);
  Future<Try<IaBellaPdfEntity>> downloadPdf(
      String condoId, String documentId, String serviceType);
  Future<Try<IaBellaRateResponseEntity>> evaluate(
      String condoId, IaBellaRateResponseModel userRate);
  Future<Try<IaBellaFinalEvaluationEntity>> finalEvaluation(
      String condoId, IaBellaFinalEvaluationModel messageEvaluation);
}
