import 'package:chopper/chopper.dart';
import 'package:lello/feature/agreements/data/model/agreement_update_status_model.dart';
import 'package:lello/feature/agreements/data/model/agreements_rules_model.dart';

part 'agreements_api.chopper.dart';

@ChopperApi()
abstract class AgreementsApi extends ChopperService {
  @GET(path: "/condominiums/{condominium_id}/agreement/report")
  Future<Response> getAgreementsReport(
    @Path("condominium_id") String condominiumId,
    @Query("from_date") String fromDate,
    @Query("to_date") String toDate,
  );

  @GET(path: "/condominiums/{condominium_id}/agreement/allInfo")
  Future<Response> getAllAgreementsInfo(
    @Path("condominium_id") String condominiumId,
  );

  @GET(path: "/condominiums/{condominium_id}/agreement")
  Future<Response> getAgreementsList(
    @Path("condominium_id") String condominiumId,
    @Query("status") String? status,
  );

  @GET(path: "/condominiums/{condominium_id}/agreement/rule")
  Future<Response> getRules(
    @Path("condominium_id") String condominiumId,
  );

  @POST(path: "/condominiums/{condominium_id}/agreement/rule")
  Future<Response> changeRules(
    @Path("condominium_id") String condominiumId,
    @Body() AgreementsRulesModel agreementsRulesModel,
  );

  @Patch(path: "/condominiums/{condominium_id}/agreement/updateStatus")
  Future<Response> agreementUpdateStatus(
    @Path("condominium_id") String condominiumId,
    @Body() AgreementUpdateStatusModel updateStatus,
  );

  static AgreementsApi create(ChopperClient client) {
    return _$AgreementsApi(client);
  }
}
