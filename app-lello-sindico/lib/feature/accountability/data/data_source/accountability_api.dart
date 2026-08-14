import 'package:chopper/chopper.dart';
import 'package:lello/feature/accountability/data/model/acountability_doubt_request_model.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt_situation.dart';
part 'accountability_api.chopper.dart';

@ChopperApi()
abstract class AccountabilityApi extends ChopperService {
  @GET(path: "/condominiums/{id}/accountabilities/{period}/grouped")
  Future<Response> get(
      @Path("id") String condominiumId, @Path("period") String period);

  @GET(path: "/condominiums/{id}/accountabilities/")
  Future<Response> getPeriod(@Path("id") String condominiumId);

  @GET(path: "/condominiums/{id}/questions/types")
  Future<Response> listType(@Path("id") String condominiumId);

  @GET(path: "/condominiums/{id}/questions/")
  Future<Response> listDoubt(@Path("id") String condominiumId,
      @Query("question_situation") DoubtSituation? questionSituation);

  @GET(path: "/condominiums/{id}/questions/detail/{question_id}")
  Future<Response> listDoubtDetail(
      @Path("id") String condominiumId, @Path("question_id") String id);

  @POST(path: "/condominiums/{id}/questions/")
  Future<Response> sendDoubt(
    @Path("id") String condominiumId,
    @Body() AccountabilityDoubtRequestModel doubt,
  );

  @POST(
      path:
          "/condominiums/{id}/accountabilities/{period}/recommendation/approve")
  Future<Response> postRecommendation(
      @Path("id") String condominiumId, @Path("period") String period);

  static AccountabilityApi create(ChopperClient client) {
    return _$AccountabilityApi(client);
  }
}
