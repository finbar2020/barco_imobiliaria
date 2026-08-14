import 'package:chopper/chopper.dart';
import 'package:morar/feature/agreements/data/model/agreement_created_model.dart';

part 'agreements_api.chopper.dart';

@ChopperApi()
abstract class AgreementsApi extends ChopperService {
  @Get(path: "/condominiums/{id}/agreement/allInfoV2")
  Future<Response> getAllInfo(
    @Path("id") String condoId,
    @Query("unitName") String unitTitle,
    @Query("onlyQuoteAndRule") bool onlyQuoteAndRule,
  );

  @Get(path: "/condominiums/{id}/agreement/recomendation")
  Future<Response> getRecommendation(@Path("id") String condoId);

  @Get(path: "/condominiums/{id}/agreement/rule")
  Future<Response> getPayday(@Path("id") String condoId);

  @Get(path: "/condominiums/{id}/agreement/installmentCredit")
  Future<Response> getInstallmentsCredit(
      @Path("id") String condoId, @Query("value") double totalValue);

  @Post(path: "/condominiums/{id}/agreement")
  Future<Response> postAgreement(
      @Path("id") String condoId, @Body() AgreementCreatedModel bodyDTO);

  @Get(path: "/condominiums/{id}/agreement/details/{agreementId}")
  Future<Response> getAgreementDetails(
      @Path("id") String condoId, @Path("agreementId") String agreementId);

  static AgreementsApi create(ChopperClient client) {
    return _$AgreementsApi(client);
  }
}
