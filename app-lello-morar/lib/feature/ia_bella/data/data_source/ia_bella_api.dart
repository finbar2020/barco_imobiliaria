import 'package:chopper/chopper.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_final_evaluation_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_rate_response_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_send_message_model.dart';
part 'ia_bella_api.chopper.dart';

@ChopperApi()
abstract class IaBellaApi extends ChopperService {
  @Post(path: "/condominiums/{condoId}/bella/start_session")
  Future<Response> startSession(
    @Path("condoId") String condoId,
  );

  @Post(path: "condominiums/{condoId}/bella/new_question")
  Future<Response> sendMessage(
    @Path("condoId") String condoId,
    @Body() IaBellaSendMessageModel body,
  );

  @Get(
      path:
          "condominiums/{condoId}/bella/download_pdf?documentId={documentId}&serviceType={serviceType}")
  Future<Response> downloadPdf(
    @Path("condoId") String condoId,
    @Path("documentId") String documentId,
    @Path("serviceType") String serviceType,
  );

  @Put(path: "condominiums/{condoId}/bella/evaluate")
  Future<Response> evaluate(
    @Path("condoId") String condoId,
    @Body() IaBellaRateResponseModel body,
  );

  @Post(path: "condominiums/{condoId}/bella/final_evaluation")
  Future<Response> finalEvaluation(
    @Path("condoId") String condoId,
    @Body() IaBellaFinalEvaluationModel body,
  );

  static IaBellaApi create(ChopperClient client) {
    return _$IaBellaApi(client);
  }
}
